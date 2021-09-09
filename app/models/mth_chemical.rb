class MthChemical < ActiveRecord::Base
  include FormulaLib

  belongs_to :mth_pdt_rpt


  def update_ptc(inflow)
    dosptc = FormulaLib.dosptc(self.act_dosage, self.cmptc, inflow) 
    per_cost = FormulaLib.chemical_per_cost(self.unprice, self.act_dosage, inflow)
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
#  dosage         :float           default("0.0"), not null
#  cmptc          :float           default("0.0"), not null
#  dosptc         :float           default("0.0"), not null
#  per_cost       :float           default("0.0"), not null
#  day_pdt_rpt_id :integer
#  day_pdt_id     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

