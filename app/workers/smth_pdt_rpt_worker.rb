class SmthPdtRptWorker
  include Sidekiq::Worker
  include SmathCube 
  include CreateSmthPdtRpt

  def perform
    puts Time.new.to_s + '  smth pdt worker process'
    factories = Sfactory.all
    t = Time.new.last_month
    year = t.year 
    month = t.month


    factories.each do |factory|
      _start = Date.new(year, month, 1)
      _end = Date.new(year, month, -1)
      @smth_pdt_rpts_cache = factory.smth_pdt_rpts.where(["start_date = ? and end_date = ?", _start, _end])
      next unless @mth_pdt_rpts_cache.blank?

      state = Setting.mth_pdt_rpts.ongoing
      create_smth_pdt_rpt(factory, year, month, state)
    end
  end 
end
