module DayPdtRptsHelper

  def options_for_my_factory(factories)
    str = ""
    factories.each do |f|
      str += "<option value='" + idencode(f.id).to_s + "'>" + f.name + "</option>"
    end

    raw(str)
  end

  def options_for_quotas
    str = ""
    quotas = Quota.all
    quotas.each do |f|
      str += "<option value='" + f.code.to_s + "'>" + f.name + "</option>"
    end

    raw(str)
  end

  def options_for_chemicals
    hash = Hash.new
    ctgs = ChemicalCtg.all
    ctgs.each do |f|
      hash[f.name] = f.code
    end
    hash
  end

  def chemicals_hash
    hash = Hash.new
    ctgs = ChemicalCtg.all
    ctgs.each do |f|
      hash[f.code] = f.name
    end
    hash
  end

  def options_for_emp_quotas
    str = "<option value='" + Setting.quota.cod + "'>" + Setting.inf_qlties.cod + "</option>" + "<option value='" + Setting.quota.nhn + "'>" + Setting.inf_qlties.nhn + "</option>" + "<option value='" + Setting.quota.tp + "'>" + Setting.inf_qlties.tp + "</option>"
    raw(str)
  end

  def options_for_years
    str = ""
    years = ["2021"]
    years.each do |year|
      str += "<option value='" + year + "'>" + year + "</option>"
    end

    raw(str)
  end

  def options_for_mth_months
    str = ""
    months.each_pair do |k, v|
      str += "<option value='" + k + "'>" + v + "</option>"
    end
    raw(str)
  end

  def cms_sub_pref(title)
    title = title.gsub(/在线-|化验-/, '')
    title
  end

end  
