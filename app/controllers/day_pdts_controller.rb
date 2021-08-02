class DayPdtsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @day_pdt = DayPdt.new
   
    @day_pdts = DayPdt.all
   
  end
   

   
  def show
   
    @day_pdt = DayPdt.find(params[:id])
   
  end
   

   
  def new
    @day_pdt = DayPdt.new
    
    @day_pdt.build_inf_qlty
    
    @day_pdt.build_eff_qlty
    
    @day_pdt.build_sed_qlty
    
    @day_pdt.build_pdt_sum
    
  end
   

   
  def create
    @day_pdt = DayPdt.new(day_pdt_params)
     
    if @day_pdt.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @day_pdt = DayPdt.find(params[:id])
   
  end
   

   
  def update
   
    @day_pdt = DayPdt.find(params[:id])
   
    if @day_pdt.update(day_pdt_params)
      redirect_to day_pdt_path(@day_pdt) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @day_pdt = DayPdt.find(params[:id])
   
    @day_pdt.destroy
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
    def day_pdt_params
      params.require(:day_pdt).permit( :pdt_date, :name, :signer, :weather, :temper, :desc , enclosures_attributes: enclosure_params, inf_qlty_attributes: inf_qlty_params, eff_qlty_attributes: eff_qlty_params, sed_qlty_attributes: sed_qlty_params, pdt_sum_attributes: pdt_sum_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
  
  
    def inf_qlty_params
      [:id, :bod, :cod, :ss, :nhn, :tn, :tp, :ph ,:_destroy]
    end
  
    def eff_qlty_params
      [:id, :bod, :cod, :ss, :nhn, :tn, :tp, :ph, :fecal ,:_destroy]
    end
  
    def sed_qlty_params
      [:id, :bod, :cod, :ss, :nhn, :tn, :tp, :ph ,:_destroy]
    end
  
    def pdt_sum_params
      [:id, :inflow, :outflow, :inmud, :outmud, :mst, :power, :mdflow, :mdrcy, :mdsell ,:_destroy]
    end
  
end

