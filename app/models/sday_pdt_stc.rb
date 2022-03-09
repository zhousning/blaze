class SdayPdtStc < ActiveRecord::Base
  belongs_to :sday_pdt

  #before_save :calculate_attrs

  #def calculate_attrs
  #  sday_pdt = self.sday_pdt
  #  bom = FormulaLib.kbom(sday_pdt.power, sday_pdt.opt) 
  #  self.bom = bom
  #end

end
