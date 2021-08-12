class MthPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @mth_pdt_rpt = MthPdtRpt.new
    @factory = my_factory
   
    @mth_pdt_rpts = @factory.mth_pdt_rpts.order('pdt_date DESC') if @factory
   
  end
   

   
  def show
   
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @mth_pdt_rpt = MthPdtRpt.new
    
    @mth_pdt_rpt.month_cods.build
    
    @mth_pdt_rpt.month_bods.build
    
    @mth_pdt_rpt.month_tps.build
    
    @mth_pdt_rpt.month_tns.build
    
    @mth_pdt_rpt.month_nhns.build
    
    @mth_pdt_rpt.month_fecals.build
    
    @mth_pdt_rpt.month_powers.build
    
    @mth_pdt_rpt.month_muds.build
    
    @mth_pdt_rpt.month_mds.build
    
    @mth_pdt_rpt.month_devices.build
    
    @mth_pdt_rpt.month_stuffs.build
    
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

