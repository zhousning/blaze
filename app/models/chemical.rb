class Chemical < ActiveRecord::Base
  include FormulaLib

  belongs_to :day_pdt_rpt
  belongs_to :day_pdt


  def update_ptc(inflow)
    dosptc = FormulaLib.dosptc(self.dosage, self.cmptc, inflow) 
    per_cost = FormulaLib.chemical_per_cost(self.unprice, self.dosage, inflow)
    self.update_attributes(:dosptc => dosptc, :per_cost => per_cost)
    per_cost
  end
end

# == Schema Information
#
# Table name: chemicals
#
#  id             :integer         not null, primary key
#  name           :string          default(""), not null
#  unprice        :float           default("0.0"), not null
#  cmptc          :float           default("0.0"), not null
#  dosptc         :float           default("0.0"), not null
#  per_cost       :float           default("0.0"), not null
#  day_pdt_rpt_id :integer
#  day_pdt_id     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

