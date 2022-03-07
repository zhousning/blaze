class CmpyMthRptWorker
  include Sidekiq::Worker
  include CmpyMathCube 
  include CreateCmpyMthRpt

  def perform
    puts Time.new.to_s + '  smth pdt worker process'
    ncompanies = Ncompany.all
    ccompanies = Ccompany.all
    t = Time.new.last_month
    year = t.year 
    month = t.month


    ncompanies.each do |company|
      _start = Date.new(year, month, 1)
      _end = Date.new(year, month, -1)
      @nmpy_mth_rpts_cache = company.cmpy_mth_rpts.where(["start_date = ? and end_date = ?", _start, _end])
      next unless @nmpy_mth_rpts_cache.blank?

      state = Setting.mth_pdt_rpts.ongoing
      create_cmpy_mth_rpt(company, year, month, state, Setting.cmpy_mth_rpts.ncategory)
    end

    ccompanies.each do |company|
      _start = Date.new(year, month, 1)
      _end = Date.new(year, month, -1)
      @cmpy_mth_rpts_cache = company.cmpy_mth_rpts.where(["start_date = ? and end_date = ?", _start, _end])
      next unless @cmpy_mth_rpts_cache.blank?

      state = Setting.mth_pdt_rpts.ongoing
      create_cmpy_mth_rpt(company, year, month, state, Setting.cmpy_mth_rpts.ccategory)
    end
  end 
end
