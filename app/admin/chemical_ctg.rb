ActiveAdmin.register ChemicalCtg  do

  permit_params  :code, :name
  actions :all, :except => [:destroy]

  menu label: Setting.chemical_ctgs.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :code, :label => Setting.chemical_ctgs.code
  filter :name, :label => Setting.chemical_ctgs.name
  filter :created_at

  index :title=>Setting.chemical_ctgs.label + "管理" do
    selectable_column
    id_column
    
    column Setting.chemical_ctgs.code, :code
    column Setting.chemical_ctgs.name, :name

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.chemical_ctgs.label do
      
      f.input :code, :label => Setting.chemical_ctgs.code 
      f.input :name, :label => Setting.chemical_ctgs.name 
    end
    f.actions
  end

  show :title=>Setting.chemical_ctgs.label + "信息" do
    attributes_table do
      row "ID" do
        chemical_ctg.id
      end
      
      row Setting.chemical_ctgs.code do
        chemical_ctg.code
      end
      row Setting.chemical_ctgs.name do
        chemical_ctg.name
      end

      row "创建时间" do
        chemical_ctg.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        chemical_ctg.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
