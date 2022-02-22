class SdayPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #authorize_resource

  def index
    @sday_pdts = [] 
    @factories = current_user.sfactories.all
    gon.fct = ""
    @factories.each do |fct|
      gon.fct += idencode(fct.id).to_s + ","
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
      puts sday_pdt.sfactory.id
      button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + sday_pdt.id.to_s + "' data-fct = '" + sday_pdt.sfactory.id.to_s + "'>查看</button>"
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
