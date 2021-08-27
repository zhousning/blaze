class EmpEff < ActiveRecord::Base






  belongs_to :factory



end

# == Schema Information
#
# Table name: emp_effs
#
#  id         :integer         not null, primary key
#  pdt_time   :datetime
#  cod        :float           default("0.0"), not null
#  nhn        :float           default("0.0"), not null
#  tp         :float           default("0.0"), not null
#  flow       :float           default("0.0"), not null
#  ph         :float           default("0.0"), not null
#  temp       :float           default("0.0"), not null
#  factory_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

