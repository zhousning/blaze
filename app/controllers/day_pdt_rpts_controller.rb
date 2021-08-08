class DayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
  
  include MathCube

   
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
    quotas
  end

  def mtlfct_statistic
  end

  def compare_statistic
    @factories = current_user.factories
    quotas = Quota.all
  end

  def sglfct_compare_cau
    @factory = my_factory
    _quota = params[:quota]
  end

  def sglfct_stc_cau
    @factory = my_factory
    quota_h = quota_hash
   
    _start = Date.parse(params[:start])
    _end = Date.parse(params[:end])
    _pos = params[:pos_type]
    analysis_result = Hash.new 

    #避免传递非当前分类中的数据
    search_type = params[:search_type]
    _qcodes = params[:qcodes].split(",")
    assay = my_assay(search_type)
    real_codes = _qcodes & assay 

    #图表配置项
    series = []
    dimensions = ['date']
    real_codes.each do |code|
      series << {type: 'line', label: { show: true}}
      dimensions << quota_h[code]
    end
    analysis_result['series'] = series
    analysis_result['dimensions'] = dimensions
    analysis_result['title'] = get_title(_pos)

    #图表数据
    if @factory
      @day_pdt_rpts = @factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
      analysis_result['categories'] = get_categories(real_codes, _pos, quota_h)
    end

    respond_to do |f|
      f.json{ render :json => analysis_result.to_json}
    end
  end

  #汇总统计数据
  def static_pool
    @factory = my_factory
    search_type = params[:search_type]
   
    _start = Date.parse(params[:start])
    _end = Date.parse(params[:end])

    _qcodes = params[:qcodes].split(",")
    assay = my_assay(search_type)
    real_codes = _qcodes & assay 

    analysis_result = Hash.new 
    analysis_result['static_pool'] = get_static_pool(@factory.id, real_codes, _start, _end) if @factory

    respond_to do |f|
      f.json{ render :json => analysis_result.to_json}
    end
  end

  def gauge_chart
    #analysis_result['sum_power'] = [gauge('总电量', sum_power)]
    #if search_type == Setting.quota.ctg_power
    #  sum_power = @day_pdt_rpts.sum(:power)
    #  analysis_result['sum_power'] = [gauge('总电量', sum_power)]
    #end
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
      if code == Setting.quota.inflow 
        ctg_hash[quota_h[code]] = rpt.inflow
      elsif code == Setting.quota.outflow
        ctg_hash[quota_h[code]] = rpt.outflow
      elsif code == Setting.quota.inmud  
        ctg_hash[quota_h[code]] = rpt.inmud
      elsif code == Setting.quota.outmud 
        ctg_hash[quota_h[code]] = rpt.outmud
      elsif code == Setting.quota.mst    
        ctg_hash[quota_h[code]] = rpt.mst
      elsif code == Setting.quota.power  
        ctg_hash[quota_h[code]] = rpt.power
      elsif code == Setting.quota.mdflow 
        ctg_hash[quota_h[code]] = rpt.mdflow
      elsif code == Setting.quota.mdrcy  
        ctg_hash[quota_h[code]] = rpt.mdrcy
      elsif code == Setting.quota.mdsell 
        ctg_hash[quota_h[code]] = rpt.mdsell
      end
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
      elsif code == Setting.quota.fecal
        ctg_hash[quota_h[code]] = rpt.eff_qlty_fecal
      end
    end
  
    def quota_hash 
      quota_hash = Hash.new
      quotas = Quota.all
      quotas.each do |q|
        quota_hash[q.code] = q.name
      end
      quota_hash
    end

    def my_assay(type)
      quotas = nil
      if type == Setting.quota.ctg_cms 
        quotas = Quota.where(:ctg => [Setting.quota.ctg_cms])
      elsif type == Setting.quota.ctg_mud 
        quotas = Quota.where(:ctg => [Setting.quota.ctg_mud, Setting.quota.ctg_flow])
      elsif type == Setting.quota.ctg_power
        quotas = Quota.where(:ctg => Setting.quota.ctg_power)
      elsif type == Setting.quota.ctg_md
        quotas = Quota.where(:ctg => Setting.quota.ctg_md)
      end
      quota_arr = []
      quotas.each do |q|
        quota_arr << q.code
      end
      quota_arr
    end

    def quotas 
      @quota_flows = Quota.where(:ctg => Setting.quota.ctg_flow)
      @quota_cms = Quota.where(:ctg => Setting.quota.ctg_cms) 
      @quota_muds = Quota.where(:ctg => Setting.quota.ctg_mud) 
      @quota_powers = Quota.where(:ctg => Setting.quota.ctg_power)
      @quota_mds = Quota.where(:ctg => Setting.quota.ctg_md)
    end

    #求和和平均值
    def get_static_pool(factory_id, real_codes, _start, _end)
      static_pools = static_sum(factory_id, _start, _end)
      static_pool = [] 
      static_pools.each_pair do |k, v|
        if real_codes.include?(v[:code])
          static_pool << { :title => v[:title], :sum => v[:sum], :avg => v[:avg] } 
        end
      end
      static_pool
    end

    def get_title(pos)
      title = ''
      if pos == Setting.quota.pos_inf
        title = '进水水质'
      elsif pos == Setting.quota.pos_eff
        title = '出水水质'
      elsif pos == Setting.quota.pos_sed
        title = '二沉池出水水质'
      elsif pos == Setting.quota.pos_other
      end
      title
    end

    #曲线数据
    def get_categories(real_codes, pos, quota_h)
      categories = []
      @day_pdt_rpts.each do |rpt|
        ctg_hash = {'date': rpt.pdt_date}

        real_codes.each do |code|
          if pos == Setting.quota.pos_inf
            inf_quota(ctg_hash, quota_h, code, rpt)
          elsif pos == Setting.quota.pos_eff
            eff_quota(ctg_hash, quota_h, code, rpt)
          elsif pos == Setting.quota.pos_other
            other_quota(ctg_hash, quota_h, code, rpt)
          end
        end

        categories << ctg_hash
      end
      categories
    end

    #仪表数据
    def gauge(name, value)
      {
        name: name,
        type: 'gauge',
        data: [{
            value: value,
            name: name 
        }]
      }
    end

end
