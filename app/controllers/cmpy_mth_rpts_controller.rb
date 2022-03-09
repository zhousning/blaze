class CmpyMthRptsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  before_filter :get_cmpy_mth_rpt, :only => [:edit, :update, :show, :upreport, :produce_report]
  authorize_resource :except => [:download_append, :produce_report, :query_day_reports, :query_mth_reports, :xls_mth_download]

  include SmathCube 
  include CreateSmthPdtRpt 
  include UpdateSmthPdtRpt

  def index
    ccmpy = current_user.ccompany
    ncmpy = current_user.ncompany
    @mth_pdt_rpts = [] 
    @mth_pdt_rpts += ccmpy.cmpy_mth_rpts.where(:state => Setting.mth_pdt_rpts.ongoing) if ccmpy 
    @mth_pdt_rpts += ncmpy.cmpy_mth_rpts.where(:state => Setting.mth_pdt_rpts.ongoing) if ncmpy
  end

  def query_mth_reports
    _start = params[:start]
    _end = params[:end]
    _fcts = params[:fcts].split(",")

    fcts = _fcts.collect do |fct|
      iddecode(fct)
    end

    ncompany = current_user.ncompany
    ccompany = current_user.ccompany
    mth_pdt_rpts = []
    if fcts.include?(Setting.cmpy_mth_rpts.ccategory)
      mth_pdt_rpts += ncompany.cmpy_mth_rpts.where(['start_date between ? and ?', _start, _end]).order('start_date DESC')
    elsif fcts.include?(Setting.cmpy_mth_rpts.ccategory)
      mth_pdt_rpts += ccompany.cmpy_mth_rpts.where(['start_date between ? and ?', _start, _end]).order('start_date DESC')
    end

    obj = []
    mth_pdt_rpts.each_with_index do |mth_pdt_rpt, index|
      button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + idencode(mth_pdt_rpt.id).to_s + "' data-fct = '" + mth_pdt_rpt.category.to_s + "'>查看</button>"
      obj << { 
        :id          => (index + 1).to_s,
        :name        => mth_pdt_rpt.name,
        :ipt     => mth_pdt_rpt.cmpy_mth_ipt.val,
        :opt     => mth_pdt_rpt.cmpy_mth_opt.val,
        :power     => mth_pdt_rpt.cmpy_mth_power.new_val,
        :state       => mth_state(mth_pdt_rpt.state),
        :button => button
      }
    end
    respond_to do |f|
      f.json{ render :json => obj.to_json}
    end
  end

  def show
  end

  def upreport
    @mth_pdt_rpt.complete
    redirect_to cmpy_mth_rpt_path(idencode(@mth_pdt_rpt.id), :category => @mth_pdt_rpt.category) 
  end

  def smth_report_finish_index
    c1 = Factory.new({id: Setting.cmpy_mth_rpts.ccategory, name: '城镇供水'})
    c2 = Factory.new({id: Setting.cmpy_mth_rpts.ncategory, name: '农村供水'})
    @factories = [c1, c2] 
    gon.fct = ""
    @factories.each do |fct|
      gon.fct += idencode(fct[:id]).to_s + ","
    end
  end

  def smth_report_finish_show
    @factory = my_factory
    @mth_pdt_rpt = @factory.mth_pdt_rpts.find(iddecode(params[:id]))
  end
   
  def edit
  end
   
  def update
    safe_param = mth_pdt_rpt_params #一定要赋一个新对象 原对象更改不生效
    powers = compute_power(@mth_pdt_rpt, mth_pdt_rpt_params[:cmpy_mth_power_attributes])
    safe_param[:cmpy_mth_power_attributes] = powers

    if @mth_pdt_rpt.update(safe_param)
      #redirect_to edit_cmpy_mth_rpt_path(idencode(@mth_pdt_rpt.id), :category => @mth_pdt_rpt.category) 
      redirect_to cmpy_mth_rpt_path(idencode(@mth_pdt_rpt.id), :category => @mth_pdt_rpt.category) 
    else
      render :edit
    end
  end

  def smth_rpt_sync
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
    @factory = my_sfactory 
    @mth_pdt_rpt = @factory.smth_pdt_rpts.find(iddecode(params[:id]))
    obj = [@mth_pdt_rpt]

    excel_tool = SspreadSheetTool.new
    target_excel = excel_tool.exportMthPdtRptToExcel(obj)
    send_file target_excel, :filename => @mth_pdt_rpt.name + ".xls", :type => "application/force-download", :x_sendfile=>true
  end

  def produce_report 
    header = {
      :name => @mth_pdt_rpt.name
    }

    flow = flow_content(@mth_pdt_rpt) 
    ipt = ipt_content(@mth_pdt_rpt) 
    opt = opt_content(@mth_pdt_rpt) 
    power = power_content(@mth_pdt_rpt) 
    sell = sell_content(@mth_pdt_rpt) 
    #cmcbill = @mth_pdt_rpt.cmc_bill_url
    ecm_ans_rpt = @mth_pdt_rpt.ecm_ans_rpt_url
    respond_to do |format|
      format.json{ render :json => 
        {
          #:cmcbill => cmcbill,
          :flow   => flow, 
          :ecm_ans_rpt => ecm_ans_rpt,
          :fct_id => idencode(@mth_pdt_rpt.category),
          :mth_rpt_id => idencode(@mth_pdt_rpt.id),
          :header => header,
          :ipt   => ipt, 
          :sell   => sell, 
          :opt   => opt, 
          :power   => power
        }.to_json}
    end
  end

  private
  
    def mth_pdt_rpt_params
      params.require(:cmpy_mth_rpt).permit( :cmc_bill , :ecm_ans_rpt, cmpy_mth_ipt_attributes: cmpy_mth_val_params, cmpy_mth_opt_attributes: cmpy_mth_val_params, cmpy_mth_power_attributes: cmpy_mth_power_params, cmpy_mth_sell_attributes: cmpy_mth_val_params )
    end
    
    def cmpy_mth_val_params
      [:id, :val, :end_val, :max_val, :min_val, :avg_val, :max_date, :min_date, :yoy, :mom, :ypdr ,:_destroy]
    end
  
    def cmpy_mth_power_params
      #[:id, :val, :new_val, :end_val, :bom, :end_bom, :avg_val, :yoy_bom, :mom_bom, :yoy, :mom, :mbom, :end_mbom, :yoy_mbom, :mom_mbom, :_destroy]
      [:id, :val, :new_val, :end_val, :bom, :end_bom, :avg_val, :yoy_bom, :mom_bom, :yoy, :mom, :_destroy]
    end

    def compute_power(rpt, input_params)
      output_params = input_params
      new_val = input_params[:new_val].to_f
      cmpy_mth_power = rpt.cmpy_mth_power
      cmpy_mth_opt_val = rpt.cmpy_mth_opt.val

      start_date, end_date = rpt.start_date, rpt.end_date
      count = (start_date..end_date).count
      _yoy_start, _mom_start = yoy_mom_date(start_date)

      yoy_mth, mom_mth = nil, nil
      if rpt.category == Setting.cmpy_mth_rpts.ncategory 
        company = rpt.ncompany
        yoy_mth = CmpyMthRpt.where(:start_date => _yoy_start, :ncompany => company).first
        mom_mth = CmpyMthRpt.where(:start_date => _mom_start, :ncompany => company).first
      elsif rpt.category == Setting.cmpy_mth_rpts.ccategory 
        company = rpt.ccompany
        yoy_mth = CmpyMthRpt.where(:start_date => _yoy_start, :ccompany => company).first
        mom_mth = CmpyMthRpt.where(:start_date => _mom_start, :ccompany => company).first
      end

      avg_val = FormulaLib.ratio(new_val.to_f, count)
      bom = FormulaLib.kbom(new_val, cmpy_mth_opt_val)

      end_val, yoy, mom, bom_yoy, bom_mom = new_val, 0, 0, 0, 0
      if !yoy_mth.nil?
        yoy_power = yoy_mth.cmpy_mth_power
        yoy = FormulaLib.yoy(new_val, yoy_power.new_val)
        bom_yoy = FormulaLib.yoy(bom, yoy_power.bom)
      end

      if !mom_mth.nil?
        mom_power = mom_mth.cmpy_mth_power
        end_val += mom_power.end_val
        mom = FormulaLib.mom(new_val, mom_power.new_val)
        bom_mom = FormulaLib.mom(bom, mom_power.bom)
      end

      end_bom = FormulaLib.kbom(end_val, cmpy_mth_opt_val)

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
      ipt = mth_pdt_rpt.cmpy_mth_ipt
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
      opt = mth_pdt_rpt.cmpy_mth_opt
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

    def sell_content(mth_pdt_rpt)
      sell = mth_pdt_rpt.cmpy_mth_sell
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
      power = mth_pdt_rpt.cmpy_mth_power
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

  
    def get_cmpy_mth_rpt
      category = params[:category].to_i
      if category == Setting.cmpy_mth_rpts.ncategory 
        ncmpy = current_user.ncompany
        @mth_pdt_rpt = ncmpy.cmpy_mth_rpts.find(iddecode(params[:id]))
      elsif category == Setting.cmpy_mth_rpts.ccategory 
        ccmpy = current_user.ccompany
        @mth_pdt_rpt = ccmpy.cmpy_mth_rpts.find(iddecode(params[:id]))
      end
    end

end

