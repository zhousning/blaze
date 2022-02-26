class SmonthSellsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_filter :validate_state, :only => [:edit, :update]
  #authorize_resource

  include FormulaLib

   
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
    output_params = compute_content(@smonth_sell, smonth_sell_params)
    if @smonth_sell.update(output_params)
      mth_pdt_rpt = @smonth_sell.smth_pdt_rpt
      qa = mth_pdt_rpt.smonth_opt.val
      qae = @smonth_sell.val
      ra = FormulaLib.ra(qa, qae)
      mth_pdt_rpt.update_attributes(:leakage => ra)
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

    def compute_content(smonth_sell, input_params)
      factory = smonth_sell.sfactory
      date = smonth_sell.start_date
      year = date.year
      month = date.month
      now_val = smonth_sell.val

      end_val = factory.smonth_sells.where(["start_date between ? and ?", Date.new(year, 1, 1), date]).sum(:val)

      yoy_year = year - 1
      _yoy_start = Date.new(yoy_year, month, 1)
      yoy_sell = SmonthSell.where(:start_date => _yoy_start).first
      yoy_val = yoy_sell.nil? ? 0 : yoy_sell.val

      mom_year = year
      mom_month = month - 1
      if mom_month == 0
        mom_month = 12
        mom_year = year - 1
      end
      _mom_start = Date.new(mom_year, mom_month, 1)
      mom_sell = SmonthSell.where(:start_date => _mom_start).first
      mom_val = mom_sell.nil? ? 0 : mom_sell.val

      yoy = FormulaLib.yoy(now_val, yoy_val)
      mom = FormulaLib.mom(now_val, mom_val)

      output_params = input_params
      output_params[:end_val] = end_val 
      output_params[:yoy] = yoy 
      output_params[:mom] = mom 
      return output_params
    end
  
  
end

