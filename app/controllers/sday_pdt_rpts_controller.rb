class SdayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:query_all, :produce_report]

  def index
    @factories = current_user.sfactories.all
    gon.fct = ""
    @factories.each do |fct|
      gon.fct += idencode(fct.id).to_s + ","
    end
  end

  #day_pdt_rpts modal显示图表用
  def produce_report 
    @factory = my_sfactory
   
    @day_pdt_rpt = @factory.sday_pdts.find(iddecode(params[:id]))
    @day_rpt_stc = @day_pdt_rpt.sday_pdt_stc
    header = {
      :name => @day_pdt_rpt.name
      #:weather => @day_pdt_rpt.weather, 
      #:min_temper => @day_pdt_rpt.min_temper,
      #:max_temper => @day_pdt_rpt.max_temper
    }

    energy = {
      Setting.sday_pdts.press => @day_pdt_rpt.press,
      Setting.sday_pdts.power => @day_pdt_rpt.power,
      Setting.sday_pdts.bom => @day_rpt_stc.bom,
      Setting.sday_pdts.yl => @day_pdt_rpt.yl,
      Setting.sday_pdts.zd => @day_pdt_rpt.zd,
      Setting.sday_pdts.yd => @day_pdt_rpt.yd,
      Setting.sday_pdts.ph => @day_pdt_rpt.ph
    }

    respond_to do |format|
      format.json{ render :json => 
        {
          :datasets => [
            {:source => "采水量"  , :'水量' => @day_pdt_rpt.ipt},
            {:source => "供水量"  , :'水量' => @day_pdt_rpt.opt}
          ],
          :fct_id => idencode(@factory.id),
          :day_rpt_id => idencode(@day_pdt_rpt.id),
          :header => header,
          :energy     => energy
        }.to_json}
    end
  end

  def query_all
    _start = params[:start]
    _end = params[:end]
    _fcts = params[:fcts].split(",")

    fcts = _fcts.collect do |fct|
      iddecode(fct)
    end

    @sday_pdts = SdayPdt.where(['pdt_date between ? and ? and sfactory_id in (?) and state = ?', _start, _end, fcts, Setting.day_pdts.complete]).order('pdt_date DESC')

    objs = []
    @sday_pdts.each_with_index do |sday_pdt, index|
      button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + idencode(sday_pdt.id).to_s + "' data-fct = '" + idencode(sday_pdt.sfactory.id).to_s + "'>查看</button>"
      objs << {
        'id': index+1,
        'name': sday_pdt.name,
        'pdt_date': sday_pdt.pdt_date,
        'ipt': sday_pdt.ipt,
        'opt': sday_pdt.opt,
        'power': sday_pdt.power,
        'operator': button 
      }
    end

    response_json(objs)
  end


end
