class SmthPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:download_append, :produce_report, :query_day_reports, :query_mth_reports]

  include MathCube 
  include CreateMthPdtRpt 
  include UpdateMthPdtRpt

  #CMS = ['cod', 'bod', 'nhn', 'tn', 'tp', 'ss', 'fecal']
  #VARVALUE = ['avg_inf', 'avg_eff', 'emr', 'avg_emq', 'emq', 'end_emq','up_std', 'end_std', 'yoy', 'mom']  
  CMS = ['cod', 'bod', 'nhn', 'tn', 'tp', 'ss']
  VARVALUE = ['avg_inf', 'avg_eff', 'emr', 'avg_emq', 'emq', 'end_emq', 'yoy', 'mom']  
  CMS.each do |c|
    VARVALUE.each do |v|
      define_method "#{c}_#{v}" do |obj|
        obj[v].nil? ? '' : obj[v].to_s
      end
    end
  end
  CMS.each do |c|
    VARVALUE.each do |v|
      define_method "c#{c}_#{v}" do |obj|
        obj[v].nil? ? '' : obj[v].to_s
      end
    end
  end

  def index
    fcts = current_user.sfactories.all.pluck(:id)
    states = [Setting.mth_pdt_rpts.ongoing, Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]
    @mth_pdt_rpts = SmthPdtRpt.where(['sfactory_id in (?) and state in (?)', fcts, states]).order('start_date DESC').page( params[:page]).per( Setting.systems.per_page )
  end

  def query_mth_reports 
    fcts = params[:fcts].gsub(/\s/, '').split(",")
    fcts = fcts.collect do |fct|
      iddecode(fct)
    end
    year = params[:year].strip.to_i
    month = params[:month].strip.to_i

    _start = Date.new(year, month, 1)
    @factories = Sfactory.find(fcts)

    obj = []
    @factories.each do |fct|
      mth_pdt_rpts = fct.mth_pdt_rpts.where(:start_date => _start)
      mth_pdt_rpts.each do |mth_pdt_rpt|
        button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + idencode(mth_pdt_rpt.id) + "' data-fct = '" + idencode(fct.id) +"'>查看</button>"
        obj << { 
          :id          => idencode(mth_pdt_rpt.id).to_s,
          :name        => mth_pdt_rpt.name,
          :ipt     => mth_pdt_rpt.ipt,
          :opt     => mth_pdt_rpt.opt,
          :power     => mth_pdt_rpt.power,
          :state       => mth_state(mth_pdt_rpt.state),
          :button => button
        }
      end
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def show
    @factory = my_sfactory
   
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
   
  end

  def verify_index
    @mth_pdt_rpts = [] 
    @sfactories = current_user.sfactories.all
    @sfactories.each do |sfactory|
      @mth_pdt_rpts += sfactory.smth_pdt_rpts.where(:state => [Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]).order("start_date DESC")
    end
  end

  def verify_show
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
  end

  def verifying
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.verifying
    redirect_to sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end
  
  def rejected
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.rejected
    redirect_to verify_show_sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def cmp_verify_index
    @mth_pdt_rpts = [] 
    @sfactories = current_user.sfactories.all
    @sfactories.each do |sfactory|
      @mth_pdt_rpts += sfactory.smth_pdt_rpts.where(:state => [Setting.mth_pdt_rpts.verifying, Setting.mth_pdt_rpts.rejected, Setting.mth_pdt_rpts.cmp_verifying, Setting.mth_pdt_rpts.cmp_rejected]).order("start_date DESC")
    end
  end
  
  def cmp_verify_show
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
  end

  def cmp_verifying
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.cmp_verifying
    redirect_to verify_show_sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end
  
  def cmp_rejected
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    @mth_pdt_rpt.cmp_rejected
    redirect_to cmp_verify_show_sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def upreport
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))

    @mth_pdt_rpt.complete
    redirect_to cmp_verify_show_sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
  end

  def smth_report_finish_index
    @factory = my_factory
    @mth_pdt_rpts = @factory.mth_pdt_rpts.where(:state => Setting.mth_pdt_rpts.complete).order('start_date DESC')
  end

  def smth_report_finish_show
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
  end
   

  def smth_rpt_create
    @factory = my_factory
    month = params[:month].strip.to_i
    year = params[:year].strip.to_i
    time = Time.new
    now_year = time.year

    search_month = Date.new(year, month)
    now_month = Date.new(now_year, time.month)
    if now_month <= search_month
      redirect_to :action => :index
      return
    end

    _year_start = Date.new(year, 1, 1)
    _start = Date.new(year, month, 1)
    _end = Date.new(year, month, -1)
    @mth_pdt_rpts_cache = @factory.mth_pdt_rpts.where(["start_date = ? and end_date = ?", _start, _end])
    unless @mth_pdt_rpts_cache.blank?
      redirect_to :action => :index
      return
    end

    status = create_mth_pdt_rpt(@factory, year, month, Setting.mth_pdt_rpts.ongoing)

    if status == 'success'
      flash[:info] = "月度报表生成成功"
    elsif status == 'fail'
      flash[:info] = "月度报表生成失败"
    elsif status == 'zero'
      flash[:info] = "选定月份暂无数据"
    end
    redirect_to :action => :index
  end

      
   
  def edit
    @factory = my_sfactory 
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
  end
   

   
  def update
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
    if @mth_pdt_rpt.update(mth_pdt_rpt_params)
      cal_per_cost(@mth_pdt_rpt)
      redirect_to factory_mth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
    else
      render :edit
    end
  end

  def mth_rpt_sync
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    _start = @mth_pdt_rpt.start_date
    _end = @mth_pdt_rpt.end_date
    cmc_hash = chemicals_hash
    result = update_mth_pdt_rpt(@mth_pdt_rpt)


    select_str = "
      chemicals.name chemical_id, 
      ifnull(sum(dosage),    0) sum_dosage, 
      ifnull(avg(dosage),    0) avg_dosage
    "
    chemicals = Chemical.joins(:day_pdt_rpt).where(["day_pdt_rpts.factory_id = ? and day_pdt_rpts.pdt_date between ? and ?", @factory.id, _start, _end]).select(select_str).group(:name)
    my_chemicals = [] 
    chemicals.each do |chemical|
      dosage = format("%0.2f", chemical.sum_dosage).to_f
      avg_dosage = format("%0.2f", chemical.avg_dosage).to_f
      id = chemical.chemical_id.to_s
      my_chemicals <<
        { 
          :chemical_code => id,
          :chemical_title => cmc_hash[id],
          :dosage => dosage,
          :avg_dosage => avg_dosage
        }
    end

    respond_to do |format|
      format.json{ render :json => 
        {
          cms: result[:cms],
          flow: result[:flow],
          chemicals: my_chemicals
        }.to_json
      }
    end
  end

  def download_append
   
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
   
    @ecm_ans_rpt = @mth_pdt_rpt.ecm_ans_rpt_url

    if @ecm_ans_rpt
      send_file File.join(Rails.root, "public", URI.decode(@ecm_ans_rpt)), :type => "application/force-download", :x_sendfile=>true
    end
  end
  


  def download_report
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))

    docWorker = ExportMthDoc.new
    target_word = docWorker.process(@mth_pdt_rpt.id)
    send_file target_word, :filename => @mth_pdt_rpt.name + ".docx", :type => "application/force-download", :x_sendfile=>true
  end
  
  def xls_mth_download
    @factory = my_factory 
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    obj = [@mth_pdt_rpt]

    excel_tool = SpreadSheetTool.new
    target_excel = excel_tool.exportMthPdtRptToExcel(obj)
    send_file target_excel, :filename => @mth_pdt_rpt.name + ".xls", :type => "application/force-download", :x_sendfile=>true
  end

  def produce_report 
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
    header = {
      :name => @mth_pdt_rpt.name
    }

    flow = flow_content(@mth_pdt_rpt) 
    cms = cms_content(@mth_pdt_rpt) 
    chemical = chemical_content(@mth_pdt_rpt) 
    power = power_content(@mth_pdt_rpt) 
    mud = mud_content(@mth_pdt_rpt) 
    md = md_content(@mth_pdt_rpt) 
    cmcbill = @mth_pdt_rpt.cmc_bill_url
    ecm_ans_rpt = @mth_pdt_rpt.ecm_ans_rpt_url
    respond_to do |format|
      format.json{ render :json => 
        {
          :cmcbill => cmcbill,
          :ecm_ans_rpt => ecm_ans_rpt,
          :fct_id => idencode(@factory.id),
          :mth_rpt_id => idencode(@mth_pdt_rpt.id),
          :header => header,
          :flow   => flow, 
          :cms    => cms,
          :power => power,
          :mud => mud,
          :md  => md,
          :chemical => chemical
        }.to_json}
    end
  end

  private
  
    def mth_pdt_rpt_params
      params.require(:smth_pdt_rpt).permit( :cmc_bill , :ecm_ans_rpt, smonth_ipt_attributes: smonth_val_params, smonth_opt_attributes: smonth_val_params, smonth_power_attributes: smonth_power_params, smonth_sell_attributes: smonth_val_params, smonth_press_attributes: smonth_press_params )
    end
    
    def smonth_val_params
      [:id, :val, :end_val, :max_val, :min_val, :avg_val, :max_date, :min_date, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def smonth_power_params
      [:id, :val, :new_val, :end_val, :bom, :end_bom, :avg_val, :yoy_bom, :mom_bom, :yoy, :mom, :mbom, :end_mbom, :yoy_mbom, :mom_mbom, :_destroy]
    end

    def smonth_press_params
      [:id, :max_val, :min_val, :avg_val, :max_date, :min_date, :_destroy]
    end

    def power_content(mth_pdt_rpt)
      power = mth_pdt_rpt.month_power
      power_targets =['power', 'stdpower', 'end_power', 'bom', 'yoy_power', 'mom_power', 'yoy_bom', 'mom_bom' ]
      power_arr = []
      power_title = []
      power_targets.each_with_index do |t, index|
        power_title += [Setting.month_powers[t], power[t]]
        if (index+1)%2 == 0
          power_arr << power_title
          power_title = []
        end
      end
      power_arr
    end


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

