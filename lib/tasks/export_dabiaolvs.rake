require 'spreadsheet' 
namespace 'db' do
  desc "export dabiaolv"
  task(:export_dabiaolvs => :environment) do
    Spreadsheet.client_encoding = 'UTF-8'
    filename = '达标率统计' + Time.now.to_i.to_s + "%04d" % [rand(10000)]
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xlsx') 

    book = Spreadsheet::Workbook.new

    sdssb=[{:key => 'cod', :val => 30}, {:key => 'bod', :val => 6}, {:key => 'ss', :val => 10}, {:key => 'nhn', :val => 1.5}, {:key => 'tn', :val => 10}, {:key => 'tp', :val => 0.3}]
    jnzsb=[{:key => 'cod', :val => 20}, {:key => 'bod', :val => 4}, {:key => 'ss', :val => 10}, {:key => 'nhn', :val => 1}, {:key => 'tn', :val => 10}, {:key => 'tp', :val => 0.2}]
    qzdbs=[{:key => 'cod', :val => 20}, {:key => 'bod', :val => 4}, {:key => 'ss', :val => 10}, {:key => 'nhn', :val => 1}, {:key => 'tn', :val => 1}, {:key => 'tp', :val => 0.2}]

    quotas = [sdssb, jnzsb, qzdbs]
    quotas.each_with_index do |quota, index|
      sheet = book.create_worksheet name: "分别标准达标率 " + index.to_s
      hash = Hash.new
      quota.each do |item|
        cond = 'pdt_date between ? and ? and eff_qlty_' + item[:key] + ' <= ?'
        val = item[:val]
        Factory.all.each do |f|
          hash[f.name] = [] if hash[f.name].nil?
          sum = f.day_pdt_rpts.where([cond, '2021-01-01', '2021-12-31', val]).count.to_f
          total = (Date.new(2021,1,1)..Date.new(2021,12,31)).count.to_f
          dabiaolv = format("%0.2f", (sum/total*100)) + '%'
          hash[f.name] << dabiaolv
        end
      end

      items = []
      hash.each_pair do |k, v|
        items << [k] + v
      end

      items.each_with_index do |item, index|
        sheet.row(index).concat item 
      end
    end

    quotas.each_with_index do |quota, index|
      sheet = book.create_worksheet name: "分别且满足达标率 " + index.to_s
      hash = Hash.new
      cond = 'pdt_date between ? and ?'
      quota.each do |item|
        cond += ' and eff_qlty_' + item[:key] + ' <= ' + item[:val].to_s
      end

      Factory.all.each do |f|
        hash[f.name] = [] if hash[f.name].nil?
        sum = f.day_pdt_rpts.where([cond, '2021-01-01', '2021-12-31']).count.to_f
        total = (Date.new(2021,1,1)..Date.new(2021,12,31)).count.to_f
        dabiaolv = format("%0.2f", (sum/total*100)) + '%'
        hash[f.name] << dabiaolv
      end

      items = []
      hash.each_pair do |k, v|
        items << [k] + v
      end

      items.each_with_index do |item, index|
        sheet.row(index).concat item 
      end
    end

    dunshui_hash = Hash.new
    dunshui_sheet = book.create_worksheet name: "吨水药剂成本"
    Factory.all.each do |f|
      rpts = f.day_pdt_rpts.where(['pdt_date between ? and ?', '2021-01-01', '2021-12-31'])
      rpts_count = rpts.count.to_f
      tp_cost_sum = 0
      tn_cost_sum = 0
      rpts.each do |rpt|
        tp_cost_sum += rpt.day_rpt_stc.tp_cost 
        tn_cost_sum += rpt.day_rpt_stc.tn_cost 
      end

      tplv = format("%0.2f", (tp_cost_sum/rpts_count*100)) + '%'
      tnlv = format("%0.2f", (tn_cost_sum/rpts_count*100)) + '%'
      dunshui_hash[f.name] = [tplv, tnlv]
    end

    dunshui_items = []
    dunshui_hash.each_pair do |k, v|
      dunshui_items << [k] + v
    end

    dunshui_items.each_with_index do |item, index|
      dunshui_sheet.row(index).concat item 
    end

    book.write target_excel
  end
end

