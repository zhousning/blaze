class EquipmentsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:index, :query_all, :upholds ]

  def index
    url = Setting.systems.equip_host + 'equipments/fcts'
    response = RestClient.get url, :accept => :json
    body = JSON.parse(response)

    str = ""
    body.each do |k|
      str += "<option value='" + k['factory'].to_s + "'>" + k['name'] + "</option>"
    end
    @fcts = str
  end


  def query_all 
    url = Setting.systems.equip_host + 'equipments/query_all'
    factory_id = params[:factory_id]
    data = {
      factory_id: factory_id 
    }
    response = RestClient.get url, params: data, :accept => :json
    body = JSON.parse(response)

    respond_to do |f|
      f.json{ render :json => body}
    end

  end

  def upholds 
    url = Setting.systems.equip_host + 'equipments/upholds'
    factory_id = params[:fct]
    device_id = params[:id]
    data = {
      factory_id: factory_id, 
      id: device_id 
    }
    response = RestClient.get url, params: data, :accept => :json
    body = JSON.parse(response)

    respond_to do |f|
      f.json{ render :json => body}
    end

  end
end
