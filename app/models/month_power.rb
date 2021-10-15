class MonthPower < ActiveRecord::Base
  include FormulaLib

  belongs_to :mth_pdt_rpt


  #这个还需要测试暂时不用
  #before_save :update_power
  #def update_power
  #  mth_pdt_rpt = self.mth_pdt_rpt
  #  factory = mth_pdt_rpt.factory

  #  mydate = mth_pdt_rpt.start_date
  #  year = mydate.year
  #  month = mydate.month

  #  yoy_year = year - 1

  #  mom_year = year
  #  mom_month = month - 1
  #  if mom_month == 0
  #    mom_month = 12
  #    mom_year = year - 1
  #  end

  #  last_year_date  = Date.new(yoy_year, month, 1)
  #  last_month_date = Date.new(mom_year, mom_month, 1)

  #  @last_year_mth_rpt  = factory.mth_pdt_rpts.where(:start_date => last_year_date).first
  #  @last_month_mth_rpt = factory.mth_pdt_rpts.where(:start_date => last_month_date).first
  #  last_year_power = 0 
  #  last_year_bom   = 0
  #  last_mth_power  = 0
  #  last_mth_bom    = 0

  #  if !@last_year_mth_rpt.nil?
  #    mth_power = @last_year_mth_rpt.month_power
  #    last_year_power =  mth_power.nil? ? 0 : mth_power.power
  #    last_year_bom   =  mth_power.nil? ? 0 : mth_power.bom
  #  end

  #  if !@last_month_mth_rpt.nil?
  #    mth_power = @last_month_mth_rpt.month_power
  #    last_mth_power =  mth_power.nil? ? 0 : mth_power.power
  #    last_mth_bom   =  mth_power.nil? ? 0 : mth_power.bom
  #  end

  #  power = FormulaLib.format_num(self.power)
  #  power_sum = last_mth_power.power_sum + power

  #  bom = FormulaLib.bom(power*10000, mth_pdt_rpt.outflow) 

  #  yoy_power = FormulaLib.yoy(power, last_year_power)
  #  mom_power = FormulaLib.mom(power, last_mth_power)

  #  yoy_bom = FormulaLib.yoy(bom, last_year_bom)
  #  mom_bom = FormulaLib.mom(bom, last_mth_bom)

  #  self.update_attributes(:power => power, :end_power => power_sum, :bom => bom, :yoy_power => yoy_power, :mom_power => mom_power, :yoy_bom => yoy_bom, :mom_bom => mom_bom)
  #end


end

# == Schema Information
#
# Table name: month_powers
#
#  id             :integer         not null, primary key
#  power          :float           default("0.0"), not null
#  end_power      :float           default("0.0"), not null
#  bom            :float           default("0.0"), not null
#  bom_power      :float           default("0.0"), not null
#  yoy_power      :float           default("0.0"), not null
#  mom_power      :float           default("0.0"), not null
#  ypdr_power     :float           default("0.0"), not null
#  yoy_bom        :float           default("0.0"), not null
#  mom_bom        :float           default("0.0"), not null
#  ypdr_bom       :float           default("0.0"), not null
#  mth_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

