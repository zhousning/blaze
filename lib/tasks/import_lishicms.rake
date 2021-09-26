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
  log_dir = "lib/tasks/data/inoutcms/logs/" 

  tool = ExcelTool.new
  results = tool.parseExcel(xls)
  factory_hash = my_factory_hash

  file_name = File.basename(xls, '.xlsx')
  log_tmpt = log_dir + 'logexcel.xls'
  target_excel = log_dir + file_name + '.xls'
  error_excel = log_dir + file_name + 'error.xls'
  book = Spreadsheet.open log_tmpt
  errorbook = Spreadsheet.open log_tmpt
  rilishi = book.worksheet 'rilishi'
  lishi = errorbook.worksheet 'rilishi'
  start = 3
  error_start = 3

  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 
  mudfct_hash = {}
  factory.mudfcts.each do |mudfct|
    mudfct_hash[mudfct.name] = mudfct.id 
  end

  results['化验室水质'][2..-1].each_with_index do |row, index|
    index = index + 3 
    index = index.to_s
    date_time = row['A' + index]
    puts date_time
    if date_time.blank?
      next
    end
    date = date_time.to_date
    name = date.to_s + factory.name + "生产运营报表"

    option = {
      :factory        =>   factory,
      :name           =>   name,   
      :pdt_date       =>   date, 
      :inflow         =>   row['B' + index].blank? ? 0 : row['B' + index],
      :inf_asy_cod    =>   row['C' + index].blank? ? 0 : row['C' + index], 
      :eff_asy_cod    =>   row['D' + index].blank? ? 0 : row['D' + index],
      :inf_qlty_bod   =>   row['E' + index].blank? ? 0 : row['E' + index],
      :eff_qlty_bod   =>   row['F' + index].blank? ? 0 : row['F' + index],
      :inf_qlty_ss    =>   row['G' + index].blank? ? 0 : row['G' + index],
      :eff_qlty_ss    =>   row['H' + index].blank? ? 0 : row['H' + index],
      :inf_asy_nhn    =>   row['I' + index].blank? ? 0 : row['I' + index],
      :eff_asy_nhn    =>   row['J' + index].blank? ? 0 : row['J' + index],
      :inf_asy_tp     =>   row['K' + index].blank? ? 0 : row['K' + index],
      :eff_asy_tp     =>   row['L' + index].blank? ? 0 : row['L' + index],
      :inf_asy_tn     =>   row['M' + index].blank? ? 0 : row['M' + index],
      :eff_asy_tn     =>   row['N' + index].blank? ? 0 : row['N' + index],
      :eff_qlty_fecal =>   row['O' + index].blank? ? 0 : row['O' + index],
      :outmud         =>   row['P' + index].blank? ? 0 : row['P' + index],
      :mst            =>   row['Q' + index].blank? ? 0 : row['Q' + index],
      :mdflow         =>   row['R' + index].blank? ? 0 : row['R' + index],
      :mdrcy          =>   row['S' + index].blank? ? 0 : row['S' + index],
      :mdsell         =>   row['T' + index].blank? ? 0 : row['T' + index],
    }
    @day_pdt_rpt = DayPdtRpt.new(option)

    tspvums  = row['U' + index].blank? ? [] : row['U' + index].to_s.strip.split(/;|；/)
    dealers  = row['V' + index].blank? ? [] : row['V' + index].to_s.strip.split(/;|；/)
    rcpvums  = row['W' + index].blank? ? [] : row['W' + index].to_s.strip.split(/;|；/)
    prices   = row['X' + index].blank? ? [] : row['X' + index].to_s.strip.split(/;|；/)
    prtmtds  = row['Y' + index].blank? ? [] : row['Y' + index].to_s.strip.split(/;|；/)

    if @day_pdt_rpt.save
      unless dealers.blank?
        count = dealers.count
        if tspvums.count != count || rcpvums.count != count || prices.count != count
          rilishi.row(start).height = 30
          rilishi.row(start).concat arr(row, index, date.to_s)
          start = start + 1
        else
         dealers.each_with_index do |dealer, index|
           dealer_id = mudfct_hash[dealer]
           unless dealer_id
             mfct = Mudfct.create!(:name => dealer, :factory => factory)
             dealer_id = mfct.id
             mudfct_hash[mfct.name] = mfct.id
           end
           lastprtmtd = prtmtds.last.nil? ? '' : prtmtds.last
           prtmtd = prtmtds[index].nil? ? '' : lastprtmtd
           unless tspvums[index].blank? || tspvums[index] == 0
             Tspmud.create!(
               :day_pdt_rpt => @day_pdt_rpt, 
               :dealer      => dealer_id.to_s, 
               :tspvum      => tspvums[index], 
               :rcpvum      => rcpvums[index], 
               :price       => prices[index],
               :prtmtd      => prtmtd
             )
           end
         end
        end
      end
    else
      lishi.row(error_start).height = 30
      lishi.row(error_start).concat arr(row, index, date.to_s)
      error_start = error_start + 1
    end
  end

  book.write target_excel
  errorbook.write error_excel
end

def arr(row, index, date)
  [
    date,
    row['B' + index],
    row['C' + index],
    row['D' + index],
    row['E' + index],
    row['F' + index],
    row['G' + index],
    row['H' + index],
    row['I' + index],
    row['J' + index],
    row['K' + index],
    row['L' + index],
    row['M' + index],
    row['N' + index],
    row['O' + index],
    row['P' + index],
    row['Q' + index],
    row['R' + index],
    row['S' + index],
    row['T' + index],
    row['U' + index],
    row['V' + index],
    row['W' + index],
    row['X' + index],
    row['Y' + index]
  ]
end
