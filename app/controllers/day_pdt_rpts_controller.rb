class DayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource
  
  include MathCube
  include QuotaConfig 
  include ChartConfig 

  def index
    @factory = my_factory
   
    @day_pdt_rpts = @factory.day_pdt_rpts.order('pdt_date DESC').page( params[:page]).per( Setting.systems.per_page )  if @factory
   
  end
   
  def show
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))

    @day_rpt_stc = @day_pdt_rpt.day_rpt_stc
  end
   
  #时间区间内单厂多指标 数据立方
  def sglfct_statistic
    @factories = current_user.factories
    quotas
  end

  #多折线图表 数据立方
  def sglfct_stc_cau
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))
    search_type = params[:search_type].gsub(/\s/, '')
    pos_type = params[:pos_type].gsub(/\s/, '')
    chart_type = params[:chart_type].gsub(/\s/, '')
    _qcodes = params[:qcodes].gsub(/\s/, '').split(",")

    chart_config = {}
    @factory = my_factory
    if @factory
      @day_pdt_rpts = @factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
      have_date = true
      chart_config = period_multiple_quota(have_date, @day_pdt_rpts, search_type, pos_type, chart_type, _qcodes)
    end

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end
  end

  #首页雷达图
  def radar_chart
    pos_type = params[:pos_type].gsub(/\s/, '')
    chart_type = params[:chart_type].gsub(/\s/, '')
    search_type = params[:search_type].gsub(/\s/, '')
    chart_config = {} 
    @factory = my_factory
    if @factory
      @day_pdt_rpt = @factory.day_pdt_rpts.order('pdt_date desc').first
      have_date = false 
      chart_config = some_day_quota(have_date, @day_pdt_rpt, search_type, pos_type, chart_type, nil)
    end
    indicator = []
    
    my_real_codes = my_real_codes(search_type)
    real_codes = my_real_codes

    unless chart_config['datasets'].blank? 
      if pos_type == Setting.quota.pos_inf
        chart_config['datasets'][0].each_pair do |k, v|
          indicator << { name: k, max: v+10}
        end
      elsif pos_type == Setting.quota.pos_eff
        real_codes.each do |code|
          indicator << { name: MYQUOTAS[code][:name], max: MYQUOTAS[code][:max]}
        end
      end
    end

    chart_config['indicator'] = indicator

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end

  end

  #仪表数据
  def new_quota_chart
    qcode = params[:qcode].gsub(/\s/, '')
    result = {}

    @factory = my_factory
    if @factory
      @day_pdt_rpt = @factory.day_pdt_rpts.order('pdt_date desc').first
      result = single_quota(qcode, @day_pdt_rpt)
    end

    respond_to do |f|
      f.json{ render :json => result.to_json}
    end
  end


  #汇总统计数据,表格展示用
  def static_pool
    @factory = my_factory
    search_type = params[:search_type].gsub(/\s/, '')
   
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    _qcodes = params[:qcodes].gsub(/\s/, '').split(",")
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes & my_real_codes 

    chart_config = Hash.new 
    chart_config['static_pool'] = get_static_pool(@factory.id, real_codes, _start, _end) if @factory

    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end
  end

  #day_pdt_rpts modal显示图表用
  def produce_report 
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))
    @day_rpt_stc = @day_pdt_rpt.day_rpt_stc
    header = {
      :name => @day_pdt_rpt.name, 
      :weather => @day_pdt_rpt.weather, 
      :temper => @day_pdt_rpt.temper,
    }
    cms = {
      Setting.day_pdt_rpts.inflow => @day_pdt_rpt.inflow, 
      Setting.day_pdt_rpts.outflow => @day_pdt_rpt.outflow, 

      Setting.day_rpt_stcs.bcr => @day_rpt_stc.bcr,
      Setting.day_rpt_stcs.bnr => @day_rpt_stc.bnr,
      Setting.day_rpt_stcs.bpr => @day_rpt_stc.bpr,

      Setting.day_rpt_stcs.cod_emq => @day_rpt_stc.cod_emq,
      Setting.day_rpt_stcs.bod_emq => @day_rpt_stc.bod_emq,
      Setting.day_rpt_stcs.nhn_emq => @day_rpt_stc.nhn_emq,
      Setting.day_rpt_stcs.tp_emq => @day_rpt_stc.tp_emq,
      Setting.day_rpt_stcs.tn_emq => @day_rpt_stc.tn_emq,
      Setting.day_rpt_stcs.ss_emq => @day_rpt_stc.ss_emq,

      Setting.day_rpt_stcs.cod_emr => @day_rpt_stc.cod_emr,
      Setting.day_rpt_stcs.bod_emr => @day_rpt_stc.bod_emr,
      Setting.day_rpt_stcs.nhn_emr => @day_rpt_stc.nhn_emr,
      Setting.day_rpt_stcs.tp_emr => @day_rpt_stc.tp_emr,
      Setting.day_rpt_stcs.tn_emr => @day_rpt_stc.tn_emr,
      Setting.day_rpt_stcs.ss_emr => @day_rpt_stc.ss_emr
    }
    mud = {
      Setting.day_pdt_rpts.inmud => @day_pdt_rpt.inmud, 
      Setting.day_pdt_rpts.outmud => @day_pdt_rpt.outmud, 
      Setting.day_pdt_rpts.mst => @day_pdt_rpt.mst
    }
    power = {
      Setting.day_pdt_rpts.power => @day_pdt_rpt.power, 
      Setting.day_rpt_stcs.bom => @day_rpt_stc.bom,
      Setting.day_rpt_stcs.cod_bom => @day_rpt_stc.cod_bom,
      Setting.day_rpt_stcs.bod_bom => @day_rpt_stc.bod_bom,
      Setting.day_rpt_stcs.nhn_bom => @day_rpt_stc.nhn_bom,
      Setting.day_rpt_stcs.tp_bom => @day_rpt_stc.tp_bom,
      Setting.day_rpt_stcs.tn_bom => @day_rpt_stc.tn_bom,
      Setting.day_rpt_stcs.ss_bom => @day_rpt_stc.ss_bom
    }
    md = {
      Setting.day_pdt_rpts.mdflow => @day_pdt_rpt.mdflow, 
      Setting.day_pdt_rpts.mdrcy => @day_pdt_rpt.mdrcy, 
      Setting.day_pdt_rpts.mdsell => @day_pdt_rpt.mdsell
    }
    tspmuds = []
    @day_pdt_rpt.tspmuds.each do |tspmud|
      tspmuds << {
        Setting.tspmuds.tspvum => tspmud.tspvum,
        Setting.tspmuds.dealer => tspmud.dealer,
        Setting.tspmuds.rcpvum => tspmud.rcpvum,
        Setting.tspmuds.price => tspmud.price,
        Setting.tspmuds.prtmtd => tspmud.prtmtd,
        Setting.tspmuds.goort => tspmud.goort
      }
    end
    chemicals = {}
    chemicals_dta = []
    @day_pdt_rpt.chemicals.each do |chemical|
      chemicals_dta << {
        Setting.chemicals.name => chemicals_hash[chemical.name],
        Setting.chemicals.unprice => chemical.unprice,
        Setting.chemicals.cmptc => chemical.cmptc,
        Setting.chemicals.dosage => chemical.dosage,
        Setting.chemicals.dosptc => chemical.dosptc,
        Setting.chemicals.per_cost => chemical.per_cost
      }
    end
    chemicals = {
      chemicals_dta: chemicals_dta,
      per_cost: @day_pdt_rpt.per_cost
    }

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
          :header => header,
          :cms => cms,
          :power => power,
          :mud => mud,
          :md  => md,
          :tspmuds => tspmuds,
          :chemicals => chemicals
        }.to_json}
    end
  end

  def xls_download
    send_file File.join(Rails.root, "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  def xls_day_download
    @factory = my_factory
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))
    obj = [@day_pdt_rpt]

    excel_tool = SpreadSheetTool.new
    target_excel = excel_tool.exportDayPdtRptToExcel(obj)
    send_file target_excel, :filename => "日报表.xls", :type => "application/force-download", :x_sendfile=>true
  end

  private
    def day_pdt_rpt_params
      params.require(:day_pdt_rpt).permit(:name, :pdt_date, :weather, :temper, 
      :inf_qlty_bod, :inf_qlty_cod, :inf_qlty_ss, :inf_qlty_nhn, :inf_qlty_tn, :inf_qlty_tp, :inf_qlty_ph, 
      :eff_qlty_bod, :eff_qlty_cod, :eff_qlty_ss, :eff_qlty_nhn, :eff_qlty_tn, :eff_qlty_tp, :eff_qlty_ph, :eff_qlty_fecal,  
      :sed_qlty_bod, :sed_qlty_cod, :sed_qlty_ss, :sed_qlty_nhn, :sed_qlty_tn, :sed_qlty_tp, :sed_qlty_ph, 
      :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell)
    end
  
    def single_quota(qcode, day_pdt_rpt)
      result = {}
      if qcode == Setting.quota.inflow
        result = gauge(Setting.day_pdt_rpts.inflow, day_pdt_rpt.inflow, (day_pdt_rpt.inflow - 50).to_i, (day_pdt_rpt.inflow + 50).to_i, '#597cd5')
      elsif qcode == Setting.quota.outflow
        result = gauge(Setting.day_pdt_rpts.outflow, day_pdt_rpt.outflow, (day_pdt_rpt.inflow - 50).to_i, (day_pdt_rpt.outflow + 50).to_i, '#597cd5')
      elsif qcode == Setting.quota.outmud
        result = gauge(Setting.day_pdt_rpts.outmud, day_pdt_rpt.outmud, (day_pdt_rpt.inflow - 50).to_i, (day_pdt_rpt.outmud + 50).to_i, '#597cd5')
      elsif qcode == Setting.quota.power
        result = gauge(Setting.day_pdt_rpts.power, day_pdt_rpt.power, (day_pdt_rpt.inflow - 50).to_i, (day_pdt_rpt.power + 50).to_i, '#597cd5')
      end
      result
    end

    #仪表数据
    def gauge(name, value,min, max, color)
      {
        name: name,
        min: min,
        max: max,
        color: color,
        value: value
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

end
