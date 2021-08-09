ActiveAdmin.register Quota  do

  permit_params  :name, :code, :ctg

  menu label: Setting.quota.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :name, :label => Setting.quota.name
  filter :code, :label => Setting.quota.code
  filter :ctg, :label => Setting.quota.ctg
  filter :created_at

  index :title=>Setting.quota.label + "管理" do
    selectable_column
    id_column
    
    column Setting.quota.name, :name
    column Setting.quota.code, :code
    column Setting.quota.ctg, :ctg
    column Setting.quota.max, :max
    column Setting.quota.min, :min

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.quota.label do
      
      f.input :name, :label => Setting.quota.name 
      f.input :code, :label => Setting.quota.code 
      f.input :ctg, :label => Setting.quota.ctg 
      f.input :max, :label => Setting.quota.max 
      f.input :min, :label => Setting.quota.min 
    end
    f.actions
  end

  show :title=>Setting.quota.label + "信息" do
    attributes_table do
      row "ID" do
        quota.id
      end
      
      row Setting.quota.name do
        quota.name
      end
      row Setting.quota.code do
        quota.code
      end
      row Setting.quota.ctg do
        quota.ctg
      end
      row Setting.quota.max do
        quota.max
      end
      row Setting.quota.min do
        quota.min
      end

      row "创建时间" do
        quota.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        quota.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
