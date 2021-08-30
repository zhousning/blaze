require 'spreadsheet'



class SpreadSheetTool

  def parseExcel(path)
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open path
    sheet1 = book.worksheet 0
    puts sheet1
    sheet1.each do |row|
      puts row
    end
  end

  def exportMthPdtRptToExcel(obj)
    Spreadsheet.client_encoding = 'UTF-8'
    filename = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    mth_report_template = File.join(Rails.root, "templates", "mth_report.xls")
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xls') 

    book = Spreadsheet.open mth_report_template 

    yuehuizong = book.worksheet 'yuehuizong'
    mingxi = book.worksheet 'mingxi'
    mth_sheets(obj, yuehuizong, mingxi)

    book.write target_excel

    return target_excel
  end

  def mth_sheets(obj, yuehuizong, mingxi)
    row_size = obj.size
    obj.each_with_index do |mth_pdt_rpt, row|
      name = mth_pdt_rpt.factory.name
      cod = mth_pdt_rpt.month_cod
      tp = mth_pdt_rpt.month_tp
      tn = mth_pdt_rpt.month_tn
      ss = mth_pdt_rpt.month_ss
      nhn = mth_pdt_rpt.month_nhn
      power = mth_pdt_rpt.month_power
      mud = mth_pdt_rpt.month_mud
      md = mth_pdt_rpt.month_md
      #fecal = mth_pdt_rpt.month_fecal
      #device = mth_pdt_rpt.month_device
      #stuff = mth_pdt_rpt.month_stuff

      arr = [name, mud.inmud, md.mdrcy, power.power, power.bom, cod.avg_inf, cod.avg_eff,nhn.avg_inf, nhn.avg_eff, tn.avg_inf, tn.avg_eff, tp.avg_inf, tp.avg_eff] 
      arr.each_with_index do |item, col|
        yuehuizong.rows[row + 4][col] = item 
      end

      _start = mth_pdt_rpt.start_date
      _end = mth_pdt_rpt.end_date
      factory = mth_pdt_rpt.factory
      @day_pdt_rpts = factory.day_pdt_rpts.where(["pdt_date between ? and ? ", _start, _end]).order("pdt_date ASC")
      mingxi_sheet(@day_pdt_rpts, mingxi)
    end
  end

  def exportDayPdtRptToExcel(obj)
    Spreadsheet.client_encoding = 'UTF-8'
    filename = Time.now.to_i.to_s + "%04d" % [rand(10000)]
    day_report_template = File.join(Rails.root, "templates", "day_report.xls")
    target_excel = File.join(Rails.root, "public", "excel", filename + '.xls') 

    book = Spreadsheet.open day_report_template 

    tuchu = book.worksheet 'tuchu'
    mingxi = book.worksheet 'mingxi'

    tuchu_sheet(obj, tuchu)
    mingxi_sheet(obj, mingxi)

    book.write target_excel

    return target_excel
  end
  private 
    def tuchu_sheet(obj, sheet)
      start = 6
      col = 1 
      obj.each_with_index do |day_pdt_rpt, index|
        sheet.rows[start + index][0] = day_pdt_rpt.factory.name
        sheet.rows[start + index][1] = day_pdt_rpt.inflow
        sheet.rows[start + index][col + 1] = day_pdt_rpt.inf_qlty_cod  
        sheet.rows[start + index][col + 2] = day_pdt_rpt.sed_qlty_cod 
        sheet.rows[start + index][col + 3] = day_pdt_rpt.eff_qlty_cod 
        sheet.rows[start + index][col + 4] = day_pdt_rpt.inf_qlty_bod  
        sheet.rows[start + index][col + 5] = day_pdt_rpt.sed_qlty_bod 
        sheet.rows[start + index][col + 6] = day_pdt_rpt.eff_qlty_bod 
        sheet.rows[start + index][col + 7] = day_pdt_rpt.inf_qlty_nhn  
        sheet.rows[start + index][col + 8] = day_pdt_rpt.sed_qlty_nhn 
        sheet.rows[start + index][col + 9] = day_pdt_rpt.eff_qlty_nhn 
        sheet.rows[start + index][col + 10] = day_pdt_rpt.inf_qlty_tn
        sheet.rows[start + index][col + 11] = day_pdt_rpt.sed_qlty_tn 
        sheet.rows[start + index][col + 12] = day_pdt_rpt.eff_qlty_tn 
        sheet.rows[start + index][col + 13] = day_pdt_rpt.inf_qlty_tp
        sheet.rows[start + index][col + 14] = day_pdt_rpt.sed_qlty_tp
        sheet.rows[start + index][col + 15] = day_pdt_rpt.eff_qlty_tp
        sheet.rows[start + index][col + 16] = day_pdt_rpt.inf_qlty_ss
        sheet.rows[start + index][col + 17] = day_pdt_rpt.sed_qlty_ss
        sheet.rows[start + index][col + 18] = day_pdt_rpt.eff_qlty_ss
        sheet.rows[start + index][col + 21] = day_pdt_rpt.eff_qlty_fecal
      end
    end

    def mingxi_sheet(obj, sheet)
      sheet.row(0).concat  day_pdt_rpt_title
      start = 1
      obj.each_with_index do |day_pdt_rpt, index|
        sheet.row(start + index).concat  day_pdt_rpt_obj(day_pdt_rpt)
      end
    end

    def day_pdt_rpt_title
      [
        "厂区",
        Setting.day_pdt_rpts.pdt_date,  
        Setting.day_pdt_rpts.inf_qlty_bod,  
        Setting.day_pdt_rpts.eff_qlty_bod,  
        Setting.day_pdt_rpts.inf_qlty_cod,  
        Setting.day_pdt_rpts.eff_qlty_cod,  
        Setting.day_pdt_rpts.inf_qlty_ss,   
        Setting.day_pdt_rpts.eff_qlty_ss,   
        Setting.day_pdt_rpts.inf_qlty_nhn,  
        Setting.day_pdt_rpts.eff_qlty_nhn,  
        Setting.day_pdt_rpts.inf_qlty_tn,   
        Setting.day_pdt_rpts.eff_qlty_tn,   
        Setting.day_pdt_rpts.inf_qlty_tp,   
        Setting.day_pdt_rpts.eff_qlty_tp,   
        Setting.day_pdt_rpts.inf_qlty_ph,   
        Setting.day_pdt_rpts.eff_qlty_ph,   
        Setting.day_pdt_rpts.eff_qlty_fecal,
        Setting.day_pdt_rpts.inflow,        
        Setting.day_pdt_rpts.outflow,       
        Setting.day_rpt_stcs.bcr,
        Setting.day_rpt_stcs.bnr,
        Setting.day_rpt_stcs.bpr,
        Setting.day_rpt_stcs.cod_emq,
        Setting.day_rpt_stcs.bod_emq,
        Setting.day_rpt_stcs.nhn_emq,
        Setting.day_rpt_stcs.tp_emq,
        Setting.day_rpt_stcs.tn_emq,
        Setting.day_rpt_stcs.ss_emq,
        Setting.day_rpt_stcs.cod_emr,
        Setting.day_rpt_stcs.bod_emr,
        Setting.day_rpt_stcs.nhn_emr,
        Setting.day_rpt_stcs.tp_emr,
        Setting.day_rpt_stcs.tn_emr,
        Setting.day_rpt_stcs.ss_emr,
        Setting.day_pdt_rpts.inmud,         
        Setting.day_pdt_rpts.outmud,        
        Setting.day_pdt_rpts.mst,           
        Setting.day_pdt_rpts.power,         
        Setting.day_rpt_stcs.bom,
        Setting.day_pdt_rpts.mdflow,        
        Setting.day_pdt_rpts.mdrcy,         
        Setting.day_pdt_rpts.mdsell,
      ]
    end

    def day_pdt_rpt_obj(day_pdt_rpt)
      [
        day_pdt_rpt.factory.name,
        day_pdt_rpt.pdt_date.to_s,  
        day_pdt_rpt.inf_qlty_bod,  
        day_pdt_rpt.eff_qlty_bod,  
        day_pdt_rpt.inf_qlty_cod,  
        day_pdt_rpt.eff_qlty_cod,  
        day_pdt_rpt.inf_qlty_ss,   
        day_pdt_rpt.eff_qlty_ss,   
        day_pdt_rpt.inf_qlty_nhn,  
        day_pdt_rpt.eff_qlty_nhn,  
        day_pdt_rpt.inf_qlty_tn,   
        day_pdt_rpt.eff_qlty_tn,   
        day_pdt_rpt.inf_qlty_tp,   
        day_pdt_rpt.eff_qlty_tp,   
        day_pdt_rpt.inf_qlty_ph,   
        day_pdt_rpt.eff_qlty_ph,   
        day_pdt_rpt.eff_qlty_fecal,
        day_pdt_rpt.inflow,        
        day_pdt_rpt.outflow,       
        day_pdt_rpt.day_rpt_stc.bcr,
        day_pdt_rpt.day_rpt_stc.bnr,
        day_pdt_rpt.day_rpt_stc.bpr,
        day_pdt_rpt.day_rpt_stc.cod_emq,
        day_pdt_rpt.day_rpt_stc.bod_emq,
        day_pdt_rpt.day_rpt_stc.nhn_emq,
        day_pdt_rpt.day_rpt_stc.tp_emq,
        day_pdt_rpt.day_rpt_stc.tn_emq,
        day_pdt_rpt.day_rpt_stc.ss_emq,
        day_pdt_rpt.day_rpt_stc.cod_emr,
        day_pdt_rpt.day_rpt_stc.bod_emr,
        day_pdt_rpt.day_rpt_stc.nhn_emr,
        day_pdt_rpt.day_rpt_stc.tp_emr,
        day_pdt_rpt.day_rpt_stc.tn_emr,
        day_pdt_rpt.day_rpt_stc.ss_emr,
        day_pdt_rpt.inmud,         
        day_pdt_rpt.outmud,        
        day_pdt_rpt.mst,           
        day_pdt_rpt.power,         
        day_pdt_rpt.day_rpt_stc.bom,
        day_pdt_rpt.mdflow,        
        day_pdt_rpt.mdrcy,         
        day_pdt_rpt.mdsell
      ]
    end
end
