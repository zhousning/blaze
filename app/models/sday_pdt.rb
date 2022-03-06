class SdayPdt < ActiveRecord::Base

  belongs_to :sfactory

  has_one :sday_pdt_stc
  accepts_nested_attributes_for :sday_pdt_stc, allow_destroy: true


  STATESTR = %w(ongoing verifying rejected cmp_verifying cmp_rejected complete)
  STATE = [Setting.day_pdts.ongoing, Setting.day_pdts.verifying,  Setting.day_pdts.rejected, Setting.day_pdts.cmp_verifying,  Setting.day_pdts.cmp_rejected,  Setting.day_pdts.complete]
  validates_inclusion_of :state, :in => STATE
  state_hash = {
    STATESTR[0] => Setting.day_pdts.ongoing, 
    STATESTR[1] => Setting.day_pdts.verifying,  
    STATESTR[2] => Setting.day_pdts.rejected,  
    STATESTR[3] => Setting.day_pdts.cmp_verifying,  
    STATESTR[4] => Setting.day_pdts.cmp_rejected,  
    STATESTR[5] => Setting.day_pdts.complete
  }

  STATESTR.each do |state|
    define_method "#{state}?" do
      self.state == state_hash[state]
    end
  end

  def onging 
    update_attribute :state, Setting.day_pdts.ongoing
  end

  def verifying 
    if ongoing? || rejected? || cmp_rejected? 
      update_attribute :state, Setting.day_pdts.verifying
    end
  end

  def rejected 
    if verifying?
      update_attribute :state, Setting.day_pdts.rejected 
    end
  end

  def cmp_verifying 
    if verifying? 
      update_attribute :state, Setting.day_pdts.cmp_verifying
    end
  end

  def cmp_rejected 
    if cmp_verifying?
      update_attribute :state, Setting.day_pdts.cmp_rejected 
    end
  end

  def complete
    if cmp_verifying?
      update_attribute :state, Setting.day_pdts.complete
    end
  end



end
