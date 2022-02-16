class AnalysesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:power_bom, :percost, :tpcost, :tncost, :tputcost, :tnutcost, :ctputcost, :ctnutcost, :zbdblv] 
  
  include MathCube
  include QuotaConfig 
  include ChartConfig 

  def compare
    @factories = current_user.factories
    quotas = Quota.all
  end

  #多厂区吨水药剂成本
  def percost 
    title = Setting.mth_chemicals.per_cost
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "per_cost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.per_cost
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  def zbdblv 
    type = params[:type]
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    @factories = Factory.find(fcts)

    zbbz = [] 
    if type == '0'
      #山东省住建厅准四标准
      zbbz = [{:key => 'cod', :val => 30, :name => 'COD'}, {:key => 'bod', :val => 6, :name => 'BOD'}, {:key => 'ss', :val => 10, :name => 'SS'}, {:key => 'nhn', :val => 1.5, :name => 'NH3-N'}, {:key => 'tn', :val => 10, :name => 'TN'}, {:key => 'tp', :val => 0.3, :name => 'TP'}]
    elsif type == '1' 
      #济宁准三标准
      zbbz = [{:key => 'cod', :val => 20, :name => 'COD'}, {:key => 'bod', :val => 4, :name => 'BOD'}, {:key => 'ss', :val => 10, :name => 'SS'}, {:key => 'nhn', :val => 1, :name => 'NH3-N'}, {:key => 'tn', :val => 10, :name => 'TN'}, {:key => 'tp', :val => 0.2, :name => 'TP'}]
    elsif type == '2' 
      #全指标地表三
      zbbz = [{:key => 'cod', :val => 20, :name => 'COD'}, {:key => 'bod', :val => 4, :name => 'BOD'}, {:key => 'ss', :val => 10, :name => 'SS'}, {:key => 'nhn', :val => 1, :name => 'NH3-N'}, {:key => 'tn', :val => 1, :name => 'TN'}, {:key => 'tp', :val => 0.2, :name => 'TP'}]
    end

    hash = Hash.new
    zbbz.each do |item|
      hash['厂区'] = [] if hash['厂区'].nil?
      cond = 'pdt_date between ? and ? and eff_qlty_' + item[:key] + ' <= ?'
      val = item[:val]
      hash['厂区'] << item[:name] + '<=' + val.to_s
      @factories.each do |f|
        hash[f.name] = [] if hash[f.name].nil?
        sum = f.day_pdt_rpts.where([cond, _start, _end, val]).count.to_f
        total = (_start.._end).count.to_f
        dabiaolv = format("%0.2f", (sum/total*100)) + '%'
        hash[f.name] << dabiaolv
      end
    end

    respond_to do |f|
      f.json{ render :json => hash.to_json}
    end
  end

  #在线多厂区去除单位TN成本
  def tnutcost 
    title = Setting.day_rpt_stcs.tn_utcost + '(在线)'
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tn_utcost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tn_utcost
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end
  #在线多厂区去除单位TP成本
  def tputcost 
    title = Setting.day_rpt_stcs.tp_utcost + '(在线)'
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tp_utcost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tp_utcost 
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #化验多厂区去除单位TN成本
  def ctnutcost 
    title = Setting.day_rpt_stcs.tn_utcost + '(化验)'
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tn_utcost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = CdayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tn_utcost
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #化验多厂区去除单位TP成本
  def ctputcost 
    title = Setting.day_rpt_stcs.tp_utcost + '(化验)'
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tp_utcost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = CdayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tp_utcost 
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end


  #多厂区脱氮成本
  def tncost 
    title = Setting.day_rpt_stcs.tn_cost
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tn_cost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tn_cost 
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #多厂区除磷药剂单位成本
  def tpcost 
    title = Setting.day_rpt_stcs.tp_cost
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "tp_cost, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.tp_cost
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #多厂区电单耗
  def power_bom
    title = Setting.day_rpt_stcs.bom 
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    items = []
    select_str = "bom, pdt_date"

    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = DayRptStc.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).order('pdt_date')
      @day_pdt_rpts.each do |rpt|
        data = {}
        data['date'] = rpt.pdt_date
        data[factory.name] = rpt.bom 
        items << data
      end
      series << {type: 'line'}
      dimensions << factory.name 
    end
    combo = items.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #需要返回的类型datasets = [
  #  {:day=>1, "六月"=>98.0, "七月"=>88.0}, 
  #  {:day=>2, "六月"=>66.0, "七月"=>88.0}, 
  #  {:day=>3, "六月"=>88.0, "七月"=>88.0}, 
  #  {:day=>4, "六月"=>93.0, "七月"=>88.0}
  #]

  #通用函数返回的类型"datasets"=>
  #[
  # {:date=>Tue, 01 Jun 2021, "BOD5(mg/l)"=>98.0}, 
  # {:date=>Wed, 02 Jun 2021, "BOD5(mg/l)"=>66.0}
  #]
  def month_compare
    my_months = months

    search_type = params[:search_type].gsub(/\s/, '')
    pos_type = params[:pos_type].gsub(/\s/, '')
    chart_type = params[:chart_type].gsub(/\s/, '')
    year = params[:year].gsub(/\s/, '').to_i
    all_months = params[:months].gsub(/\s/, '').split(",")
    _qcodes = [params[:quota].gsub(/\s/, '')]
    quota = MYQUOTAS[params[:quota].gsub(/\s/, '')][:name]
    title = get_title(pos_type)
    dimensions = ["day"]
    series = []

    datasets = []
    31.times.each do |day|
      datasets << {:day => day+1} 
    end

    dataset_cache = []
    all_months.each do |month|
      _start = Date::new(year, month.to_i, 1)
      _end = Date::new(year, month.to_i, -1)

      dimensions << my_months[month]
      series << {:type=>"line"}

      @factory = my_factory
      if @factory
        @day_pdt_rpts = @factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
        have_date = true
        chart_config = period_multiple_quota(have_date, @day_pdt_rpts, search_type, pos_type, chart_type, _qcodes)
        dataset_cache += chart_config["datasets"]
      end
    end

    hash_cache = {}
    dataset_cache.each do |c|
      hash_cache[c[:date].to_s] = c[quota]
    end

    all_months.each do |month|
      31.times.each do |t|
        begin
          date_cache = Date::new(year, month.to_i, t)
          quota_value = hash_cache[date_cache.to_s]
          if quota_value
            datasets[t][my_months[month]] = quota_value
          else
            datasets[t][my_months[month]] = 0 
          end
        rescue
          datasets[t][my_months[month]] = 0 
          next
        end
      end
    end
    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => datasets} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #通用函数返回的类型"datasets"=>
  #[
  # {:date=>Tue, 01 Jun 2021, "BOD5(mg/l)"=>98.0}, 
  # {:date=>Wed, 02 Jun 2021, "BOD5(mg/l)"=>66.0}
  #]
  #diamensions = ['date', 'BOD5(mg/l)']
  #单指标厂间对比
  def area_time_compare
    search_type = params[:search_type].gsub(/\s/, '')
    pos_type = params[:pos_type].gsub(/\s/, '')
    chart_type = params[:chart_type].gsub(/\s/, '')
    _qcodes = [params[:quota].gsub(/\s/, '')]
    quota = MYQUOTAS[params[:quota].gsub(/\s/, '')][:name]
    title = get_title(pos_type)
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))

    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    obj = []
    dimensions = ['date']
    series = []
    @factories = Factory.find(fcts)
    @factories.each do |factory|
      @day_pdt_rpts = factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
      have_date = true
      chart_config = period_multiple_quota(have_date, @day_pdt_rpts, search_type, pos_type, chart_type, _qcodes)
      chart_config["datasets"].each do |dataset|
        new_data = {}
        new_data['date'] = dataset[:date]
        new_data[factory.name] = dataset[quota]
        obj << new_data 
      end
      series << {type: chart_type(chart_type)}
      dimensions << factory.name 
    end
    combo = obj.group_by{|h| h['date']}.map{|k,v| v.reduce(:merge)}

    result_config = {"title" => title, "series" => series, "dimensions" => dimensions, "datasets" => combo} 

    respond_to do |f|
      f.json{ render :json => result_config.to_json}
    end
  end

  #用作scatter 3d 但日期不能正常显示暂时先不用这个函数
  #def area_time_compare
  #  search_type = params[:search_type].gsub(/\s/, '')
  #  pos_type = params[:pos_type].gsub(/\s/, '')
  #  chart_type = params[:chart_type].gsub(/\s/, '')
  #  _qcodes = [params[:quota].gsub(/\s/, '')]
  #  quota = MYQUOTAS[params[:quota].gsub(/\s/, '')][:name]
  #  title = get_title(pos_type)
  #  _start = Date.parse(params[:start].gsub(/\s/, ''))
  #  _end = Date.parse(params[:end].gsub(/\s/, ''))

  #  fcts = params[:fcts].gsub(/\s/, '').split(",")
  #  fcts = fcts.collect do |fct|
  #    iddecode(fct)
  #  end

  #  obj = []
  #  dimensions = []
  #  @factories = Factory.find(fcts)
  #  @factories.each do |factory|
  #    @day_pdt_rpts = factory.day_pdt_rpts.where(["pdt_date between ? and ?", _start, _end]).order('pdt_date')
  #    have_date = true
  #    chart_config = period_multiple_quota(have_date, @day_pdt_rpts, search_type, pos_type, chart_type, _qcodes)
  #    chart_config["datasets"].each do |dataset|
  #      dataset['fct'] = factory.name
  #      obj << dataset
  #    end
  #    dimensions += chart_config['dimensions']
  #  end
  #  dimensions += ["fct"]
  #  puts dimensions
  #  puts obj

  #  result_config = {"title" => title, "dimensions" => dimensions.uniq, "datasets" => obj} 

  #  respond_to do |f|
  #    f.json{ render :json => result_config.to_json}
  #  end
  #end
  
  def area_time
    @factories = current_user.factories
  end

  def power_chart
    #chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #if search_type == Setting.quota.ctg_power
    #  sum_power = @day_pdt_rpts.sum(:power)
    #  chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #end
  end
end
