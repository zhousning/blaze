class MudfctsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

   
  def index
    @mudfct = Mudfct.new
   
    @mudfcts = Mudfct.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @mudfct = Mudfct.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @mudfct = Mudfct.new
    
  end
   

   
  def create
    @mudfct = Mudfct.new(mudfct_params)
     
    if @mudfct.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @mudfct = Mudfct.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @mudfct = Mudfct.find(iddecode(params[:id]))
   
    if @mudfct.update(mudfct_params)
      redirect_to mudfct_path(idencode(@mudfct.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @mudfct = Mudfct.find(iddecode(params[:id]))
   
    @mudfct.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def mudfct_params
      params.require(:mudfct).permit( :name, :ability)
    end
  
  
  
end

