class EffQlty < ActiveRecord::Base
  validates  :bod, :cod, :ss, :nhn, :tn, :tp, :ph, :asy_cod, :asy_nhn, :asy_tp, :asy_tn, :presence => true 






  belongs_to :day_pdt



end


# == Schema Information
#
# Table name: eff_qlties
#
#  id         :integer         not null, primary key
#  bod        :float           default("0.0"), not null
#  cod        :float           default("0.0"), not null
#  ss         :float           default("0.0"), not null
#  nhn        :float           default("0.0"), not null
#  tn         :float           default("0.0"), not null
#  tp         :float           default("0.0"), not null
#  ph         :float           default("0.0"), not null
#  fecal      :integer         default("0"), not null
#  asy_cod    :float           default("0.0"), not null
#  asy_nhn    :float           default("0.0"), not null
#  asy_tp     :float           default("0.0"), not null
#  asy_tn     :float           default("0.0"), not null
#  day_pdt_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

