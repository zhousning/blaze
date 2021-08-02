class PdtSumsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @pdt_sum = PdtSum.new
   
    @pdt_sums = PdtSum.all
   
  end
   

   
  def show
   
    @pdt_sum = PdtSum.find(params[:id])
   
  end
   

   
  def new
    @pdt_sum = PdtSum.new
    
  end
   

   
  def create
    @pdt_sum = PdtSum.new(pdt_sum_params)
     
    if @pdt_sum.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @pdt_sum = PdtSum.find(params[:id])
   
  end
   

   
  def update
   
    @pdt_sum = PdtSum.find(params[:id])
   
    if @pdt_sum.update(pdt_sum_params)
      redirect_to pdt_sum_path(@pdt_sum) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @pdt_sum = PdtSum.find(params[:id])
   
    @pdt_sum.destroy
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
    def pdt_sum_params
      params.require(:pdt_sum).permit( :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell)
    end
  
  
  
end

