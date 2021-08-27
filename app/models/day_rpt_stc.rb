class DayRptStc < ActiveRecord::Base






  belongs_to :day_pdt_rpt



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

