class CmpyMthSell < ActiveRecord::Base
  belongs_to :cmpy_mth_rpt
  belongs_to :ccompany
  belongs_to :ncompany

  def ongoing 
    update_attribute :state, Setting.smonth_sells.ongoing
  end

  def complete
    update_attribute :state, Setting.smonth_sells.complete
  end



end
