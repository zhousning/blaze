class Quota < ActiveRecord::Base







end

# == Schema Information
#
# Table name: quota
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  code       :string          default(""), not null
#  ctg        :string          default(""), not null
#  max        :float
#  min        :float
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

