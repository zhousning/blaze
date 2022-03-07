module CmpyMathCube
  include FormulaLib
  
  def static_yoy(company_id, year, month, category)
    last_year = year - 1

    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    _last_start = Date.new(last_year, month, 1)
    _last_end = Date.new(last_year, month, -1)
    
    result = static_sum(company_id, _start, _end, category)
    last_year_result = static_sum(company_id, _last_start, _last_end, category)

    ipt  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:ipt][:sum], last_year_result[:ipt][:sum])
    opt  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:opt][:sum], last_year_result[:opt][:sum])
    #power  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum], last_year_result[:power][:sum])

    #power = 0
    #bom = 0
    #last_year_mth_rpt = MthPdtRpt.where(["company_id = ? and start_date = ?", company_id, _last_start]).first
    #if last_year_mth_rpt
    #  power = result[:power][:sum]
    #  power_w = FormulaLib.format_num(power/10000)
    #  last_year_power = last_year_mth_rpt.month_power
    #  power   = last_year_power.blank? ? 0 : FormulaLib.mom(power_w, last_year_power.power)     
    #  bom     = last_year_power.blank? ? 0 : FormulaLib.mom(result[:power][:bom], last_year_power.bom)     
    #end

    {
      :ipt   =>  ipt,
      :opt   =>  opt
    }
  end

  def static_mom(company_id, year, month, category)

    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    last_year = year
    last_month = month - 1
    if last_month == 0
      last_month = 12
      last_year = year - 1
    end

    _last_start = Date.new(last_year, last_month, 1)
    _last_end = Date.new(last_year, last_month, -1)
    
    result = static_sum(company_id, _start, _end, category)
    last_year_result = static_sum(company_id, _last_start, _last_end, category)

    ipt  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:ipt][:sum], last_year_result[:ipt][:sum])
    opt  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:opt][:sum], last_year_result[:opt][:sum])
    #power  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum], last_year_result[:power][:sum])

    #last_month_mth_rpt = MthPdtRpt.where(["company_id = ? and start_date = ?", company_id, _last_start]).first
    #power = 0
    #bom = 0
    #if last_month_mth_rpt
    #  power = result[:power][:sum]
    #  power_w = FormulaLib.format_num(power/10000)
    #  last_month_power = last_month_mth_rpt.month_power
    #  power = last_month_power.blank? ? 0 : FormulaLib.mom(power_w, last_month_power.power)     
    #  bom   = last_month_power.blank? ? 0 : FormulaLib.mom(result[:power][:bom], last_month_power.bom)     
    #end

    {
      :ipt   =>  ipt,
      :opt   =>  opt
    }
  end

  def static_max_min(company_id, _start, _end, category)
    day_pdt_rpts = SdayPdt.where(["company_id = ? and pdt_date between ? and ?", company_id, _start, _end])
    max_ipt = day_pdt_rpts.select('pdt_date, max(ipt) max')[0] 
    max_opt = day_pdt_rpts.select('pdt_date, max(opt) max')[0] 
    max_press = day_pdt_rpts.select('pdt_date, max(press) max')[0] 
    min_ipt = day_pdt_rpts.select('pdt_date, min(ipt) min')[0] 
    min_opt = day_pdt_rpts.select('pdt_date, min(opt) min')[0] 
    min_press = day_pdt_rpts.select('pdt_date, min(press) min')[0] 

    {
      :max_ipt => {:pdt_date => max_ipt.pdt_date, :val => max_ipt.max},
      :max_opt => {:pdt_date => max_opt.pdt_date, :val => max_opt.max},
      :min_ipt => {:pdt_date => min_ipt.pdt_date, :val => min_ipt.min},
      :min_opt => {:pdt_date => min_opt.pdt_date, :val => min_opt.min},
      :max_press => {:pdt_date => max_press.pdt_date, :val => max_press.max},
      :min_press => {:pdt_date => min_press.pdt_date, :val => min_press.min}
    }
  end

  def static_sum(company_id, _start, _end, category)
    - if mth_pdt_rpt.category == Setting.cmpy_mth_rpts.ncategory 
      day_pdt_rpts = SmthPdtRpt.where(["company_id = ? and pdt_date between ? and ?", company_id, _start, _end])
      rpt_static = day_pdt_rpts.select(search_str) 
      rpt = rpt_static[0]
      #day_rpt_stcs = DayRptStc.where(:day_pdt_rpt => day_pdt_rpts.pluck(:id))
      #stc_static = day_rpt_stcs.select(rpt_stc_search_str) 
      #stc = stc_static[0]
    - else mth_pdt_rpt.category == Setting.cmpy_mth_rpts.ccategory 

    result = {}
    if rpt.counts > 0
      result = result_hash(rpt) 
    else
      result = result_zero
    end
    result
  end

  def result_hash(rpt)
    #单耗
    #bom = FormulaLib.bom(rpt.sum_power, rpt.sum_opt) 

    result = {
      :state => 'nozero',
      :ipt => { title: Setting.sday_pdts.ipt, sum: rpt.sum_ipt, avg: rpt.avg_ipt},
      :opt => { title: Setting.sday_pdts.opt, sum: rpt.sum_opt, avg: rpt.avg_opt},
      :press => { title: Setting.sday_pdts.press, sum: rpt.sum_press, avg: rpt.avg_press},
      :power => { title: Setting.sday_pdts.power, sum: rpt.sum_power, avg: rpt.avg_power}
    }
    result
  end

  def result_zero
    {
      :state => 'zero',
      :ipt => { title: Setting.sday_pdts.ipt, sum: 0, avg: 0},
      :opt => { title: Setting.sday_pdts.opt, sum: 0, avg: 0},
      :press => { title: Setting.sday_pdts.press, sum: 0, avg: 0},
      :power => { title: Setting.sday_pdts.power, sum: 0, avg: 0}
    }
  end

  def rpt_stc_search_str
    "
      ifnull(ROUND(sum(bod_emq)   , 2), 0) sum_bod_emq,
    "
  end
      
  def search_str
    "
      ifnull(count(id), 0) counts,
      ifnull(ROUND(sum(ipt), 2), 0) sum_ipt,
      ifnull(ROUND(sum(opt), 2), 0) sum_opt,
      ifnull(ROUND(sum(press), 2), 0) sum_press,
      ifnull(ROUND(sum(power), 2), 0) sum_power,

      ifnull(ROUND(avg(nullif(ipt, 0)), 2), 0) avg_ipt,
      ifnull(ROUND(avg(nullif(opt, 0)), 2), 0) avg_opt,
      ifnull(ROUND(avg(nullif(press, 0)), 2), 0) avg_press,
      ifnull(ROUND(avg(nullif(power, 0)), 2), 0) avg_power
    "
  end  
end    
