ActiveAdmin.register MthPdtRpt  do

  permit_params :name, :start_date

  menu label: Setting.mth_pdt_rpts.label
  config.per_page = 20
  config.sort_order = "start_date_desc"

  actions :all, :except => [:destroy]

  
  filter :name, :label => Setting.mth_pdt_rpts.name
  filter :start_date, :label => Setting.mth_pdt_rpts.start_date
  #filter :created_at

  #action_item :only => [:show, :edit] do
  action_item :only => [:show, :edit] do
  end

  index :title=>Setting.mth_pdt_rpts.label + "管理" do
    selectable_column
    id_column
    
    column Setting.mth_pdt_rpts.name, :name
    column Setting.mth_pdt_rpts.start_date, :start_date, :sortable=> :start_date do |f|
      f.start_date.strftime('%Y-%m-%d')
    end
    #column "创建时间", :created_at do |f|
    #  f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    #end

    column "状态" do |f|
      mth_pdt_rpt = f
      if mth_pdt_rpt.state == Setting.mth_pdt_rpts.complete
        Setting.mth_pdt_rpts.complete_t
      elsif mth_pdt_rpt.state == Setting.mth_pdt_rpts.ongoing
        Setting.mth_pdt_rpts.ongoing_t
      elsif mth_pdt_rpt.state == Setting.mth_pdt_rpts.verifying
        Setting.mth_pdt_rpts.verifying_t
      elsif mth_pdt_rpt.state == Setting.mth_pdt_rpts.rejected
        Setting.mth_pdt_rpts.rejected_t
      elsif mth_pdt_rpt.state == Setting.mth_pdt_rpts.cmp_verifying
        Setting.mth_pdt_rpts.cmp_verifying_t
      elsif mth_pdt_rpt.state == Setting.mth_pdt_rpts.cmp_rejected
        Setting.mth_pdt_rpts.cmp_rejected_t
      end
    end
    #column "更新时间", :updated_at do |f|
    #  f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    #end
    actions do |mth_pdt_rpt|
      link_to('重报', reject_mth_jackadmin_mth_pdt_rpt_path(mth_pdt_rpt.id))
    end
  end

  member_action :reject_mth do
    mth_pdt_rpt = MthPdtRpt.find(params[:id])
    mth_pdt_rpt.ongoing
    redirect_to jackadmin_mth_pdt_rpts_path
  end


  form do |f|
    f.inputs "添加" + Setting.mth_pdt_rpts.label do
      
      f.input :name, :label => Setting.mth_pdt_rpts.name 
      #f.input :start_date, :label => Setting.mth_pdt_rpts.start_date 
    end
    f.actions
  end

  show :title=>Setting.mth_pdt_rpts.label + "信息" do
    attributes_table do
      row "ID" do
        mth_pdt_rpt.id
      end
      
      row Setting.mth_pdt_rpts.name do
        mth_pdt_rpt.name
      end
      #row Setting.mth_pdt_rpts.start_date do
      #  mth_pdt_rpt.start_date
      #end

      row "创建时间" do
        mth_pdt_rpt.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        mth_pdt_rpt.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end

