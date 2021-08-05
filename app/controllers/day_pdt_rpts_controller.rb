class DayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @day_pdt_rpt = DayPdtRpt.new
    @factory = my_factory
   
    @day_pdt_rpts = @factory.day_pdt_rpts.order('pdt_date DESC') if @factory
   
  end
   
  def show
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))
  end
   
  def sglfct_statistic
    @factories = current_user.factories
    @quotas = Quota.where(:ctg => 0)
  end

  def mtlfct_statistic
  end


  def sglfct_stc_cau
    @factory = my_factory
    assay = my_assay
   
    _start = params[:start]
    _end = params[:end]
    _flow = params[:flow] 
    _qcodes = params[:qcodes].split(",")
    quota_h = quota_hash

    series = []
    dimensions = ['date']
    _qcodes.each do |code|
      if assay.include?(code)
        series << {type: 'line'}
        dimensions << quota_h[code]
      end
    end

    @day_pdt_rpts = @factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
    categories = []
    @day_pdt_rpts.each do |rpt|
      ctg_hash = {'date': rpt.pdt_date}

      if _flow == Setting.quota.inflow_c
        _qcodes.each do |code|
          inf_quota(ctg_hash, quota_h, code, rpt) unless other_quota(ctg_hash, quota_h, code, rpt)
        end
      elsif _flow == Setting.quota.outflow_c
        _qcodes.each do |code|
          eff_quota(ctg_hash, quota_h, code, rpt) unless other_quota(ctg_hash, quota_h, code, rpt)
        end
      end
      categories << ctg_hash
    end

    puts categories

    respond_to do |format|
      format.json{ render :json => 
        {
          :categories => categories, 
          :series => series,
          :dimensions => dimensions
        }
      }
    end
  end

  def mtlfct_stc_cau
  end

  def produce_report 
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))

    respond_to do |format|
      format.json{ render :json => 
        {
          :categories => [
            {:source => "COD", :'进水' => @day_pdt_rpt.inf_qlty_cod, :'出水' => @day_pdt_rpt.eff_qlty_cod},
            {:source => "BOD", :'进水' => @day_pdt_rpt.inf_qlty_bod, :'出水' => @day_pdt_rpt.eff_qlty_bod},
            {:source => "TN", :'进水' => @day_pdt_rpt.inf_qlty_tn, :'出水' => @day_pdt_rpt.eff_qlty_tn},
            {:source => "TP", :'进水' => @day_pdt_rpt.inf_qlty_tp, :'出水' => @day_pdt_rpt.eff_qlty_tp},
            {:source => "NH3-N", :'进水' => @day_pdt_rpt.inf_qlty_nhn, :'出水' => @day_pdt_rpt.eff_qlty_nhn},
            {:source => "PH", :'进水' => @day_pdt_rpt.inf_qlty_ph, :'出水' => @day_pdt_rpt.eff_qlty_ph}
          ],
          :info => {
            :inflow => @day_pdt_rpt.inflow, 
            :outflow => @day_pdt_rpt.outflow, 
            :inmud => @day_pdt_rpt.inmud, 
            :outmud => @day_pdt_rpt.outmud, 
            :mst => @day_pdt_rpt.mst, 
            :power => @day_pdt_rpt.power, 
            :mdflow => @day_pdt_rpt.mdflow, 
            :mdrcy => @day_pdt_rpt.mdrcy, 
            :mdsell => @day_pdt_rpt.mdsell,
            :name => @day_pdt_rpt.name, 
            :pdt_date => @day_pdt_rpt.pdt_date, 
            :weather => @day_pdt_rpt.weather, 
            :temper => @day_pdt_rpt.temper
          }
        }.to_json}
    end
  end

  
  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  

  private
    def day_pdt_rpt_params
      params.require(:day_pdt_rpt).permit(:name, :pdt_date, :weather, :temper, 
      :inf_qlty_bod, :inf_qlty_cod, :inf_qlty_ss, :inf_qlty_nhn, :inf_qlty_tn, :inf_qlty_tp, :inf_qlty_ph, 
      :eff_qlty_bod, :eff_qlty_cod, :eff_qlty_ss, :eff_qlty_nhn, :eff_qlty_tn, :eff_qlty_tp, :eff_qlty_ph, :eff_qlty_fecal,  
      :sed_qlty_bod, :sed_qlty_cod, :sed_qlty_ss, :sed_qlty_nhn, :sed_qlty_tn, :sed_qlty_tp, :sed_qlty_ph, 
      :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell)
    end
  
    def my_factory
      @factory = current_user.factories.find(iddecode(params[:factory_id]))
    end
   
    def other_quota(ctg_hash, quota_h, code, rpt)
      flag = false
      if code == Setting.quota.inflow 
        ctg_hash[quota_h[code]] = rpt.inflow
        flag = true 
      elsif code == Setting.quota.outflow
        ctg_hash[quota_h[code]] = rpt.outflow
        flag = true 
      elsif code == Setting.quota.inmud  
        ctg_hash[quota_h[code]] = rpt.inmud
        flag = true 
      elsif code == Setting.quota.outmud 
        ctg_hash[quota_h[code]] = rpt.outmud
        flag = true 
      elsif code == Setting.quota.mst    
        ctg_hash[quota_h[code]] = rpt.mst
        flag = true 
      elsif code == Setting.quota.power  
        ctg_hash[quota_h[code]] = rpt.power
        flag = true 
      elsif code == Setting.quota.mdflow 
        ctg_hash[quota_h[code]] = rpt.mdflow
        flag = true 
      elsif code == Setting.quota.mdrcy  
        ctg_hash[quota_h[code]] = rpt.mdrcy
        flag = true 
      elsif code == Setting.quota.mdsell 
        ctg_hash[quota_h[code]] = rpt.mdsell
        flag = true 
      end
      flag
    end

    def inf_quota(ctg_hash, quota_h, code, rpt)
      if code == Setting.quota.cod 
        ctg_hash[quota_h[code]] = rpt.inf_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[quota_h[code]] = rpt.inf_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[quota_h[code]] = rpt.inf_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[quota_h[code]] = rpt.inf_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[quota_h[code]] = rpt.inf_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[quota_h[code]] = rpt.inf_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[quota_h[code]] = rpt.inf_qlty_ph
      end
    end

    def eff_quota(ctg_hash, quota_h, code, rpt)
      if code == Setting.quota.cod 
        ctg_hash[quota_h[code]] = rpt.eff_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[quota_h[code]] = rpt.eff_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[quota_h[code]] = rpt.eff_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[quota_h[code]] = rpt.eff_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[quota_h[code]] = rpt.eff_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[quota_h[code]] = rpt.eff_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[quota_h[code]] = rpt.eff_qlty_ph
      end
    end
  
    def quota_hash 
      {
        Setting.quota.cod     => Setting.inf_qlties.cod,
        Setting.quota.bod     => Setting.inf_qlties.bod,
        Setting.quota.ss      => Setting.inf_qlties.ss ,
        Setting.quota.nhn     => Setting.inf_qlties.nhn,
        Setting.quota.tn      => Setting.inf_qlties.tn ,
        Setting.quota.tp      => Setting.inf_qlties.tp ,
        Setting.quota.ph      => Setting.inf_qlties.ph ,
        Setting.quota.inflow  => Setting.day_pdt_rpts.inflow,
        Setting.quota.outflow => Setting.day_pdt_rpts.outflow,
        Setting.quota.inmud   => Setting.day_pdt_rpts.inmud ,
        Setting.quota.outmud  => Setting.day_pdt_rpts.outmud,
        Setting.quota.mst     => Setting.day_pdt_rpts.mst   ,
        Setting.quota.power   => Setting.day_pdt_rpts.power  ,
        Setting.quota.mdflow  => Setting.day_pdt_rpts.mdflow,
        Setting.quota.mdrcy   => Setting.day_pdt_rpts.mdrcy ,
        Setting.quota.mdsell  => Setting.day_pdt_rpts.mdsell
      }
    end

    def my_assay
      quotas = Quota.where(:ctg => Setting.quota.ctg_one)
      quota_arr = []
      quotas.each do |q|
        quota_arr << q.code
      end
      quota_arr
    end
end
  # 
  #def create
  #  @day_pdt_rpt = DayPdtRpt.new(day_pdt_rpt_params)
  #   
  #  @day_pdt_rpt.user = current_user
  #   
  #  if @day_pdt_rpt.save
  #    redirect_to :action => :index
  #  else
  #    render :new
  #  end
  #end
   

   
  #def edit
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #end
  # 

  # 
  #def update
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #  if @day_pdt_rpt.update(day_pdt_rpt_params)
  #    redirect_to day_pdt_rpt_path(idencode(@day_pdt_rpt.id)) 
  #  else
  #    render :edit
  #  end
  #end
  # 

  # 
  #def destroy
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #  @day_pdt_rpt.destroy
  #  redirect_to :action => :index
  #end
   

  

  
