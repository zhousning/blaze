class SmonthIpt < ActiveRecord::Base





  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true


  belongs_to :smth_pdt_rpt



end
