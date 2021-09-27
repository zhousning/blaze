require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "update_mth_power_chemicals"
  task(:update_mth_power_chemicals => :environment) do
    base_dir = "lib/tasks/data/inoutcms/lishimth/" 
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @log = Logger.new(@log_dir + '更新月数据错误.log')

    Find.find(base_dir).each do |xls|
      unless File::directory?(xls)
        puts xls
        parse_mth_power_chemical(xls)
      end
    end
  end
end

def parse_mth_power_chemical(xls)
  file_name = File.basename(xls, '.xlsx')

  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  factory_hash = my_factory_hash
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 

  results['Sheet1'][2..-1].each_with_index do |row, index|
    index = index + 3 
    index = index.to_s
    date = row['A' + index]
    next if date.blank?

    puts date
    #@mth_pdt_rpt = factory.mth_pdt_rpts.where(:start_date => date).first
    #if @mth_pdt_rpt
    #  option = {
    #    :inflow         =>   row['B' + index].blank? ? 0 : FormulaLib.format_num(row['B' + index]),
    #    :inf_asy_cod    =>   row['C' + index].blank? ? 0 : FormulaLib.format_num(row['C' + index]), 
    #    :eff_asy_cod    =>   row['D' + index].blank? ? 0 : FormulaLib.format_num(row['D' + index]),
    #    :inf_qlty_bod   =>   row['E' + index].blank? ? 0 : FormulaLib.format_num(row['E' + index]),
    #    :eff_qlty_bod   =>   row['F' + index].blank? ? 0 : FormulaLib.format_num(row['F' + index]),
    #    :inf_qlty_ss    =>   row['G' + index].blank? ? 0 : FormulaLib.format_num(row['G' + index]),
    #    :eff_qlty_ss    =>   row['H' + index].blank? ? 0 : FormulaLib.format_num(row['H' + index]),
    #    :inf_asy_nhn    =>   row['I' + index].blank? ? 0 : FormulaLib.format_num(row['I' + index]),
    #    :eff_asy_nhn    =>   row['J' + index].blank? ? 0 : FormulaLib.format_num(row['J' + index]),
    #    :inf_asy_tp     =>   row['K' + index].blank? ? 0 : FormulaLib.format_num(row['K' + index]),
    #    :eff_asy_tp     =>   row['L' + index].blank? ? 0 : FormulaLib.format_num(row['L' + index]),
    #    :inf_asy_tn     =>   row['M' + index].blank? ? 0 : FormulaLib.format_num(row['M' + index]),
    #    :eff_asy_tn     =>   row['N' + index].blank? ? 0 : FormulaLib.format_num(row['N' + index]),
    #    :eff_qlty_fecal =>   row['O' + index].blank? ? 0 : FormulaLib.format_num(row['O' + index]),
    #    :outmud         =>   row['P' + index].blank? ? 0 : FormulaLib.format_num(row['P' + index]),
    #    :mst            =>   row['Q' + index].blank? ? 0 : FormulaLib.format_num(row['Q' + index]),
    #    :mdflow         =>   row['R' + index].blank? ? 0 : FormulaLib.format_num(row['R' + index]),
    #    :mdrcy          =>   row['S' + index].blank? ? 0 : FormulaLib.format_num(row['S' + index]),
    #    :mdsell         =>   row['T' + index].blank? ? 0 : FormulaLib.format_num(row['T' + index]),
    #  }
    #  unless @mth_pdt_rpt.update_attributes(option)
    #    @log.error 'update error: ' + @mth_pdt_rpt.name 
    #  end
    #else
    #  @log.error 'none error: ' + file_name + date 
    #end
  end
end
