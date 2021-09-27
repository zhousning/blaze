require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "update_mth_power_chemicals"
  task(:update_mth_power_chemicals => :environment) do
    base_dir = "lib/tasks/data/inoutcms/lishimth/" 
    @log_dir = "lib/tasks/data/inoutcms/logs/" 
    @mthpowerchemicallog = Logger.new(@log_dir + '更新月数据错误.log')

    @chemical_ctg = {}
    ChemicalCtg.all.each do |c|
      chemical_ctg[c.name] = c.id
    end


    Find.find(base_dir).each do |xls|
      unless File::directory?(xls)
        puts xls
        parse_mth_power_chemical(xls)
      end
    end
  end
end

def parse_mth_power_chemical(xls)
  file_name = File.basename(xls, '.xlsx')

  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  factory_hash = my_factory_hash
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 

  results['Sheet1'][2..-1].each_with_index do |row, index|
    index = index + 3 
    index = index.to_s
    date = row['A' + index]
    next if date.blank?

    @mth_pdt_rpt = factory.mth_pdt_rpts.where(:start_date => date).first
    if @mth_pdt_rpt
      power = row['B' + index].blank? ? 0 : FormulaLib.format_num(row['B' + index])
      csn_price      =  row['C' + index]
      csn_cmptc      =  row['D' + index]
      csn_dosage     =  row['E' + index] 
      create_mthcmc(csn_price, csn_cmptc, csn_dosage, Setting.chemical_ctgs.csn_t)

      jc_price       =  row['F' + index]
      jc_cmptc       =  row['G' + index]
      jc_dosage      =  row['H' + index] 
      create_mthcmc(jc_price, jc_cmptc, jc_dosage, Setting.chemical_ctgs.jc_t)
      
      xxty_price     =  row['I' + index]
      xxty_cmptc     =  row['J' + index]
      xxty_dosage    =  row['K' + index] 
      create_mthcmc(xxty_price, xxty_cmptc, xxty_dosage, Setting.chemical_ctgs.xxty_t)

      pac_price      =  row['L' + index]
      pac_cmptc      =  row['M' + index]
      pac_dosage     =  row['N' + index] 
      create_mthcmc(pac_price, pac_cmptc, pac_dosage, Setting.chemical_ctgs.pac_t)

      pam_yang_price =  row['O' + index]
      pam_yang_cmptc =  row['P' + index]
      pam_yang_dosage=  row['Q' + index] 
      create_mthcmc(pam_yang_price, pam_yang_cmptc, pam_yang_dosage, Setting.chemical_ctgs.pam_yang_t)

      pam_yin_price  =  row['R' + index]
      pam_yin_cmptc  =  row['S' + index]
      pam_yin_dosage =  row['T' + index] 
      create_mthcmc(pam_yin_price, pam_yin_cmptc, pam_yin_dosage, Setting.chemical_ctgs.pam_yin_t)

      slht_price     =  row['U' + index]
      slht_cmptc     =  row['V' + index]
      slht_dosage    =  row['W' + index] 
      create_mthcmc(slht_price, slht_cmptc, slht_dosage, Setting.chemical_ctgs.slht_t)

      jhlst_price    =  row['X' + index]
      jhlst_cmptc    =  row['Y' + index]
      jhlst_dosage   =  row['Z' + index] 
      create_mthcmc(jhlst_price, jhlst_cmptc, jhlst_dosage, Setting.chemical_ctgs.jhlst_t)

      clsn_price     =  row['AA' + index]
      clsn_cmptc     =  row['AB' + index]
      clsn_dosage    =  row['AC' + index] 
      create_mthcmc(clsn_price, clsn_cmptc, clsn_dosage, Setting.chemical_ctgs.clsn_t)
      
      swj_price      =  row['AD' + index]
      swj_cmptc      =  row['AE' + index]
      swj_dosage     =  row['AF' + index] 
      create_mthcmc(swj_price, swj_cmptc, swj_dosage, Setting.chemical_ctgs.swj_t)

      yy_price       =  row['AG' + index]
      yy_cmptc       =  row['AH' + index]
      yy_dosage      =  row['AI' + index] 
      create_mthcmc(yy_price, yy_cmptc, yy_dosage, Setting.chemical_ctgs.yy_t)

      hxt_price      =  row['AJ' + index]
      hxt_cmptc      =  row['AK' + index]
      hxt_dosage     =  row['AL' + index] 
      create_mthcmc(hxt_price, hxt_cmptc, hxt_dosage, Setting.chemical_ctgs.hxt_t)
    end
  end
end

def create_mthcmc(price, cmptc, dosage, type)
  if !((price.blank? || cs_price == 0) && (cmptc.blank? || cs_cmptc == 0) && (dosage.blank? || cs_dosage == 0))
    @mth_chemical = MthChemical.new(
      :mth_pdt_rpt => @mth_pdt_rpt,
      :name       => @chemical_ctg[type], 
      :unprice    => price.blank?  ? 0 : FormulaLib.format_num(price),
      :dosage     => dosage.blank? ? 0 : FormulaLib.format_num(dosage), 
      :act_dosage => dosage.blank? ? 0 : FormulaLib.format_num(dosage), 
      :avg_dosage => dosage.blank? ? 0 : FormulaLib.format_num(dosage/30), 
      :cmptc      => cmptc.blank?  ? 0 : FormulaLib.format_num(cmptc)
    ) 
    if @mth_chemical.save
      @mth_chemical.update_ptc(@mth_pdt_rpt.inflow)
    else
      @mthpowerchemicallog.error 'mth chemical save error: ' + @mth_pdt_rpt.name 
    end
  end
end
