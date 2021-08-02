class Department < ActiveRecord::Base


  belongs_to :factory


  has_many :user_depts, :dependent => :destroy
  has_many :users, :through => :user_depts

  has_many :roles, :dependent => :destroy
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true



  belongs_to :user

end
