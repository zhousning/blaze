class CmpyMthSellsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_filter :validate_state, :only => [:edit, :update]
  #authorize_resource

  include FormulaLib

   
  def index
    ccmpy = current_user.ccompany
    ncmpy = current_user.ncompany
    @cmpy_mth_sells = [] 
    @cmpy_mth_sells += ccmpy.cmpy_mth_sells.where(:state => Setting.mth_pdt_rpts.ongoing) if ccmpy 
    @cmpy_mth_sells += ncmpy.cmpy_mth_sells.where(:state => Setting.mth_pdt_rpts.ongoing) if ncmpy
  end
   
  def show
    @cmpy_mth_sell = CmpyMthSell.find(iddecode(params[:id]))
  end
   
  def edit
  end
   
  def update
    output_params = compute_content(@cmpy_mth_sell, cmpy_mth_sell_params)
    if @cmpy_mth_sell.update(output_params)
      mth_pdt_rpt = @cmpy_mth_sell.cmpy_mth_rpt
      qa = mth_pdt_rpt.cmpy_mth_opt.val
      qae = @cmpy_mth_sell.val
      ra = FormulaLib.ra(qa, qae)
      mth_pdt_rpt.update_attributes(:leakage => ra)
      redirect_to cmpy_mth_sell_path(idencode(@cmpy_mth_sell.id)) 
    else
      render :edit
    end
  end
   
  def upreport
    @cmpy_mth_sell = CmpyMthSell.find(iddecode(params[:id]))
    @cmpy_mth_sell.complete
    redirect_to cmpy_mth_sell_path(idencode(@cmpy_mth_sell.id)) 
  end

   
  private
    def cmpy_mth_sell_params
      params.require(:cmpy_mth_sell).permit( :val, :end_val, :max_val, :min_val, :avg_val, :max_date, :min_date, :yoy, :mom, :ypdr)
    end

    def validate_state
      @cmpy_mth_sell = CmpyMthSell.find(iddecode(params[:id]))
      if @cmpy_mth_sell.state == Setting.mth_pdt_rpts.complete
        redirect_to cmpy_mth_sells_url
      end
    end

    def compute_content(cmpy_mth_sell, input_params)
      company = nil
      if cmpy_mth_sell.category == Setting.cmpy_mth_rpts.ccategory
        company = cmpy_mth_sell.ccompany
      elsif cmpy_mth_sell.category == Setting.cmpy_mth_rpts.ncategory
        company = cmpy_mth_sell.ncompany
      end

      date = cmpy_mth_sell.start_date
      year = date.year
      month = date.month
      now_val = input_params[:val].to_f
      end_val = now_val

      last_month = month - 1
      if last_month != 0 
        sum = company.cmpy_mth_sells.where(["start_date between ? and ?", Date.new(year, 1, 1), Date.new(year, last_month, 1)]).sum(:val)
        end_val += sum 
      end

      yoy_year = year - 1
      _yoy_start = Date.new(yoy_year, month, 1)
      yoy_sell = CmpyMthSell.where(:start_date => _yoy_start).first
      yoy_val = yoy_sell.nil? ? 0 : yoy_sell.val

      mom_year = year
      mom_month = month - 1
      if mom_month == 0
        mom_month = 12
        mom_year = year - 1
      end
      _mom_start = Date.new(mom_year, mom_month, 1)
      mom_sell = CmpyMthSell.where(:start_date => _mom_start).first
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

