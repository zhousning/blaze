class SmonthSell < ActiveRecord::Base
  belongs_to :smth_pdt_rpt
  belongs_to :sfactory

  def ongoing 
    update_attribute :state, Setting.smonth_sells.ongoing
  end

  def complete
    update_attribute :state, Setting.smonth_sells.complete
  end


end
