
namespace 'db' do
  desc "create cday pdt stcs"
  task(:create_cday_pdt_stcs => :environment) do
    day_pdt_rpts = DayPdtRpt.all
    day_pdt_rpts.each do |day_pdt_rpt|
      DayRptStc.create!(:day_pdt_rpt => day_pdt_rpt)
      CdayRptStc.create!(:day_pdt_rpt => day_pdt_rpt)
    end
  end
end
