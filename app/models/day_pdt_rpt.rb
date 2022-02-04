class DayPdtRpt < ActiveRecord::Base

  include FormulaLib
  #validates :pdt_date, :presence => { :message => "日期必填" },
  #  :uniqueness => { :message => "当前日期运营数据已存在,不能重复创建" }
  #validate :pdt_date_validation

  #def pdt_date_validation
  #  if pdt_date > Date.today-1 || pdt_date < Date.new(2021,1,1)
  #    errors[:base] << "日期超限"
  #  end
  #end

  has_many :tspmuds, :dependent => :destroy
  has_many :chemicals, :dependent => :destroy
  has_one :day_rpt_stc, :dependent => :destroy
  has_one :cday_rpt_stc, :dependent => :destroy

  belongs_to :day_pdt
  belongs_to :factory
  belongs_to :user

  #before_save 在 before_create之前执行, before_create只执行一次
  #before_save :update_day_rpt_stc
  #def update_day_rpt_stc
  #  self.day_rpt_stc.update_attributes
  #end


end



# == Schema Information
#
# Table name: day_pdt_rpts
#
#  id             :integer         not null, primary key
#  name           :string          default(""), not null
#  pdt_date       :date
#  weather        :string          default(""), not null
#  min_temper     :float           default("0.0"), not null
#  max_temper     :float           default("0.0"), not null
#  inf_qlty_bod   :float           default("0.0"), not null
#  inf_qlty_cod   :float           default("0.0"), not null
#  inf_qlty_ss    :float           default("0.0"), not null
#  inf_qlty_nhn   :float           default("0.0"), not null
#  inf_qlty_tn    :float           default("0.0"), not null
#  inf_qlty_tp    :float           default("0.0"), not null
#  inf_qlty_ph    :float           default("0.0"), not null
#  eff_qlty_cod   :float           default("0.0"), not null
#  eff_qlty_ss    :float           default("0.0"), not null
#  eff_qlty_nhn   :float           default("0.0"), not null
#  eff_qlty_tn    :float           default("0.0"), not null
#  eff_qlty_tp    :float           default("0.0"), not null
#  eff_qlty_ph    :float           default("0.0"), not null
#  eff_qlty_fecal :float           default("0.0"), not null
#  eff_qlty_bod   :float           default("0.0"), not null
#  sed_qlty_bod   :float           default("0.0"), not null
#  sed_qlty_cod   :float           default("0.0"), not null
#  sed_qlty_ss    :float           default("0.0"), not null
#  sed_qlty_nhn   :float           default("0.0"), not null
#  sed_qlty_tn    :float           default("0.0"), not null
#  sed_qlty_tp    :float           default("0.0"), not null
#  sed_qlty_ph    :float           default("0.0"), not null
#  inflow         :float           default("0.0"), not null
#  outflow        :float           default("0.0"), not null
#  inmud          :float           default("0.0"), not null
#  outmud         :float           default("0.0"), not null
#  mst            :float           default("0.0"), not null
#  power          :float           default("0.0"), not null
#  mdflow         :float           default("0.0"), not null
#  mdrcy          :float           default("0.0"), not null
#  mdsell         :float           default("0.0"), not null
#  per_cost       :float           default("0.0"), not null
#  inf_asy_cod    :float           default("0.0"), not null
#  inf_asy_nhn    :float           default("0.0"), not null
#  inf_asy_tp     :float           default("0.0"), not null
#  inf_asy_tn     :float           default("0.0"), not null
#  eff_asy_cod    :float           default("0.0"), not null
#  eff_asy_nhn    :float           default("0.0"), not null
#  eff_asy_tp     :float           default("0.0"), not null
#  eff_asy_tn     :float           default("0.0"), not null
#  sed_asy_cod    :float           default("0.0"), not null
#  sed_asy_nhn    :float           default("0.0"), not null
#  sed_asy_tp     :float           default("0.0"), not null
#  sed_asy_tn     :float           default("0.0"), not null
#  day_pdt_id     :integer
#  factory_id     :integer
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

