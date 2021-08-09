class DayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
  
  include MathCube
  include QuotaConfig 

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

  #多折线图表
  def sglfct_stc_cau
    @factory = my_factory
   
    _start = Date.parse(params[:start])
    _end = Date.parse(params[:end])
    _pos = params[:pos_type]

    #避免传递非当前分类中的数据
    search_type = params[:search_type]
    _qcodes = params[:qcodes].split(",")
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes & my_real_codes #查询哪些指标 

    #图表配置项
    series = []
    dimensions = ['date']
    real_codes.each do |code|
      series << {type: 'line'}
      dimensions << quota_hash[code][:name]
    end

    chart_config = {} 

    #图表数据
    if @factory
      @day_pdt_rpts = @factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
      datasets = get_datasets(@day_pdt_rpts, real_codes, _pos)
      chart_config = my_chart_config(_pos, series, dimensions, datasets)
    end

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end
  end

  #雷达图 核心参数: search_type用于筛选出合法的指标code(化验、污泥、电耗、中水), pos_type用于区分标题,根据不同的位置获取不同的数据(进水、出水、其他)
  def radar_chart
    @factory = my_factory

    _pos = params[:pos_type]

    search_type = params[:search_type]
    my_real_codes = my_real_codes(search_type)
    real_codes = my_real_codes 

    #图表配置项
    series = []
    series << {type: 'radar'}
    dimensions = []
    real_codes.each do |code|
      dimensions << quota_hash[code][:name]
    end

    chart_config = {} 
    indicator = []

    #图表数据
    if @factory
      @day_pdt_rpt = @factory.day_pdt_rpts.order('pdt_date desc').first
      day_pdt_rpts = @day_pdt_rpt ? [@day_pdt_rpt] : []
      datasets = get_datasets(day_pdt_rpts, real_codes, _pos) 

      chart_config = my_chart_config(_pos, series, dimensions, datasets)

      unless chart_config['datasets'].blank? 
        if _pos == Setting.quota.pos_inf
            chart_config['datasets'][0].each_pair do |k, v|
              indicator << { name: k, max: v+10}
            end
        elsif _pos == Setting.quota.pos_eff
          real_codes.each do |code|
            indicator << { name: quota_hash[code][:name], max: quota_hash[code][:max]}
          end
        end
      end

      chart_config['indicator'] = indicator
    end

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end

  end

  def gauge_chart
    #chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #if search_type == Setting.quota.ctg_power
    #  sum_power = @day_pdt_rpts.sum(:power)
    #  chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #end
  end

  #汇总统计数据,表格展示用
  def static_pool
    @factory = my_factory
    search_type = params[:search_type]
   
    _start = Date.parse(params[:start])
    _end = Date.parse(params[:end])

    _qcodes = params[:qcodes].split(",")
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes & my_real_codes 

    chart_config = Hash.new 
    chart_config['static_pool'] = get_static_pool(@factory.id, real_codes, _start, _end) if @factory

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
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
          :datasets => [
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

    #指标求和和平均值
    #[
    # { :title => 'cod', :sum => 20, :avg => 10 },
    # { :title => 'bod', :sum => 20, :avg => 10 }
    #]
    #real_codes '1,2,3'
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

    #带日期数据
    #[
    # { :date => '2021-02-01', 'cod' => 2, 'bod' => 5 },
    # { :date => '2021-02-02', 'cod' => 2, 'bod' => 5 },
    #]
    def get_datasets(day_pdt_rpts, real_codes, pos)
      datasets = []
      day_pdt_rpts.each do |rpt|
        dataset_item = {'date': rpt.pdt_date}

        real_codes.each do |code|
          if pos == Setting.quota.pos_inf
            inf_quota(dataset_item, code, rpt)
          elsif pos == Setting.quota.pos_eff
            eff_quota(dataset_item, code, rpt)
          elsif pos == Setting.quota.pos_other
            other_quota(dataset_item, code, rpt)
          end
        end

        datasets << dataset_item
      end
      datasets
    end

    def my_chart_config(_pos, series, dimensions, datasets) 
      chart_config = Hash.new 
      chart_config['title'] = get_title(_pos)
      chart_config['series'] = series
      chart_config['dimensions'] = dimensions
      chart_config['datasets'] = datasets
      chart_config
    end

end
