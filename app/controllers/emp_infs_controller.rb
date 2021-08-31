class EmpInfsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource 
  #load_and_authorize_resource

  include QuotaConfig
   
  def index
   
    @emp_inf = EmpInf.new
    @factory = my_factory
    @factories = Factory.all
    @emp_infs = @factory.emp_infs.order('pdt_time DESC').page( params[:page]).per( Setting.systems.per_page ) 
   
  end
   
  def grp_index
   
    @emp_inf = EmpInf.new
    @factories = Factory.all
    @emp_infs = EmpInf.order('pdt_time DESC').page( params[:page]).per( Setting.systems.per_page ) 
   
  end

  #def new
  #  @emp_inf = EmpInf.new
  #end
  # 
  #def create
  #  @factory = my_factory
  #  @emp_inf = EmpInf.new(emp_inf_params)
  #  @emp_inf.factory = @factory
  #   
  #  if @emp_inf.save
  #    redirect_to :action => :index
  #  else
  #    render :new
  #  end
  #end
   

   
  def edit
   
    @emp_inf = EmpInf.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @emp_inf = EmpInf.find(iddecode(params[:id]))
   
    if @emp_inf.update(emp_inf_params)
      redirect_to edit_emp_inf_path(idencode(@emp_inf.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @emp_inf = EmpInf.find(iddecode(params[:id]))
    @emp_inf.destroy if @emp_inf
    redirect_to :action => :grp_index
  end
   
  def watercms_flow
    _start = Date.parse(params[:start].gsub(/\s/, ''))
    _end = Date.parse(params[:end].gsub(/\s/, ''))
    quota = params[:quota].strip
    fct = params[:fct].strip
    @factory = current_user.factories.find(iddecode(fct)) 

    quota_title = emp_quota(quota)

    time = []
    s1_data = [] 
    s2_data = []
    start_time = _start
    end_time = _end

    if @factory
      @emp_infs = EmpInf.where(['factory_id = ? and pdt_time between ? and ?', @factory.id, _start, _end]).order('pdt_time')
      @emp_infs.each do |inf|
        time << inf.pdt_time.strftime("%Y-%m-%d %H")
        s1_data << inf.flow
        s2_data << inf[quota_title.to_sym]
      end
    end

    chart_config = {
      :time    => time,
      :s1_data => s1_data,
      :s2_data => s2_data,
      :start_time => start_time.strftime("%Y-%m-%d %H"),
      :end_time   => end_time.strftime("%Y-%m-%d %H"),  
      :title_text => '水质流量关系图',
      :title_subtext => '数据来自济宁市环境监测系统',
      :legend => [Setting.emp_infs.flow, MYQUOTAS[quota][:name]],
      :y1_max => 2000,
      :y2_max => s2_data.max.to_i + 100
    }
    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end

  end
   
  def xls_download
    send_file File.join(Rails.root, "templates", "emp_inf.xlsx"), :filename => "环境监测进水水质模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    tool = ExcelTool.new
    @factories = Factory.all
    @factories.each do |factory|
      factory_id = idencode(factory.id).to_s
      excel = params[factory_id]
      if excel
        if File.extname(excel.path) == '.xlsx'
          #elsif File.extname(excel.path) == '.xls'
          results = tool.parseExcel(excel.path)
          values = results.first[1][4..-5]
          if !values.nil?
            EmpInf.transaction do
              values.each_with_index do |item, index|
                index += 5 
                time = item['A' + index.to_s].strip
                next if time.blank?
                datetime = time #DateTime.strptime(time, "%Y-%m-%d %H")
                cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
                nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
                tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
                tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
                inflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
                ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
                temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

                @emp_inf = factory.emp_infs.where(:pdt_time => datetime).first
                EmpInf.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :flow => inflow, :ph => ph, :temp => temp, :factory => factory) unless @emp_inf
              end
            end
          end
        else
          next
        end
      end
    end

    redirect_to grp_index_emp_infs_path
  end 
  
  #bootstrap table分页用 暂时没有用
  def query_list
    @factory = my_factory
    @emp_infs = @factory.emp_infs.order('pdt_time DESC').paginate( :page => params[:page], :per_page => 10 ) 
    result = []
    @emp_infs.each do |inf|
      result << {
        :id        => inf.id,
        :pdt_time  => inf.pdt_time,
        :cod       => inf.cod,     
        :nhn       => inf.nhn,     
        :tp        => inf.tp,      
        :flow      => inf.flow,    
        :ph        => inf.ph,      
        :temp      => inf.temp    
      }
    end

    respond_to do |f|
      f.json{ render :json => {:rows => result}.to_json}
    end
  end


  private
    def emp_inf_params
      params.require(:emp_inf).permit( :pdt_time, :cod, :nhn, :tp, :flow, :ph, :temp)
    end
  
  
end

