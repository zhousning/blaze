module MathCube
  include MyCommon 
  include FormulaLib
  
  MYQUOTAS = MyCommon.quota_hash

  def up_standard_days(factory_id, _start, _end)
    quotas = MyCommon.quota_hash
    bod_max = quotas[Setting.quota.bod][:max]
    cod_max = quotas[Setting.quota.cod][:max]
    tn_max = quotas[Setting.quota.tn][:max]
    tp_max = quotas[Setting.quota.tp][:max]
    nhn_max = quotas[Setting.quota.nhn][:max]
    ss_max = quotas[Setting.quota.ss][:max]
    fecal_max = quotas[Setting.quota.fecal][:max]
    mst_max = quotas[Setting.quota.mst][:max]

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

    inflow  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:inflow][:sum],   last_year_result[:inflow][:sum])
    power   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum],     last_year_result[:power][:sum])     
    bom     = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:bom],     last_year_result[:power][:bom])     
    emq_tn  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:tn],        last_year_result[:emq][:tn])        
    emq_tp  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:tp],        last_year_result[:emq][:tp])        
    emq_bod = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:bod],       last_year_result[:emq][:bod])       
    emq_cod = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:cod],       last_year_result[:emq][:cod])       
    emq_nhn = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:nhn],       last_year_result[:emq][:nhn])       
    emq_ss  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:ss],        last_year_result[:emq][:ss])        
    mud     = last_year_result.blank? ? 0 : FormulaLib.mom(result[:outmud][:sum],    last_year_result[:outmud][:sum])    
    mdrcy   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:mdrcy][:sum],     last_year_result[:mdrcy][:sum])     
    mdsell  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:mdsell][:sum],    last_year_result[:mdsell][:sum])    
    fecal   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:eff_fecal][:sum], last_year_result[:eff_fecal][:sum]) 

    {
      :inflow   =>  inflow,
      :power    =>  power,
      :bom      =>  bom,
      :emq_tn   =>  emq_tn ,
      :emq_tp   =>  emq_tp,
      :emq_bod  =>  emq_bod,
      :emq_cod  =>  emq_cod,
      :emq_nhn  =>  emq_nhn,
      :emq_ss   =>  emq_ss  , 
      :mud      =>  mud,
      :mdsell   =>  mdsell,
      :mdrcy    =>  mdrcy,
      :fecal    =>  fecal
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

    inflow  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:inflow][:sum],    last_year_result[:inflow][:sum])   
    power   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:sum],     last_year_result[:power][:sum])     
    bom     = last_year_result.blank? ? 0 : FormulaLib.mom(result[:power][:bom],     last_year_result[:power][:bom])     
    emq_tn  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:tn],        last_year_result[:emq][:tn])        
    emq_tp  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:tp],        last_year_result[:emq][:tp])        
    emq_bod = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:bod],       last_year_result[:emq][:bod])       
    emq_cod = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:cod],       last_year_result[:emq][:cod])       
    emq_nhn = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:nhn],       last_year_result[:emq][:nhn])       
    emq_ss  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:emq][:ss],        last_year_result[:emq][:ss])        
    mud     = last_year_result.blank? ? 0 : FormulaLib.mom(result[:outmud][:sum],    last_year_result[:outmud][:sum])    
    mdrcy   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:mdrcy][:sum],     last_year_result[:mdrcy][:sum])     
    mdsell  = last_year_result.blank? ? 0 : FormulaLib.mom(result[:mdsell][:sum],    last_year_result[:mdsell][:sum])    
    fecal   = last_year_result.blank? ? 0 : FormulaLib.mom(result[:eff_fecal][:sum], last_year_result[:eff_fecal][:sum]) 

    {
      :inflow  =>  inflow,
      :power    =>  power,
      :bom      =>  bom,
      :emq_tn   =>  emq_tn, 
      :emq_tp   =>  emq_tp,
      :emq_bod  =>  emq_bod,
      :emq_cod  =>  emq_cod,
      :emq_nhn  =>  emq_nhn,
      :emq_ss   =>  emq_ss  , 
      :mud      =>  mud,
      :mdsell   =>  mdsell,
      :mdrcy    =>  mdrcy,
      :fecal    =>  fecal
    }
  end


  def static_sum(factory_id, _start, _end)
    day_pdt_rpts = DayPdtRpt.where(["factory_id = ? and pdt_date between ? and ?", factory_id, _start, _end])
    day_rpt_stcs = DayRptStc.where(:day_pdt_rpt => day_pdt_rpts.pluck(:id))

    rpt_static = day_pdt_rpts.select(search_str) 
    stc_static = day_rpt_stcs.select(rpt_stc_search_str) 

    rpt = rpt_static[0]
    stc = stc_static[0]

    result = {}
    if rpt.counts > 0
      result = result_hash(rpt, stc) 
    else
      result = result_zero
    end
    result
  end

  def result_hash(rpt, stc)
    #单耗
    bom = FormulaLib.bom(rpt.sum_power, rpt.sum_inflow) 

    #本月削减量
    emq_bod = stc.sum_bod_emq
    emq_cod = stc.sum_cod_emq
    emq_tp  = stc.sum_tp_emq 
    emq_tn  = stc.sum_tn_emq 
    emq_ss  = stc.sum_ss_emq 
    emq_nhn = stc.sum_nhn_emq

    #平均削减率
    emr_bod = FormulaLib.avg_emr(emq_bod, stc.sum_bod_inflow)
    emr_cod = FormulaLib.avg_emr(emq_cod, stc.sum_cod_inflow)
    emr_tp  = FormulaLib.avg_emr(emq_tp , stc.sum_tp_inflow)
    emr_tn  = FormulaLib.avg_emr(emq_tn , stc.sum_tn_inflow)
    emr_ss  = FormulaLib.avg_emr(emq_ss , stc.sum_ss_inflow)
    emr_nhn = FormulaLib.avg_emr(emq_nhn, stc.sum_nhn_inflow)

    #平均削减量
    avg_emq_bod = FormulaLib.avg_emq(emq_bod, rpt.sum_inflow) 
    avg_emq_cod = FormulaLib.avg_emq(emq_cod, rpt.sum_inflow) 
    avg_emq_tp  = FormulaLib.avg_emq(emq_tp,  rpt.sum_inflow) 
    avg_emq_tn  = FormulaLib.avg_emq(emq_tn,  rpt.sum_inflow)
    avg_emq_ss  = FormulaLib.avg_emq(emq_ss,  rpt.sum_inflow) 
    avg_emq_nhn = FormulaLib.avg_emq(emq_nhn, rpt.sum_inflow) 

    result = {
      :state => 'nozero',
      :inf_cod   => { code: Setting.quota.cod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_cod),   sum: rpt.sum_inf_cod,   avg: rpt.avg_inf_cod   },
      :eff_cod   => { code: Setting.quota.cod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_cod),   sum: rpt.sum_eff_cod,   avg: rpt.avg_eff_cod   },
      :inf_bod   => { code: Setting.quota.bod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_bod),   sum: rpt.sum_inf_bod,   avg: rpt.avg_inf_bod   },
      :eff_bod   => { code: Setting.quota.bod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_bod),   sum: rpt.sum_eff_bod,   avg: rpt.avg_eff_bod   },
      :inf_nhn   => { code: Setting.quota.nhn,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_nhn),   sum: rpt.sum_inf_nhn,   avg: rpt.avg_inf_nhn   },
      :eff_nhn   => { code: Setting.quota.nhn,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_nhn),   sum: rpt.sum_eff_nhn,   avg: rpt.avg_eff_nhn   },
      :inf_tn    => { code: Setting.quota.tn,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_tn),    sum: rpt.sum_inf_tn,    avg: rpt.avg_inf_tn    },
      :eff_tn    => { code: Setting.quota.tn,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_tn),    sum: rpt.sum_eff_tn,    avg: rpt.avg_eff_tn    },
      :inf_tp    => { code: Setting.quota.tp,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_tp),    sum: rpt.sum_inf_tp,    avg: rpt.avg_inf_tp    },
      :eff_tp    => { code: Setting.quota.tp,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_tp),    sum: rpt.sum_eff_tp,    avg: rpt.avg_eff_tp    },
      :inf_ss    => { code: Setting.quota.ss,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_ss),    sum: rpt.sum_inf_ss,    avg: rpt.avg_inf_ss    },
      :eff_ss    => { code: Setting.quota.ss,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_ss),    sum: rpt.sum_eff_ss,    avg: rpt.avg_eff_ss    },
      :inf_ph    => { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.inf_qlty_ph,                           sum: rpt.sum_inf_ph,    avg: rpt.avg_inf_ph    },
      :eff_ph    => { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.eff_qlty_ph,                           sum: rpt.sum_eff_ph,    avg: rpt.avg_eff_ph    },
      :eff_fecal => { code: Setting.quota.fecal,   title: Setting.day_pdt_rpts.eff_qlty_fecal,                        sum: rpt.sum_eff_fecal, avg: rpt.avg_eff_fecal },
      :inflow    => { code: Setting.quota.inflow,  title: Setting.day_pdt_rpts.inflow,                           sum: rpt.sum_inflow,    avg: rpt.avg_inflow    }, 
      :outflow   => { code: Setting.quota.outflow, title: Setting.day_pdt_rpts.outflow,                          sum: rpt.sum_outflow,   avg: rpt.avg_outflow   },
      :inmud     => { code: Setting.quota.inmud,   title: Setting.day_pdt_rpts.inmud,                            sum: rpt.sum_inmud,     avg: rpt.avg_inmud     }, 
      :outmud    => { code: Setting.quota.outmud,  title: Setting.day_pdt_rpts.outmud,                           sum: rpt.sum_outmud,    avg: rpt.avg_outmud    },
      :mst       => { code: Setting.quota.mst,     title: Setting.day_pdt_rpts.mst,                              sum: rpt.sum_mst,       avg: rpt.avg_mst       },  
      :power     => { code: Setting.quota.power,   title: Setting.day_pdt_rpts.power,                            sum: rpt.sum_power,     avg: rpt.avg_power, bom: bom }, 
      :mdflow    => { code: Setting.quota.mdflow,  title: Setting.day_pdt_rpts.mdflow,                           sum: rpt.sum_mdflow,    avg: rpt.avg_mdflow    },
      :mdrcy     => { code: Setting.quota.mdrcy,   title: Setting.day_pdt_rpts.mdrcy,                            sum: rpt.sum_mdrcy,     avg: rpt.avg_mdrcy     }, 
      :mdsell    => { code: Setting.quota.mdsell,  title: Setting.day_pdt_rpts.mdsell,                           sum: rpt.sum_mdsell,    avg: rpt.avg_mdsell    },
      :emr       => { :bod => emr_bod,     :cod => emr_cod,     :tp => emr_tp,     :tn => emr_tn,     :ss => emr_ss,     :nhn => emr_nhn},
      :emq       => { :bod => emq_bod,     :cod => emq_cod,     :tp => emq_tp,     :tn => emq_tn,     :ss => emq_ss,     :nhn => emq_nhn},
      :avg_emq   => { :bod => avg_emq_bod, :cod => avg_emq_cod, :tp => avg_emq_tp, :tn => avg_emq_tn, :ss => avg_emq_ss, :nhn => avg_emq_nhn}
    }
    result
  end

  def result_zero
    {
      :state => 'zero',
      :inf_cod   => { code: Setting.quota.cod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_cod),   sum: 0,   avg: 0  },
      :eff_cod   => { code: Setting.quota.cod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_cod),   sum: 0,   avg: 0  },
      :inf_bod   => { code: Setting.quota.bod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_bod),   sum: 0,   avg: 0  },
      :eff_bod   => { code: Setting.quota.bod,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_bod),   sum: 0,   avg: 0  },
      :inf_nhn   => { code: Setting.quota.nhn,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_nhn),   sum: 0,   avg: 0  },
      :eff_nhn   => { code: Setting.quota.nhn,     title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_nhn),   sum: 0,   avg: 0  },
      :inf_tn    => { code: Setting.quota.tn,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_tn),    sum: 0,   avg: 0  },
      :eff_tn    => { code: Setting.quota.tn,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_tn),    sum: 0,   avg: 0  },
      :inf_tp    => { code: Setting.quota.tp,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_tp),    sum: 0,   avg: 0  },
      :eff_tp    => { code: Setting.quota.tp,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_tp),    sum: 0,   avg: 0  },
      :inf_ss    => { code: Setting.quota.ss,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.inf_qlty_ss),    sum: 0,   avg: 0  },
      :eff_ss    => { code: Setting.quota.ss,      title: MyCommon.cms_sub_pref(Setting.day_pdt_rpts.eff_qlty_ss),    sum: 0,   avg: 0  },
      :inf_ph    => { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.inf_qlty_ph,                           sum: 0,   avg: 0  },
      :eff_ph    => { code: Setting.quota.ph,      title: Setting.day_pdt_rpts.eff_qlty_ph,                           sum: 0,   avg: 0  },
      :eff_fecal => { code: Setting.quota.fecal,   title: Setting.day_pdt_rpts.eff_qlty_fecal,                        sum: 0,   avg: 0  },
      :inflow    => { code: Setting.quota.inflow,  title: Setting.day_pdt_rpts.inflow,                           sum: 0,   avg: 0  }, 
      :outflow   => { code: Setting.quota.outflow, title: Setting.day_pdt_rpts.outflow,                          sum: 0,   avg: 0  },
      :inmud     => { code: Setting.quota.inmud,   title: Setting.day_pdt_rpts.inmud,                            sum: 0,   avg: 0  }, 
      :outmud    => { code: Setting.quota.outmud,  title: Setting.day_pdt_rpts.outmud,                           sum: 0,   avg: 0  },
      :mst       => { code: Setting.quota.mst,     title: Setting.day_pdt_rpts.mst,                              sum: 0,   avg: 0  },  
      :power     => { code: Setting.quota.power,   title: Setting.day_pdt_rpts.power,                            sum: 0,   avg: 0, bom: 0 }, 
      :mdflow    => { code: Setting.quota.mdflow,  title: Setting.day_pdt_rpts.mdflow,                           sum: 0,   avg: 0  },
      :mdrcy     => { code: Setting.quota.mdrcy,   title: Setting.day_pdt_rpts.mdrcy,                            sum: 0,   avg: 0  }, 
      :mdsell    => { code: Setting.quota.mdsell,  title: Setting.day_pdt_rpts.mdsell,                           sum: 0,   avg: 0  },
      :emr       => { :bod => 0, :cod => 0, :tp => 0, :tn => 0, :ss => 0, :nhn => 0},
      :emq       => { :bod => 0, :cod => 0, :tp => 0, :tn => 0, :ss => 0, :nhn => 0},
      :avg_emq   => { :bod => 0, :cod => 0, :tp => 0, :tn => 0, :ss => 0, :nhn => 0}
    }
  end

  def rpt_stc_search_str
    "
      ifnull(ROUND(sum(bod_emq)   , 2), 0) sum_bod_emq,
      ifnull(ROUND(sum(cod_emq)   , 2), 0) sum_cod_emq,
      ifnull(ROUND(sum(ss_emq)    , 2), 0) sum_ss_emq,
      ifnull(ROUND(sum(nhn_emq)   , 2), 0) sum_nhn_emq,
      ifnull(ROUND(sum(tn_emq)    , 2), 0) sum_tn_emq,
      ifnull(ROUND(sum(tp_emq)    , 2), 0) sum_tp_emq,
      ifnull(ROUND(sum(cod_inflow), 2), 0) sum_cod_inflow,
      ifnull(ROUND(sum(ss_inflow) , 2), 0) sum_ss_inflow,
      ifnull(ROUND(sum(nhn_inflow), 2), 0) sum_nhn_inflow,
      ifnull(ROUND(sum(tn_inflow) , 2), 0) sum_tn_inflow,
      ifnull(ROUND(sum(tp_inflow) , 2), 0) sum_tp_inflow,
      ifnull(ROUND(sum(bod_inflow), 2), 0) sum_bod_inflow
    "
  end
      
  def search_str
    "
      ifnull(count(id), 0) counts,
      ifnull(ROUND(sum(min_temper), 2), 0) sum_min_temper,
      ifnull(ROUND(sum(max_temper), 2), 0) sum_max_temper,
      ifnull(ROUND(sum(inf_qlty_bod)   , 2), 0) sum_inf_bod,
      ifnull(ROUND(sum(inf_qlty_cod)   , 2), 0) sum_inf_cod,
      ifnull(ROUND(sum(inf_qlty_ss)    , 2), 0) sum_inf_ss,
      ifnull(ROUND(sum(inf_qlty_nhn)   , 2), 0) sum_inf_nhn,
      ifnull(ROUND(sum(inf_qlty_tn)    , 2), 0) sum_inf_tn,
      ifnull(ROUND(sum(inf_qlty_tp)    , 2), 0) sum_inf_tp,
      ifnull(ROUND(sum(inf_qlty_ph)    , 2), 0) sum_inf_ph,
      ifnull(ROUND(sum(eff_qlty_cod)   , 2), 0) sum_eff_cod,
      ifnull(ROUND(sum(eff_qlty_ss)    , 2), 0) sum_eff_ss,
      ifnull(ROUND(sum(eff_qlty_nhn)   , 2), 0) sum_eff_nhn,
      ifnull(ROUND(sum(eff_qlty_tn)    , 2), 0) sum_eff_tn,
      ifnull(ROUND(sum(eff_qlty_tp)    , 2), 0) sum_eff_tp,
      ifnull(ROUND(sum(eff_qlty_ph)    , 2), 0) sum_eff_ph,
      ifnull(ROUND(sum(eff_qlty_fecal) , 2), 0) sum_eff_fecal,
      ifnull(ROUND(sum(eff_qlty_bod)   , 2), 0) sum_eff_bod,
      ifnull(ROUND(sum(inflow)    , 2), 0) sum_inflow,    
      ifnull(ROUND(sum(outflow)   , 2), 0) sum_outflow,
      ifnull(ROUND(sum(inmud)     , 2), 0) sum_inmud,  
      ifnull(ROUND(sum(outmud)    , 2), 0) sum_outmud, 
      ifnull(ROUND(sum(mst)       , 2), 0) sum_mst,  
      ifnull(ROUND(sum(power)     , 2), 0) sum_power,  
      ifnull(ROUND(sum(mdflow)    , 2), 0) sum_mdflow, 
      ifnull(ROUND(sum(mdrcy)     , 2), 0) sum_mdrcy,  
      ifnull(ROUND(sum(mdsell)    , 2), 0) sum_mdsell,

      ifnull(ROUND(avg(nullif(min_temper, 0))     , 2), 0) avg_min_temper,
      ifnull(ROUND(avg(nullif(max_temper, 0))     , 2), 0) avg_max_temper,
      ifnull(ROUND(avg(nullif(inf_qlty_bod, 0))   , 2), 0) avg_inf_bod,
      ifnull(ROUND(avg(nullif(inf_qlty_cod, 0))   , 2), 0) avg_inf_cod,
      ifnull(ROUND(avg(nullif(inf_qlty_ss, 0))    , 2), 0) avg_inf_ss,
      ifnull(ROUND(avg(nullif(inf_qlty_nhn, 0))   , 2), 0) avg_inf_nhn,
      ifnull(ROUND(avg(nullif(inf_qlty_tn, 0))    , 2), 0) avg_inf_tn,
      ifnull(ROUND(avg(nullif(inf_qlty_tp, 0))    , 2), 0) avg_inf_tp,
      ifnull(ROUND(avg(nullif(inf_qlty_ph, 0))    , 2), 0) avg_inf_ph,
      ifnull(ROUND(avg(nullif(eff_qlty_cod, 0))   , 2), 0) avg_eff_cod,
      ifnull(ROUND(avg(nullif(eff_qlty_ss, 0))    , 2), 0) avg_eff_ss,
      ifnull(ROUND(avg(nullif(eff_qlty_nhn, 0))   , 2), 0) avg_eff_nhn,
      ifnull(ROUND(avg(nullif(eff_qlty_tn, 0))    , 2), 0) avg_eff_tn,
      ifnull(ROUND(avg(nullif(eff_qlty_tp, 0))    , 2), 0) avg_eff_tp,
      ifnull(ROUND(avg(nullif(eff_qlty_ph, 0))    , 2), 0) avg_eff_ph,
      ifnull(ROUND(avg(nullif(eff_qlty_fecal, 0)) , 2), 0) avg_eff_fecal,
      ifnull(ROUND(avg(nullif(eff_qlty_bod, 0))   , 2), 0) avg_eff_bod,
      ifnull(ROUND(avg(nullif(inflow, 0))         , 2), 0) avg_inflow,    
      ifnull(ROUND(avg(nullif(outflow, 0))        , 2), 0) avg_outflow,
      ifnull(ROUND(avg(nullif(inmud, 0))          , 2), 0) avg_inmud,  
      ifnull(ROUND(avg(nullif(outmud, 0))         , 2), 0) avg_outmud, 
      ifnull(ROUND(avg(nullif(mst, 0))            , 2), 0) avg_mst,  
      ifnull(ROUND(avg(nullif(power, 0))          , 2), 0) avg_power,  
      ifnull(ROUND(avg(nullif(mdflow, 0))         , 2), 0) avg_mdflow, 
      ifnull(ROUND(avg(nullif(mdrcy, 0))          , 2), 0) avg_mdrcy,  
      ifnull(ROUND(avg(nullif(mdsell, 0))         , 2), 0) avg_mdsell
    "
  end  
