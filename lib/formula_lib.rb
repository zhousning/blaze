module FormulaLib

  #进水
  def self.ratio(a, b)
    b == 0 ? 0 : format("%0.2f",a/b)
  end

  #同比%
  def self.yoy(current, last)
    last == 0 ? 0 : format("%0.2f", (current-last)/last*10*10)
  end

  #同比%
  def self.mom(current, last)
    last == 0 ? 0 : format("%0.2f", (current-last)/last*10*10)
  end

  #削减率(单位%, 指标mg/l, 进水量m3)
  def self.emr(quota_in, quota_out)
    quota_in == 0 ? 0 : format("%0.2f",(quota_in - quota_out)/quota_in*10*10)
  end

  #削减量(单位mg/l, 指标mg/l, 进水量m3)
  #单位若是吨需除1000000
  def self.emq(quota_in, quota_out, inflow)
    format("%0.2f",(quota_in - quota_out)*inflow)
  end

  #电单耗(单位kw.h/m3, 电量kw.h, 进水量m3)
  def self.bom(power, inflow)
    inflow == 0 ? 0 : format("%0.2f",power/inflow)
  end

  #削减电单耗(单位kw.h/kg, 电量kw.h, 指标mg/l, 进水量m3)
  def self.em_bom(power, quota_in, quota_out, inflow) 
    (quota_in - quota_out != 0 && inflow !=0) ? format("%0.2f",power*1000/(quota_in - quota_out)/inflow) : 0
  end

end
