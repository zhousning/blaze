class EmpInfsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
   
    @factory = my_factory
    @factories = Factory.all
    @emp_infs = @factory.emp_infs.order('pdt_time DESC') 
   
  end
   

   

  def xls_download
    send_file File.join(Rails.root, "public", "templates", "表格模板.xlsx"), :filename => "表格模板.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  
  
  
  def parse_excel
    excel = params["excel_file"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)
    fct = iddecode(params[:fcts])
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