end    

#sum(sed_bod)     sum_sed_bod,
#sum(sed_cod)     sum_sed_cod,
#sum(sed_ss)      sum_sed_ss,
#sum(sed_nhn)     sum_sed_nhn,
#sum(sed_tn)      sum_sed_tn,
#sum(sed_tp)      sum_sed_tp,  
#sum(sed_ph)      sum_sed_ph, 
#:temper =>              { title: Setting.day_pdt_rpts.temper,         sum: rpt.sum_temper,          avg: format_number( rpt.sum_temper/counts ) },
#:sed_qlty_bod =>        { code: Setting.quota.bod,  title: Setting.day_pdt_rpts.sed_qlty_bod,   sum: rpt.sum_sed_qlty_bod,    avg: format_number( rpt.sum_sed_qlty_bod/counts ) },
#:sed_qlty_cod =>        { code: Setting.quota.cod,  title: Setting.day_pdt_rpts.sed_qlty_cod,   sum: rpt.sum_sed_qlty_cod,    avg: format_number( rpt.sum_sed_qlty_cod/counts ) },
#:sed_qlty_ss =>         { code: Setting.quota.ss,   title: Setting.day_pdt_rpts.sed_qlty_ss,    sum: rpt.sum_sed_qlty_ss,     avg: format_number( rpt.sum_sed_qlty_ss/counts ) },
#:sed_qlty_nhn =>        { code: Setting.quota.nhn,  title: Setting.day_pdt_rpts.sed_qlty_nhn,   sum: rpt.sum_sed_qlty_nhn,    avg: format_number( rpt.sum_sed_qlty_nhn/counts ) },
#:sed_qlty_tn =>         { code: Setting.quota.tn,   title: Setting.day_pdt_rpts.sed_qlty_tn,    sum: rpt.sum_sed_qlty_tn,     avg: format_number( rpt.sum_sed_qlty_tn/counts ) },
#:sed_qlty_tp =>         { code: Setting.quota.tp,   title: Setting.day_pdt_rpts.sed_qlty_tp,    sum: rpt.sum_sed_qlty_tp,     avg: format_number( rpt.sum_sed_qlty_tp/counts ) },  
#:sed_qlty_ph =>         { code: Setting.quota.ph,   title: Setting.day_pdt_rpts.sed_qlty_ph,    sum: rpt.sum_sed_qlty_ph,     avg: format_number( rpt.sum_sed_qlty_ph/counts ) }, 
