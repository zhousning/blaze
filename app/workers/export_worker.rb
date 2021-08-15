require "sablon"

class ExportWorker
  include Sidekiq::Worker

  FOLDER_PUBLIC = File.join(Rails.root, "public")
  MONTH_REPORT = File.join(Rails.root, "app", "workers", "templates", "monthreport.docx")

  def perform(mth_pdt_rpt_id, document_id)
    @mth_pdt_rpt = MthPdtRpt.find(mth_pdt_rpt_id)
    @document = Document.find(document_id)
    @document.update_attribute :status, Setting.documents.status_process

    begin
      export_process(@mth_pdt_rpt, @document)
      @document.update_attribute :status, Setting.documents.status_success
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect 
      @document.update_attribute :status, Setting.documents.status_fail
    end
  end

  def export_process(mth_pdt_rpt, document)

    target_folder = Rails.root.join("public", "mth_pdt_rpts", mth_pdt_rpt.name).to_s
    FileUtils.makedirs(target_folder) unless File.directory?(target_folder)
    target_docx = target_folder + '/' + mth_pdt_rpt.name + '.docx'

    #docx = Caracal::Document.new(target_folder + '/' + mth_pdt_rpt.name + '.docx')
    #style_config(docx)

    #new_report(objs, target_folder, docx)

    #docx.save

    template = Sablon.template(File.expand_path(MONTH_REPORT))
    context = {
      title: mth_pdt_rpt.name,
      cod: mth_pdt_rpt.month_cod,
      bod: mth_pdt_rpt.month_bod,
      tp: mth_pdt_rpt.month_tp,
      tn: mth_pdt_rpt.month_tn,
      ss: mth_pdt_rpt.month_ss,
      nhn: mth_pdt_rpt.month_nhn,
      power: mth_pdt_rpt.month_power,
      mud: mth_pdt_rpt.month_mud,
      md: mth_pdt_rpt.month_md,
      fecal: mth_pdt_rpt.month_fecal,
      device: mth_pdt_rpt.month_device,
      stuff: mth_pdt_rpt.month_stuff,
      technologies: ["Ruby", "HTML", "ODF"]
    }
    template.render_to_file File.expand_path(target_docx), context

    document.update_attribute :html_link, document.title + '.docx'
  end

  #def new_report(objs, target_folder, docx)
  #  nodeid = node['nodeid']
  #  name = node['name']
  #  index_str = index.to_s
  #  level += "/#{index_str}_#{name}" 
  #  title_level += 1

  #  isParent = node['isParent']
  #  if isParent
  #    FileUtils.makedirs(level) unless File.directory?(level)

  #    front_cover_dir = target_folder + "/封皮/" + title_level.to_s + "级封皮"
  #    front_cover(front_cover_dir, name)

  #    category(title_level, index_str, name, docx)
  #  else
  #    if nodeid
  #      @file = FileLib.find(nodeid)
  #      if @file
  #        FileUtils.cp FOLDER_PUBLIC + @file.path, level
  #        docx.p "#{index}、#{name}" do 
  #          style 'p'
  #        end
  #      end
  #    end
  #  end

  #  if node['children'] 
  #    node['children'].each_with_index do |obj, index|
  #      hier(obj, level, index+1, title_level, target_folder, docx)
  #    end
  #  end
  #end


  def category(title_level, index, name, docx)
    if title_level == 1
      docx.h1 "#{index} #{name}" 
    elsif title_level == 2 
      docx.page
      docx.h2 "#{number_map(index)}、#{name}" do
        style 'h2'
      end
    elsif title_level == 3
      docx.h3 "（#{number_map(index)}）#{name}" do 
        style 'h3'
      end
    elsif title_level == 4 
      docx.h4 "( #{index} )、#{name}" do 
        style 'h4'
      end
    else
      docx.p "#{index}、#{name}" do 
        style 'p'
      end
    end
  end

  def create_report(docx, name)
    template = Sablon.template(File.expand_path(MONTH_REPORT))
    context = {
      title: name,
      technologies: ["Ruby", "HTML", "ODF"]
    }
    template.render_to_file File.expand_path(docx), context
  end

  def style_config(docx)
    docx.style do
      id "h2"
      name "h2"
      font "黑体"
      size 40
      bold true
      italic false
    end
    docx.style do
      id "h3"
      name "h3"
      font "黑体"
      size 36
      bold true
      italic false
    end
    docx.style do
      id "h4"
      name "h4"
      font "黑体"
      size 32
      bold true
      italic false
      indent_left 340
    end
    docx.style do
      id "p"
      name "p"
      font "宋体"
      size 30
      bold false 
      italic false
      indent_left 360
    end
  end

  def number_map(number)
    number = number.to_s
    obj = {
      "1" => "一", 
      "2" => "二", 
      "3" => "三", 
      "4" => "四", 
      "5" => "五"
    }
    obj[number]
  end
end
