class ReportsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

  def index
    @factories = Factory.all
  end

  def day_report
    @factories = Factory.all
    @day_pdt_rpts = DayPdtRpt.all.order('pdt_date DESC')
  end

  def mth_report
    @factories = Factory.all
    @mth_pdt_rpts = DayPdtRpt.where(:state => Setting.mth_pdt_rpts.complete).('pdt_date DESC')
  end
  
  #  obj = 
  #    {
  #     sheet1: [['a1', 'a2', 'a3'], ['b1','b2','b3']],
  #     sheet2: [['a1', 'a2', 'a3'], ['b1','b2','b3']]
  #    }
  def xls_day_download
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    puts fcts
    search_date = Date.parse(params[:search_date].gsub(/\s/, ''))
    excel_tool = ExcelTool.new

    @factories = Factory.find(fcts)
    sheet1 = [day_pdt_rpt_title]
    @factories.each do |fct|
      day_pdt_rpt = fct.day_pdt_rpts.where(:pdt_date => search_date).first
      sheet1 << day_pdt_rpt_obj(day_pdt_rpt) if day_pdt_rpt
    end

    obj = {
      sheet1: sheet1
    }
    filename = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    target_excel = excel_tool.exportToExcel(obj, filename)
    send_file target_excel, :filename => "日报表.xlsx", :type => "application/force-download", :x_sendfile=>true
  end

  def xls_mth_download
  end
  
  private
    def day_pdt_rpt_title
      [
        "",
        Setting.day_pdt_rpts.inf_qlty_bod,  
        Setting.day_pdt_rpts.eff_qlty_bod,  
        Setting.day_pdt_rpts.inf_qlty_cod,  
        Setting.day_pdt_rpts.eff_qlty_cod,  
        Setting.day_pdt_rpts.inf_qlty_ss,   
        Setting.day_pdt_rpts.eff_qlty_ss,   
        Setting.day_pdt_rpts.inf_qlty_nhn,  
        Setting.day_pdt_rpts.eff_qlty_nhn,  
        Setting.day_pdt_rpts.inf_qlty_tn,   
        Setting.day_pdt_rpts.eff_qlty_tn,   
        Setting.day_pdt_rpts.inf_qlty_tp,   
        Setting.day_pdt_rpts.eff_qlty_tp,   
        Setting.day_pdt_rpts.inf_qlty_ph,   
        Setting.day_pdt_rpts.eff_qlty_ph,   
        Setting.day_pdt_rpts.eff_qlty_fecal,
        Setting.day_pdt_rpts.inflow,        
        Setting.day_pdt_rpts.outflow,       
        Setting.day_pdt_rpts.inmud,         
        Setting.day_pdt_rpts.outmud,        
        Setting.day_pdt_rpts.mst,           
        Setting.day_pdt_rpts.power,         
        Setting.day_pdt_rpts.mdflow,        
        Setting.day_pdt_rpts.mdrcy,         
        Setting.day_pdt_rpts.mdsell
      ]
    end

    def day_pdt_rpt_obj(day_pdt_rpt)
      [
        day_pdt_rpt.factory.name,
        day_pdt_rpt.inf_qlty_bod,  
        day_pdt_rpt.eff_qlty_bod,  
        day_pdt_rpt.inf_qlty_cod,  
        day_pdt_rpt.eff_qlty_cod,  
        day_pdt_rpt.inf_qlty_ss,   
        day_pdt_rpt.eff_qlty_ss,   
        day_pdt_rpt.inf_qlty_nhn,  
        day_pdt_rpt.eff_qlty_nhn,  
        day_pdt_rpt.inf_qlty_tn,   
        day_pdt_rpt.eff_qlty_tn,   
        day_pdt_rpt.inf_qlty_tp,   
        day_pdt_rpt.eff_qlty_tp,   
        day_pdt_rpt.inf_qlty_ph,   
        day_pdt_rpt.eff_qlty_ph,   
        day_pdt_rpt.eff_qlty_fecal,
        day_pdt_rpt.inflow,        
        day_pdt_rpt.outflow,       
        day_pdt_rpt.inmud,         
        day_pdt_rpt.outmud,        
        day_pdt_rpt.mst,           
        day_pdt_rpt.power,         
        day_pdt_rpt.mdflow,        
        day_pdt_rpt.mdrcy,         
        day_pdt_rpt.mdsell
      ]
    end
end
