class Tspmud < ActiveRecord::Base






  belongs_to :day_pdt


  belongs_to :day_pdt_rpt



end

# == Schema Information
#
# Table name: tspmuds
#
#  id             :integer         not null, primary key
#  tspvum         :float           default("0.0"), not null
#  dealer         :string          default(""), not null
#  rcpvum         :float           default("0.0"), not null
#  price          :float           default("0.0"), not null
#  prtmtd         :string          default(""), not null
#  goort          :string          default(""), not null
#  day_pdt_id     :integer
#  day_pdt_rpt_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

