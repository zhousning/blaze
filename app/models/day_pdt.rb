class DayPdt < ActiveRecord::Base




  has_many :enclosures, :dependent => :destroy
  accepts_nested_attributes_for :enclosures, reject_if: :all_blank, allow_destroy: true



  belongs_to :factory


  has_one :inf_qlty
  accepts_nested_attributes_for :inf_qlty, allow_destroy: true

  has_one :eff_qlty
  accepts_nested_attributes_for :eff_qlty, allow_destroy: true


  has_one :pdt_sum
  accepts_nested_attributes_for :pdt_sum, allow_destroy: true


  has_one :sed_qlty
  accepts_nested_attributes_for :sed_qlty, allow_destroy: true

  has_one :day_pdt_rpt
  accepts_nested_attributes_for :sed_qlty, allow_destroy: true

  def onging 
    update_attribute :state, Setting.day_pdts.ongoing
  end

  def complete 
    update_attribute :state, Setting.day_pdts.complete
  end
end
