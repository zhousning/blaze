require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "import lishi cms"
  task(:import_lishicms => :environment) do
    exec_import_lishicms
  end
end

def exec_import_lishicms
  
  base_dir = "lib/tasks/data/inoutcms/lishi/" 

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      puts xls
      parse_watercms_excel(xls)
    end
  end
end

def parse_watercms_excel(xls)
  Spreadsheet.client_encoding = 'UTF-8'
  tool = ExcelTool.new
  results = tool.parseExcel(xls)
  factory_hash = my_factory_hash

  file_name = File.basename(xls, '.xlsx')
  target_excel = base_dir + 'logs/' + file_name + '.xls') 
  book = Spreadsheet.open target_excel
  rilishi = book.worksheet 'rilishi'
  start = 3

  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 
  mudfct_hash = {} 
  factory.mudfcts.each do |mudfct|
    mudfct_hash[mudfct.name] = mudfct.id 
  end


  results['Sheet1'][2..-1].each_with_index do |row, index|
    index = index + 3 
    index = index.to_s
    date_time = row['A' + index]
    date = date_time.to_date
    name = date.to_s + factory.name + "生产运营报表"

    option = {
      :factory        =>   factory,
      :name           =>   name,   
      :pdt_date       =>   date, 
      :inflow         =>   row['B' + index].blank? ? 0 : row['B' + index],
      :inf_asy_cod    =>   row['C' + index].blank? ? 0 : row['C' + index], 
      :eff_asy_cod    =>   row['D' + index].blank? ? 0 : row['D' + index],
      :inf_asy_nhn    =>   row['I' + index].blank? ? 0 : row['I' + index],
      :eff_asy_nhn    =>   row['J' + index].blank? ? 0 : row['J' + index],
      :inf_asy_tp     =>   row['K' + index].blank? ? 0 : row['K' + index],
      :eff_asy_tp     =>   row['L' + index].blank? ? 0 : row['L' + index],
      :inf_asy_tn     =>   row['M' + index].blank? ? 0 : row['M' + index],
      :eff_asy_tn     =>   row['N' + index].blank? ? 0 : row['N' + index],
      :inf_qlty_bod   =>   row['E' + index].blank? ? 0 : row['E' + index],
      :eff_qlty_bod   =>   row['F' + index].blank? ? 0 : row['F' + index],
      :inf_qlty_ss    =>   row['G' + index].blank? ? 0 : row['G' + index],
      :eff_qlty_ss    =>   row['H' + index].blank? ? 0 : row['H' + index],
      :eff_qlty_fecal =>   row['O' + index].blank? ? 0 : row['O' + index],
      :outmud         =>   row['P' + index].blank? ? 0 : row['P' + index],
      :mst            =>   row['Q' + index].blank? ? 0 : row['Q' + index],
      :mdflow         =>   row['R' + index].blank? ? 0 : row['R' + index],
      :mdrcy          =>   row['S' + index].blank? ? 0 : row['S' + index],
      :mdsell         =>   row['T' + index].blank? ? 0 : row['T' + index],
    }
    @day_pdt_rpt = DayPdtRpt.new(option)

    tspvums  = row['U' + index].blank? ? [] : row['U' + index].strip.split(/;|；/)
    dealers  = row['V' + index].blank? ? [] : row['V' + index].strip.split(/;|；/)
    rcpvums  = row['W' + index].blank? ? [] : row['W' + index].strip.split(/;|；/)
    prices   = row['X' + index].blank? ? [] : row['X' + index].strip.split(/;|；/)
    prtmtds  = row['Y' + index].blank? ? [] : row['Y' + index].strip.split(/;|；/)

    if @day_pdt_rpt.save
      unless delears.blank?
        count = delears.count
        if tspvums.count != count || rcpvums.count != count || prices.count != count
          #输出到excel 这条记录
          rilishi.row(start) = name 
          start = start + 1
        else
         delears.each_with_index do |delear, index|
           mudfct = factory.mudfcts.where(:name => delear).first
           delear_id = mudfct_hash(delear)
           unless delear_id
             mfct = MudFct.create!(:name => delear)
             delear_id = mfct.id
             mudfct_hash[mfct.name] = mfct.id
           end
           lastprtmtd = prtmtds.last.nil? ? '' : prtmtds.last
           prtmtd = prtmtds[index].nil? ? '' : lastprtmtd
           Tspmud.create(
             :day_pdt_rpt => @day_pdt_rpt, 
             :delear_id   => delear_id, 
             :tspvum      => tspvums[index], 
             :rcpvum      => rcpvums[index], 
             :price       => prices[index],
             :prtmtd      => prtmtd)

         end
        end
      end
      book.write target_excel
    else
      #输出错误到excel 这条记录
    end
    ##puts "index: " + index.to_s + "  " + a_str.to_s + " " +  b_str.to_s + " " +   c_str.to_s + " " +   d_str.to_s + " " +   e_str.to_s + " " +   f_str.to_s + " " +   g_str.to_s
    #else
    #end
  end

end
