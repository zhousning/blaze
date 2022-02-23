class SmonthPowersController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @smonth_power = SmonthPower.new
   
    @smonth_powers = SmonthPower.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @smonth_power = SmonthPower.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @smonth_power = SmonthPower.new
    
  end
   

   
  def create
    @smonth_power = SmonthPower.new(smonth_power_params)
     
    if @smonth_power.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @smonth_power = SmonthPower.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @smonth_power = SmonthPower.find(iddecode(params[:id]))
   
    if @smonth_power.update(smonth_power_params)
      redirect_to smonth_power_path(idencode(@smonth_power.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @smonth_power = SmonthPower.find(iddecode(params[:id]))
   
    @smonth_power.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def smonth_power_params
      params.require(:smonth_power).permit( :power, :end_power, :bom, :end_bom, :avg_power, :yoy_bom, :mom_bom, :yoy, :mom, :ypdr)
    end
  
  
  
end

