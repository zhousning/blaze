require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

#给清源更新电数据用的
namespace 'db' do
  desc "update_lishimth_powers"
  task(:update_lishimth_powers => :environment) do
    include FormulaLib
    base_dir = "lib/tasks/data/inoutcms/singlelishimth/" 
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @mthpowerchemicallog = Logger.new(@log_dir + '更新月电数据错误.log')

    Find.find(base_dir).each do |xls|
      unless File::directory?(xls)
        puts xls
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
    index = index + 3 
    index = index.to_s
    date = row['A' + index]
    next if date.blank?

    mydate = date.to_date
    year = mydate.year
    month = mydate.month

    yoy_year = year - 1

    mom_year = year
    mom_month = month - 1
    if mom_month == 0
      mom_month = 12
      mom_year = year - 1
    end

    last_year_date  = Date.new(yoy_year, month, 1)
    last_month_date = Date.new(mom_year, mom_month, 1)

    @last_year_mth_rpt  = factory.mth_pdt_rpts.where(:start_date => last_year_date).first
    @last_month_mth_rpt = factory.mth_pdt_rpts.where(:start_date => last_month_date).first
    last_year_power = 0 
    last_year_bom   = 0
    last_mth_power  = 0
    last_mth_bom    = 0

    if !@last_year_mth_rpt.nil?
      mth_power = @last_year_mth_rpt.month_power
      last_year_power =  mth_power.nil? ? 0 : mth_power.power
      last_year_bom   =  mth_power.nil? ? 0 : mth_power.bom
    end

    if !@last_month_mth_rpt.nil?
      mth_power = @last_month_mth_rpt.month_power
      last_mth_power =  mth_power.nil? ? 0 : mth_power.power
      last_mth_bom   =  mth_power.nil? ? 0 : mth_power.bom
    end

    @mth_pdt_rpt = factory.mth_pdt_rpts.where(:start_date => mydate).first
    if @mth_pdt_rpt
      power = row['B' + index].blank? ? 0 : FormulaLib.format_num(row['B' + index])
      power = FormulaLib.format_num(power)
      power_sum = FormulaLib.format_num(power_sum + power)

      bom = FormulaLib.bom(power*10000, @mth_pdt_rpt.outflow) 

      yoy_power = FormulaLib.yoy(power, last_year_power)
      mom_power = FormulaLib.mom(power, last_mth_power)

      yoy_bom = FormulaLib.yoy(bom, last_year_bom)
      mom_bom = FormulaLib.mom(bom, last_mth_bom)

      mthpower = @mth_pdt_rpt.month_power
      unless mthpower.update_attributes(:power => power, :end_power => power_sum, :bom => bom, :yoy_power => yoy_power, :mom_power => mom_power, :yoy_bom => yoy_bom, :mom_bom => mom_bom)
        @mthpowerchemicallog.error 'mth power update error: ' + @mth_pdt_rpt.name 
      end

    else
      @mthpowerchemicallog.error 'mth chemical none error: ' + file_name + '  ' + date.to_s 
    end
  end
end
