class ControlsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!

  def index
    @factories = current_user.factories
  end
      
      
      
end
