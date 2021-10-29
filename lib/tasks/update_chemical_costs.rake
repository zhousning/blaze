require 'logger'

namespace 'db' do
  desc "update_chemical_costs"
  task(:update_chemical_costs => :environment) do
    include FormulaLib
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @update_chemical_cost_log = Logger.new(@log_dir + '更新化学药剂成本数据.log')

    factories = Factory.all
    years = [2021]
    factories.each do |factory|
      years.each do |year|
        (Date.new(year, 9, 1)..Date.new(year, 10, 30)).each do |day|
          day_rpt = factory.day_pdt_rpts.where(:pdt_date => day).first
          if day_rpt
            day_rpt_stc = day_rpt.day_rpt_stc
            if day_rpt_stc 
              chemicals = day_rpt.chemicals
              inflow = day_rpt.inflow
              clyj_cost = 0
              tuodan_cost = 0
              chemicals.each do |cmc|
                fclyj = [Setting.chemical_ctgs.csn, Setting.chemical_ctgs.pam_yin, Setting.chemical_ctgs.pam_yang]
                if !fclyj.include?(cmc.name)
                  clyj_cost += cmc.unprice*cmc.dosage 
                end
                if cmc.name == Setting.chemical_ctgs.csn
                  tuodan_cost = cmc.unprice*cmc.dosage
                end
              end
              clyjcb = FormulaLib.format_num(clyj_cost/inflow)
              tuodancb = FormulaLib.format_num(tuodan_cost/inflow)
              qctpcb = FormulaLib.format_num(clyj_cost/day_rpt_stc.tp_emq)
              qctncb = FormulaLib.format_num(clyj_cost/day_rpt_stc.tn_emq)

              unless day_rpt_stc.update_attributes(:tp_cost => clyjcb, :tn_cost => tuodancb, :tp_utcost => qctpcb, :tn_utcost => qctncb)
                @update_chemical_cost_log.error rpt.name + "更新化学药剂成本数据"
              end
            end
          end
        end
      end
    end
  end
end
