class MthPdtRpt < ActiveRecord::Base






  has_one :month_bod
  accepts_nested_attributes_for :month_bod, allow_destroy: true


  has_one :month_cod
  accepts_nested_attributes_for :month_cod, allow_destroy: true


  has_one :month_tp
  accepts_nested_attributes_for :month_tp, allow_destroy: true


  has_one :month_tn
  accepts_nested_attributes_for :month_tn, allow_destroy: true


  has_one :month_nhn
  accepts_nested_attributes_for :month_nhn, allow_destroy: true


  has_one :month_fecal
  accepts_nested_attributes_for :month_fecal, allow_destroy: true


  has_one :month_device
  accepts_nested_attributes_for :month_device, allow_destroy: true


  has_one :month_stuff
  accepts_nested_attributes_for :month_stuff, allow_destroy: true


  has_one :month_power
  accepts_nested_attributes_for :month_power, allow_destroy: true


  has_one :month_ss
  accepts_nested_attributes_for :month_ss, allow_destroy: true

  has_one :month_mud
  accepts_nested_attributes_for :month_mud, allow_destroy: true

  has_one :month_md
  accepts_nested_attributes_for :month_md, allow_destroy: true

end
