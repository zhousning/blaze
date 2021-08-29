class ControlsController < ApplicationController
  #layout "application_control"
  layout "application_no_header"
  before_filter :authenticate_user!

  def index
    @factories = current_user.factories
    @other_quotas = [Setting.quota.inflow, Setting.quota.outflow, Setting.quota.outmud, Setting.quota.power]
  end
      
      
      
end
