require 'logger'

namespace 'db' do
  desc "update_chemical_per_costs"
  task(:update_chemical_per_costs => :environment) do
    include FormulaLib
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @update_chemical_per_cost_log = Logger.new(@log_dir + '修改吨水药剂成本单位.log')

      day_rpts = DayPdtRpt.all
      day_rpts.each do |day_rpt|
        begin
          day_rpt_cost = format("%0.4f", day_rpt.per_cost/1000).to_f
          day_rpt.update_attributes(:per_cost => day_rpt_cost)

          chemicals = day_rpt.chemicals
          chemicals.each do |cmc|
            cost = format("%0.4f", cmc.per_cost/1000).to_f
            cmc.update_attributes(:per_cost => cost)
          end
        rescue
          @update_chemical_per_cost_log.error day_rpt.name + 'error' 
        end
      end

      mth_rpts = MthPdtRpt.all
      mth_rpts.each do |mth_rpt|
        mth_rpt.mth_chemicals.each do |cmc|
          cost = format("%0.4f", cmc.per_cost/1000).to_f
          unless cmc.update_attributes(:per_cost => cost)
            @update_chemical_per_cost_log.error mth_rpt.name + 'error' 
          end
        end
      end
  end
end
