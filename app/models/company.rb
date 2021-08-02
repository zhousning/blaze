class Company < ActiveRecord::Base

  mount_uploader :logo, EnclosureUploader






  has_many :users, :dependent => :destroy
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true


  has_many :factories, :dependent => :destroy
  accepts_nested_attributes_for :factories, reject_if: :all_blank, allow_destroy: true



end
