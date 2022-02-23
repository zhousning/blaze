class SmonthIptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @smonth_ipt = SmonthIpt.new
   
    @smonth_ipts = SmonthIpt.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @smonth_ipt = SmonthIpt.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @smonth_ipt = SmonthIpt.new
    
  end
   

   
  def create
    @smonth_ipt = SmonthIpt.new(smonth_ipt_params)
     
    if @smonth_ipt.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @smonth_ipt = SmonthIpt.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @smonth_ipt = SmonthIpt.find(iddecode(params[:id]))
   
    if @smonth_ipt.update(smonth_ipt_params)
      redirect_to smonth_ipt_path(idencode(@smonth_ipt.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @smonth_ipt = SmonthIpt.find(iddecode(params[:id]))
   
    @smonth_ipt.destroy
    redirect_to :action => :index
  end
   

  
    def download_attachment 
     
      @smonth_ipt = SmonthIpt.find(iddecode(params[:id]))
     
      @attachment_id = params[:number].to_i
      @attachment = @smonth_ipt.attachments[@attachment_id]

      if @attachment
        send_file File.join(Rails.root, "public", URI.decode(@attachment.file_url)), :type => "application/force-download", :x_sendfile=>true
      end
    end
  

  

  
  
  

  private
    def smonth_ipt_params
      params.require(:smonth_ipt).permit( :ipt, :end_ipt, :max_ipt, :min_ipt, :avg_ipt, :max_date, :min_date, :yoy, :mom, :ypdr , attachments_attributes: attachment_params)
    end
  
  
    def attachment_params
      [:id, :file, :_destroy]
    end
  
  
end

