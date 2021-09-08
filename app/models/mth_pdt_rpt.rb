class MthPdtRpt < ActiveRecord::Base

  mount_uploader :cmc_bill, EnclosureUploader



  mount_uploader :ecm_ans_rpt, AttachmentUploader

  has_many :mth_chemicals, :dependent => :destroy
  accepts_nested_attributes_for :mth_chemicals, reject_if: :all_blank, allow_destroy: true


  has_one :document




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

  belongs_to :factory

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

end

# == Schema Information
#
# Table name: mth_pdt_rpts
#
#  id          :integer         not null, primary key
#  start_date  :date
#  end_date    :date
#  name        :string          default(""), not null
#  design      :float           default("0.0"), not null
#  outflow     :float           default("0.0"), not null
#  avg_outflow :float           default("0.0"), not null
#  end_outflow :float           default("0.0"), not null
#  state       :integer         default("0"), not null
#  factory_id  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

