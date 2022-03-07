class Ccompany < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true

  has_many :sfactories, :dependent => :destroy
  accepts_nested_attributes_for :sfactories, reject_if: :all_blank, allow_destroy: true

  has_many :cmpy_mth_rpts, :dependent => :destroy
  accepts_nested_attributes_for :cmpy_mth_rpts, reject_if: :all_blank, allow_destroy: true
end

# == Schema Information
#
# Table name: companies
#
#  id         :integer         not null, primary key
#  area       :string          default(""), not null
#  name       :string          default(""), not null
#  info       :text
#  lnt        :string          default(""), not null
#  lat        :string          default(""), not null
#  logo       :string          default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

