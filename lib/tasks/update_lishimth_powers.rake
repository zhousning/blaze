require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "update_lishimth_powers"
  task(:update_lishimth_powers => :environment) do
    include FormulaLib
    base_dir = "lib/tasks/data/inoutcms/lishimth/" 
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @mthpowerchemicallog = Logger.new(@log_dir + '更新历史电量月数据错误.log')

    Find.find(base_dir).each do |xls|
      unless File::directory?(xls)
        parse_lishimth_power(xls)
      end
    end
  end
end

def parse_lishimth_power(xls)
  file_name = File.basename(xls, '.xlsx')

  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  factory_hash = my_factory_hash
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 
  power_sum = 0

  results['Sheet1'][2..-1].each_with_index do |row, index|

    @mth_pdt_rpt = factory.mth_pdt_rpts.where(:start_date => mydate).first
    if @mth_pdt_rpt

    else
      @mthpowerchemicallog.error 'mth chemical none error: ' + file_name + '  ' + date.to_s 
    end
  end
end
