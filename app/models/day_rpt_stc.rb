class DayRptStc < ActiveRecord::Base
  belongs_to :day_pdt_rpt

  #before_save :calculate_attrs

  def calculate_attrs
    day_pdt_rpt = self.day_pdt_rpt
    clyjcb, tuodancb, qctpcb, qctncb = chemical_cost(day_pdt_rpt)

    self.bcr     = FormulaLib.ratio(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.inf_qlty_cod)
    self.bnr     = FormulaLib.ratio(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.inf_qlty_tn)
    self.bpr     = FormulaLib.ratio(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.inf_qlty_tp)
    self.bom     = FormulaLib.bom(day_pdt_rpt.power, day_pdt_rpt.inflow) 

    self.cod_bom = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_cod, day_pdt_rpt.eff_qlty_cod, day_pdt_rpt.inflow ) 
    self.bod_bom = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.eff_qlty_bod, day_pdt_rpt.inflow ) 
    self.nhn_bom = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_nhn, day_pdt_rpt.eff_qlty_nhn, day_pdt_rpt.inflow ) 
    self.tp_bom  = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_tp,  day_pdt_rpt.eff_qlty_tp,  day_pdt_rpt.inflow ) 
    self.tn_bom  = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_tn,  day_pdt_rpt.eff_qlty_tn,  day_pdt_rpt.inflow ) 
    self.ss_bom  = FormulaLib.em_bom(day_pdt_rpt.power, day_pdt_rpt.inf_qlty_ss,  day_pdt_rpt.eff_qlty_ss,  day_pdt_rpt.inflow ) 

    self.cod_emq = FormulaLib.emq(day_pdt_rpt.inf_qlty_cod, day_pdt_rpt.eff_qlty_cod,  day_pdt_rpt.inflow ) 
    self.bod_emq = FormulaLib.emq(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.eff_qlty_bod,  day_pdt_rpt.inflow ) 
    self.nhn_emq = FormulaLib.emq(day_pdt_rpt.inf_qlty_nhn, day_pdt_rpt.eff_qlty_nhn,  day_pdt_rpt.inflow ) 
    self.tp_emq  = FormulaLib.emq(day_pdt_rpt.inf_qlty_tp,  day_pdt_rpt.eff_qlty_tp,   day_pdt_rpt.inflow ) 
    self.tn_emq  = FormulaLib.emq(day_pdt_rpt.inf_qlty_tn,  day_pdt_rpt.eff_qlty_tn,   day_pdt_rpt.inflow ) 
    self.ss_emq  = FormulaLib.emq(day_pdt_rpt.inf_qlty_ss,  day_pdt_rpt.eff_qlty_ss,   day_pdt_rpt.inflow ) 

    self.cod_emr = FormulaLib.emr(day_pdt_rpt.inf_qlty_cod, day_pdt_rpt.eff_qlty_cod ) 
    self.bod_emr = FormulaLib.emr(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.eff_qlty_bod ) 
    self.nhn_emr = FormulaLib.emr(day_pdt_rpt.inf_qlty_nhn, day_pdt_rpt.eff_qlty_nhn ) 
    self.tp_emr  = FormulaLib.emr(day_pdt_rpt.inf_qlty_tp,  day_pdt_rpt.eff_qlty_tp  ) 
    self.tn_emr  = FormulaLib.emr(day_pdt_rpt.inf_qlty_tn,  day_pdt_rpt.eff_qlty_tn  ) 
    self.ss_emr  = FormulaLib.emr(day_pdt_rpt.inf_qlty_ss,  day_pdt_rpt.eff_qlty_ss  )

    self.cod_inflow = FormulaLib.multiply(day_pdt_rpt.inf_qlty_cod, day_pdt_rpt.inflow ) 
    self.bod_inflow = FormulaLib.multiply(day_pdt_rpt.inf_qlty_bod, day_pdt_rpt.inflow ) 
    self.nhn_inflow = FormulaLib.multiply(day_pdt_rpt.inf_qlty_nhn, day_pdt_rpt.inflow ) 
    self.tp_inflow  = FormulaLib.multiply(day_pdt_rpt.inf_qlty_tp,  day_pdt_rpt.inflow ) 
    self.tn_inflow  = FormulaLib.multiply(day_pdt_rpt.inf_qlty_tn,  day_pdt_rpt.inflow ) 
    self.ss_inflow  = FormulaLib.multiply(day_pdt_rpt.inf_qlty_ss,  day_pdt_rpt.inflow )

    self.tp_cost = clyjcb
    self.tn_cost = tuodancb 
    self.tp_utcost = qctpcb 
    self.tn_utcost = qctncb
  end

  private
    def chemical_cost(day_rpt)
      chemicals = day_rpt.chemicals
      inflow = day_rpt.inflow
      clyj_cost = 0
      tuodan_cost = 0
      chemicals.each do |cmc|
        tanyuan = [Setting.chemical_ctgs.csn, Setting.chemical_ctgs.jc, Setting.chemical_ctgs.xxty]
        clyj = [Setting.chemical_ctgs.pac, Setting.chemical_ctgs.slht, Setting.chemical_ctgs.jhlst]
        if clyj.include?(cmc.name)
          clyj_cost += cmc.unprice*cmc.dosage 
        end
        if tanyuan.include?(cmc.name)
          tuodan_cost += cmc.unprice*cmc.dosage
        end
      end

      tp_emq = FormulaLib.emq(day_rpt.inf_qlty_tp, day_rpt.eff_qlty_tp, day_rpt.inflow )
      tn_emq = FormulaLib.emq(day_rpt.inf_qlty_tn, day_rpt.eff_qlty_tn, day_rpt.inflow )

      clyjcb = FormulaLib.format_num(clyj_cost/inflow)
      tuodancb = FormulaLib.format_num(tuodan_cost/inflow)
      qctpcb = FormulaLib.format_num(clyj_cost/tp_emq)
      qctncb = FormulaLib.format_num(tuodan_cost/tn_emq)

      [clyjcb, tuodancb, qctpcb, qctncb]
    end

end

# == Schema Information
#
# Table name: day_rpt_stcs
#
#  id             :integer         not null, primary key
#  bcr            :float           default("0.0"), not null
#  bnr            :float           default("0.0"), not null
#  bpr            :float           default("0.0"), not null
#  bom            :float           default("0.0"), not null
#  cod_bom        :float           default("0.0"), not null
#  bod_bom        :float           default("0.0"), not null
#  nhn_bom        :float           default("0.0"), not null
#  tp_bom         :float           default("0.0"), not null
#  tn_bom         :float           default("0.0"), not null
#  ss_bom         :float           default("0.0"), not null
#  cod_emq        :float           default("0.0"), not null
#  bod_emq        :float           default("0.0"), not null
#  nhn_emq        :float           default("0.0"), not null
#  tp_emq         :float           default("0.0"), not null
#  tn_emq         :float           default("0.0"), not null
#  ss_emq         :float           default("0.0"), not null
#  cod_emr        :float           default("0.0"), not null
#  bod_emr        :float           default("0.0"), not null
#  nhn_emr        :float           default("0.0"), not null
#  tp_emr         :float           default("0.0"), not null
#  tn_emr         :float           default("0.0"), not null
#  ss_emr         :float           default("0.0"), not null
#  cod_inflow     :float           default("0.0"), not null
#  bod_inflow     :float           default("0.0"), not null
#  nhn_inflow     :float           default("0.0"), not null
#  tp_inflow      :float           default("0.0"), not null
#  tn_inflow      :float           default("0.0"), not null
#  ss_inflow      :float           default("0.0"), not null
#  day_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

