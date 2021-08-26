class TspmudsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   

   

   

   

   

   

   

  

  

  
  
  

  private
    def tspmud_params
      params.require(:tspmud).permit( :tspvum, :dealer, :rcpvum, :price, :prtmtd, :goort)
    end
  
  
  
end

