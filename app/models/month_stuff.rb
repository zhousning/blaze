class MonthStuff < ActiveRecord::Base






  belongs_to :mth_pdt_rpt



end

# == Schema Information
#
# Table name: month_stuffs
#
#  id             :integer         not null, primary key
#  xdjtjl         :float           default("0.0"), not null
#  end_xdjtjl     :float           default("0.0"), not null
#  yoy            :float           default("0.0"), not null
#  mom            :float           default("0.0"), not null
#  ypdr           :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

