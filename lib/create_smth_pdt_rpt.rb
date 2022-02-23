module CreateSmthPdtRpt
  include FormulaLib 
  def create_mth_pdt_rpt(factory, year, month, state)
    process_result = ''
    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    result = static_sum(factory.id, _start, _end)

    #判断选定的月份是否有数据
    if result[:state] == 'zero'
      process_result = 'zero'
      return process_result
    end

    year_result = static_sum(factory.id, _year_start, _end)

    mom_result = static_mom(factory.id, year, month)
    yoy_result = static_yoy(factory.id, year, month)
    up_std  = up_standard_days(factory.id, _start, _end)
    end_std = up_standard_days(factory.id, _year_start, _end)

    name = year.to_s + "年" + month.to_s + "月" + factory.name + "生产运营报告"
    rpt = mth_pdt_rpt(_start, _end, factory.design, result[:inflow][:sum], result[:inflow][:avg], year_result[:inflow][:sum], factory.id, name, state)

    bod = month_cms(result[:inf_bod][:avg], result[:eff_bod][:avg], result[:emr][:bod], result[:avg_emq][:bod], result[:emq][:bod], year_result[:emq][:bod], up_std[:bod] , end_std[:bod], yoy_result[:emq_bod], mom_result[:emq_bod], 0)
    cod = month_cms(result[:inf_cod][:avg], result[:eff_cod][:avg], result[:emr][:cod], result[:avg_emq][:cod], result[:emq][:cod], year_result[:emq][:cod], up_std[:cod] , end_std[:cod], yoy_result[:emq_cod], mom_result[:emq_cod], 0)
    tp = month_cms(result[:inf_tp][:avg], result[:eff_tp][:avg], result[:emr][:tp], result[:avg_emq][:tp], result[:emq][:tp], year_result[:emq][:tp], up_std[:tp] , end_std[:tp], yoy_result[:emq_tp], mom_result[:emq_tp], 0)
    tn = month_cms(result[:inf_tn][:avg], result[:eff_tn][:avg], result[:emr][:tn], result[:avg_emq][:tn], result[:emq][:tn], year_result[:emq][:tn], up_std[:tn] , end_std[:tn], yoy_result[:emq_tn], mom_result[:emq_tn], 0)
    ss = month_cms(result[:inf_ss][:avg], result[:eff_ss][:avg], result[:emr][:ss], result[:avg_emq][:ss], result[:emq][:ss], year_result[:emq][:ss], up_std[:ss] , end_std[:ss], yoy_result[:emq_ss], mom_result[:emq_ss], 0)
    nhn = month_cms(result[:inf_nhn][:avg], result[:eff_nhn][:avg], result[:emr][:nhn], result[:avg_emq][:nhn], result[:emq][:nhn], year_result[:emq][:nhn], up_std[:nhn] , end_std[:nhn], yoy_result[:emq_nhn], mom_result[:emq_nhn], 0)

    ccod = month_cms(result[:inf_cod][:cavg], result[:eff_cod][:cavg], result[:cemr][:cod], result[:cavg_emq][:cod], result[:cemq][:cod], year_result[:cemq][:cod], up_std[:ccod] , end_std[:ccod], yoy_result[:cemq_cod], mom_result[:cemq_cod], 0)
    ctp = month_cms(result[:inf_tp][:cavg], result[:eff_tp][:cavg], result[:cemr][:tp], result[:cavg_emq][:tp], result[:cemq][:tp], year_result[:cemq][:tp], up_std[:ctp] , end_std[:ctp], yoy_result[:cemq_tp], mom_result[:cemq_tp], 0)
    ctn = month_cms(result[:inf_tn][:cavg], result[:eff_tn][:cavg], result[:cemr][:tn], result[:cavg_emq][:tn], result[:cemq][:tn], year_result[:cemq][:tn], up_std[:ctn] , end_std[:ctn], yoy_result[:cemq_tn], mom_result[:cemq_tn], 0)
    cnhn = month_cms(result[:inf_nhn][:cavg], result[:eff_nhn][:cavg], result[:cemr][:nhn], result[:cavg_emq][:nhn], result[:cemq][:nhn], year_result[:cemq][:nhn], up_std[:cnhn] , end_std[:cnhn], yoy_result[:cemq_nhn], mom_result[:cemq_nhn], 0)

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
    
    MthPdtRpt.transaction do
      rpt = MthPdtRpt.new(rpt)

      if rpt.save!
        select_str = "
          chemicals.name chemical_id, 
          ifnull(sum(dosage),    0) sum_dosage, 
          ifnull(avg(dosage),    0) avg_dosage
        "
        chemicals = Chemical.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", factory.id, _start, _end]).select(select_str).group(:name)
        chemicals.each do |chemical|
          theory_dosage = format("%0.2f", chemical.sum_dosage).to_f
          avg_dosage    = format("%0.2f", chemical.avg_dosage).to_f

          MthChemical.create!(:name => chemical.chemical_id, :dosage => theory_dosage, :avg_dosage => avg_dosage, :mth_pdt_rpt => rpt) 
        end

        mthbod = MonthBod.new(bod)
        mthbod.mth_pdt_rpt = rpt
        mthbod.save!

        mthcod = MonthCod.new(cod)
        mthcod.mth_pdt_rpt = rpt
        mthcod.save!

        mthtp = MonthTp.new(tp)
        mthtp.mth_pdt_rpt = rpt
        mthtp.save!

        mthtn = MonthTn.new(tn)
        mthtn.mth_pdt_rpt = rpt
        mthtn.save!

        mthnhn = MonthNhn.new(nhn)
        mthnhn.mth_pdt_rpt = rpt
        mthnhn.save!

        mthss = MonthSs.new(ss)
        mthss.mth_pdt_rpt = rpt
        mthss.save!

        cmthcod = CmonthCod.new(ccod)
        cmthcod.mth_pdt_rpt = rpt
        cmthcod.save!

        cmthtp = CmonthTp.new(ctp)
        cmthtp.mth_pdt_rpt = rpt
        cmthtp.save!
        
        cmthtn = CmonthTn.new(ctn)
        cmthtn.mth_pdt_rpt = rpt
        cmthtn.save!

        cmthnhn = CmonthNhn.new(cnhn)
        cmthnhn.mth_pdt_rpt = rpt
        cmthnhn.save!

        mthpower = MonthPower.new(power)
        mthpower.mth_pdt_rpt = rpt
        mthpower.save!
        mthmud = MonthMud.new(mud)
        mthmud.mth_pdt_rpt = rpt
        mthmud.save!
        mthmd = MonthMd.new(md)
        mthmd.mth_pdt_rpt = rpt
        mthmd.save!
        mthfecal = MonthFecal.new(fecal)
        mthfecal.mth_pdt_rpt = rpt
        mthfecal.save!

        process_result = 'success'
      else
        process_result = 'fail'
      end
    end
    process_result
  end


  private
    def mth_pdt_rpt(start_date, end_date, design, outflow, avg_outflow, end_outflow, factory_id, name, state)
      {
        :state => state,
        :name => name,
        :start_date =>  start_date, 
        :end_date =>  end_date, 
        :factory_id => factory_id,
        :design   =>  design,
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
