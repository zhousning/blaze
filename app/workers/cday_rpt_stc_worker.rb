class CdayRptStcWorker
  include Sidekiq::Worker

  def perform(day_pdt_rpt_id)
    @day_pdt_rpt = DayPdtRpt.find(day_pdt_rpt_id)
    if @day_pdt_rpt.cday_rpt_stc.nil?
      begin
        CdayRptStc.create!(:day_pdt_rpt => @day_pdt_rpt)
      rescue Exception => e
        RPT_STC_LOGGER.error "create cday_stc error --- DayPdtRpt id=" + @day_pdt_rpt.id.to_s + "---" + e.message
      end
    else
      begin
        @day_pdt_rpt.cday_rpt_stc.update({})
      rescue Exception => e
        RPT_STC_LOGGER.error "update cday_stc error --- DayPdtRpt id=" + @day_pdt_rpt.id.to_s + "---" + e.message
      end
    end
  end 
end

#Dir::mkdir(spidr_dir) unless File.directory?(spider_dir)
