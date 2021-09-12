class DayPdtWorker
  include Sidekiq::Worker

  def perform
    puts 'qidong day pdt'
    @factories = Factory.all
    @factories.each do |factory|
      pdt_date = Date.today-1
      day_pdt = factory.day_pdts.where(:pdt_date => pdt_date).first
      day_pdt_rpt = factory.day_pdt_rpts.where(:pdt_date => pdt_date).first

      if day_pdt.nil? && day_pdt_rpt.nil?
        name = pdt_date.to_s + factory.name + "生产运营报表"
        @day_pdt = DayPdt.new(:pdt_date => pdt_date, :signer => '填报人', :name => name, :min_temper => 0, :max_temper => 0, :weather => '晴', :factory => factory)
        @day_pdt.build_inf_qlty
        @day_pdt.build_eff_qlty
        @day_pdt.build_sed_qlty
        @day_pdt.build_pdt_sum

        @day_pdt.save!
      end
    end
  end 
end
