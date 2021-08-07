module MathCube
  def static_sum(factory_id, _start, _end)
    rpt_static = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ?", factory_id, _start, _end]).select(search_str) 
    rpt = rpt_static[0]

    result = {}
    result = result_hash(rpt) if rpt.counts > 0
    result
  end

  def result_hash(rpt)
    counts = rpt.counts
    result = {
      #:temper =>              { title: Setting.day_pdt_rpts.temper,         sum: rpt.sum_temper,          avg: format_number( rpt.sum_temper/counts ) },
      :inf_qlty_bod =>        { code: Setting.quota.bod,  title: Setting.day_pdt_rpts.inf_qlty_bod,   sum: rpt.sum_inf_qlty_bod,    avg: format_number( rpt.sum_inf_qlty_bod/counts ) },
      :eff_qlty_bod =>        { code: Setting.quota.bod,  title: Setting.day_pdt_rpts.eff_qlty_bod,   sum: rpt.sum_eff_qlty_bod,    avg: format_number( rpt.sum_eff_qlty_bod/counts ) },
      :inf_qlty_cod =>        { code: Setting.quota.cod,  title: Setting.day_pdt_rpts.inf_qlty_cod,   sum: rpt.sum_inf_qlty_cod,    avg: format_number( rpt.sum_inf_qlty_cod/counts ) },
      :eff_qlty_cod =>        { code: Setting.quota.cod,  title: Setting.day_pdt_rpts.eff_qlty_cod,   sum: rpt.sum_eff_qlty_cod,    avg: format_number( rpt.sum_eff_qlty_cod/counts ) },
      :inf_qlty_ss =>         { code: Setting.quota.ss,   title: Setting.day_pdt_rpts.inf_qlty_ss,    sum: rpt.sum_inf_qlty_ss,     avg: format_number( rpt.sum_inf_qlty_ss/counts ) },
      :eff_qlty_ss =>         { code: Setting.quota.ss,   title: Setting.day_pdt_rpts.eff_qlty_ss,    sum: rpt.sum_eff_qlty_ss,     avg: format_number( rpt.sum_eff_qlty_ss/counts ) },
      :inf_qlty_nhn =>        { code: Setting.quota.nhn,  title: Setting.day_pdt_rpts.inf_qlty_nhn,   sum: rpt.sum_inf_qlty_nhn,    avg: format_number( rpt.sum_inf_qlty_nhn/counts ) },
      :eff_qlty_nhn =>        { code: Setting.quota.nhn,  title: Setting.day_pdt_rpts.eff_qlty_nhn,   sum: rpt.sum_eff_qlty_nhn,    avg: format_number( rpt.sum_eff_qlty_nhn/counts ) },
      :inf_qlty_tn =>         { code: Setting.quota.tn,   title: Setting.day_pdt_rpts.inf_qlty_tn,    sum: rpt.sum_inf_qlty_tn,     avg: format_number( rpt.sum_inf_qlty_tn/counts ) },
      :eff_qlty_tn =>         { code: Setting.quota.tn,   title: Setting.day_pdt_rpts.eff_qlty_tn,    sum: rpt.sum_eff_qlty_tn,     avg: format_number( rpt.sum_eff_qlty_tn/counts ) },
      :inf_qlty_tp =>         { code: Setting.quota.tp,   title: Setting.day_pdt_rpts.inf_qlty_tp,    sum: rpt.sum_inf_qlty_tp,     avg: format_number( rpt.sum_inf_qlty_tp/counts ) },
      :eff_qlty_tp =>         { code: Setting.quota.tp,   title: Setting.day_pdt_rpts.eff_qlty_tp,    sum: rpt.sum_eff_qlty_tp,     avg: format_number( rpt.sum_eff_qlty_tp/counts ) },
      :inf_qlty_ph =>         { code: Setting.quota.ph,   title: Setting.day_pdt_rpts.inf_qlty_ph,    sum: rpt.sum_inf_qlty_ph,     avg: format_number( rpt.sum_inf_qlty_ph/counts ) },
      :eff_qlty_ph =>         { code: Setting.quota.ph,   title: Setting.day_pdt_rpts.eff_qlty_ph,    sum: rpt.sum_eff_qlty_ph,     avg: format_number( rpt.sum_eff_qlty_ph/counts ) },
      :eff_qlty_fecal =>      { code: Setting.quota.fecal,title: Setting.day_pdt_rpts.eff_qlty_fecal, sum: rpt.sum_eff_qlty_fecal,  avg: format_number( rpt.sum_eff_qlty_fecal/counts ) },
      #:sed_qlty_bod =>        { code: Setting.quota.bod,  title: Setting.day_pdt_rpts.sed_qlty_bod,   sum: rpt.sum_sed_qlty_bod,    avg: format_number( rpt.sum_sed_qlty_bod/counts ) },
      #:sed_qlty_cod =>        { code: Setting.quota.cod,  title: Setting.day_pdt_rpts.sed_qlty_cod,   sum: rpt.sum_sed_qlty_cod,    avg: format_number( rpt.sum_sed_qlty_cod/counts ) },
      #:sed_qlty_ss =>         { code: Setting.quota.ss,   title: Setting.day_pdt_rpts.sed_qlty_ss,    sum: rpt.sum_sed_qlty_ss,     avg: format_number( rpt.sum_sed_qlty_ss/counts ) },
      #:sed_qlty_nhn =>        { code: Setting.quota.nhn,  title: Setting.day_pdt_rpts.sed_qlty_nhn,   sum: rpt.sum_sed_qlty_nhn,    avg: format_number( rpt.sum_sed_qlty_nhn/counts ) },
      #:sed_qlty_tn =>         { code: Setting.quota.tn,   title: Setting.day_pdt_rpts.sed_qlty_tn,    sum: rpt.sum_sed_qlty_tn,     avg: format_number( rpt.sum_sed_qlty_tn/counts ) },
      #:sed_qlty_tp =>         { code: Setting.quota.tp,   title: Setting.day_pdt_rpts.sed_qlty_tp,    sum: rpt.sum_sed_qlty_tp,     avg: format_number( rpt.sum_sed_qlty_tp/counts ) },  
      #:sed_qlty_ph =>         { code: Setting.quota.ph,   title: Setting.day_pdt_rpts.sed_qlty_ph,    sum: rpt.sum_sed_qlty_ph,     avg: format_number( rpt.sum_sed_qlty_ph/counts ) }, 
      :inflow =>              { code: Setting.quota.inflow,        title: Setting.day_pdt_rpts.inflow,         sum: rpt.sum_inflow,          avg: format_number( rpt.sum_inflow/counts ) }, 
      :outflow =>             { code: Setting.quota.outflow,       title: Setting.day_pdt_rpts.outflow,        sum: rpt.sum_outflow,         avg: format_number( rpt.sum_outflow/counts ) },
      :inmud =>               { code: Setting.quota.inmud,         title: Setting.day_pdt_rpts.inmud,          sum: rpt.sum_inmud,           avg: format_number( rpt.sum_inmud/counts ) }, 
      :outmud =>              { code: Setting.quota.outmud,        title: Setting.day_pdt_rpts.outmud,         sum: rpt.sum_outmud,          avg: format_number( rpt.sum_outmud/counts ) },
      :mst =>                 { code: Setting.quota.mst,           title: Setting.day_pdt_rpts.mst,            sum: rpt.sum_mst,             avg: format_number( rpt.sum_mst/counts ) },  
      :power =>               { code: Setting.quota.power,         title: Setting.day_pdt_rpts.power,          sum: rpt.sum_power,           avg: format_number( rpt.sum_power/counts ) }, 
      :mdflow =>              { code: Setting.quota.mdflow,        title: Setting.day_pdt_rpts.mdflow,         sum: rpt.sum_mdflow,          avg: format_number( rpt.sum_mdflow/counts ) },
      :mdrcy =>               { code: Setting.quota.mdrcy,         title: Setting.day_pdt_rpts.mdrcy,          sum: rpt.sum_mdrcy,           avg: format_number( rpt.sum_mdrcy/counts ) }, 
      :mdsell =>              { code: Setting.quota.mdsell,        title: Setting.day_pdt_rpts.mdsell,         sum: rpt.sum_mdsell,          avg: format_number( rpt.sum_mdsell/counts ) }
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
