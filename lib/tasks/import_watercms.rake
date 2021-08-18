require 'yaml'
require 'logger'
require 'find'
require 'creek'

namespace 'db' do
  desc "import water cms"
  task(:import_watercms => :environment) do
    exec_import
  end
end

def exec_import
  
  base_dir = "lib/tasks/data/inoutcms2/" 

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      parse_excel(xls)
    end
  end
end

def parse_excel(xls)
  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  a_str = ""
  b_str = ""
  c_str = "" 
  d_str = ""
  e_str = ""
  f_str = ""
  g_str = ""

  #results['4.2'][6..22].each_with_index do |row, index|
  #  row.each do |k, v|
  #    if !(/A/ =~ k).nil?
  #      a_str = v.nil? ? "" : v 
  #    elsif !(/B/ =~ k).nil?
  #      b_str = v.nil? ? "" : v 
  #    elsif !(/C/ =~ k).nil?
  #      c_str = v.nil? ? "" : v 
  #    elsif !(/D/ =~ k).nil?
  #      d_str = v.nil? ? "" : v 
  #    elsif !(/E/ =~ k).nil?
  #      e_str = v.nil? ? "" : v 
  #    elsif !(/F/ =~ k).nil?
  #      f_str = v.nil? ? "" : v 
  #    elsif !(/G/ =~ k).nil?
  #      g_str = v.nil? ? "" : v 
  #      break
  #    end
  #  end
  #  #puts "index: " + index.to_s + "  " + a_str.to_s + " " +  b_str.to_s + " " +   c_str.to_s + " " +   d_str.to_s + " " +   e_str.to_s + " " +   f_str.to_s + " " +   g_str.to_s
  #end
end 
