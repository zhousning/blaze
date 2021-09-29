module UpdateMthPdtRpt
  def update_mth_pdt_rpt(rpt)
    process_result = ''
    _start = rpt.start_date
    _end = rpt.end_date
    _year_start = Date.new(_start.year, 1, 1)

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
    power = month_power(result[:power][:sum], year_result[:power][:sum], result[:power][:bom], 0, yoy_result[:power], mom_result[:power], 0, yoy_result[:bom], mom_result[:bom], 0)

    mud = month_mud(result[:inmud][:sum], year_result[:inmud][:sum], result[:outmud][:sum], year_result[:outmud][:sum], up_std[:mud], yoy_result[:mud], mom_result[:mud], 0)

    md = month_md(result[:mdrcy][:sum], year_result[:mdrcy][:sum], result[:mdsell][:sum], year_result[:mdsell][:sum], yoy_result[:mdrcy], mom_result[:mdrcy], 0, yoy_result[:mdsell], mom_result[:mdsell], 0)

    fecal = month_fecal(up_std[:fecal] , end_std[:fecal], yoy_result[:fecal], mom_result[:fecal])
    
    MthPdtRpt.transaction do
      if rpt.update(flow)
        mthbod = rpt.mthbod 
        mthcod = rpt.mthcod
        mthtp  = rpt.mthtp 
        mthtn  = rpt.mthtn 
        mthnhn = rpt.mthnhn
        mthss  = rpt.mthss 
        mthpower = rpt.mthpower
        mthmud = rpt.mthmud
        mthmd  = rpt.mthmd 
        mthfecal = rpt.mthfecal 

        select_str = "
          chemicals.name chemical_id, 
          ifnull(sum(dosage),    0) sum_dosage, 
          ifnull(avg(dosage),    0) avg_dosage
        "
        rpt.mth_chemicals = []
        chemicals = Chemical.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).group(:name)
        chemicals.each do |chemical|
          theory_dosage = format("%0.2f", chemical.sum_dosage).to_f
          avg_dosage    = format("%0.2f", chemical.avg_dosage).to_f
          MthChemical.create!(:name => chemical.chemical_id, :dosage => theory_dosage, :avg_dosage => avg_dosage, :mth_pdt_rpt => rpt) 
        end

        mthbod.update_attributes(bod)
        mthcod.update_attributes(cod)
        mthtp.update_attributes(tp)
        mthtn.update_attributes(tn)
        mthnhn.update_attributes(nhn)
        mthss.update_attributes(ss)
        mthpower.update_attributes(power)
        mthmud.update_attributes(mud)
        mthmd.update_attributes(md)
        mthfecal.update_attributes(fecal)        
      end
    end
  end

  protected
    def mth_pdt_rpt_update(outflow, avg_outflow, end_outflow)
      {
        :outflow  =>  outflow,
        :avg_outflow =>  avg_outflow,
        :end_outflow =>  end_outflow
      }
    end
end
