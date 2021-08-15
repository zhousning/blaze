module MathCube
  
  def QuotaConfig.quota_hash 
    quota_hash = Hash.new
    quotas = Quota.all
    quotas.each do |q|
      quota_hash[q.code.strip] = {:name => q.name, :max => q.max }
    end
    quota_hash
  end

  MYQUOTAS = QuotaConfig.quota_hash


  def up_standard_days(factory_id, _start, _end)
    bod_max = MYQUOTAS[Setting.quota.bod][:max]
    cod_max = MYQUOTAS[Setting.quota.bod][:max]
    tn_max = MYQUOTAS[Setting.quota.tn][:max]
    tp_max = MYQUOTAS[Setting.quota.tp][:max]
    nhn_max = MYQUOTAS[Setting.quota.nhn][:max]
    ss_max = MYQUOTAS[Setting.quota.ss][:max]
    fecal_max = MYQUOTAS[Setting.quota.fecal][:max]
    mst_max = MYQUOTAS[Setting.quota.mst][:max]

    bod = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_bod <= ?", factory_id, _start, _end, bod_max]).count
    cod = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_cod <= ?", factory_id, _start, _end, cod_max]).count
    tp = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_tp <= ?", factory_id, _start, _end, tp_max]).count
    tn = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_tn <= ?", factory_id, _start, _end, tn_max]).count
    ss = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_ss <= ?", factory_id, _start, _end, ss_max]).count
    nhn = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_nhn <= ?", factory_id, _start, _end, nhn_max]).count
    fecal = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and eff_qlty_fecal <= ?", factory_id, _start, _end, fecal_max]).count
    mud = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ? and mst <= ?", factory_id, _start, _end, mst_max]).count

    result = {:bod => bod, :cod => cod, :tp => tp, :tn => tn, :ss => ss, :nhn => nhn, :fecal => fecal, :mud => mud}
    result
  end

  def static_yoy(factory_id, year, month)
    last_year = year - 1

    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    _last_start = Date.new(last_year, month, 1)
    _last_end = Date.new(last_year, month, -1)
    
    result = static_sum(factory_id, _start, _end)
    last_year_result = static_sum(factory_id, _last_start, _last_end)

    outflow = format_number((last_year_result[:outflow][:sum] - result[:outflow][:sum])/last_year_result[:outflow][:sum])
    power = format_number((last_year_result[:power][:sum] - result[:power][:sum])/last_year_result[:power][:sum])
    bom = format_number((last_year_result[:power][:bom] - result[:power][:bom])/last_year_result[:power][:bom])
    emq_tn = format_number((last_year_result[:emq][:tn] - result[:emq][:tn])/last_year_result[:emq][:tn])
    emq_tp = format_number((last_year_result[:emq][:tp] - result[:emq][:tp])/last_year_result[:emq][:tp])
    emq_bod = format_number((last_year_result[:emq][:bod] - result[:emq][:bod])/last_year_result[:emq][:bod])
    emq_cod = format_number((last_year_result[:emq][:cod] - result[:emq][:cod])/last_year_result[:emq][:cod])
    emq_nhn = format_number((last_year_result[:emq][:nhn] - result[:emq][:nhn])/last_year_result[:emq][:nhn])
    emq_ss = format_number((last_year_result[:emq][:ss] - result[:emq][:ss])/last_year_result[:emq][:ss])
    mud = format_number((last_year_result[:outmud][:sum] - result[:outmud][:sum])/last_year_result[:outmud][:sum])
    mdrcy = format_number((last_year_result[:mdrcy][:sum] - result[:mdrcy][:sum])/last_year_result[:mdrcy][:sum])
    mdsell = format_number((last_year_result[:mdsell][:sum] - result[:mdsell][:sum])/last_year_result[:mdsell][:sum])

    {
      :outflow  =>  outflow*100,
      :power    =>  power*100 ,
      :bom      =>  bom*100 ,
      :emq_tn   =>  emq_tn*100, 
      :emq_tp   =>  emq_tp*100 ,
      :emq_bod  =>  emq_bod*100,
      :emq_cod  =>  emq_cod*100,
      :emq_nhn  =>  emq_nhn*100,
      :emq_ss   =>  emq_ss*100  ,   
      :mud      =>  mud*100,
      :mdsell      =>  mdsell*100,
      :mdrcy      =>  mdrcy*100
    }
  end

  def static_mom(factory_id, year, month)

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
    
    result = static_sum(factory_id, _start, _end)
    last_year_result = static_sum(factory_id, _last_start, _last_end)

    outflow = format_number((last_year_result[:outflow][:sum] - result[:outflow][:sum])/last_year_result[:outflow][:sum])
    power = format_number((last_year_result[:power][:sum] - result[:power][:sum])/last_year_result[:power][:sum])
    bom = format_number((last_year_result[:power][:bom] - result[:power][:bom])/last_year_result[:power][:bom])
    emq_tn = format_number((last_year_result[:emq][:tn] - result[:emq][:tn])/last_year_result[:emq][:tn])
    emq_tp = format_number((last_year_result[:emq][:tp] - result[:emq][:tp])/last_year_result[:emq][:tp])
    emq_bod = format_number((last_year_result[:emq][:bod] - result[:emq][:bod])/last_year_result[:emq][:bod])
    emq_cod = format_number((last_year_result[:emq][:cod] - result[:emq][:cod])/last_year_result[:emq][:cod])
    emq_nhn = format_number((last_year_result[:emq][:nhn] - result[:emq][:nhn])/last_year_result[:emq][:nhn])
    emq_ss = format_number((last_year_result[:emq][:ss] - result[:emq][:ss])/last_year_result[:emq][:ss])
    mud = format_number((last_year_result[:outmud][:sum] - result[:outmud][:sum])/last_year_result[:outmud][:sum])
    mdrcy = format_number((last_year_result[:mdrcy][:sum] - result[:mdrcy][:sum])/last_year_result[:mdrcy][:sum])
    mdsell = format_number((last_year_result[:mdsell][:sum] - result[:mdsell][:sum])/last_year_result[:mdsell][:sum])

    {
      :outflow  =>  outflow*100,
      :power    =>  power*100 ,
      :bom      =>  bom*100 ,
      :emq_tn   =>  emq_tn*100, 
      :emq_tp   =>  emq_tp*100 ,
      :emq_bod  =>  emq_bod*100,
      :emq_cod  =>  emq_cod*100,
      :emq_nhn  =>  emq_nhn*100,
      :emq_ss   =>  emq_ss*100  ,   
      :mud      =>  mud*100,
      :mdsell      =>  mdsell*100,
      :mdrcy      =>  mdrcy*100
    }
  end


  def static_sum(factory_id, _start, _end)
    rpt_static = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ?", factory_id, _start, _end]).select(search_str) 
    rpt = rpt_static[0]

    result = {}
    result = result_hash(rpt) if rpt.counts > 0
    result
  end

  def result_hash(rpt)
    counts = rpt.counts
    inf_bod   =  rpt.sum_inf_qlty_bod   
    eff_bod   =  rpt.sum_eff_qlty_bod   
    inf_cod   =  rpt.sum_inf_qlty_cod   
    eff_cod   =  rpt.sum_eff_qlty_cod   
    inf_ss    =  rpt.sum_inf_qlty_ss    
    eff_ss    =  rpt.sum_eff_qlty_ss    
    inf_nhn   =  rpt.sum_inf_qlty_nhn   
    eff_nhn   =  rpt.sum_eff_qlty_nhn   
    inf_tn    =  rpt.sum_inf_qlty_tn    
    eff_tn    =  rpt.sum_eff_qlty_tn    
    inf_tp    =  rpt.sum_inf_qlty_tp    
    eff_tp    =  rpt.sum_eff_qlty_tp    
    inf_ph    =  rpt.sum_inf_qlty_ph    
    eff_ph    =  rpt.sum_eff_qlty_ph    
    eff_fecal =  rpt.sum_eff_qlty_fecal 
    inflow    =  rpt.sum_inflow
    outflow   =  rpt.sum_outflow
    inmud     =  rpt.sum_inmud 
    outmud    =  rpt.sum_outmud
    mst       =  rpt.sum_mst   
    power     =  rpt.sum_power 
    mdflow    =  rpt.sum_mdflow
    mdrcy     =  rpt.sum_mdrcy 
    mdsell    =  rpt.sum_mdsell
    bom = format_number(power/inflow) 
    #bom_power = 
    emr_bod = format_number((inf_bod - eff_bod)/eff_bod)*100
    emr_cod = format_number((inf_cod - eff_cod)/eff_cod)*100
    emr_tp = format_number((inf_tp - eff_tp)/eff_tp)*100
    emr_tn = format_number((inf_tn - eff_tn)/eff_tn)*100
    emr_ss = format_number((inf_ss - eff_ss)/eff_ss)*100
    emr_nhn = format_number((inf_nhn - eff_nhn)/eff_nhn)*100

    emq_bod = format_number((inf_bod - eff_bod)*inflow)
    emq_cod = format_number((inf_cod - eff_cod)*inflow)
    emq_tp = format_number((inf_tp - eff_tp)*inflow)
    emq_tn = format_number((inf_tn - eff_tn)*inflow)
    emq_ss = format_number((inf_ss - eff_ss)*inflow)
    emq_nhn = format_number((inf_nhn - eff_nhn)*inflow)

    avg_emq_bod = format_number(emq_bod/counts) 
    avg_emq_cod = format_number(emq_cod/counts) 
    avg_emq_tp =  format_number(emq_tp/counts) 
    avg_emq_tn =  format_number(emq_tn/counts)
    avg_emq_ss =  format_number(emq_ss/counts) 
    avg_emq_nhn = format_number(emq_nhn/counts) 

    result = {
      :inf_bod =>   { code: Setting.quota.bod,     title: Setting.day_pdt_rpts.inf_qlty_bod,   sum: inf_bod,   avg: format_number( inf_bod/counts ) },
      :eff_bod =>   { code: Setting.quota.bod,     title: Setting.day_pdt_rpts.eff_qlty_bod,   sum: eff_bod,   avg: format_number( eff_bod/counts ) },
      :inf_cod =>   { code: Setting.quota.cod,     title: Setting.day_pdt_rpts.inf_qlty_cod,   sum: inf_cod,   avg: format_number( inf_cod/counts ) },
      :eff_cod =>   { code: Setting.quota.cod,     title: Setting.day_pdt_rpts.eff_qlty_cod,   sum: eff_cod,   avg: format_number( eff_cod/counts ) },
      :inf_ss =>    { code: Setting.quota.ss,      title: Setting.day_pdt_rpts.inf_qlty_ss,    sum: inf_ss,    avg: format_number( inf_ss/counts ) },
      :eff_ss =>    { code: Setting.quota.ss,      title: Setting.day_pdt_rpts.eff_qlty_ss,    sum: eff_ss,    avg: format_number( eff_ss/counts ) },
      :inf_nhn =>   { code: Setting.quota.nhn,     title: Setting.day_pdt_rpts.inf_qlty_nhn,   sum: inf_nhn,   avg: format_number( inf_nhn/counts ) },
      :eff_nhn =>   { code: Setting.quota.nhn,     title: Setting.day_pdt_rpts.eff_qlty_nhn,   sum: eff_nhn,   avg: format_number( eff_nhn/counts ) },
      :inf_tn =>    { code: Setting.quota.tn,      title: Setting.day_pdt_rpts.inf_qlty_tn,    sum: inf_tn,    avg: format_number( inf_tn/counts ) },
      :eff_tn =>    { code: Setting.quota.tn,      title: Setting.day_pdt_rpts.eff_qlty_tn,    sum: eff_tn,    avg: format_number( eff_tn/counts ) },
      :inf_tp =>    { code: Setting.quota.tp,      title: Setting.day_pdt_rpts.inf_qlty_tp,    sum: inf_tp,    avg: format_number( inf_tp/counts ) },
      :eff_tp =>    { code: Setting.quota.tp,      title: Setting.day_pdt_rpts.eff_qlty_tp,    sum: eff_tp,    avg: format_number( eff_tp/counts ) },
      :inf_ph =>    { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.inf_qlty_ph,    sum: inf_ph,    avg: format_number( inf_ph/counts ) },
      :eff_ph =>    { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.eff_qlty_ph,    sum: eff_ph,    avg: format_number( eff_ph/counts ) },
      :eff_fecal => { code: Setting.quota.fecal,   title: Setting.day_pdt_rpts.eff_qlty_fecal, sum: eff_fecal, avg: format_number( eff_fecal/counts ) },
      :inflow =>    { code: Setting.quota.inflow,  title: Setting.day_pdt_rpts.inflow,         sum: inflow,    avg: format_number( inflow/counts ) }, 
      :outflow =>   { code: Setting.quota.outflow, title: Setting.day_pdt_rpts.outflow,        sum: outflow,   avg: format_number( outflow/counts ) },
      :inmud =>     { code: Setting.quota.inmud,   title: Setting.day_pdt_rpts.inmud,          sum: inmud,     avg: format_number( inmud/counts ) }, 
      :outmud =>    { code: Setting.quota.outmud,  title: Setting.day_pdt_rpts.outmud,         sum: outmud,    avg: format_number( outmud/counts ) },
      :mst =>       { code: Setting.quota.mst,     title: Setting.day_pdt_rpts.mst,            sum: mst,       avg: format_number( mst/counts ) },  
      :power =>     { code: Setting.quota.power,   title: Setting.day_pdt_rpts.power,          sum: power,     avg: format_number( power/counts ), bom: bom }, 
      :mdflow =>    { code: Setting.quota.mdflow,  title: Setting.day_pdt_rpts.mdflow,         sum: mdflow,    avg: format_number( mdflow/counts ) },
      :mdrcy =>     { code: Setting.quota.mdrcy,   title: Setting.day_pdt_rpts.mdrcy,          sum: mdrcy,     avg: format_number( mdrcy/counts ) }, 
      :mdsell =>    { code: Setting.quota.mdsell,  title: Setting.day_pdt_rpts.mdsell,         sum: mdsell,    avg: format_number( mdsell/counts ) },
      :emr => {:bod => emr_bod, :cod => emr_cod, :tp => emr_tp, :tn => emr_tn, :ss => emr_ss, :nhn => emr_nhn},
      :emq => {:bod => emq_bod, :cod => emq_cod, :tp => emq_tp, :tn => emq_tn, :ss => emq_ss, :nhn => emq_nhn},
      :avg_emq => {:bod => avg_emq_bod, :cod => avg_emq_cod, :tp => avg_emq_tp, :tn => avg_emq_tn, :ss => avg_emq_ss, :nhn => avg_emq_nhn}
    }
    result
  end
  
  def search_str
    "
      count(id)             counts,
      sum(temper)           sum_temper,
      sum(inf_qlty_bod)     sum_inf_qlty_bod,
      sum(inf_qlty_cod)     sum_inf_qlty_cod,
      sum(inf_qlty_ss)      sum_inf_qlty_ss,
      sum(inf_qlty_nhn)     sum_inf_qlty_nhn,
      sum(inf_qlty_tn)      sum_inf_qlty_tn,
      sum(inf_qlty_tp)      sum_inf_qlty_tp,
      sum(inf_qlty_ph)      sum_inf_qlty_ph,
      sum(eff_qlty_cod)     sum_eff_qlty_cod,
      sum(eff_qlty_ss)      sum_eff_qlty_ss,
      sum(eff_qlty_nhn)     sum_eff_qlty_nhn,
      sum(eff_qlty_tn)      sum_eff_qlty_tn,
      sum(eff_qlty_tp)      sum_eff_qlty_tp,
      sum(eff_qlty_ph)      sum_eff_qlty_ph,
      sum(eff_qlty_fecal)   sum_eff_qlty_fecal,
      sum(eff_qlty_bod)     sum_eff_qlty_bod,
      sum(inflow)           sum_inflow,    
      sum(outflow)          sum_outflow,
      sum(inmud)            sum_inmud,  
      sum(outmud)           sum_outmud, 
      sum(mst)              sum_mst,  
      sum(power)            sum_power,  
      sum(mdflow)           sum_mdflow, 
      sum(mdrcy)            sum_mdrcy,  
      sum(mdsell)           sum_mdsell"
      #sum(sed_qlty_bod)     sum_sed_qlty_bod,
      #sum(sed_qlty_cod)     sum_sed_qlty_cod,
      #sum(sed_qlty_ss)      sum_sed_qlty_ss,
      #sum(sed_qlty_nhn)     sum_sed_qlty_nhn,
      #sum(sed_qlty_tn)      sum_sed_qlty_tn,
      #sum(sed_qlty_tp)      sum_sed_qlty_tp,  
      #sum(sed_qlty_ph)      sum_sed_qlty_ph, 
  end

  def format_number(number)
    format("%0.2f", number).to_f
  end
