class MonthMud < ActiveRecord::Base






  belongs_to :mth_pdt_rpt



end

# == Schema Information
#
# Table name: month_muds
#
#  id             :integer         not null, primary key
#  inmud          :float           default("0.0"), not null
#  end_inmud      :float           default("0.0"), not null
#  outmud         :float           default("0.0"), not null
#  end_outmud     :float           default("0.0"), not null
#  mst_up         :float           default("0.0"), not null
#  yoy            :float           default("0.0"), not null
#  mom            :float           default("0.0"), not null
#  ypdr           :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

