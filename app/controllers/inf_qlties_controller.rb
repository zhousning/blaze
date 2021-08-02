class InfQltiesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @inf_qlty = InfQlty.new
   
    @inf_qlties = InfQlty.all
   
  end
   

   
  def show
   
    @inf_qlty = InfQlty.find(params[:id])
   
  end
   

   
  def new
    @inf_qlty = InfQlty.new
    
  end
   

   
  def create
    @inf_qlty = InfQlty.new(inf_qlty_params)
     
    if @inf_qlty.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @inf_qlty = InfQlty.find(params[:id])
   
  end
   

   
  def update
   
    @inf_qlty = InfQlty.find(params[:id])
   
    if @inf_qlty.update(inf_qlty_params)
      redirect_to inf_qlty_path(@inf_qlty) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @inf_qlty = InfQlty.find(params[:id])
   
    @inf_qlty.destroy
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
    def inf_qlty_params
      params.require(:inf_qlty).permit( :bod, :cod, :ss, :nhn, :tn, :tp, :ph)
    end
  
  
  
end

