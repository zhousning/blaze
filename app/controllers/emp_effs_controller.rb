class EmpEffsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

  def index
   
    @emp_eff = EmpEff.new
    @factory = my_factory
    @factories = Factory.all
    @emp_effs = @factory.emp_effs.order('pdt_time DESC') 
   
  end
   

  def new
    @emp_eff = EmpEff.new
  end
   
  def create
    @factory = my_factory
    @emp_eff = EmpEff.new(emp_eff_params)
    @emp_eff.factory = @factory

    if @emp_eff.save
      redirect_to :action => :index
    else
      render :new
    end
  end
   

   
  def edit
   
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
   
  end
   

   
  def update
   
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
   
    if @emp_eff.update(emp_eff_params)
      redirect_to edit_factory_emp_eff_path(idencode(@factory.id), idencode(@emp_eff.id)) 
    else
      render :edit
    end
  end
   

   
  def destroy
   
    @factory = my_factory
    @emp_eff = @factory.emp_effs.find(iddecode(params[:id]))
   
    @emp_eff.destroy if @emp_eff
    redirect_to :action => :index
  end
   
   

  def xls_download
    send_file File.join(Rails.root, "templates", "emp_eff.xlsx"), :filename => "环境监测出水水质模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)
    fct = iddecode(params[:factory_id])
    @my_factory = my_factory
    @factory = current_user.factories.find(fct)

    if @factory && !results["Sheet1"][4..-1].nil?
      EmpEff.transaction do
        results["Sheet1"][4..-1].each_with_index do |item, index|
          index += 5 
          time = item['A' + index.to_s].strip
          if /\d\d\d\d-\d\d-\d\d/.match(time)
            datetime = time.to_datetime #DateTime.strptime(time, "%Y-%m-%d %H")
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
      end
    end

    redirect_to factory_emp_effs_path(idencode(@my_factory.id)) 
  end 

  private
    def emp_eff_params
      params.require(:emp_eff).permit( :pdt_time, :cod, :nhn, :tp, :flow, :ph, :temp)
    end
  
  
  
end

