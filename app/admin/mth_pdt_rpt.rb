ActiveAdmin.register MthPdtRpt  do

  permit_params  :outflow
  actions :all, :except => [:destroy]

  menu label: Setting.mth_pdt_rpts.label
  config.per_page = 20
  config.sort_order = "id_asc"
  
  filter :outflow, :label => Setting.mth_pdt_rpts.outflow
  filter :avg_outflow, :label => Setting.mth_pdt_rpts.avg_outflow
  filter :end_outflow, :label => Setting.mth_pdt_rpts.end_outflow
  filter :created_at

  index :title=>Setting.mth_pdt_rpts.label + "管理" do
    selectable_column
    id_column
    
    column Setting.mth_pdt_rpts.name, :name
    column Setting.mth_pdt_rpts.outflow, :outflow

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.mth_pdt_rpts.label do
      
      f.input :code, :label => Setting.mth_pdt_rpts.code 
      f.input :name, :label => Setting.mth_pdt_rpts.name 
    end
    f.actions
  end

  show :title=>Setting.mth_pdt_rpts.label + "信息" do
    attributes_table do
      row "ID" do
        mth_pdt_rpt.id
      end
      
      row Setting.mth_pdt_rpts.code do
        mth_pdt_rpt.code
      end
      row Setting.mth_pdt_rpts.name do
        mth_pdt_rpt.name
      end

      row "创建时间" do
        mth_pdt_rpt.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        mth_pdt_rpt.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
