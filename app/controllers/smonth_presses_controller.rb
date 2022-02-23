class SmonthPressesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @smonth_press = SmonthPress.new
   
    @smonth_presses = SmonthPress.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @smonth_press = SmonthPress.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @smonth_press = SmonthPress.new
    
  end
   

   
  def create
    @smonth_press = SmonthPress.new(smonth_press_params)
     
    if @smonth_press.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @smonth_press = SmonthPress.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @smonth_press = SmonthPress.find(iddecode(params[:id]))
   
    if @smonth_press.update(smonth_press_params)
      redirect_to smonth_press_path(idencode(@smonth_press.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @smonth_press = SmonthPress.find(iddecode(params[:id]))
   
    @smonth_press.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def smonth_press_params
      params.require(:smonth_press).permit( :max_pres, :min_pres, :avg_pres, :max_date, :min_date)
    end
  
  
  
end

