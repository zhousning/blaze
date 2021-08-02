class EffQltiesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @eff_qlty = EffQlty.new
   
    @eff_qlties = EffQlty.all
   
  end
   

   
  def show
   
    @eff_qlty = EffQlty.find(params[:id])
   
  end
   

   
  def new
    @eff_qlty = EffQlty.new
    
  end
   

   
  def create
    @eff_qlty = EffQlty.new(eff_qlty_params)
     
    if @eff_qlty.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @eff_qlty = EffQlty.find(params[:id])
   
  end
   

   
  def update
   
    @eff_qlty = EffQlty.find(params[:id])
   
    if @eff_qlty.update(eff_qlty_params)
      redirect_to eff_qlty_path(@eff_qlty) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @eff_qlty = EffQlty.find(params[:id])
   
    @eff_qlty.destroy
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
    def eff_qlty_params
      params.require(:eff_qlty).permit( :bod, :cod, :ss, :nhn, :tn, :tp, :ph, :fecal)
    end
  
  
  
end

