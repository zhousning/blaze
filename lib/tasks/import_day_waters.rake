require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "import day waters"
  task(:import_day_waters => :environment) do
    include FormulaLib
    exec_import_day_waters
  end
end

def exec_import_day_waters
  base_dir = "lib/tasks/data/cwaters/days/" 
  @log_dir = "lib/tasks/data/cwaters/logs/" 
  @log = Logger.new(@log_dir + '创建城镇供水日运营数据错误.log')

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      Spreadsheet.client_encoding = 'UTF-8'

      tool = ExcelTool.new
      results = tool.parseExcel(xls)

      file_name = File.basename(xls, '.xlsx')
      log_tmpt = @log_dir + 'dayslog.xls'

      target_excel = @log_dir + file_name + '.xls'
      book = Spreadsheet.open log_tmpt
      rilishi = book.worksheet '供水日数据'
      start = 2 

      factory = Sfactory.where(:name => fct_name).first 

      results['供水日数据'][1..-1].each_with_index do |row, index|
        index = index + 2 
        index = index.to_s
        date_time = row['A' + index]
        if date_time.blank?
          next
        end
        date = date_time.to_date
        name = date.to_s + factory.name + "生产运营报表"

        begin
          option = {
            :sfactory        =>   factory,
            :name           =>   name,   
            :pdt_date       =>   date, 
            :ipt         =>   row['B' + index].blank? ? 0 : FormulaLib.format_num(row['B' + index]),
            :opt         =>   row['C' + index].blank? ? 0 : FormulaLib.format_num(row['C' + index]), 
            :press       =>   row['D' + index].blank? ? 0 : FormulaLib.format_num(row['D' + index]),
            :power       =>   row['E' + index].blank? ? 0 : FormulaLib.format_num(row['E' + index]),
            :yl          =>   row['F' + index].blank? ? 0 : FormulaLib.format_num(row['F' + index]),
            :zd          =>   row['G' + index].blank? ? 0 : FormulaLib.format_num(row['G' + index]),
            :yd          =>   row['H' + index].blank? ? 0 : FormulaLib.format_num(row['H' + index]),
            :ph          =>   row['I' + index].blank? ? 0 : FormulaLib.format_num(row['H' + index]),
          }                                                                                          
          @day_pdt_rpt = SdayPdt.new(option)                                                       
          @day_pdt_rpt.save!
        rescue Exception => e
          rilishi.row(start).height = 30
          rilishi.row(start).concat arr(row, index, date.to_s)
          start = start + 1
          @log.error name + ' ' + e.message
        end
      end

      book.write target_excel
    end
  end
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
    row['I' + index]
  ]
end
