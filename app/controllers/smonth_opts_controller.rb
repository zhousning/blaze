class SmonthOptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @smonth_opt = SmonthOpt.new
   
    @smonth_opts = SmonthOpt.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @smonth_opt = SmonthOpt.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @smonth_opt = SmonthOpt.new
    
  end
   

   
  def create
    @smonth_opt = SmonthOpt.new(smonth_opt_params)
     
    if @smonth_opt.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @smonth_opt = SmonthOpt.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @smonth_opt = SmonthOpt.find(iddecode(params[:id]))
   
    if @smonth_opt.update(smonth_opt_params)
      redirect_to smonth_opt_path(idencode(@smonth_opt.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @smonth_opt = SmonthOpt.find(iddecode(params[:id]))
   
    @smonth_opt.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def smonth_opt_params
      params.require(:smonth_opt).permit( :ipt, :end_ipt, :max_ipt, :min_ipt, :avg_ipt, :max_date, :min_date, :yoy, :mom, :ypdr)
    end
  
  
  
end

