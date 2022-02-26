class SmonthSellsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_filter :validate_state, :only => [:edit, :update]
  #authorize_resource

   
  def index
    fcts = current_user.sfactories.all.pluck(:id)
    @smonth_sells = SmonthSell.where(['sfactory_id in (?)', fcts]).order('id DESC').page( params[:page]).per( Setting.systems.per_page )
  end
   
  def show
    @smonth_sell = SmonthSell.find(iddecode(params[:id]))
  end
   
  def edit
  end
   
  def update
    if @smonth_sell.update(smonth_sell_params)
      redirect_to smonth_sell_path(idencode(@smonth_sell.id)) 
    else
      render :edit
    end
  end
   
  def upreport
    @smonth_sell = SmonthSell.find(iddecode(params[:id]))
    @smonth_sell.complete
    redirect_to smonth_sell_path(idencode(@smonth_sell.id)) 
  end

   
  private
    def smonth_sell_params
      params.require(:smonth_sell).permit( :val, :end_val, :max_val, :min_val, :avg_val, :max_date, :min_date, :yoy, :mom, :ypdr)
    end

    def validate_state
      @smonth_sell = SmonthSell.find(iddecode(params[:id]))
      if @smonth_sell.state == Setting.smonth_sells.complete
        redirect_to smonth_sells_url
      end
    end
  
  
end

