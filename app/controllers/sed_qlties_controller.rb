class SedQltiesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @sed_qlty = SedQlty.new
   
    @sed_qlties = SedQlty.all
   
  end
   

   
  def show
   
    @sed_qlty = SedQlty.find(params[:id])
   
  end
   

   
  def new
    @sed_qlty = SedQlty.new
    
  end
   

   
  def create
    @sed_qlty = SedQlty.new(sed_qlty_params)
     
    if @sed_qlty.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @sed_qlty = SedQlty.find(params[:id])
   
  end
   

   
  def update
   
    @sed_qlty = SedQlty.find(params[:id])
   
    if @sed_qlty.update(sed_qlty_params)
      redirect_to sed_qlty_path(@sed_qlty) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @sed_qlty = SedQlty.find(params[:id])
   
    @sed_qlty.destroy
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
    def sed_qlty_params
      params.require(:sed_qlty).permit( :bod, :cod, :ss, :nhn, :tn, :tp, :ph)
    end
  
  
  
end

