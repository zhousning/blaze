class MonthTn < ActiveRecord::Base






  belongs_to :mth_pdt_rpt



end

# == Schema Information
#
# Table name: month_tns
#
#  id             :integer         not null, primary key
#  avg_inf        :float           default("0.0"), not null
#  avg_eff        :float           default("0.0"), not null
#  emr            :float           default("0.0"), not null
#  avg_emq        :float           default("0.0"), not null
#  emq            :float           default("0.0"), not null
#  end_emq        :float           default("0.0"), not null
#  up_std         :integer         default("0"), not null
#  end_std        :integer         default("0"), not null
#  yoy            :float           default("0.0"), not null
#  mom            :float           default("0.0"), not null
#  ypdr           :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

