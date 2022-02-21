class SdayPdtsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @sday_pdts = [] 
    @sfactories = current_user.sfactories.all
    @sfactories.each do |factory|
      @sday_pdts += factory.sday_pdts.where(:state => [Setting.day_pdts.ongoing, Setting.day_pdts.verifying, Setting.day_pdts.rejected, Setting.day_pdts.cmp_verifying, Setting.day_pdts.cmp_rejected]).order('pdt_date DESC')
    end
  end
   

   
  def show
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
  end
   

  def edit
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
  end
   

   
  def update
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))

    if @sday_pdt.update(sday_pdt_params)
      redirect_to sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
    else
      render :edit
    end
  end
   
  def verify_index
    @sday_pdts = [] 
    @sfactories = current_user.sfactories.all
    @sfactories.each do |sfactory|
      @sday_pdts += sfactory.sday_pdts.where(:state => [Setting.day_pdts.verifying, Setting.day_pdts.rejected, Setting.day_pdts.cmp_verifying, Setting.day_pdts.cmp_rejected]).order("pdt_date DESC")
    end
  end

  def verify_show
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
  end

  def verifying
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
    @sday_pdt.verifying
    redirect_to sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
  end
  
  def rejected
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
    @sday_pdt.rejected
    redirect_to verify_show_sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
  end

  def cmp_verify_index
    @sday_pdts = [] 
    @sfactories = current_user.sfactories.all
    @sfactories.each do |sfactory|
      @sday_pdts += sfactory.sday_pdts.where(:state => [Setting.day_pdts.verifying, Setting.day_pdts.rejected, Setting.day_pdts.cmp_verifying, Setting.day_pdts.cmp_rejected]).order("pdt_date DESC")
    end
  end
  
  def cmp_verify_show
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
  end

  def cmp_verifying
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
    @sday_pdt.cmp_verifying
    redirect_to verify_show_sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
  end
  
  def cmp_rejected
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
    @sday_pdt.cmp_rejected
    redirect_to cmp_verify_show_sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
  end

  def upreport
    @sfactory = my_sfactory
    @sday_pdt = @sfactory.sday_pdts.find(iddecode(params[:id]))
    @sday_pdt.complete
    redirect_to cmp_verify_show_sfactory_sday_pdt_path(idencode(@sfactory.id), idencode(@sday_pdt.id)) 
  end
  private
    def sday_pdt_params
      params.require(:sday_pdt).permit( :name, :pdt_date, :signer, :state, :weather, :min_temper, :max_temper, :desc, :one_verify, :two_verify, :ipt, :opt, :pres, :power, :yl, :zd, :yd, :ph)
    end
  
  
  
end

