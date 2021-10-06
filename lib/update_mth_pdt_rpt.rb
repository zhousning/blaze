module UpdateMthPdtRpt
  include FormulaLib 
  def update_mth_pdt_rpt(rpt)
    _start = rpt.start_date
    _end = rpt.end_date
    year = _start.year
    month = _start.month
    _year_start = Date.new(year, 1, 1)

    factory = rpt.factory

    result = static_sum(factory.id, _start, _end)
    year_result = static_sum(factory.id, _year_start, _end)

    mom_result = static_mom(factory.id, year, month)
    yoy_result = static_yoy(factory.id, year, month)
    up_std  = up_standard_days(factory.id, _start, _end)
    end_std = up_standard_days(factory.id, _year_start, _end)

    flow = mth_pdt_rpt_update(result[:inflow][:sum], result[:inflow][:avg], year_result[:inflow][:sum])

    bod = month_cms(result[:inf_bod][:avg], result[:eff_bod][:avg], result[:emr][:bod], result[:avg_emq][:bod], result[:emq][:bod], year_result[:emq][:bod], up_std[:bod] , end_std[:bod], yoy_result[:emq_bod], mom_result[:emq_bod], 0)
    cod = month_cms(result[:inf_cod][:avg], result[:eff_cod][:avg], result[:emr][:cod], result[:avg_emq][:cod], result[:emq][:cod], year_result[:emq][:cod], up_std[:cod] , end_std[:cod], yoy_result[:emq_cod], mom_result[:emq_cod], 0)
    tp = month_cms(result[:inf_tp][:avg], result[:eff_tp][:avg], result[:emr][:tp], result[:avg_emq][:tp], result[:emq][:tp], year_result[:emq][:tp], up_std[:tp] , end_std[:tp], yoy_result[:emq_tp], mom_result[:emq_tp], 0)
    tn = month_cms(result[:inf_tn][:avg], result[:eff_tn][:avg], result[:emr][:tn], result[:avg_emq][:tn], result[:emq][:tn], year_result[:emq][:tn], up_std[:tn] , end_std[:tn], yoy_result[:emq_tn], mom_result[:emq_tn], 0)
    ss = month_cms(result[:inf_ss][:avg], result[:eff_ss][:avg], result[:emr][:ss], result[:avg_emq][:ss], result[:emq][:ss], year_result[:emq][:ss], up_std[:ss] , end_std[:ss], yoy_result[:emq_ss], mom_result[:emq_ss], 0)
    nhn = month_cms(result[:inf_nhn][:avg], result[:eff_nhn][:avg], result[:emr][:nhn], result[:avg_emq][:nhn], result[:emq][:nhn], year_result[:emq][:nhn], up_std[:nhn] , end_std[:nhn], yoy_result[:emq_nhn], mom_result[:emq_nhn], 0)

    # 现在是0-缺少bom_power
    power = result[:power][:sum]
    power_w = FormulaLib.format_num(power/10000)

    year_power_sum = power_w 
    if month != 1
      last_mth_rpt = MthPdtRpt.where(["factory_id = ? and start_date = ?", factory.id, Date.new(year, month-1, 1)]).first
      year_power_sum = last_mth_rpt.month_power.end_power + power_w
    end
    
    power = month_power(power_w, year_power_sum, result[:power][:bom], 0, yoy_result[:power], mom_result[:power], 0, yoy_result[:bom], mom_result[:bom], 0)

    mud = month_mud(result[:inmud][:sum], year_result[:inmud][:sum], result[:outmud][:sum], year_result[:outmud][:sum], up_std[:mud], yoy_result[:mud], mom_result[:mud], 0)

    md = month_md(result[:mdrcy][:sum], year_result[:mdrcy][:sum], result[:mdsell][:sum], year_result[:mdsell][:sum], yoy_result[:mdrcy], mom_result[:mdrcy], 0, yoy_result[:mdsell], mom_result[:mdsell], 0)

    fecal = month_fecal(up_std[:fecal] , end_std[:fecal], yoy_result[:fecal], mom_result[:fecal])
    
    {
      :flow => flow,
      :cms => {
        :bod => bod,
        :cod => cod,
        :tp => tp,
        :tn => tn,
        :nhn => nhn,
        :ss => ss,
        :power => power,
        :mud => mud,
        :md => md,
        :fecal => fecal
      }
    }
  end

  private
    def mth_pdt_rpt_update(outflow, avg_outflow, end_outflow)
      {
        :outflow  =>  outflow,
        :avg_outflow =>  avg_outflow,
        :end_outflow =>  end_outflow
      }
    end

    #削减量同比和环比
    def month_cms(avg_inf, avg_eff, emr, avg_emq, emq, end_emq, up_std , end_std, yoy, mom, ypdr)
      {
        :avg_inf   =>   avg_inf,
        :avg_eff   =>   avg_eff,
        :emr       =>   emr    ,
        :avg_emq   =>   avg_emq,
        :emq       =>   emq    ,
        :end_emq   =>   end_emq,
        :up_std    =>   up_std ,
        :end_std   =>   end_std,
        :yoy       =>   yoy    ,
        :mom       =>   mom    ,
        :ypdr      =>   ypdr   
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
     
    def month_mud(inmud, end_inmud, outmud, end_outmud, mst_up, yoy, mom, ypdr)
      {
        :inmud      =>  inmud    ,
        :end_inmud  =>  end_inmud,
        :outmud     =>  outmud   ,
        :end_outmud =>  end_outmud,
        :mst_up     =>  mst_up   ,
        :yoy        =>  yoy      ,
        :mom        =>  mom      ,
        :ypdr       =>  ypdr     
      }
    end

    def month_md(mdrcy, end_mdrcy, mdsell, end_mdsell, yoy_mdrcy, mom_mdrcy, ypdr_mdrcy, yoy_mdsell, mom_mdsell, ypdr_mdsell)
      {
        :mdrcy        =>   mdrcy,
        :end_mdrcy    =>   end_mdrcy,
        :mdsell       =>   mdsell,
        :end_mdsell   =>   end_mdsell,
        :yoy_mdrcy    =>   yoy_mdrcy,
        :mom_mdrcy    =>   mom_mdrcy,
        :ypdr_mdrcy   =>   ypdr_mdrcy,
        :yoy_mdsell   =>   yoy_mdsell,
        :mom_mdsell   =>   mom_mdsell,
        :ypdr_mdsell  =>   ypdr_mdsell
      }
    end

    def month_fecal(up_std, end_std, yoy, mom)
      {
        :up_std  => up_std,
        :end_std => end_std,
        :yoy => yoy,
        :mom => mom
      }
    end
end
