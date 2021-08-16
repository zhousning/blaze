class DayPdt < ActiveRecord::Base

  validates :pdt_date, :presence => { :message => "日期必填" },
    :uniqueness => { :message => "当前日期运营数据已存在,不能重复创建" }
  validate :pdt_date_validation

  def pdt_date_validation
    if pdt_date > Date.today-1 || pdt_date < Date.new(2021,1,1)
      errors[:base] << "日期超限"
    end
  end


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

