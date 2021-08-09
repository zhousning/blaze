module QuotaConfig 
  
    def quota_hash 
      quota_hash = Hash.new
      quotas = Quota.all
      quotas.each do |q|
        quota_hash[q.code] = {:name => q.name, :max => q.max }
      end
      quota_hash
    end

    def my_real_codes(type)
      quotas = nil
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
        quota_arr << q.code
      end
      quota_arr
    end

    def inf_quota(ctg_hash, code, rpt)
      if code == Setting.quota.cod 
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[quota_hash[code][:name]] = rpt.inf_qlty_ph
      end
    end

    def eff_quota(ctg_hash, code, rpt)
      if code == Setting.quota.cod 
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_cod
      elsif code == Setting.quota.bod 
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_bod
      elsif code == Setting.quota.ss  
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_ss
      elsif code == Setting.quota.nhn 
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_nhn
      elsif code == Setting.quota.tn  
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_tn
      elsif code == Setting.quota.tp  
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_tp
      elsif code == Setting.quota.ph  
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_ph
      elsif code == Setting.quota.fecal
        ctg_hash[quota_hash[code][:name]] = rpt.eff_qlty_fecal
      end
    end

    def other_quota(ctg_hash, code, rpt)
      if code == Setting.quota.inflow 
        ctg_hash[quota_hash[code][:name]] = rpt.inflow
      elsif code == Setting.quota.outflow
        ctg_hash[quota_hash[code][:name]] = rpt.outflow
      elsif code == Setting.quota.inmud  
        ctg_hash[quota_hash[code][:name]] = rpt.inmud
      elsif code == Setting.quota.outmud 
        ctg_hash[quota_hash[code][:name]] = rpt.outmud
      elsif code == Setting.quota.mst    
        ctg_hash[quota_hash[code][:name]] = rpt.mst
      elsif code == Setting.quota.power  
        ctg_hash[quota_hash[code][:name]] = rpt.power
      elsif code == Setting.quota.mdflow 
        ctg_hash[quota_hash[code][:name]] = rpt.mdflow
      elsif code == Setting.quota.mdrcy  
        ctg_hash[quota_hash[code][:name]] = rpt.mdrcy
      elsif code == Setting.quota.mdsell 
        ctg_hash[quota_hash[code][:name]] = rpt.mdsell
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
