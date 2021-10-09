ActiveAdmin.register Mudfct  do

  permit_params  :name, :ability
  actions :all, :except => [:destroy]

  menu label: Setting.mudfcts.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :name, :label => Setting.mudfcts.name
  filter :ability, :label => Setting.mudfcts.ability
  filter :created_at

  index :title=>Setting.mudfcts.label + "管理" do
    selectable_column
    id_column
    
    column Setting.mudfcts.name, :name
    column Setting.mudfcts.ability, :ability

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.mudfcts.label do
      
      f.input :name, :label => Setting.mudfcts.name 
      f.input :ability, :label => Setting.mudfcts.ability 
    end
    f.actions
  end

  show :title=>Setting.mudfcts.label + "信息" do
    attributes_table do
      row "ID" do
        mudfct.id
      end
      
      row Setting.mudfcts.name do
        mudfct.name
      end
      row Setting.mudfcts.ability do
        mudfct.ability
      end

      row "创建时间" do
        mudfct.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        mudfct.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
