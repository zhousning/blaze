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
  
  def xls_day_download
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    search_date = Date.parse(params[:search_date].gsub(/\s/, ''))
    excel_tool = SpreadSheetTool.new

    @factories = Factory.find(fcts)

    obj = []
    @factories.each do |fct|
      day_pdt_rpt = fct.day_pdt_rpts.where(:pdt_date => search_date).first
      obj << day_pdt_rpt if day_pdt_rpt
    end

    target_excel = excel_tool.exportDayPdtRptToExcel(obj)
    send_file target_excel, :filename => "日报表.xlsx", :type => "application/force-download", :x_sendfile=>true
  end

  def xls_mth_download
  end
  
  private
end
