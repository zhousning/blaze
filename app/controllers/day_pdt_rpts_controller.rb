class DayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @day_pdt_rpt = DayPdtRpt.new
    @factory = my_factory
   
    @day_pdt_rpts = @factory.day_pdt_rpts if @factory
   
  end
   

   
  def show
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))
  end
   

  def produce_report 
    @factory = my_factory
   
    @day_pdt_rpt = @factory.day_pdt_rpts.find(iddecode(params[:id]))

    respond_to do |format|
      format.json{ render :json => 
        {
          :categories => [
            {:source => "COD", :'进水' => @day_pdt_rpt.inf_qlty_cod, :'出水' => @day_pdt_rpt.eff_qlty_cod},
            {:source => "BOD", :'进水' => @day_pdt_rpt.inf_qlty_bod, :'出水' => @day_pdt_rpt.eff_qlty_bod},
            {:source => "TN", :'进水' => @day_pdt_rpt.inf_qlty_tn, :'出水' => @day_pdt_rpt.eff_qlty_tn},
            {:source => "TP", :'进水' => @day_pdt_rpt.inf_qlty_tp, :'出水' => @day_pdt_rpt.eff_qlty_tp},
            {:source => "NH3-N", :'进水' => @day_pdt_rpt.inf_qlty_nhn, :'出水' => @day_pdt_rpt.eff_qlty_nhn},
            {:source => "PH", :'进水' => @day_pdt_rpt.inf_qlty_ph, :'出水' => @day_pdt_rpt.eff_qlty_ph}
          ]
        }.to_json}
      #format.json{ render :json => 
      #  {
      #    :categories => [{:source => "进水", :COD => @day_pdt_rpt.inf_qlty_cod, :BOD => @day_pdt_rpt.inf_qlty_bod, :TN => @day_pdt_rpt.inf_qlty_tn, :TP => @day_pdt_rpt.inf_qlty_tp, :'NH3-N' => @day_pdt_rpt.inf_qlty_nhn}, {:source => "出水", :COD => @day_pdt_rpt.eff_qlty_cod, :BOD => @day_pdt_rpt.eff_qlty_bod, :TN =>  @day_pdt_rpt.eff_qlty_tn, :TP => @day_pdt_rpt.eff_qlty_tp, :'NH3-N' => @day_pdt_rpt.eff_qlty_nhn}]
      #  }.to_json}
    end
  end
   
  #def new
  #  @day_pdt_rpt = DayPdtRpt.new
  #  
  #end
  # 

  # 
  #def create
  #  @day_pdt_rpt = DayPdtRpt.new(day_pdt_rpt_params)
  #   
  #  @day_pdt_rpt.user = current_user
  #   
  #  if @day_pdt_rpt.save
  #    redirect_to :action => :index
  #  else
  #    render :new
  #  end
  #end
   

   
  #def edit
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #end
  # 

  # 
  #def update
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #  if @day_pdt_rpt.update(day_pdt_rpt_params)
  #    redirect_to day_pdt_rpt_path(idencode(@day_pdt_rpt.id)) 
  #  else
  #    render :edit
  #  end
  #end
  # 

  # 
  #def destroy
  # 
  #  @day_pdt_rpt = DayPdtRpt.where(:user => current_user, :id => iddecode(params[:id])).first
  # 
  #  @day_pdt_rpt.destroy
  #  redirect_to :action => :index
  #end
   

  

  

  
  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  

  private
    def day_pdt_rpt_params
      params.require(:day_pdt_rpt).permit(:name, :pdt_date, :weather, :temper, 
      :inf_qlty_bod, :inf_qlty_cod, :inf_qlty_ss, :inf_qlty_nhn, :inf_qlty_tn, :inf_qlty_tp, :inf_qlty_ph, 
      :eff_qlty_bod, :eff_qlty_cod, :eff_qlty_ss, :eff_qlty_nhn, :eff_qlty_tn, :eff_qlty_tp, :eff_qlty_ph, :eff_qlty_fecal,  
      :sed_qlty_bod, :sed_qlty_cod, :sed_qlty_ss, :sed_qlty_nhn, :sed_qlty_tn, :sed_qlty_tp, :sed_qlty_ph, 
      :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell)
    end
  
    def my_factory
      @factory = current_user.factories.find(iddecode(params[:factory_id]))
    end
   
  
  
end

