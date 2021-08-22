class DayPdtWorker
  include Sidekiq::Worker

  def perform
    @factories = Factory.all
    @factories.each do |factory|
      pdt_date = Date.today-1
      name = pdt_date.to_s + factory.name + "生产运营报表"
      @day_pdt = DayPdt.new(:pdt_date => pdt_date, :name => name, :factory => factory)
      @day_pdt.build_inf_qlty
      @day_pdt.build_eff_qlty
      @day_pdt.build_sed_qlty
      @day_pdt.build_pdt_sum

      @day_pdt.save!
    end
  end 

  private
end