end

#:temper =>              { title: Setting.day_pdt_rpts.temper,         sum: rpt.sum_temper,          avg: format_number( rpt.sum_temper/counts ) },
#:sed_qlty_bod =>        { code: Setting.quota.bod,  title: Setting.day_pdt_rpts.sed_qlty_bod,   sum: rpt.sum_sed_qlty_bod,    avg: format_number( rpt.sum_sed_qlty_bod/counts ) },
#:sed_qlty_cod =>        { code: Setting.quota.cod,  title: Setting.day_pdt_rpts.sed_qlty_cod,   sum: rpt.sum_sed_qlty_cod,    avg: format_number( rpt.sum_sed_qlty_cod/counts ) },
#:sed_qlty_ss =>         { code: Setting.quota.ss,   title: Setting.day_pdt_rpts.sed_qlty_ss,    sum: rpt.sum_sed_qlty_ss,     avg: format_number( rpt.sum_sed_qlty_ss/counts ) },
#:sed_qlty_nhn =>        { code: Setting.quota.nhn,  title: Setting.day_pdt_rpts.sed_qlty_nhn,   sum: rpt.sum_sed_qlty_nhn,    avg: format_number( rpt.sum_sed_qlty_nhn/counts ) },
#:sed_qlty_tn =>         { code: Setting.quota.tn,   title: Setting.day_pdt_rpts.sed_qlty_tn,    sum: rpt.sum_sed_qlty_tn,     avg: format_number( rpt.sum_sed_qlty_tn/counts ) },
#:sed_qlty_tp =>         { code: Setting.quota.tp,   title: Setting.day_pdt_rpts.sed_qlty_tp,    sum: rpt.sum_sed_qlty_tp,     avg: format_number( rpt.sum_sed_qlty_tp/counts ) },  
#:sed_qlty_ph =>         { code: Setting.quota.ph,   title: Setting.day_pdt_rpts.sed_qlty_ph,    sum: rpt.sum_sed_qlty_ph,     avg: format_number( rpt.sum_sed_qlty_ph/counts ) }, 
