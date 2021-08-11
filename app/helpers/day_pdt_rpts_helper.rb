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

  def months
    {
      Setting.months.one    => Setting.months.one_t, 
      Setting.months.two    => Setting.months.two_t, 
      Setting.months.three  => Setting.months.three_t,
      Setting.months.four   => Setting.months.four_t, 
      Setting.months.five   => Setting.months.five_t,
      Setting.months.six    => Setting.months.six_t,
      Setting.months.seven  => Setting.months.seven_t,
      Setting.months.eight  => Setting.months.eight_t,
      Setting.months.nine   => Setting.months.nine_t, 
      Setting.months.ten    => Setting.months.ten_t,
      Setting.months.eleven => Setting.months.eleven_t,
      Setting.months.twelve => Setting.months.twelve_t
    }

  end
end  
