class SdayPdtWorker
  include Sidekiq::Worker

  def perform
    puts Time.new.to_s + '  sday pdt worker process'
    @factories = Sfactory.all
    @factories.each do |factory|
      pdt_date = Date.today-1
      sday_pdt = factory.sday_pdts.where(:pdt_date => pdt_date).first

      if sday_pdt.nil?
        name = pdt_date.to_s + factory.name + "生产运营报表"
        @sday_pdt = SdayPdt.new(:pdt_date => pdt_date, :signer => '填报人', :name => name, :sfactory => factory)
        @sday_pdt.build_sday_pdt_stc
        @sday_pdt.save!
      end
    end
  end 
end
