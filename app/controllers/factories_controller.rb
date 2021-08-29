class FactoriesController < ApplicationController
  layout "application_no_header"
  before_filter :authenticate_user!
  #load_and_authorize_resource


  def bigscreen
    @factory = current_user.factories.find(iddecode(params[:id]))
    @other_quotas = [Setting.quota.inflow, Setting.quota.outflow, Setting.quota.outmud, Setting.quota.power]
    gon.lnt = @factory.lnt
    gon.lat = @factory.lat
    gon.title = @factory.name
  end
   
  def index
    @factory = Factory.new
   
    @factories = Factory.all
   
  end
   

   
  def show
   
    @factory = Factory.where(:id => params[:id]).first
   
  end
   

   
  def new
    @factory = Factory.new
    
    @factory.departments.build
    
  end
   

   
  def create
    @factory = Factory.new(factory_params)
     
    #@factory.user = current_user
     
    if @factory.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @factory = Factory.where(:id => params[:id]).first
   
  end
   

   
  def update
   
    @factory = Factory.where(:id => params[:id]).first
   
    if @factory.update(factory_params)
      redirect_to factory_path(@factory) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @factory = Factory.where(:id => params[:id]).first
   
    @factory.destroy
    redirect_to :action => :index
  end
   

  

  

  
  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)

    a_str = ""
    b_str = ""
    c_str = "" 
    d_str = ""
    e_str = ""
    f_str = ""
    g_str = ""

    results["Sheet1"][1..-1].each do |items|
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          a_str = v.nil? ? "" : v 
        elsif !(/B/ =~ k).nil?
          b_str = v.nil? ? "" : v 
        elsif !(/C/ =~ k).nil?
          c_str = v.nil? ? "" : v 
        elsif !(/D/ =~ k).nil?
          d_str = v.nil? ? "" : v 
        elsif !(/E/ =~ k).nil?
          e_str = v.nil? ? "" : v 
        elsif !(/F/ =~ k).nil?
          f_str = v.nil? ? "" : v 
        elsif !(/G/ =~ k).nil?
          g_str = v.nil? ? "" : v 
          break
        end
      end
    end

    redirect_to :action => :index
  end 
  

  private
    def factory_params
      params.require(:factory).permit( :area, :name, :info, :lnt, :lat , :logo, departments_attributes: department_params)
    end
  
  
  
    def department_params
      [:id, :name, :info ,:_destroy]
    end
  
end

