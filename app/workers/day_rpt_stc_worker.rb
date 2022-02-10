class DayRptStcWorker
  include Sidekiq::Worker

  def perform(day_pdt_rpt_id)
    @root_dir = File.join(Rails.root, "log")
    @error = Logger.new( @root_dir + '/day_stc_error.log')
    @day_pdt_rpt = DayPdtRpt.find(day_pdt_rpt_id)
    if @day_pdt_rpt.day_rpt_stc.nil?
      begin
        DayRptStc.create!(:day_pdt_rpt => @day_pdt_rpt)
      rescue Exception => e
        @error.error "create day_stc error --- DayPdtRpt id=" + @day_pdt_rpt.id.to_s + "---" + e.message
      end
    else
      begin
        @day_pdt_rpt.day_rpt_stc.update({})
      rescue Exception => e
        @error.error "update day_stc error --- DayPdtRpt id=" + @day_pdt_rpt.id.to_s + "---" + e.message
      end
    end
  end 
end

#Dir::mkdir(spidr_dir) unless File.directory?(spider_dir)
