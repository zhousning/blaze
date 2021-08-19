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
    @mth_pdt_rpts = MthPdtRpt.where(:state => Setting.mth_pdt_rpts.complete).order('start_date DESC')
  end
  
  def mth_report_show
    @mth_pdt_rpt = MthPdtRpt.find(iddecode(params[:id]))
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
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end

    year = params[:year].strip.to_i
    month = params[:month].strip.to_i

    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)
    @factories = Factory.find(fcts)

    obj = []
    @factories.each do |fct|
      mth_pdt_rpt = fct.mth_pdt_rpts.where(["start_date = ? and end_date = ?", _start, _end]).first
      obj << mth_pdt_rpt if mth_pdt_rpt
    end

    excel_tool = SpreadSheetTool.new
    target_excel = excel_tool.exportMthPdtRptToExcel(obj)
    send_file target_excel, :filename => "月报表.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  private
end
