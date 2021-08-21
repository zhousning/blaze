class EmpInfsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
   
    @emp_inf = EmpInf.new
    @factory = my_factory
    @factories = Factory.all
    @emp_infs = @factory.emp_infs.order('pdt_time DESC') 
   
  end
   
  def new
    @emp_inf = EmpInf.new
  end
   
  def create
    @factory = my_factory
    @emp_inf = EmpInf.new(emp_inf_params)
    @emp_inf.factory = @factory
     
    if @emp_inf.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @factory = my_factory
    @emp_inf = @factory.emp_infs.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @factory = my_factory
    @emp_inf = @factory.emp_infs.find(iddecode(params[:id]))
   
    if @emp_inf.update(emp_inf_params)
      redirect_to edit_factory_emp_inf_path(idencode(@factory.id), idencode(@emp_inf.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @factory = my_factory
    @emp_inf = @factory.emp_infs.find(iddecode(params[:id]))
   
    @emp_inf.destroy if @emp_inf
    redirect_to :action => :index
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
        time << inf.pdt_time
        s1_data << inf.flow
        s2_data << inf[quota_title.to_sym]
      end
    end

    chart_config = {
      :time    => time,
      :s1_data => s1_data,
      :s1_data => s2_data,
      :start_time => start_time,
      :end_time   => end_time  
    }
    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end

  end
   
  def emp_quota(quota)
    obj = {
      Setting.quota.cod => 'cod', 
      Setting.quota.nhn => 'nhn',
      Setting.quota.tp  => 'tp'
    }
    obj[quota]
  end

  def xls_download
    send_file File.join(Rails.root, "templates", "emp_inf.xlsx"), :filename => "环境监测进水水质模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)
    fct = iddecode(params[:factory_id])
    @my_factory = my_factory
    @factory = current_user.factories.find(fct)

    if @factory && !results["Sheet1"][4..-1].nil?
      EmpInf.transaction do
        results["Sheet1"][4..-1].each_with_index do |item, index|
          index += 5 
          time = item['A' + index.to_s].strip
          if /\d\d\d\d-\d\d-\d\d/.match(time)
            datetime = time.to_datetime #DateTime.strptime(time, "%Y-%m-%d %H")
            cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
            nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
            tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
            tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
            inflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
            ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
            temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

            @emp_inf = @factory.emp_infs.where(:pdt_time => datetime).first
            EmpInf.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :flow => inflow, :ph => ph, :temp => temp, :factory => @factory) unless @emp_inf
          end
        end
      end
    end

    redirect_to factory_emp_infs_path(idencode(@my_factory.id)) 
  end 
  

  private
    def emp_inf_params
      params.require(:emp_inf).permit( :pdt_time, :cod, :nhn, :tp, :flow, :ph, :temp)
    end
  
  
end

