module CreateCmpyMthRpt
  include FormulaLib 
  def create_cmpy_mth_rpt(company, year, month, state, category)
    process_result = ''
    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    result = static_sum(company.id, _start, _end, category)

    #判断选定的月份是否有数据
    if result[:state] == 'zero'
      process_result = 'zero'
      return process_result
    end

    year_result = static_sum(company.id, _year_start, _end, category)
    mom_result = static_mom(company.id, year, month, category)
    yoy_result = static_yoy(company.id, year, month, category)

    rpt = nil 
    if category == Setting.cmpy_mth_rpts.ccategory
      name = year.to_s + "年" + month.to_s + "月" + company.name + "城镇供水生产运营报告"
      rpt = cmth_pdt_rpt(_start, _end, company.id, name, state, category)
    else category == Setting.cmpy_mth_rpts.ncategory
      name = year.to_s + "年" + month.to_s + "月" + company.name + "农村供水生产运营报告"
      rpt = nmth_pdt_rpt(_start, _end, company.id, name, state, category)
    end

    ipt = month_water(result[:ipt][:sum], year_result[:ipt][:sum], result[:max_ipt][:val], result[:min_ipt][:val], result[:ipt][:avg], result[:max_ipt][:pdt_date], result[:min_ipt][:pdt_date], yoy_result[:ipt], mom_result[:ipt])
    opt = month_water(result[:opt][:sum], year_result[:opt][:sum], result[:max_opt][:val], result[:min_opt][:val], result[:opt][:avg], result[:max_opt][:pdt_date], result[:min_opt][:pdt_date], yoy_result[:opt], mom_result[:opt])
    #power = month_power(result[:power][:sum], year_result[:power][:sum], result[:max_power][:val], result[:min_power][:val], result[:power][:avg], result[:max_power][:pdt_date], result[:min_power][:pdt_date], yoy_result[:power], mom_result[:power])
    
    CmpyMthRpt.transaction do
      rpt = CmpyMthRpt.new(rpt)

      if rpt.save!
        mthipt = CmpyMthIpt.new(ipt)
        mthipt.cmpy_mth_rpt = rpt
        mthipt.save!

        mthopt = CmpyMthOpt.new(opt)
        mthopt.cmpy_mth_rpt = rpt
        mthopt.save!

        mthpower = CmpyMthPower.new(:val => result[:power][:sum])
        mthpower.cmpy_mth_rpt = rpt
        mthpower.save!

        mthsell = CmpyMthSell.new(:start_date => rpt.start_date, :end_date => rpt.end_date, :name => rpt.name + '-售水量数据报表', :category => rpt.category)
        mthsell.cmpy_mth_rpt = rpt
        if rpt.category == Setting.cmpy_mth_rpts.ccategory
          company = rpt.ccompany
          mthsell.ccompany = company
        else
          company = rpt.ncompany
          mthsell.ncompany = company
        end
        mthsell.save!

        process_result = 'success'
      else
        process_result = 'fail'
      end
    end
    process_result
  end


  private
    def cmth_pdt_rpt(start_date, end_date, company_id, name, state, category)
      {
        :state => state,
        :name => name,
        :start_date =>  start_date, 
        :end_date =>  end_date, 
        :ccompany_id => company_id,
        :category => category
      }
    end

    def nmth_pdt_rpt(start_date, end_date, company_id, name, state, category)
      {
        :state => state,
        :name => name,
        :start_date =>  start_date, 
        :end_date =>  end_date, 
        :ncompany_id => company_id,
        :category => category
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
