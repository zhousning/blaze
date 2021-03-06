
namespace 'db' do
  desc "create cmpy_mth rpts"
  task(:create_cmpy_mth_rpts => :environment) do
    include CmpyMathCube 
    include CreateCmpyMthRpt
    ncompanies = Ncompany.all
    ccompanies = Ccompany.all
    @log_dir = "lib/tasks/data/cwaters/logs/" 
    @mthcreatelog = Logger.new(@log_dir + '创建公司供水月数据错误.log')

    years = [2021, 2022]
    ncompanies.each do |company|
      years.each do |year|
        12.times.each do |t|
          month = t + 1
          status = create_cmpy_mth_rpt(company, year, month, Setting.mth_pdt_rpts.complete, Setting.cmpy_mth_rpts.ncategory)
          title = company.name + year.to_s + '年' + month.to_s
          if status == 'success'
            puts title + "农供月报表生成成功"
          elsif status == 'fail'
            @mthcreatelog.error title + "农供月报表生成失败"
          elsif status == 'zero'
            @mthcreatelog.error title + "暂无数据"
          end
        end
      end
    end
    ccompanies.each do |company|
      years.each do |year|
        12.times.each do |t|
          month = t + 1
          status = create_cmpy_mth_rpt(company, year, month, Setting.mth_pdt_rpts.complete, Setting.cmpy_mth_rpts.ccategory)
          title = company.name + year.to_s + '年' + month.to_s
          if status == 'success'
            puts title + "城镇月报表生成成功"
          elsif status == 'fail'
            @mthcreatelog.error title + "城镇月报表生成失败"
          elsif status == 'zero'
            @mthcreatelog.error title + "暂无数据"
          end
        end
      end
    end
  end
end
