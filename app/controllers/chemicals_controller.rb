class ChemicalsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource

   
  def index
    @chemical = Chemical.new
   
    @chemicals = Chemical.all.page( params[:page]).per( Setting.systems.per_page )
   
  end
   

   
  def show
   
    @chemical = Chemical.find(iddecode(params[:id]))
   
  end
   

   
  def new
    @chemical = Chemical.new
    
  end
   

   
  def create
    @chemical = Chemical.new(chemical_params)
     
    if @chemical.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @chemical = Chemical.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @chemical = Chemical.find(iddecode(params[:id]))
   
    if @chemical.update(chemical_params)
      redirect_to chemical_path(idencode(@chemical.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @chemical = Chemical.find(iddecode(params[:id]))
   
    @chemical.destroy
    redirect_to :action => :index
  end
   

  

  

  
  
  

  private
    def chemical_params
      params.require(:chemical).permit( :name, :unprice, :cmptc, :dosptc, :per_cost)
    end
  
  
  
end

