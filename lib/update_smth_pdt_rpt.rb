module UpdateSmthPdtRpt
  include FormulaLib 
  def update_smth_pdt_rpt(rpt)
    _start = rpt.start_date
    _end = rpt.end_date
    year = _start.year
    month = _start.month
    _year_start = Date.new(year, 1, 1)

    factory = rpt.sfactory

    result = static_sum(factory.id, _start, _end)
    max_min = static_max_min(factory.id, _start, _end)
    year_result = static_sum(factory.id, _year_start, _end)
    mom_result = static_mom(factory.id, year, month)
    yoy_result = static_yoy(factory.id, year, month)

    ipt = month_water(result[:ipt][:sum], year_result[:ipt][:sum], max_min[:max_ipt][:val], max_min[:min_ipt][:val], result[:ipt][:avg], max_min[:max_ipt][:pdt_date], max_min[:min_ipt][:pdt_date], yoy_result[:ipt], mom_result[:ipt])
    opt = month_water(result[:opt][:sum], year_result[:opt][:sum], max_min[:max_opt][:val], max_min[:min_opt][:val], result[:opt][:avg], max_min[:max_opt][:pdt_date], max_min[:min_opt][:pdt_date], yoy_result[:opt], mom_result[:opt])
    press = month_press(max_min[:max_press][:val], max_min[:min_press][:val], result[:press][:avg], max_min[:max_press][:pdt_date], max_min[:min_press][:pdt_date])
    power = month_power(result[:power][:sum])
    
    {
      :water => {
        :smonth_ipt => ipt,
        :smonth_opt => opt,
        :smonth_power => power,
        :smonth_press => press 
      }
    }
  end

  private
    def month_water(val, end_val, max_val, min_val, avg_val, max_date, min_date, yoy, mom)
      {
        :val   =>   val,
        :end_val   =>   end_val,
        :max_val   =>   max_val,
        :min_val   =>   min_val,
        :avg_val   =>   avg_val,
        :min_date   =>   min_date,
        :max_date   =>   max_date,
        :yoy       =>   yoy    ,
        :mom       =>   mom    
      }
    end

    def month_press(max_val, min_val, avg_val, max_date, min_date)
      {
        :max_val   =>   max_val,
        :min_val   =>   min_val,
        :avg_val   =>   avg_val,
        :min_date   =>   min_date,
        :max_date   =>   max_date
      }
    end

    def month_power(val)
      {
        :val => val
      }
    end
end
