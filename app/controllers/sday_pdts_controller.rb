class SdayPdtsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @sday_pdt = SdayPdt.new
   
    @sday_pdts = SdayPdt.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @sday_pdt = SdayPdt.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @sday_pdt = SdayPdt.new
    
  end
   

   
  def create
    @sday_pdt = SdayPdt.new(sday_pdt_params)
     
    if @sday_pdt.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @sday_pdt = SdayPdt.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @sday_pdt = SdayPdt.find(iddecode(params[:id]))
   
    if @sday_pdt.update(sday_pdt_params)
      redirect_to sday_pdt_path(idencode(@sday_pdt.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @sday_pdt = SdayPdt.find(iddecode(params[:id]))
   
    @sday_pdt.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def sday_pdt_params
      params.require(:sday_pdt).permit( :name, :pdt_date, :signer, :state, :weather, :min_temper, :max_temper, :desc, :one_verify, :two_verify, :ipt, :opt, :pres, :power, :yl, :zd, :yd, :ph)
    end
  
  
  
end

