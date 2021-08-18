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
  
  def day_report_download
  end

  def mth_report_download
  end
end
