class MthPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

  include MathCube 

  def index
    @mth_pdt_rpt = MthPdtRpt.new
    @factory = my_factory
   
    @mth_pdt_rpts = @factory.mth_pdt_rpts.order('pdt_date DESC') if @factory
   
  end

  def mth_rpt_create
    @factory = my_factory
    month = params[:month].trip.to_i
    time = Time.new
    year = time.year

    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)

    result = static_sum(@factory.id, _start, _end)
    year_result = static_sum(@factory.id, _year_start, _end)

    mom_result = static_mom(@factory.id, year, month)
    yoy_result = static_yoy(@factory.id, year, month)
    up_std = up_standard_days(@factory.id, _start, _end)
    end_std = up_standard_days(@factory.id, _year_start, _end)

    rpt = mth_pdt_rpt(pdt_date, @factory.design, result[:outflow][:sum], result[:outflow][:avg], year_result[:outflow][:sum])

    bod = month_cms(result[:inf_bod][:avg], result[:eff_bod][:avg], result[:emr][:bod], result[:avg_emq][:bod], result[:emq][:bod], year_result[:emq][:bod], up_std[:bod] , end_std[:bod], yoy_result[:emq_bod], mom_result[:emq_bod], 0)
    cod = month_cms(result[:inf_cod][:avg], result[:eff_cod][:avg], result[:emr][:cod], result[:avg_emq][:cod], result[:emq][:cod], year_result[:emq][:cod], up_std[:cod] , end_std[:cod], yoy_result[:emq_cod], mom_result[:emq_cod], 0)
    tp = month_cms(result[:inf_tp][:avg], result[:eff_tp][:avg], result[:emr][:tp], result[:avg_emq][:tp], result[:emq][:tp], year_result[:emq][:tp], up_std[:tp] , end_std[:tp], yoy_result[:emq_tp], mom_result[:emq_tp], 0)
    tn = month_cms(result[:inf_tn][:avg], result[:eff_tn][:avg], result[:emr][:tn], result[:avg_emq][:tn], result[:emq][:tn], year_result[:emq][:tn], up_std[:tn] , end_std[:tn], yoy_result[:emq_tn], mom_result[:emq_tn], 0)
    ss = month_cms(result[:inf_ss][:avg], result[:eff_ss][:avg], result[:emr][:ss], result[:avg_emq][:ss], result[:emq][:ss], year_result[:emq][:ss], up_std[:ss] , end_std[:ss], yoy_result[:emq_ss], mom_result[:emq_ss], 0)
    nhn = month_cms(result[:inf_nhn][:avg], result[:eff_nhn][:avg], result[:emr][:nhn], result[:avg_emq][:nhn], result[:emq][:nhn], year_result[:emq][:nhn], up_std[:nhn] , end_std[:nhn], yoy_result[:emq_nhn], mom_result[:emq_nhn], 0)

    power = month_power(result[:power][:sum], year_result[:power][:sum], result[:power][:bom], yoy_result[:power], mom_result[:power], 0, yoy_result[:bom], mom_result[:bom], 0)

    mud = month_mud(result[:inmud][:sum], year_result[:inmud][:sum], result[:outmud][:sum], year_result[:outmud][:sum], up_std[:mst], yoy_result[:mst], mom_result[:mst], 0)


    md = month_md(result[:mdrcy][:sum], year_result[:mdrcy][:sum], result[:mdsell][:sum], year_result[:mdsell][:sum], yoy_result[:mdrcy], mom_result[:mdrcy], 0, yoy_result[:mdsell], mom_result[:mdsell], 0)

    fecal = month_fecal(up_std[:fecal] , end_std[:fecal])
    
    MthPdtRpt.transaction do
      rpt = MthPdtRpt.new(rpt)
      rpt.build_month_bod(bod)
      rpt.build_month_cod(cod)
      rpt.build_month_tp(tp)
      rpt.build_month_tn(tn)
      rpt.build_month_ss(ss)
      rpt.build_month_nhn(nhn)
      rpt.build_month_power(power)
      rpt.build_month_mud(mud)
      rpt.build_month_md(md)
      rpt.build_month_fecal(fecal)

      if @mth_pdt_rpt.save
        flash[:succes] = "月度报表生成成功"
      else
        flash[:warning] = "月度报表生成失败"
      end
    end
    redirect_to :action => :index
  end

  def mth_pdt_rpt(pdt_date, design, outflow, avg_outflow, end_outflow)
    {
      :pdt_date =>  pdt_date, 
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
      :end_mdsell   =>   end_mdsell
      :yoy_mdrcy    =>   yoy_mdrcy,
      :mom_mdrcy    =>   mom_mdrcy,
      :ypdr_mdrcy   =>   ypdr_mdrcy,
      :yoy_mdsell   =>   yoy_mdsell,
      :mom_mdsell   =>   mom_mdsell,
      :ypdr_mdsell  =>   ypdr_mdsell
    }
  end

  def month_fecal(up_std, end_std)
    {
      :up_std  => up_std,
      :end_std => end_std
    }
  end
      




   
  def show
   
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
   
  end
   

   
  def create
    @mth_pdt_rpt = MthPdtRpt.new(mth_pdt_rpt_params)
     
    if @mth_pdt_rpt.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
   
    if @mth_pdt_rpt.update(mth_pdt_rpt_params)
      redirect_to mth_pdt_rpt_path(idencode(@mth_pdt_rpt.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
   
    @mth_pdt_rpt.destroy
    redirect_to :action => :index
  end
   

  

  

  
  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  

  private
    def mth_pdt_rpt_params
      params.require(:mth_pdt_rpt).permit( :design, :outflow, :avg_outflow, :end_outflow, month_cods_attributes: month_cod_params, month_bods_attributes: month_bod_params, month_tps_attributes: month_tp_params, month_tns_attributes: month_tn_params, month_nhns_attributes: month_nhn_params, month_fecals_attributes: month_fecal_params, month_powers_attributes: month_power_params, month_muds_attributes: month_mud_params, month_mds_attributes: month_md_params, month_devices_attributes: month_device_params, month_stuffs_attributes: month_stuff_params)
    end
  
  
  
    def month_cod_params
      [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_bod_params
      [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_tp_params
      [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_tn_params
      [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_nhn_params
      [:id, :avg_inf, :avg_eff, :emr, :avg_emq, :emq, :end_emq, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_fecal_params
      [:id, :up_std, :end_std, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_power_params
      [:id, :power, :end_power, :bom, :bom_power, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_mud_params
      [:id, :inmud, :end_inmud, :outmud, :end_outmud, :mst_up, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_md_params
      [:id, :mdrcy, :end_mdrcy, :mdsell, :end_mdsell, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_device_params
      [:id, :wsyxts, :wswdyxts, :sbwhl, :gysbwhl, :wbywhl, :gzwwhl, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def month_stuff_params
      [:id, :xdjtjl, :end_xdjtjl, :yoy, :mom, :ypdr ,:_destroy]
    end
  
  def my_factory
    @factory = current_user.factories.find(iddecode(params[:factory_id]))
  end
end

