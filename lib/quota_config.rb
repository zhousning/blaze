module QuotaConfig 
  
    def QuotaConfig.quota_hash 
      quota_hash = Hash.new
      quotas = Quota.all
      quotas.each do |q|
        quota_hash[q.code.strip] = {:name => q.name, :max => q.max }
      end
      quota_hash
    end

    MYQUOTAS = QuotaConfig.quota_hash

    def emp_quota(quota)
      obj = {
        Setting.quota.cod => 'cod', 
        Setting.quota.nhn => 'nhn',
        Setting.quota.tp  => 'tp'
      }
      obj[quota]
    end


    def my_real_codes(type)
      quotas = nil
      type = type.strip
      if type == Setting.quota.ctg_cms 
        quotas = Quota.where(:ctg => [Setting.quota.ctg_cms])
      elsif type == Setting.quota.ctg_mud 
        quotas = Quota.where(:ctg => [Setting.quota.ctg_mud, Setting.quota.ctg_flow])
      elsif type == Setting.quota.ctg_power
        quotas = Quota.where(:ctg => Setting.quota.ctg_power)
      elsif type == Setting.quota.ctg_md
        quotas = Quota.where(:ctg => Setting.quota.ctg_md)
      end
      quota_arr = []
      quotas.each do |q|
        quota_arr << q.code.strip
      end
      quota_arr
    end

    def inf_quota(ctg_hash, code, rpt)
      code = code.strip
      if code == Setting.quota.cod 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inf_qlty_ph
      end
    end

    def eff_quota(ctg_hash, code, rpt)
      code = code.strip
      if code == Setting.quota.cod 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_ph
      elsif code == Setting.quota.fecal
        ctg_hash[MYQUOTAS[code][:name]] = rpt.eff_qlty_fecal
      end
    end

    def other_quota(ctg_hash, code, rpt)
      code = code.strip
      if code == Setting.quota.inflow 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inflow
      elsif code == Setting.quota.outflow
        ctg_hash[MYQUOTAS[code][:name]] = rpt.outflow
      elsif code == Setting.quota.inmud  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.inmud
      elsif code == Setting.quota.outmud 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.outmud
      elsif code == Setting.quota.mst    
        ctg_hash[MYQUOTAS[code][:name]] = rpt.mst
      elsif code == Setting.quota.power  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.power
      elsif code == Setting.quota.mdflow 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.mdflow
      elsif code == Setting.quota.mdrcy  
        ctg_hash[MYQUOTAS[code][:name]] = rpt.mdrcy
      elsif code == Setting.quota.mdsell 
        ctg_hash[MYQUOTAS[code][:name]] = rpt.mdsell
      end
    end

    def quotas 
      @quota_flows = Quota.where(:ctg => Setting.quota.ctg_flow)
      @quota_cms = Quota.where(:ctg => Setting.quota.ctg_cms) 
      @quota_muds = Quota.where(:ctg => Setting.quota.ctg_mud) 
      @quota_powers = Quota.where(:ctg => Setting.quota.ctg_power)
      @quota_mds = Quota.where(:ctg => Setting.quota.ctg_md)
    end

    def get_title(pos)
      title = ''
      pos = pos.strip
      if pos == Setting.quota.pos_inf
        title = '进水水质'
      elsif pos == Setting.quota.pos_eff
        title = '出水水质'
      elsif pos == Setting.quota.pos_sed
        title = '二沉池出水水质'
      elsif pos == Setting.quota.pos_other
      end
      title
    end

end
