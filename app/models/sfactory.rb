class Sfactory < ActiveRecord::Base

  mount_uploader :logo, EnclosureUploader

  belongs_to :company

  has_many :user_sfcts, :dependent => :destroy
  has_many :users, :through => :user_sfcts

  has_many :sday_pdts, :dependent => :destroy
  accepts_nested_attributes_for :sday_pdts, reject_if: :all_blank, allow_destroy: true

  has_many :sday_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :sday_pdt_rpts, reject_if: :all_blank, allow_destroy: true

  has_many :smth_pdt_rpts, :dependent => :destroy
  accepts_nested_attributes_for :smth_pdt_rpts, reject_if: :all_blank, allow_destroy: true

  #has_many :departments, :dependent => :destroy
  #accepts_nested_attributes_for :departments, reject_if: :all_blank, allow_destroy: true

  #has_many :ses_pdt_rpts, :dependent => :destroy
  #accepts_nested_attributes_for :ses_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  #has_many :hyear_pdt_rpts, :dependent => :destroy
  #accepts_nested_attributes_for :hyear_pdt_rpts, reject_if: :all_blank, allow_destroy: true


  #has_many :year_pdt_rpts, :dependent => :destroy
  #accepts_nested_attributes_for :year_pdt_rpts, reject_if: :all_blank, allow_destroy: true



end
