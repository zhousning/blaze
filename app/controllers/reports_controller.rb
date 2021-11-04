class ReportsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:query_day_reports, :query_mth_reports ]

  def index
    @factories = Factory.all
  end

  def day_report
    @factories = Factory.all
    @day_pdt_rpts = DayPdtRpt.all.order('pdt_date DESC')
  end

  def query_day_reports 
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    search_date = Date.parse(params[:search_date].gsub(/\s/, ''))

    @factories = Factory.find(fcts)

    obj = []
    @factories.each do |fct|
      day_pdt_rpts = fct.day_pdt_rpts.where(:pdt_date => search_date)
      day_pdt_rpts.each do |day_pdt_rpt|
        obj << { 
          :id      => idencode(day_pdt_rpt.id).to_s,
          :fct_id  => idencode(day_pdt_rpt.factory.id).to_s,
          :name    => day_pdt_rpt.name,
          :inf_cod => day_pdt_rpt.inf_qlty_cod,
          :eff_cod => day_pdt_rpt.eff_qlty_cod,
          :inf_bod => day_pdt_rpt.inf_qlty_bod,
          :eff_bod => day_pdt_rpt.eff_qlty_bod,
          :inf_tn  => day_pdt_rpt.inf_qlty_tn,
          :eff_tn  => day_pdt_rpt.eff_qlty_tn,
          :inf_tp  => day_pdt_rpt.inf_qlty_tp,
          :eff_tp  => day_pdt_rpt.eff_qlty_tp,
          :inf_nhn => day_pdt_rpt.inf_qlty_nhn,
          :eff_nhn => day_pdt_rpt.eff_qlty_nhn
        }
      end
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def query_mth_reports 
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    year = params[:year].strip.to_i
    month = params[:month].strip.to_i

    _start = Date.new(year, month, 1)
    @factories = Factory.find(fcts)

    obj = []
    @factories.each do |fct|
      mth_pdt_rpts = fct.mth_pdt_rpts.where(:start_date => _start)
      mth_pdt_rpts.each do |mth_pdt_rpt|
        obj << { 
          :id          => idencode(mth_pdt_rpt.id).to_s,
          :fct_id      => idencode(mth_pdt_rpt.factory.id).to_s,
          :name        => mth_pdt_rpt.name,
          :outflow     => mth_pdt_rpt.outflow,
          :state       => mth_state(mth_pdt_rpt.state),
          :avg_outflow => mth_pdt_rpt.avg_outflow,
          :end_outflow => mth_pdt_rpt.end_outflow
        }
      end
    end
    puts obj
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
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
    send_file target_excel, :filename => "日报表.xls", :type => "application/force-download", :x_sendfile=>true
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
    target_excel = excel_tool.exportKgMthPdtRptToExcel(obj)
    send_file target_excel, :filename => "月报汇总表.xls", :type => "application/force-download", :x_sendfile=>true
  end

  private 
    def mth_state(state) 
      result = {
        Setting.mth_pdt_rpts.complete => Setting.mth_pdt_rpts.complete_t,
        Setting.mth_pdt_rpts.ongoing => Setting.mth_pdt_rpts.ongoing_t,
        Setting.mth_pdt_rpts.verifying => Setting.mth_pdt_rpts.verifying_t,
        Setting.mth_pdt_rpts.rejected => Setting.mth_pdt_rpts.rejected_t,
        Setting.mth_pdt_rpts.cmp_verifying => Setting.mth_pdt_rpts.cmp_verifying_t,
        Setting.mth_pdt_rpts.cmp_rejected =>  Setting.mth_pdt_rpts.cmp_rejected_t
      }
      result[state]
    end

end
