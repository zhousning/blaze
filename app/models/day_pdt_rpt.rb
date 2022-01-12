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

  belongs_to :day_pdt
  belongs_to :factory
  belongs_to :user

  #before_save 在 before_create之前执行, before_create只执行一次
  before_save :update_day_stc
  before_create :build_day_stc

  def build_day_stc
    clyjcb, tuodancb, qctpcb, qctncb = chemical_cost(self)

    build_day_rpt_stc(
      :bcr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_cod),
      :bnr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_tn),
      :bpr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_tp),
      :bom     => FormulaLib.bom(self.power, self.inflow), 

      :cod_bom => FormulaLib.em_bom(self.power, self.inf_qlty_cod, self.eff_qlty_cod, self.inflow ), 
      :bod_bom => FormulaLib.em_bom(self.power, self.inf_qlty_bod, self.eff_qlty_bod, self.inflow ), 
      :nhn_bom => FormulaLib.em_bom(self.power, self.inf_qlty_nhn, self.eff_qlty_nhn, self.inflow ), 
      :tp_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_tp,  self.eff_qlty_tp,  self.inflow ), 
      :tn_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_tn,  self.eff_qlty_tn,  self.inflow ), 
      :ss_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_ss,  self.eff_qlty_ss,  self.inflow ), 

      :cod_emq => FormulaLib.emq(self.inf_qlty_cod, self.eff_qlty_cod,  self.inflow ), 
      :bod_emq => FormulaLib.emq(self.inf_qlty_bod, self.eff_qlty_bod,  self.inflow ), 
      :nhn_emq => FormulaLib.emq(self.inf_qlty_nhn, self.eff_qlty_nhn,  self.inflow ), 
      :tp_emq  => FormulaLib.emq(self.inf_qlty_tp,  self.eff_qlty_tp,   self.inflow ), 
      :tn_emq  => FormulaLib.emq(self.inf_qlty_tn,  self.eff_qlty_tn,   self.inflow ), 
      :ss_emq  => FormulaLib.emq(self.inf_qlty_ss,  self.eff_qlty_ss,   self.inflow ), 

      :cod_emr => FormulaLib.emr(self.inf_qlty_cod, self.eff_qlty_cod ), 
      :bod_emr => FormulaLib.emr(self.inf_qlty_bod, self.eff_qlty_bod ), 
      :nhn_emr => FormulaLib.emr(self.inf_qlty_nhn, self.eff_qlty_nhn ), 
      :tp_emr  => FormulaLib.emr(self.inf_qlty_tp,  self.eff_qlty_tp  ), 
      :tn_emr  => FormulaLib.emr(self.inf_qlty_tn,  self.eff_qlty_tn  ), 
      :ss_emr  => FormulaLib.emr(self.inf_qlty_ss,  self.eff_qlty_ss  ),

      :cod_inflow => FormulaLib.multiply(self.inf_qlty_cod, self.inflow ), 
      :bod_inflow => FormulaLib.multiply(self.inf_qlty_bod, self.inflow ), 
      :nhn_inflow => FormulaLib.multiply(self.inf_qlty_nhn, self.inflow ), 
      :tp_inflow  => FormulaLib.multiply(self.inf_qlty_tp,  self.inflow ), 
      :tn_inflow  => FormulaLib.multiply(self.inf_qlty_tn,  self.inflow ), 
      :ss_inflow  => FormulaLib.multiply(self.inf_qlty_ss,  self.inflow ),

      :tp_cost => clyjcb, 
      :tn_cost => tuodancb, 
      :tp_utcost => qctpcb, 
      :tn_utcost => qctncb
    )
  end

  def update_day_stc
    if self.day_rpt_stc
      clyjcb, tuodancb, qctpcb, qctncb = chemical_cost(self)

      self.day_rpt_stc.update_attributes(
        :bcr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_cod),
        :bnr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_tn),
        :bpr     => FormulaLib.ratio(self.inf_qlty_bod, self.inf_qlty_tp),
        :bom     => FormulaLib.bom(self.power, self.inflow), 

        :cod_bom => FormulaLib.em_bom(self.power, self.inf_qlty_cod, self.eff_qlty_cod, self.inflow ), 
        :bod_bom => FormulaLib.em_bom(self.power, self.inf_qlty_bod, self.eff_qlty_bod, self.inflow ), 
        :nhn_bom => FormulaLib.em_bom(self.power, self.inf_qlty_nhn, self.eff_qlty_nhn, self.inflow ), 
        :tp_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_tp,  self.eff_qlty_tp,  self.inflow ), 
        :tn_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_tn,  self.eff_qlty_tn,  self.inflow ), 
        :ss_bom  => FormulaLib.em_bom(self.power, self.inf_qlty_ss,  self.eff_qlty_ss,  self.inflow ), 

        :cod_emq => FormulaLib.emq(self.inf_qlty_cod, self.eff_qlty_cod,  self.inflow ), 
        :bod_emq => FormulaLib.emq(self.inf_qlty_bod, self.eff_qlty_bod,  self.inflow ), 
        :nhn_emq => FormulaLib.emq(self.inf_qlty_nhn, self.eff_qlty_nhn,  self.inflow ), 
        :tp_emq  => FormulaLib.emq(self.inf_qlty_tp,  self.eff_qlty_tp,   self.inflow ), 
        :tn_emq  => FormulaLib.emq(self.inf_qlty_tn,  self.eff_qlty_tn,   self.inflow ), 
        :ss_emq  => FormulaLib.emq(self.inf_qlty_ss,  self.eff_qlty_ss,   self.inflow ), 

        :cod_emr => FormulaLib.emr(self.inf_qlty_cod, self.eff_qlty_cod ), 
        :bod_emr => FormulaLib.emr(self.inf_qlty_bod, self.eff_qlty_bod ), 
        :nhn_emr => FormulaLib.emr(self.inf_qlty_nhn, self.eff_qlty_nhn ), 
        :tp_emr  => FormulaLib.emr(self.inf_qlty_tp,  self.eff_qlty_tp  ), 
        :tn_emr  => FormulaLib.emr(self.inf_qlty_tn,  self.eff_qlty_tn  ), 
        :ss_emr  => FormulaLib.emr(self.inf_qlty_ss,  self.eff_qlty_ss  ),

        :cod_inflow => FormulaLib.multiply(self.inf_qlty_cod, self.inflow ), 
        :bod_inflow => FormulaLib.multiply(self.inf_qlty_bod, self.inflow ), 
        :nhn_inflow => FormulaLib.multiply(self.inf_qlty_nhn, self.inflow ), 
        :tp_inflow  => FormulaLib.multiply(self.inf_qlty_tp,  self.inflow ), 
        :tn_inflow  => FormulaLib.multiply(self.inf_qlty_tn,  self.inflow ), 
        :ss_inflow  => FormulaLib.multiply(self.inf_qlty_ss,  self.inflow ),

        :tp_cost => clyjcb, 
        :tn_cost => tuodancb, 
        :tp_utcost => qctpcb, 
        :tn_utcost => qctncb
      )
    end
  end

  private
    def chemical_cost(day_rpt)
      chemicals = day_rpt.chemicals
      inflow = day_rpt.inflow
      clyj_cost = 0
      tuodan_cost = 0
      chemicals.each do |cmc|
        tanyuan = [Setting.chemical_ctgs.csn, Setting.chemical_ctgs.jc, Setting.chemical_ctgs.xxty]
        clyj = [Setting.chemical_ctgs.pac, Setting.chemical_ctgs.slht, Setting.chemical_ctgs.jhlst]
        if clyj.include?(cmc.name)
          clyj_cost += cmc.unprice*cmc.dosage 
        end
        if tanyuan.include?(cmc.name)
          tuodan_cost += cmc.unprice*cmc.dosage
        end
      end

      tp_emq = FormulaLib.emq(day_rpt.inf_qlty_tp, day_rpt.eff_qlty_tp, day_rpt.inflow )
      tn_emq = FormulaLib.emq(day_rpt.inf_qlty_tn, day_rpt.eff_qlty_tn, day_rpt.inflow )

      clyjcb = FormulaLib.format_num(clyj_cost/inflow)
      tuodancb = FormulaLib.format_num(tuodan_cost/inflow)
      qctpcb = FormulaLib.format_num(clyj_cost/tp_emq)
      qctncb = FormulaLib.format_num(tuodan_cost/tn_emq)

      [clyjcb, tuodancb, qctpcb, qctncb]
    end

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

