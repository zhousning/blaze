class DayPdtRpt < ActiveRecord::Base






  belongs_to :day_pdt


  belongs_to :factory



  belongs_to :user

end

# == Schema Information
#
# Table name: day_pdt_rpts
#
#  id             :integer         not null, primary key
#  name           :string          default(""), not null
#  pdt_date       :date
#  weather        :string          default(""), not null
#  temper         :float           default("0.0"), not null
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
#  day_pdt_id     :integer
#  factory_id     :integer
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

