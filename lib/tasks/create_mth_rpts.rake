
namespace 'db' do
  desc "create mth rpts"
  task(:create_mth_rpts => :environment) do
    include MathCube 
    include CreateMthPdtRpt
    factories = Factory.all
    years = [2021]
    factories.each do |factory|
      years.each do |year|
        12.times.each do |t|
          month = t + 1
          status = create_mth_pdt_rpt(factory, year, month, Setting.mth_pdt_rpts.ongoing)
          title = factory.name + year.to_s + '年' + month.to_s
          if status == 'success'
            puts title + "月度报表生成成功"
          elsif status == 'fail'
            puts title + "月度报表生成失败"
          elsif status == 'zero'
            puts title + "暂无数据"
          end
        end
      end
    end
  end
end
