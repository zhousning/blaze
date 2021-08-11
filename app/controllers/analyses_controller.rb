class AnalysesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
  
  include MathCube
  include QuotaConfig 
  include ChartConfig 

  def compare
    @factories = current_user.factories
    quotas = Quota.all
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
    quota_h = quota_hash

    search_type = params[:search_type]
    pos_type = params[:pos_type]
    chart_type = params[:chart_type]
    year = params[:year].to_i
    all_months = params[:months].split(",")
    _qcodes = [params[:quota]]
    quota = quota_h[params[:quota]][:name]
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

  def power_chart
    #chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #if search_type == Setting.quota.ctg_power
    #  sum_power = @day_pdt_rpts.sum(:power)
    #  chart_config['sum_power'] = [gauge('总电量', sum_power)]
    #end
  end
end