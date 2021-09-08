class MthPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:download_append]

  include MathCube 

  def index
    @mth_pdt_rpt = MthPdtRpt.new
    @factory = my_factory
   
    @months = months
    @mth_pdt_rpts = @factory.mth_pdt_rpts.where(:state => [Setting.mth_pdt_rpts.ongoing, Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]).order('start_date DESC').page( params[:page]).per( Setting.systems.per_page )  if @factory
   
  end

  def show
    @factory = my_factory
   
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
  end

  def verify_index
    @factory = my_factory

    @mth_pdt_rpts = @factory.mth_pdt_rpts.where(:state => [Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]).order("start_date DESC").page( params[:page]).per( Setting.systems.per_page ) if @factory
  end

  def verify_show
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
  end

  def verifying
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.verifying
    redirect_to factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end
  
  def rejected
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.rejected
    redirect_to verify_show_factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def cmp_verify_index
    @factory = my_factory

    @mth_pdt_rpts = @factory.mth_pdt_rpts.where(:state => [Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]).order("start_date DESC").page( params[:page]).per( Setting.systems.per_page ) if @factory
  end
  
  def cmp_verify_show
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
  end

  def cmp_verifying
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.cmp_verifying
    redirect_to verify_show_factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end
  
  def cmp_rejected
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.cmp_rejected
    redirect_to cmp_verify_show_factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def upreport
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))

    @mth_pdt_rpt.complete
    redirect_to cmp_verify_show_factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def mth_report_finish_index
    @factory = my_factory
    @mth_pdt_rpts = @factory.mth_pdt_rpts.where(:state => Setting.mth_pdt_rpts.complete).order('start_date DESC')
  end

  def mth_report_finish_show
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
  end
   

  def mth_rpt_create
    @factory = my_factory
    month = params[:month].strip.to_i
    year = params[:year].strip.to_i
    time = Time.new
    now_year = time.year

    search_month = Date.new(year, month)
    now_month = Date.new(now_year, time.month)
    if now_month <= search_month
      redirect_to :action => :index
      return
    end

    sql = Chemical.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", '1', '2020-01-01', '2020-01-31']).select("chemicals.name, sum(dosage) sum_dosage, avg(dosage) avg_dosage").group(:name)

    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)
    @mth_pdt_rpts_cache = @factory.mth_pdt_rpts.where(["start_date = ? and end_date = ?", _start, _end])
    unless @mth_pdt_rpts_cache.blank?
      redirect_to :action => :index
      return
    end

    result = static_sum(@factory.id, _start, _end)
    year_result = static_sum(@factory.id, _year_start, _end)

    if result.blank?
      redirect_to :action => :index
      #flash[:info] = "选定月份暂无数据"
      return
    end

    mom_result = static_mom(@factory.id, year, month)
    yoy_result = static_yoy(@factory.id, year, month)
    up_std = up_standard_days(@factory.id, _start, _end)
    end_std = up_standard_days(@factory.id, _year_start, _end)

    start_date = _start
    end_date = _end
    name = year.to_s + "年" + month.to_s + "月" + @factory.name + "生产运营报告"
    rpt = mth_pdt_rpt(start_date, end_date, @factory.design, result[:inflow][:sum], result[:inflow][:avg], year_result[:inflow][:sum], @factory.id, name)

    bod = month_cms(result[:inf_bod][:avg], result[:eff_bod][:avg], result[:emr][:bod], result[:avg_emq][:bod], result[:emq][:bod], year_result[:emq][:bod], up_std[:bod] , end_std[:bod], yoy_result[:emq_bod], mom_result[:emq_bod], 0)
    cod = month_cms(result[:inf_cod][:avg], result[:eff_cod][:avg], result[:emr][:cod], result[:avg_emq][:cod], result[:emq][:cod], year_result[:emq][:cod], up_std[:cod] , end_std[:cod], yoy_result[:emq_cod], mom_result[:emq_cod], 0)
    tp = month_cms(result[:inf_tp][:avg], result[:eff_tp][:avg], result[:emr][:tp], result[:avg_emq][:tp], result[:emq][:tp], year_result[:emq][:tp], up_std[:tp] , end_std[:tp], yoy_result[:emq_tp], mom_result[:emq_tp], 0)
    tn = month_cms(result[:inf_tn][:avg], result[:eff_tn][:avg], result[:emr][:tn], result[:avg_emq][:tn], result[:emq][:tn], year_result[:emq][:tn], up_std[:tn] , end_std[:tn], yoy_result[:emq_tn], mom_result[:emq_tn], 0)
    ss = month_cms(result[:inf_ss][:avg], result[:eff_ss][:avg], result[:emr][:ss], result[:avg_emq][:ss], result[:emq][:ss], year_result[:emq][:ss], up_std[:ss] , end_std[:ss], yoy_result[:emq_ss], mom_result[:emq_ss], 0)
    nhn = month_cms(result[:inf_nhn][:avg], result[:eff_nhn][:avg], result[:emr][:nhn], result[:avg_emq][:nhn], result[:emq][:nhn], year_result[:emq][:nhn], up_std[:nhn] , end_std[:nhn], yoy_result[:emq_nhn], mom_result[:emq_nhn], 0)

    #todo 现在是0-缺少bom_power
    power = month_power(result[:power][:sum], year_result[:power][:sum], result[:power][:bom], 0, yoy_result[:power], mom_result[:power], 0, yoy_result[:bom], mom_result[:bom], 0)

    mud = month_mud(result[:inmud][:sum], year_result[:inmud][:sum], result[:outmud][:sum], year_result[:outmud][:sum], up_std[:mud], yoy_result[:mud], mom_result[:mud], 0)

    md = month_md(result[:mdrcy][:sum], year_result[:mdrcy][:sum], result[:mdsell][:sum], year_result[:mdsell][:sum], yoy_result[:mdrcy], mom_result[:mdrcy], 0, yoy_result[:mdsell], mom_result[:mdsell], 0)

    fecal = month_fecal(up_std[:fecal] , end_std[:fecal], yoy_result[:fecal], mom_result[:fecal])
    
    MthPdtRpt.transaction do
      rpt = MthPdtRpt.new(rpt)

      if rpt.save!
        mthbod = MonthBod.new(bod)
        mthbod.mth_pdt_rpt = rpt
        mthbod.save!
        mthcod = MonthCod.new(cod)
        mthcod.mth_pdt_rpt = rpt
        mthcod.save!
        mthtp = MonthTp.new(tp)
        mthtp.mth_pdt_rpt = rpt
        mthtp.save!
        mthtn = MonthTn.new(tn)
        mthtn.mth_pdt_rpt = rpt
        mthtn.save!
        mthnhn = MonthNhn.new(nhn)
        mthnhn.mth_pdt_rpt = rpt
        mthnhn.save!
        mthss = MonthSs.new(ss)
        mthss.mth_pdt_rpt = rpt
        mthss.save!
        mthpower = MonthPower.new(power)
        mthpower.mth_pdt_rpt = rpt
        mthpower.save!
        mthmud = MonthMud.new(mud)
        mthmud.mth_pdt_rpt = rpt
        mthmud.save!
        mthmd = MonthMd.new(md)
        mthmd.mth_pdt_rpt = rpt
        mthmd.save!
        mthfecal = MonthFecal.new(fecal)
        mthfecal.mth_pdt_rpt = rpt
        mthfecal.save!

        flash[:info] = "月度报表生成成功"
      else
        flash[:info] = "月度报表生成失败"
      end
    end
    redirect_to :action => :index
  end

      
   
  def edit
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
  end
   

   
  def update
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
    if @mth_pdt_rpt.update(mth_pdt_rpt_params)
      redirect_to factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
    else
      render :edit
    end
  end

  def download_append
   
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
    @ecm_ans_rpt = @mth_pdt_rpt.ecm_ans_rpt_url

    if @ecm_ans_rpt
      send_file File.join(Rails.root, "public", URI.decode(@ecm_ans_rpt)), :type => "application/force-download", :x_sendfile=>true
    end
  end
  


  def download_report
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))

    docWorker = ExportMthDoc.new
    target_word = docWorker.process(@mth_pdt_rpt.id)
    send_file target_word, :filename => "月报表word报告.docx", :type => "application/force-download", :x_sendfile=>true
  end
  
  def xls_mth_download
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    obj = [@mth_pdt_rpt]

    excel_tool = SpreadSheetTool.new
    target_excel = excel_tool.exportMthPdtRptToExcel(obj)
    send_file target_excel, :filename => "月报表.xls", :type => "application/force-download", :x_sendfile=>true
  end
  

  private
  
    def mth_pdt_rpt_params
      params.require(:mth_pdt_rpt).permit( :cmc_bill , :ecm_ans_rpt, month_cod_attributes: month_cod_params, month_bod_attributes: month_bod_params, month_tp_attributes: month_tp_params, month_tn_attributes: month_tn_params, month_nhn_attributes: month_nhn_params, month_ss_attributes: month_ss_params, month_fecal_attributes: month_fecal_params, month_power_attributes: month_power_params, month_mud_attributes: month_mud_params, month_md_attributes: month_md_params, month_device_attributes: month_device_params, month_stuff_attributes: month_stuff_params,  chemicals_attributes: chemical_params)
    end

    def chemical_params
      [:id, :name, :unprice, :cmptc, :dosage , :avg_dosage , :act_dosage , :dosptc, :per_cost, :_destroy]
    end
  
    def month_cod_params
      [:id, :ypdr]
    end
  
    def month_bod_params
      [:id, :ypdr ]
    end
  

    def month_tp_params
      [:id, :ypdr ]
    end
  
    def month_tn_params
      [:id, :ypdr ]
    end
  
    def month_nhn_params
      [:id, :ypdr ]
    end
  
    def month_ss_params
      [:id, :ypdr ]
    end

    def month_fecal_params
      [:id,:ypdr ]
    end
  
    def month_power_params
      [:id, :ypdr_power, :ypdr_bom]
    end
  
    def month_mud_params
      [:id, :ypdr ]
    end
  
    def month_md_params
      [:id, :ypdr_mdsell, :ypdr_mdrcy ]
    end
  
    def month_device_params
      [:id, :wsyxts, :wswdyxts, :sbwhl, :gysbwhl, :wbywhl, :gzwwhl, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_stuff_params
      [:id, :xdjtjl, :end_xdjtjl, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    #def mth_pdt_rpt_params
    #  params.require(:mth_pdt_rpt).permit( :design, :outflow, :avg_outflow, :end_outflow, month_cod_attributes: month_cod_params, month_bod_attributes: month_bod_params, month_tp_attributes: month_tp_params, month_tn_attributes: month_tn_params, month_nhn_attributes: month_nhn_params, month_fecal_attributes: month_fecal_params, month_power_attributes: month_power_params, month_mud_attributes: month_mud_params, month_md_attributes: month_md_params, month_device_attributes: month_device_params, month_stuff_attributes: month_stuff_params)
    #end
  
    #def month_cod_params
    #  [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_bod_params
    #  [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_tp_params
    #  [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_tn_params
    #  [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_nhn_params
    #  [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_fecal_params
    #  [:id, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_power_params
    #  [:id, :power, :end_power, :bom, :bom_power, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_mud_params
    #  [:id, :inmud, :end_inmud, :outmud, :end_outmud, :mst_up, :yoy, :mom, :ypdr ,:_destroy]
    #end
  
    #def month_md_params
    #  [:id, :mdrcy, :end_mdrcy, :mdsell, :end_mdsell, :yoy, :mom, :ypdr ,:_destroy]
    #end
    
    def my_factory
      @factory = current_user.factories.find(iddecode(params[:factory_id]))
    end

    def mth_pdt_rpt(start_date, end_date, design, outflow, avg_outflow, end_outflow, factory_id, name)
      {
        :name => name,
        :start_date =>  start_date, 
        :end_date =>  end_date, 
        :factory_id => factory_id,
        :design   =>  design,
        :outflow  =>  outflow,
        :avg_outflow =>  avg_outflow,
        :end_outflow =>  end_outflow
      }
    end

    #削减量同比和环比
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

    def month_power(power, end_power, bom, bom_power, yoy_power, mom_power, ypdr_power, yoy_bom, mom_bom, ypdr_bom)
      {
        :power => power,
        :end_power => end_power,
        :bom => bom,
        :bom_power => bom_power,
        :yoy_power => yoy_power,
        :mom_power => mom_power,
        :ypdr_power => ypdr_power,
        :yoy_bom => yoy_bom,
        :mom_bom => mom_bom,
        :ypdr_bom => ypdr_bom
      }
    end
     
    def month_mud(inmud, end_inmud, outmud, end_outmud, mst_up, yoy, mom, ypdr)
      {
        :inmud      =>  inmud    ,
        :end_inmud  =>  end_inmud,
        :outmud     =>  outmud   ,
        :end_outmud =>  end_outmud,
        :mst_up     =>  mst_up   ,
        :yoy        =>  yoy      ,
        :mom        =>  mom      ,
        :ypdr       =>  ypdr     
      }
    end

    def month_md(mdrcy, end_mdrcy, mdsell, end_mdsell, yoy_mdrcy, mom_mdrcy, ypdr_mdrcy, yoy_mdsell, mom_mdsell, ypdr_mdsell)
      {
        :mdrcy        =>   mdrcy,
        :end_mdrcy    =>   end_mdrcy,
        :mdsell       =>   mdsell,
        :end_mdsell   =>   end_mdsell,
        :yoy_mdrcy    =>   yoy_mdrcy,
        :mom_mdrcy    =>   mom_mdrcy,
        :ypdr_mdrcy   =>   ypdr_mdrcy,
        :yoy_mdsell   =>   yoy_mdsell,
        :mom_mdsell   =>   mom_mdsell,
        :ypdr_mdsell  =>   ypdr_mdsell
      }
    end

    def month_fecal(up_std, end_std, yoy, mom)
      {
        :up_std  => up_std,
        :end_std => end_std,
        :yoy => yoy,
        :mom => mom
      }
    end
end

