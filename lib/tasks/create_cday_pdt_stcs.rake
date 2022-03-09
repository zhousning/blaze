
namespace 'db' do
  desc "create cday pdt stcs"
  task(:create_cday_pdt_stcs => :environment) do
    #day_pdt_rpts = DayPdtRpt.all
    day_pdt_rpts = DayPdtRpt.where(['pdt_date between ? and ?', '2022-03-01', '2022-03-04'])
    day_pdt_rpts.each do |day_pdt_rpt|
      day_pdt_rpt.day_rpt_stc.destroy if day_pdt_rpt.day_rpt_stc
      day_pdt_rpt.cday_rpt_stc.destroy if day_pdt_rpt.cday_rpt_stc
      CdayRptStc.create!(:day_pdt_rpt => day_pdt_rpt)
      DayRptStc.create!(:day_pdt_rpt => day_pdt_rpt) 
    end
  end
end
