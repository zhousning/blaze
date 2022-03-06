
namespace 'db' do
  desc "create smth rpts"
  task(:create_smth_rpts => :environment) do
    include SmathCube 
    include CreateSmthPdtRpt
    factories = Sfactory.all
    #factories = []
    #f=Factory.where(:name => '邹城第一污水处理厂').first
    #factories << f
    @log_dir = "lib/tasks/data/cwaters/logs/" 
    @mthcreatelog = Logger.new(@log_dir + '创建供水月数据错误.log')

    years = [2021, 2022]
    factories.each do |factory|
      years.each do |year|
        12.times.each do |t|
          month = t + 1
          status = create_smth_pdt_rpt(factory, year, month, Setting.mth_pdt_rpts.complete)
          title = factory.name + year.to_s + '年' + month.to_s
          if status == 'success'
            puts title + "月度报表生成成功"
          elsif status == 'fail'
            @mthcreatelog.error title + "月度报表生成失败"
          elsif status == 'zero'
            @mthcreatelog.error title + "暂无数据"
          end
        end
      end
    end
  end
end
