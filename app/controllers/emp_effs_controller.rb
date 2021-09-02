class EmpEffsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource
  authorize_resource

  include QuotaConfig

  def index
   
    @emp_eff = EmpEff.new
    @factory = my_factory
    @factories = Factory.all
    @emp_effs = @factory.emp_effs.order('pdt_time DESC').page( params[:page]).per( Setting.systems.per_page ) 
   
  end

  def grp_index
   
    @emp_eff = EmpEff.new
    @factories = Factory.all
    @emp_effs = EmpEff.order('pdt_time DESC').page( params[:page]).per( Setting.systems.per_page ) 
   
  end

  #def new
  #  @emp_eff = EmpEff.new
  #end
   
  def create
    @factory = my_factory
    @emp_eff = EmpEff.new(emp_eff_params)
    @emp_eff.factory = @factory
    year = emp_eff_params['pdt_time(1i)'].to_i
    month = emp_eff_params['pdt_time(2i)'].to_i
    day = emp_eff_params['pdt_time(3i)'].to_i
    hour = emp_eff_params['pdt_time(4i)'].to_i
    minute = emp_eff_params['pdt_time(5i)'].to_i
    
    exist_emp_eff = @factory.emp_effs.where( :pdt_time => DateTime.new(year, month, day, hour) ).first

    if exist_emp_eff.nil?
      flash[:pdt_time] = year.to_s + "年" + month.to_s + "月" + day.to_s + "日" + hour.to_s + '时数据已存在'
      redirect_to :action => :index
      return
    end
     
    if @emp_eff.save
      redirect_to :action => :index
    else
      render :index
    end
  end
   
  def fct_edit
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
  end
   
  def fct_update
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
    year = emp_eff_params['pdt_time(1i)'].to_i
    month = emp_eff_params['pdt_time(2i)'].to_i
    day = emp_eff_params['pdt_time(3i)'].to_i
    hour = emp_eff_params['pdt_time(4i)'].to_i
    minute = emp_eff_params['pdt_time(5i)'].to_i
    
    exist_emp_eff = @factory.emp_effs.where( :pdt_time => DateTime.new(year, month, day, hour) ).first

    if !exist_emp_eff.nil? && exist_emp_eff.id != @emp_eff.id 
      @emp_eff.errors[:pdt_time] = year.to_s + "年" + month.to_s + "月" + day.to_s + "日" + hour.to_s + '时数据已存在'
      render :fct_edit
      return
    end

    if @emp_eff.update(emp_eff_params)
      redirect_to fct_edit_factory_emp_eff_path(idencode(@factory.id), idencode(@emp_eff.id)) 
    else
      render :fct_edit
    end
  end
   
  def fct_destroy
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
    @emp_eff.destroy if @emp_eff
    redirect_to :action => :index
  end

   
  def edit
   
    @emp_eff = EmpEff.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @emp_eff = EmpEff.find(iddecode(params[:id]))
   
    if @emp_eff.update(emp_eff_params)
      redirect_to edit_emp_eff_path(idencode(@emp_eff.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @emp_eff = EmpEff.find(iddecode(params[:id]))
    @emp_eff.destroy if @emp_eff
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
      @emp_effs = EmpEff.where(['factory_id = ? and pdt_time between ? and ?', @factory.id, _start, _end]).order('pdt_time')
      @emp_effs.each do |eff|
        time << eff.pdt_time.strftime("%Y-%m-%d %H")
        s1_data << eff.flow
        s2_data << eff[quota_title.to_sym]
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
      :legend => [Setting.emp_effs.flow, MYQUOTAS[quota][:name]],
      :y1_max => 2000,
      :y2_max => s2_data.max.to_i + 100
    }
    respond_to do |f|
      f.json{ render :json => chart_config.to_json}
    end

  end
   
  def xls_download
    send_file File.join(Rails.root, "templates", "emp_eff.xlsx"), :filename => "环境监测出水水质模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  def parse_fct_excel
    tool = ExcelTool.new
    @factory = my_factory
    excel = params['excel_file']
    if excel && File.extname(excel.path) == '.xlsx'
      results = tool.parseExcel(excel.path)
      values = results.first[1][4..-5]
      if !values.nil?
        begin
          EmpEff.transaction do
            values.each_with_index do |item, index|
              index += 5 
              time = item['A' + index.to_s].strip
              next if time.blank?
              datetime = time #DateTime.strptime(time, "%Y-%m-%d %H")
              cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
              nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
              tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
              tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
              efflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
              ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
              temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

              @emp_eff = @factory.emp_effs.where(:pdt_time => datetime).first
              EmpEff.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :flow => efflow, :ph => ph, :temp => temp, :factory => @factory) unless @emp_eff
            end
          end
        rescue
          flash[:pdt_time] = '解析失败，请按环境监测平台标准数据上传'
          redirect_to factory_emp_effs_path(idencode(@factory.id))
          return
        end
      end
    end

    redirect_to factory_emp_effs_path(idencode(@factory.id))
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
            EmpEff.transaction do
              values.each_with_index do |item, index|
                index += 5 
                time = item['A' + index.to_s].strip
                next if time.blank?
                datetime = time #DateTime.strptime(time, "%Y-%m-%d %H")
                cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
                nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
                tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
                tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
                efflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
                ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
                temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

                @emp_eff = factory.emp_effs.where(:pdt_time => datetime).first
                EmpEff.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :flow => efflow, :ph => ph, :temp => temp, :factory => factory) unless @emp_eff
              end
            end
          end
        else
          next
        end
      end
    end

    redirect_to grp_index_emp_effs_path
  end 
  
  

  private
    def emp_eff_params
      params.require(:emp_eff).permit( :pdt_time, :cod, :nhn, :tp, :flow, :ph, :temp)
    end
  
  
  
end

