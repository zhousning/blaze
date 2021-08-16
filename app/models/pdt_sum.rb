class PdtSum < ActiveRecord::Base






  belongs_to :day_pdt



end

# == Schema Information
#
# Table name: pdt_sums
#
#  id         :integer         not null, primary key
#  inflow     :float           default("0.0"), not null
#  outflow    :float           default("0.0"), not null
#  inmud      :float           default("0.0"), not null
#  outmud     :float           default("0.0"), not null
#  mst        :float           default("0.0"), not null
#  power      :float           default("0.0"), not null
#  mdflow     :float           default("0.0"), not null
#  mdrcy      :float           default("0.0"), not null
#  mdsell     :float           default("0.0"), not null
#  day_pdt_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

