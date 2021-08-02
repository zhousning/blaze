class Retrieval < ActiveRecord::Base
  has_one :project

  mount_uploader :sign, EnclosureUploader


  has_many :output_items, :dependent => :destroy
  accepts_nested_attributes_for :output_items, reject_if: :all_blank, allow_destroy: true


  belongs_to :user

  STATE = %w(opening selecting selected completed canceled)
  validates_inclusion_of :state, :in => STATE

  STATE.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
  end

  def selecting 
    if opening? or selected?
      update_attribute :state, Setting.retrievals.selecting 
    end
  end

  def selected 
    if selecting?
      update_attribute :state, Setting.retrievals.selected
    end
  end

  def complete
    if selected?
      update_attribute :state, Setting.retrievals.completed
    end
  end

  def cancel
    if opening? or selecting? or selected?
      update_attribute :state, Setting.retrievals.canceled
    end
  end

end


# == Schema Information
#
# Table name: retrievals
#
#  id         :integer         not null, primary key
#  name       :string          default(""), not null
#  outdate    :date
#  dept       :string          default(""), not null
#  receiver   :string          default(""), not null
#  sign       :string          default(""), not null
#  signer     :string          default(""), not null
#  state      :string
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

