module CreateSmthPdtRpt
  include FormulaLib 
  def create_smth_pdt_rpt(factory, year, month, state)
    process_result = ''
    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    result = static_sum(factory.id, _start, _end)
    max_min = static_max_min(factory.id, _start, _end)

    #判断选定的月份是否有数据
    if result[:state] == 'zero'
      process_result = 'zero'
      return process_result
    end

    year_result = static_sum(factory.id, _year_start, _end)
    mom_result = static_mom(factory.id, year, month)
    yoy_result = static_yoy(factory.id, year, month)

    name = year.to_s + "年" + month.to_s + "月" + factory.name + "生产运营报告"
    rpt = mth_pdt_rpt(_start, _end, factory.id, name, state)

    ipt = month_water(result[:ipt][:sum], year_result[:ipt][:sum], max_min[:max_ipt][:val], max_min[:min_ipt][:val], result[:ipt][:avg], max_min[:max_ipt][:pdt_date], max_min[:min_ipt][:pdt_date], yoy_result[:ipt], mom_result[:ipt])
    opt = month_water(result[:opt][:sum], year_result[:opt][:sum], max_min[:max_opt][:val], max_min[:min_opt][:val], result[:opt][:avg], max_min[:max_opt][:pdt_date], max_min[:min_opt][:pdt_date], yoy_result[:opt], mom_result[:opt])

    
    SmthPdtRpt.transaction do
      rpt = SmthPdtRpt.new(rpt)

      if rpt.save!
        mthipt = SmonthIpt.new(ipt)
        mthipt.smth_pdt_rpt = rpt
        mthipt.save!

        mthopt = SmonthOpt.new(opt)
        mthopt.smth_pdt_rpt = rpt
        mthopt.save!

        mthpower = SmonthPower.new()
        mthpower.smth_pdt_rpt = rpt
        mthpower.save!

        mthsell = SmonthSell.new()
        mthsell.smth_pdt_rpt = rpt
        mthsell.save!

        process_result = 'success'
      else
        process_result = 'fail'
      end
    end
    process_result
  end


  private
    def mth_pdt_rpt(start_date, end_date, factory_id, name, state)
      {
        :state => state,
        :name => name,
        :start_date =>  start_date, 
        :end_date =>  end_date, 
        :sfactory_id => factory_id,
      }
    end

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

    def month_power(power, end_power, bom, bom_power, yoy_power, mom_power, ypdr_power, yoy_bom, mom_bom, ypdr_bom)
      {
        :power => power,
        :end_power => end_power,
        :bom => bom,
        :bom_power => bom_power,
        :yoy_power => yoy_power,
        :mom_power => mom_power,
        :ypdr_power => ypdr_power,
        :yoy_bom => yoy_bom,
        :mom_bom => mom_bom,
        :ypdr_bom => ypdr_bom
      }
    end
     
end
