class DayPdt < ActiveRecord::Base
  validates :min_temper, :max_temper, :pdt_date, :signer, :weather, :presence => true 
  #validates :pdt_date, :presence => { :message => "日期必填" }
  #:uniqueness => { :message => "当前日期运营数据已存在,不能重复创建" }
  #validate :pdt_date_validation

  #def pdt_date_validation
  #  if pdt_date > Date.today-1 || pdt_date < Date.new(2021,5,1)
  #    errors[:base] << "日期超限"
  #  end
  #end


  has_many :tspmuds, :dependent => :destroy
  accepts_nested_attributes_for :tspmuds, reject_if: :all_blank, allow_destroy: true

  has_many :chemicals, :dependent => :destroy
  accepts_nested_attributes_for :chemicals, reject_if: :all_blank, allow_destroy: true

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

  STATESTR = %w(ongoing verifying rejected cmp_verifying cmp_rejected complete)
  STATE = [Setting.day_pdts.ongoing, Setting.day_pdts.verifying,  Setting.day_pdts.rejected, Setting.day_pdts.cmp_verifying,  Setting.day_pdts.cmp_rejected,  Setting.day_pdts.complete]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.day_pdts.ongoing, 
    STATESTR[1] => Setting.day_pdts.verifying,  
    STATESTR[2] => Setting.day_pdts.rejected,  
    STATESTR[3] => Setting.day_pdts.cmp_verifying,  
    STATESTR[4] => Setting.day_pdts.cmp_rejected,  
    STATESTR[5] => Setting.day_pdts.complete
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def onging 
    update_attribute :state, Setting.day_pdts.ongoing
  end

  def verifying 
    if ongoing? || rejected? || cmp_rejected? 
      update_attribute :state, Setting.day_pdts.verifying
    end
  end

  def rejected 
    if verifying?
      update_attribute :state, Setting.day_pdts.rejected 
    end
  end

  def cmp_verifying 
    if verifying? 
      update_attribute :state, Setting.day_pdts.cmp_verifying
    end
  end

  def cmp_rejected 
    if cmp_verifying?
      update_attribute :state, Setting.day_pdts.cmp_rejected 
    end
  end

  def complete
    if cmp_verifying?
      update_attribute :state, Setting.day_pdts.complete
    end
  end


end

# == Schema Information
#
# Table name: day_pdts
#
#  id         :integer         not null, primary key
#  pdt_date   :date
#  name       :string          default(""), not null
#  signer     :string          default(""), not null
#  weather    :string          default(""), not null
#  temper     :float           default("0.0"), not null
#  desc       :text
#  state      :integer         default("0"), not null
#  factory_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

