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
    power  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum], last_year_result[:power][:sum])
    bom  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:bom][:sum], last_year_result[:bom][:sum])

    {
      :ipt   =>  ipt,
      :opt   =>  opt,
      :bom   =>  bom,
      :power   =>  power
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
    power  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum], last_year_result[:power][:sum])
    bom  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:bom][:sum], last_year_result[:bom][:sum])

    {
      :ipt   =>  ipt,
      :opt   =>  opt,
      :bom   =>  bom,
      :power   =>  power
    }
  end

  def static_sum(company_id, _start, _end, category)
    fct_ids = []
    - if category == Setting.cmpy_mth_rpts.ncategory 
      ncompany = Ncompany.find(company_id)
      fct_ids = ncompany.sfactories.pluck(:id)
    - else category == Setting.cmpy_mth_rpts.ccategory 
      ccompany = Ccompany.find(company_id)
      fct_ids = ccompany.sfactories.pluck(:id)

    day_pdt_rpts = SdayPdt.where(["sfactory_id in (?) and pdt_date between ? and ?", fct_ids, _start, _end])
    items = day_pdt_rpts.select(search_str).group("pdt_date")
    size = items.size
    result = {}

    if size == 0
      result = result_zero
      return result
    end

    sum_ipt, sum_opt, sum_power = 0, 0, 0
    max_ipt = {pdt_date: items[0].pdt_date, val: items[0].sum_ipt}
    max_opt = {pdt_date: items[0].pdt_date, val: items[0].sum_opt}
    max_power = {pdt_date: items[0].pdt_date, val: items[0].sum_power}
    min_ipt = {pdt_date: items[0].pdt_date, val: items[0].sum_ipt}
    min_opt = {pdt_date: items[0].pdt_date, val: items[0].sum_opt}
    min_power = {pdt_date: items[0].pdt_date, val: items[0].sum_power}

    items.each do |item|
      sum_ipt += item.sum_ipt
      sum_opt += item.sum_opt
      sum_power += item.sum_power

      max_ipt = {pdt_date: item.pdt_date, val: item.sum_ipt} if item.sum_ipt > max_ipt.val
      max_opt = {pdt_date: item.pdt_date, val: item.sum_opt} if item.sum_opt > max_opt.val
      max_power = {pdt_date: item.pdt_date, val: item.sum_power} if item.sum_power > max_power.val

      min_ipt = {pdt_date: item.pdt_date, val: item.sum_ipt} if item.sum_ipt < min_ipt.val
      min_opt = {pdt_date: item.pdt_date, val: item.sum_opt} if item.sum_opt < min_opt.val
      min_power = {pdt_date: item.pdt_date, val: item.sum_power} if item.sum_power < min_power.val
    end
    avg_ipt = FormulaLib.ratio(ipt, size)
    avg_opt = FormulaLib.ratio(opt, size)
    avg_power = FormulaLib.ratio(power, size)
    bom = FormulaLib.ratio(sum_power, sum_opt)

    result = {
      :state => 'nozero',
      :ipt => {title: Setting.sday_pdts.ipt, sum: sum_ipt, avg: avg_ipt},
      :opt => {title: Setting.sday_pdts.opt, sum: sum_opt, avg: avg_opt},
      :bom => {title: Setting.sday_pdts.bom, sum: sum_bom, avg: avg_bom},
      :power => { title: Setting.sday_pdts.power, sum: sum_power, avg: avg_power},
      :max_ipt => max_ipt,
      :max_opt => max_opt,
      :max_power => max_power,
      :min_ipt => min_ipt,
      :min_opt => min_opt,
      :min_power => min_power
    }

    result
  end

  def result_zero
    {
      :state => 'zero',
      :ipt => { title: Setting.sday_pdts.ipt, sum: 0, avg: 0},
      :opt => { title: Setting.sday_pdts.opt, sum: 0, avg: 0},
      :bom => { title: Setting.sday_pdts.bom, sum: 0, avg: 0},
      :power => { title: Setting.sday_pdts.power, sum: 0, avg: 0},
      :max_ipt => {pdt_date: '', val: 0},
      :max_opt => {pdt_date: '', val: 0},
      :max_power => {pdt_date: '', val: 0},
      :min_ipt => {pdt_date: '', val: 0},
      :min_opt => {pdt_date: '', val: 0},
      :min_power => {pdt_date: '', val: 0}
    }
  end

  def search_str
    "
      pdt_date, 
      ifnull(ROUND(sum(ipt), 2), 0) sum_ipt,
      ifnull(ROUND(sum(opt), 2), 0) sum_opt,
      ifnull(ROUND(sum(power), 2), 0) sum_power
    "
  end  
end    
