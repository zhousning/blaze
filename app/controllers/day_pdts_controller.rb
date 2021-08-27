class DayPdtsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

  include FormulaLib

  def index
    @day_pdt = DayPdt.new
    @factory = my_factory

    @day_pdts = @factory.day_pdts.order('pdt_date DESC').page( params[:page]).per( Setting.systems.per_page )  if @factory
  end
   

   
  def show
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
  end
   

   
  def new
    @factory = my_factory
    @day_pdt = DayPdt.new
    
    @day_pdt.build_inf_qlty
    @day_pdt.build_eff_qlty
    @day_pdt.build_sed_qlty
    @day_pdt.build_pdt_sum
    
  end
   
  def create
    @factory = my_factory
    day_pdt = @factory.day_pdts.where(:pdt_date => day_pdt_params[:pdt_date]).first
    day_pdt_rpt = @factory.day_pdt_rpts.where(:pdt_date => day_pdt_params[:pdt_date]).first
    @day_pdt = DayPdt.new(day_pdt_params)
    if day_pdt || day_pdt_rpt
      @day_pdt.errors[:date_error] = "当前日期运营数据已存在,请重新填报"
      render :new
    else
      @day_pdt.name = @day_pdt.pdt_date.to_s + @factory.name + "生产运营报表"
      @day_pdt.factory = @factory

      if @day_pdt.save
        redirect_to :action => :index
      else
        render :new
      end
    end
  end
   
  def emp_sync
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
    @inf_qlty = @day_pdt.inf_qlty
    @eff_qlty = @day_pdt.eff_qlty
    @pdt_sum  = @day_pdt.pdt_sum

    date = @day_pdt.pdt_date
    _start = date.to_s + "00:10:00"
    _end = (date + 1).to_s + "00:10:00"
    @emp_infs = @factory.emp_infs.where(["pdt_time > ? and pdt_time < ?", _start, _end])
    @emp_effs = @factory.emp_effs.where(["pdt_time > ? and pdt_time < ?", _start, _end])

    unless @emp_infs.blank?
      inf_avg_cod  = format("%0.2f", @emp_infs.average(:cod)).to_f
      inf_avg_nhn  = format("%0.2f", @emp_infs.average(:nhn)).to_f
      inf_avg_tp   = format("%0.2f", @emp_infs.average(:tp)).to_f
      inf_avg_ph   = format("%0.2f", @emp_infs.average(:ph)).to_f
      inf_avg_temp = format("%0.2f", @emp_infs.average(:temp)).to_f
      inf_sum_flow = format("%0.2f", @emp_infs.average(:flow)).to_f
      inf_qlty = {
        :cod => inf_avg_cod, 
        :nhn => inf_avg_nhn, 
        :tp  => inf_avg_tp , 
        :ph  => inf_avg_ph  
      }
      @inf_qlty.update_attributes(inf_qlty)
      @pdt_sum.update_attributes(:inflow => inf_sum_flow)
    end

    unless @emp_effs.blank?
      eff_avg_cod  = format("%0.2f", @emp_effs.average(:cod)).to_f
      eff_avg_nhn  = format("%0.2f", @emp_effs.average(:nhn)).to_f
      eff_avg_tp   = format("%0.2f", @emp_effs.average(:tp)).to_f
      eff_avg_ph   = format("%0.2f", @emp_effs.average(:ph)).to_f
      eff_avg_temp = format("%0.2f", @emp_effs.average(:temp)).to_f
      eff_sum_flow = format("%0.2f", @emp_effs.average(:flow)).to_f
      eff_qlty = {
        :cod => eff_avg_cod, 
        :nhn => eff_avg_nhn, 
        :tp  => eff_avg_tp , 
        :ph  => eff_avg_ph  
      }
      @eff_qlty.update_attributes(eff_qlty)
      @pdt_sum.update_attributes(:outflow => eff_sum_flow)
    end

    redirect_to edit_factory_day_pdt_path(idencode(@factory.id), idencode(@day_pdt.id)) 
  end

   
  def edit
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
  end
   

   
  def update
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
    @day_pdt.name = day_pdt_params[:pdt_date].to_s + @factory.name + "生产运营报表"

    if @day_pdt.update(day_pdt_params)
      redirect_to factory_day_pdt_path(idencode(@factory.id), idencode(@day_pdt.id)) 
    else
      render :edit
    end
  end

  def verify_index
    @factory = my_factory

    @day_pdts = @factory.day_pdts.where(:state => [Setting.day_pdts.verifying, Setting.day_pdts.rejected, Setting.day_pdts.complete]).order("pdt_date DESC").page( params[:page]).per( Setting.systems.per_page ) if @factory
  end

  def verify_show
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
  end

  def verifying
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
    @day_pdt.verifying
    redirect_to factory_day_pdt_path(idencode(@factory.id), idencode(@day_pdt.id)) 
  end
  
  def rejected
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
    @day_pdt.rejected
    redirect_to verify_show_factory_day_pdt_path(idencode(@factory.id), idencode(@day_pdt.id)) 
  end

  def upreport
    @factory = my_factory
    @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
    if @day_pdt.state == Setting.day_pdts.verifying
      @eff = @day_pdt.eff_qlty
      @inf = @day_pdt.inf_qlty
      @sed = @day_pdt.sed_qlty
      @tspmuds = @day_pdt.tspmuds
      @pdt_sum = @day_pdt.pdt_sum

      @day_pdt_rpt = DayPdtRpt.new(
        :factory => @factory,
        :day_pdt => @day_pdt,
        :tspmuds => @tspmuds,
        :name => @day_pdt.name, :pdt_date => @day_pdt.pdt_date, :weather => @day_pdt.weather, :temper => @day_pdt.temper, 
        :inf_qlty_bod => @inf.bod, :inf_qlty_cod => @inf.cod, :inf_qlty_ss => @inf.ss, :inf_qlty_nhn => @inf.nhn, :inf_qlty_tn => @inf.tn, :inf_qlty_tp => @inf.tp, :inf_qlty_ph => @inf.ph, 
        :eff_qlty_bod => @eff.bod, :eff_qlty_cod => @eff.cod, :eff_qlty_ss => @eff.ss, :eff_qlty_nhn => @eff.nhn, :eff_qlty_tn => @eff.tn, :eff_qlty_tp => @eff.tp, :eff_qlty_ph => @eff.ph, :eff_qlty_fecal => @eff.fecal,
        :sed_qlty_bod => @sed.bod, :sed_qlty_cod => @sed.cod, :sed_qlty_ss => @sed.ss, :sed_qlty_nhn => @sed.nhn, :sed_qlty_tn => @sed.tn, :sed_qlty_tp => @sed.tp, :sed_qlty_ph => @sed.ph, 
        :inflow => @pdt_sum.inflow, :outflow => @pdt_sum.outflow, :inmud => @pdt_sum.inmud, :outmud => @pdt_sum.outmud, :mst => @pdt_sum.mst, :power => @pdt_sum.power, :mdflow => @pdt_sum.mdflow, :mdrcy => @pdt_sum.mdrcy, :mdsell => @pdt_sum.mdsell
      )

      if @day_pdt_rpt.save
        @day_pdt.complete
      end
    end
    redirect_to verify_show_factory_day_pdt_path(idencode(@factory.id), idencode(@day_pdt.id)) 
  end
   

   
  #def destroy
  #  @factory = my_factory
  #  @day_pdt = @factory.day_pdts.find(iddecode(params[:id]))
  # 
  #  @day_pdt.destroy
  #  redirect_to :action => :index
  #end
   

  def xls_download
    send_file File.join(Rails.root, "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
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
      params.require(:day_pdt).permit( :pdt_date, :name, :signer, :weather, :temper, :desc , enclosures_attributes: enclosure_params, inf_qlty_attributes: inf_qlty_params, eff_qlty_attributes: eff_qlty_params, sed_qlty_attributes: sed_qlty_params, pdt_sum_attributes: pdt_sum_params, tspmuds_attributes: tspmud_params, chemicals_attributes: chemical_params)
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
    def tspmud_params
      [:id, :tspvum, :dealer, :rcpvum, :price, :prtmtd, :goort ,:_destroy]
    end
  
    def chemical_params
      [:id, :name, :unprice, :cmptc]
    end

    def my_factory
      @factory = current_user.factories.find(iddecode(params[:factory_id]))
    end
   
end

