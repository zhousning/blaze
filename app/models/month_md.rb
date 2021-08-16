class MonthMd < ActiveRecord::Base






  belongs_to :mth_pdt_rpt



end

# == Schema Information
#
# Table name: month_mds
#
#  id             :integer         not null, primary key
#  mdrcy          :float           default("0.0"), not null
#  end_mdrcy      :float           default("0.0"), not null
#  mdsell         :float           default("0.0"), not null
#  end_mdsell     :float           default("0.0"), not null
#  yoy_mdrcy      :float           default("0.0"), not null
#  mom_mdrcy      :float           default("0.0"), not null
#  ypdr_mdrcy     :float           default("0.0"), not null
#  yoy_mdsell     :float           default("0.0"), not null
#  mom_mdsell     :float           default("0.0"), not null
#  ypdr_mdsell    :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

