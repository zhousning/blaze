class CmpyMthRpt < ActiveRecord::Base

  mount_uploader :cmc_bill, EnclosureUploader
  mount_uploader :ecm_ans_rpt, AttachmentUploader

  belongs_to :ccompany
  belongs_to :ncompany
  

  has_one :cmpy_mth_ipt, :dependent => :destroy
  accepts_nested_attributes_for :cmpy_mth_ipt, reject_if: :all_blank, allow_destroy: true

  has_one :cmpy_mth_opt, :dependent => :destroy
  accepts_nested_attributes_for :cmpy_mth_opt, reject_if: :all_blank, allow_destroy: true

  has_one :cmpy_mth_sell, :dependent => :destroy
  accepts_nested_attributes_for :cmpy_mth_sell, reject_if: :all_blank, allow_destroy: true

  has_one :cmpy_mth_power, :dependent => :destroy
  accepts_nested_attributes_for :cmpy_mth_power, reject_if: :all_blank, allow_destroy: true

  STATESTR = %w(ongoing complete)
  STATE = [Setting.mth_pdt_rpts.ongoing, Setting.mth_pdt_rpts.complete]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.mth_pdt_rpts.ongoing, 
    STATESTR[1] => Setting.mth_pdt_rpts.complete
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def ongoing 
    update_attribute :state, Setting.mth_pdt_rpts.ongoing
  end

  def complete
    if ongoing?
      update_attribute :state, Setting.mth_pdt_rpts.complete
    end
  end

end

