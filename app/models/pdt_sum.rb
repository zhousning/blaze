class PdtSum < ActiveRecord::Base
  belongs_to :day_pdt

  def update_per_cost(per_cost)
    self.update_attribute :per_cost, per_cost 
  end


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
#  tspmud     :float           default("0.0"), not null
#  rcpmud     :float           default("0.0"), not null
#  dlemud     :string          default(""), not null
#  mst        :float           default("0.0"), not null
#  power      :float           default("0.0"), not null
#  mdflow     :float           default("0.0"), not null
#  mdrcy      :float           default("0.0"), not null
#  mdsell     :float           default("0.0"), not null
#  per_cost   :float           default("0.0"), not null
#  day_pdt_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

