class MonthPower < ActiveRecord::Base






  belongs_to :mth_pdt_rpt



end

# == Schema Information
#
# Table name: month_powers
#
#  id             :integer         not null, primary key
#  power          :float           default("0.0"), not null
#  end_power      :float           default("0.0"), not null
#  bom            :float           default("0.0"), not null
#  bom_power      :float           default("0.0"), not null
#  yoy_power      :float           default("0.0"), not null
#  mom_power      :float           default("0.0"), not null
#  ypdr_power     :float           default("0.0"), not null
#  yoy_bom        :float           default("0.0"), not null
#  mom_bom        :float           default("0.0"), not null
#  ypdr_bom       :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

