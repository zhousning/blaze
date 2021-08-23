module FormulaLib

  #进水
  def self.ratio(a, b)
    format_number(a/b)
  end

  #削减率(单位%, 指标mg/l, 进水量m3)
  def self.emr(quota_in, quota_out)
    format_number((quota_in - quota_out)/quota_in)
  end

  #削减量(单位mg/l, 指标mg/l, 进水量m3)
  #单位若是吨需除1000000
  def self.emq(quota_in, quota_out, inflow)
    format_number((quota_in - quota_out)*inflow)
  end

  #电单耗(单位kw.h/m3, 电量kw.h, 进水量m3)
  def self.bom(power, inflow)
    format_number(power/inflow)
  end

  #削减电单耗(单位kw.h/kg, 电量kw.h, 指标mg/l, 进水量m3)
  def self.em_bom(power, quota_in, quota_out, inflow) 
    format_number(power*1000/(quota_in - quota_out)/inflow)
  end

  private
    def format_number(number)
      format("%0.2f", number).to_f
    end
end
