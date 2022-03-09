class ControlsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!

  def index
    if current_user.has_role?(Setting.roles.sday_pdt_rpt)
      redirect_to sday_pdt_rpts_url
    else
      @factories = current_user.factories
      gon.fct = ""
      @factories.each do |fct|
        gon.fct += idencode(fct.id).to_s + ","
      end
      @other_quotas = [Setting.quota.inflow, Setting.quota.outflow, Setting.quota.outmud, Setting.quota.power]
    end
  end
      
      
      
end
