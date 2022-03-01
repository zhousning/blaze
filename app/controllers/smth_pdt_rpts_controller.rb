class SmthPdtRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  authorize_resource :except => [:download_append, :produce_report, :query_day_reports, :query_mth_reports]

  include SmathCube 
  include CreateSmthPdtRpt 
  include UpdateSmthPdtRpt

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
    _start = params[:start]
    _end = params[:end]
    _fcts = params[:fcts].split(",")

    fcts = _fcts.collect do |fct|
      iddecode(fct)
    end

    mth_pdt_rpts = SmthPdtRpt.where(['start_date between ? and ? and sfactory_id in (?) and state = ?', _start, _end, fcts, Setting.mth_pdt_rpts.complete]).order('start_date DESC')

    obj = []
    mth_pdt_rpts.each_with_index do |mth_pdt_rpt, index|
      button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + idencode(mth_pdt_rpt.id).to_s + "' data-fct = '" + idencode(mth_pdt_rpt.sfactory.id).to_s + "'>查看</button>"
      obj << { 
        :id          => (index + 1).to_s,
        :name        => mth_pdt_rpt.name,
        :ipt     => mth_pdt_rpt.smonth_ipt.val,
        :opt     => mth_pdt_rpt.smonth_opt.val,
        :power     => mth_pdt_rpt.smonth_power.new_val,
        :state       => mth_state(mth_pdt_rpt.state),
        :button => button
      }
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
    @factories = current_user.sfactories.all
    gon.fct = ""
    @factories.each do |fct|
      gon.fct += idencode(fct.id).to_s + ","
    end
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
    @factory = my_sfactory 
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
   
    safe_param = mth_pdt_rpt_params #一定要赋一个新对象 原对象更改不生效
    powers = compute_power(@mth_pdt_rpt, mth_pdt_rpt_params[:smonth_power_attributes])
    safe_param[:smonth_power_attributes] = powers

    if @mth_pdt_rpt.update(safe_param)
      redirect_to sfactory_smth_pdt_rpt_path(idencode(@factory.id), idencode(@mth_pdt_rpt.id)) 
    else
      render :edit
    end
  end

  def smth_rpt_sync
    @factory = my_sfactory 
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    result = update_smth_pdt_rpt(@mth_pdt_rpt)

    respond_to do |format|
      format.json{ render :json => 
        {
          cms: result[:water],
        }.to_json
      }
    end
  end

  def download_append
   
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
   
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
    @factory = my_sfactory
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    header = {
      :name => @mth_pdt_rpt.name
    }

    flow = flow_content(@mth_pdt_rpt) 
    ipt = ipt_content(@mth_pdt_rpt) 
    opt = opt_content(@mth_pdt_rpt) 
    power = power_content(@mth_pdt_rpt) 
    press = press_content(@mth_pdt_rpt) 
    sell = sell_content(@mth_pdt_rpt) 
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
          :ipt   => ipt, 
          :flow   => flow, 
          :opt   => opt, 
          :sell   => sell, 
          :power   => power, 
          :press   => press 
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
      #[:id, :val, :new_val, :end_val, :bom, :end_bom, :avg_val, :yoy_bom, :mom_bom, :yoy, :mom, :mbom, :end_mbom, :yoy_mbom, :mom_mbom, :_destroy]
      [:id, :val, :new_val, :end_val, :bom, :end_bom, :avg_val, :yoy_bom, :mom_bom, :yoy, :mom, :_destroy]
      #[:id, :val, :new_val, :_destroy]
    end

    def smonth_press_params
      [:id, :max_val, :min_val, :avg_val, :max_date, :min_date, :_destroy]
    end

    def compute_power(rpt, input_params)
      output_params = input_params
      new_val = input_params[:new_val].to_f
      smonth_power = rpt.smonth_power
      smonth_opt_val = rpt.smonth_opt.val
      factory = rpt.sfactory

      start_date, end_date = rpt.start_date, rpt.end_date
      count = (start_date..end_date).count
      _yoy_start, _mom_start = yoy_mom_date(start_date)

      yoy_mth = SmthPdtRpt.where(:start_date => _yoy_start, :sfactory => factory).first
      mom_mth = SmthPdtRpt.where(:start_date => _mom_start, :sfactory => factory).first

      avg_val = FormulaLib.ratio(new_val.to_f, count)
      bom = FormulaLib.kbom(new_val, smonth_opt_val)

      end_val, yoy, mom, bom_yoy, bom_mom = new_val, 0, 0, 0, 0
      if !yoy_mth.nil?
        yoy_power = yoy_mth.smonth_power
        yoy = FormulaLib.yoy(new_val, yoy_power.new_val)
        bom_yoy = FormulaLib.yoy(bom, yoy_power.bom)
      end

      if !mom_mth.nil?
        mom_power = mom_mth.smonth_power
        end_val += mom_power.end_val
        mom = FormulaLib.mom(new_val, mom_power.new_val)
        bom_mom = FormulaLib.mom(bom, mom_power.bom)
      end

      end_bom = FormulaLib.kbom(end_val, smonth_opt_val)

      output_params[:end_val] = end_val
      output_params[:bom] = bom
      output_params[:end_bom] = end_bom
      output_params[:avg_val] = avg_val
      output_params[:yoy_bom] = bom_yoy
      output_params[:mom_bom] = bom_mom
      output_params[:bom] = bom
      output_params[:yoy] = yoy

      output_params
    end

    def flow_content(mth_pdt_rpt)
      targets = ['leakage', '']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        if !t.blank?
          title += [Setting.smth_pdt_rpts[t], mth_pdt_rpt[t]]
        else
          title += ['', '']
        end
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
    end

    def ipt_content(mth_pdt_rpt)
      ipt = mth_pdt_rpt.smonth_ipt
      targets = ['val', 'end_val', 'avg_val', '', 'yoy', 'mom', 'max_val', 'max_date', 'min_val', 'min_date']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        if !t.blank?
          title += [Setting.smonth_ipts[t], ipt[t]]
        else
          title += ['', '']
        end
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
    end

    def opt_content(mth_pdt_rpt)
      opt = mth_pdt_rpt.smonth_opt
      targets = ['val', 'end_val', 'avg_val', '', 'yoy', 'mom', 'max_val', 'max_date', 'min_val', 'min_date']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        if !t.blank?
          title += [Setting.smonth_opts[t], opt[t]]
        else
          title += ['', '']
        end
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
    end

    def press_content(mth_pdt_rpt)
      press = mth_pdt_rpt.smonth_press
      targets = ['max_val', 'max_date', 'min_val', 'min_date', 'avg_val', '']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        if !t.blank?
          title += [Setting.smonth_presses[t], press[t]]
        else
          title += ['', '']
        end
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
    end

    def sell_content(mth_pdt_rpt)
      sell = mth_pdt_rpt.smonth_sell
      targets = ['val', 'end_val', 'avg_val', 'yoy', 'mom']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        title += [Setting.smonth_sells[t], sell[t]]
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
    end

    def power_content(mth_pdt_rpt)
      power = mth_pdt_rpt.smonth_power
      targets = ['new_val', 'end_val', 'val', 'avg_val', 'yoy', 'mom', 'bom', 'end_bom', 'yoy_bom', 'mom_bom']
      arr = []
      title = []
      targets.each_with_index do |t, index|
        title += [Setting.smonth_powers[t], power[t]]
        if (index+1)%2 == 0
          arr << title
          title = []
        end
      end
      arr
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

