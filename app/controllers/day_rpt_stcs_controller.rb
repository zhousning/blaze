class DayRptStcsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @day_rpt_stc = DayRptStc.new
   
    @day_rpt_stcs = DayRptStc.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @day_rpt_stc = DayRptStc.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @day_rpt_stc = DayRptStc.new
    
  end
   

   
  def create
    @day_rpt_stc = DayRptStc.new(day_rpt_stc_params)
     
    if @day_rpt_stc.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @day_rpt_stc = DayRptStc.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @day_rpt_stc = DayRptStc.find(iddecode(params[:id]))
   
    if @day_rpt_stc.update(day_rpt_stc_params)
      redirect_to day_rpt_stc_path(idencode(@day_rpt_stc.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @day_rpt_stc = DayRptStc.find(iddecode(params[:id]))
   
    @day_rpt_stc.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def day_rpt_stc_params
      params.require(:day_rpt_stc).permit( :bcr, :bnr, :bpr, :bom, :cod_bom, :bod_bom, :nhn_bom, :tp_bom, :tn_bom, :ss_bom, :cod_emq, :bod_emq, :nhn_emq, :tp_emq, :tn_emq, :ss_emq, :cod_emr, :bod_emr, :nhn_emr, :tp_emr, :tn_emr, :ss_emr)
    end
  
  
  
end

