class SmthPdtRpt < ActiveRecord::Base

  mount_uploader :cmc_bill, EnclosureUploader
  mount_uploader :ecm_ans_rpt, AttachmentUploader

  belongs_to :sfactory

  has_one :smonth_ipt, :dependent => :destroy
  accepts_nested_attributes_for :smonth_ipt, reject_if: :all_blank, allow_destroy: true

  has_one :smonth_opt, :dependent => :destroy
  accepts_nested_attributes_for :smonth_opt, reject_if: :all_blank, allow_destroy: true

  has_one :smonth_sell, :dependent => :destroy
  accepts_nested_attributes_for :smonth_sell, reject_if: :all_blank, allow_destroy: true

  has_one :smonth_power, :dependent => :destroy
  accepts_nested_attributes_for :smonth_power, reject_if: :all_blank, allow_destroy: true

  has_one :smonth_press, :dependent => :destroy
  accepts_nested_attributes_for :smonth_press, reject_if: :all_blank, allow_destroy: true

  STATESTR = %w(ongoing verifying rejected cmp_verifying cmp_rejected complete)
  STATE = [Setting.mth_pdt_rpts.ongoing, Setting.mth_pdt_rpts.verifying,  Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying,  Setting.mth_pdt_rpts.cmp_rejected,  Setting.mth_pdt_rpts.complete]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.mth_pdt_rpts.ongoing, 
    STATESTR[1] => Setting.mth_pdt_rpts.verifying,  
    STATESTR[2] => Setting.mth_pdt_rpts.rejected,  
    STATESTR[3] => Setting.mth_pdt_rpts.cmp_verifying,  
    STATESTR[4] => Setting.mth_pdt_rpts.cmp_rejected,  
    STATESTR[5] => Setting.mth_pdt_rpts.complete
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def onging 
    update_attribute :state, Setting.mth_pdt_rpts.ongoing
  end

  def verifying 
    if ongoing? || rejected? || cmp_rejected? 
      update_attribute :state, Setting.mth_pdt_rpts.verifying
    end
  end

  def rejected 
    if verifying?
      update_attribute :state, Setting.mth_pdt_rpts.rejected 
    end
  end

  def cmp_verifying 
    if verifying? 
      update_attribute :state, Setting.mth_pdt_rpts.cmp_verifying
    end
  end

  def cmp_rejected 
    if cmp_verifying?
      update_attribute :state, Setting.mth_pdt_rpts.cmp_rejected 
    end
  end

  def complete
    if cmp_verifying?
      update_attribute :state, Setting.mth_pdt_rpts.complete
    end
  end

  def update_per_cost(per_cost)
    self.update_attribute :per_cost, per_cost 
  end
end

