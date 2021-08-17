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

  def options_for_years
    str = ""
    years = ["2021", "2020"]
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

end  
