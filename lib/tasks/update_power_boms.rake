require 'logger'

namespace 'db' do
  desc "update_power_boms"
  task(:update_power_boms => :environment) do
    include FormulaLib
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @update_power_bom_log = Logger.new(@log_dir + '修改电单耗.log')

      day_rpts = DayPdtRpt.all
      day_rpts.each do |day_rpt|
        bom = FormulaLib.bom(day_rpt.power, day_rpt.inflow), 
        stc = day_rpt.day_rpt_stc
        unless stc.update_attributes(:bom => bom)
          @update_power_bom_log.error day_rpt.name + 'error' 
        end
      end

      mth_rpts = MthPdtRpt.all
      mth_rpts.each do |mth_rpt|
        mth_power = mth_rpt.month_power
        bom = FormulaLib.bom(mth_power.power, mth_rpt.outflow), 
        unless mth_power.update_attributes(:bom => bom)
          @update_power_bom_log.error mth_rpt.name + 'error' 
        end
      end
  end
end
