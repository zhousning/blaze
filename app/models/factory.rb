class Factory < ActiveRecord::Base

  mount_uploader :logo, EnclosureUploader

  belongs_to :company


  has_many :user_fcts, :dependent => :destroy
  has_many :users, :through => :user_fcts


  has_many :departments, :dependent => :destroy
  accepts_nested_attributes_for :departments, reject_if: :all_blank, allow_destroy: true


  has_many :day_pdts, :dependent => :destroy
  accepts_nested_attributes_for :day_pdts, reject_if: :all_blank, allow_destroy: true


  has_many :day_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :day_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  has_many :mth_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :mth_pdt_rpts, reject_if: :all_blank, allow_destroy: true

  has_many :mth_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :mth_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  has_many :ses_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :ses_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  has_many :hyear_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :hyear_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  has_many :year_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :year_pdt_rpts, reject_if: :all_blank, allow_destroy: true

  has_many :emp_infs, :dependent => :destroy
  accepts_nested_attributes_for :emp_infs, reject_if: :all_blank, allow_destroy: true

  has_many :emp_effs, :dependent => :destroy
  accepts_nested_attributes_for :emp_effs, reject_if: :all_blank, allow_destroy: true
end


# == Schema Information
#
# Table name: factories
#
#  id         :integer         not null, primary key
#  area       :string          default(""), not null
#  name       :string          default(""), not null
#  info       :text
#  lnt        :string          default(""), not null
#  lat        :string          default(""), not null
#  design     :float           default("0.0"), not null
#  plan       :float           default("0.0"), not null
#  logo       :string          default(""), not null
#  company_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

