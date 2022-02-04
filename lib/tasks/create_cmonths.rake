
namespace 'db' do
  desc "create cmonths"
  task(:create_cmonths => :environment) do
    include MathCube 
    mth_pdt_rpts = MthPdtRpt.all
    mth_pdt_rpts.each do |rpt|
      factory = rpt.factory
      year = rpt.start_date.year
      month = rpt.start_date.month

      _year_start = Date.new(year, 1, 1)
      _start = rpt.start_date 
      _end = rpt.end_date 

      result = static_sum(factory.id, _start, _end)
      year_result = static_sum(factory.id, _year_start, _end)

      mom_result = static_mom(factory.id, year, month)
      yoy_result = static_yoy(factory.id, year, month)
      up_std  = up_standard_days(factory.id, _start, _end)
      end_std = up_standard_days(factory.id, _year_start, _end)

      ccod = month_cms(result[:inf_cod][:cavg], result[:eff_cod][:cavg], result[:cemr][:cod], result[:cavg_emq][:cod], result[:cemq][:cod], year_result[:cemq][:cod], up_std[:ccod] , end_std[:ccod], yoy_result[:cemq_cod], mom_result[:cemq_cod], 0)
      ctp = month_cms(result[:inf_tp][:cavg], result[:eff_tp][:cavg], result[:cemr][:tp], result[:cavg_emq][:tp], result[:cemq][:tp], year_result[:cemq][:tp], up_std[:ctp] , end_std[:ctp], yoy_result[:cemq_tp], mom_result[:cemq_tp], 0)
      ctn = month_cms(result[:inf_tn][:cavg], result[:eff_tn][:cavg], result[:cemr][:tn], result[:cavg_emq][:tn], result[:cemq][:tn], year_result[:cemq][:tn], up_std[:ctn] , end_std[:ctn], yoy_result[:cemq_tn], mom_result[:cemq_tn], 0)
      cnhn = month_cms(result[:inf_nhn][:cavg], result[:eff_nhn][:cavg], result[:cemr][:nhn], result[:cavg_emq][:nhn], result[:cemq][:nhn], year_result[:cemq][:nhn], up_std[:cnhn] , end_std[:cnhn], yoy_result[:cemq_nhn], mom_result[:cemq_nhn], 0)

      if rpt.cmonth_cod.nil?
        cmthcod = CmonthCod.new(ccod)
        cmthcod.mth_pdt_rpt = rpt
        cmthcod.save!
      else
        rpt.cmonth_cod.update_attributes(ccod)
      end

      if rpt.cmonth_tp.nil?
        cmthtp = CmonthTp.new(ctp)
        cmthtp.mth_pdt_rpt = rpt
        cmthtp.save!
      else
        rpt.cmonth_tp.update_attributes(ctp)
      end

      if rpt.cmonth_tn.nil?
        cmthtn = CmonthTn.new(ctn)
        cmthtn.mth_pdt_rpt = rpt
        cmthtn.save!
      else
        rpt.cmonth_tn.update_attributes(ctn)
      end

      if rpt.cmonth_nhn.nil?
        cmthnhn = CmonthNhn.new(cnhn)
        cmthnhn.mth_pdt_rpt = rpt
        cmthnhn.save!
      else
        rpt.cmonth_nhn.update_attributes(cnhn)
      end
    end
  end
end

private
  def month_cms(avg_inf, avg_eff, emr, avg_emq, emq, end_emq, up_std , end_std, yoy, mom, ypdr)
    {
      :avg_inf   =>   avg_inf,
      :avg_eff   =>   avg_eff,
      :emr       =>   emr    ,
      :avg_emq   =>   avg_emq,
      :emq       =>   emq    ,
      :end_emq   =>   end_emq,
      :up_std    =>   up_std ,
      :end_std   =>   end_std,
      :yoy       =>   yoy    ,
      :mom       =>   mom    ,
      :ypdr      =>   ypdr   
    }
  end
