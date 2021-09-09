class Mudfct < ActiveRecord::Base






  belongs_to :factory



end

# == Schema Information
#
# Table name: mudfcts
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  ability    :float           default("0.0"), not null
#  factory_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

