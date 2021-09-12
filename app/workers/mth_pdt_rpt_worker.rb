class MthPdtRptWorker
  include Sidekiq::Worker
  include MathCube 
  include CreateMthPdtRpt

  def perform
    factories = Factory.all
    t = Time.new.last_month
    year = t.year 
    month = t.month


    factories.each do |factory|
      _start = Date.new(year, month, 1)
      _end = Date.new(year, month, -1)
      @mth_pdt_rpts_cache = factory.mth_pdt_rpts.where(["start_date = ? and end_date = ?", _start, _end])
      next unless @mth_pdt_rpts_cache.blank?

      state = Setting.mth_pdt_rpts.ongoing
      create_mth_pdt_rpt(factory, year, month, state)
    end
  end 
end
