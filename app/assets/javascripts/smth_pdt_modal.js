function smth_pdt_modal() {
  $("#mth-pdt-rpt-table").on('click', 'button', function(e) {
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var url = "/sfactories/" + data_fct + "/smth_pdt_rpts/" + data_rpt + "/produce_report";
    $.get(url).done(function (data) {
      var header = data.header.name
      $("#mth-pdt-rpt-header").html(header);

      //start只改动data后的内容即可
      var flow = data.flow;
      var cms = data.ipt;
      var chemical = data.opt;
      var power = data.power;
      var mud = data.sell;
      var md = data.press;
      var cmcbill = data.cmcbill;
      var ecmansrpt = data.ecm_ans_rpt;
      var fct_id = data.fct_id;
      var mth_rpt_id = data.mth_rpt_id;
      //end
      
      var xls_download = "/factories/" + fct_id + "/mth_pdt_rpts/" + mth_rpt_id + "/xls_mth_download";
      var word_download = "/factories/" + fct_id + "/mth_pdt_rpts/" + mth_rpt_id + "/download_report";
      $("#xls-download").attr("href", xls_download);
      $("#word-download").attr("href", word_download);

      if (ecmansrpt != null) {
        var ecm_rpt_download = "/factories/" + fct_id + "/mth_pdt_rpts/" + mth_rpt_id + "/download_append";
        $("#ecm-rpt-download").attr("href", ecm_rpt_download);
        $("#ecm-rpt-download").html("下载经济运行分析报告");
      } else {
        $("#ecm-rpt-download").attr("href", '#');
        $("#ecm-rpt-download").html("未上传经济运行分析报告");
      }

      $("#mth-cmc-bill").attr('src', cmcbill);

      var mth_flow_ctn = ''; 
      $.each(flow, function(k, v) {
        mth_flow_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_flow_ctn += "<td>" + item + "</td>"; 
        })
        mth_flow_ctn += "</tr>"; 
      })
      $("#mth-flow-ctn").html(mth_flow_ctn);

      var mth_cms_ctn = ''; 
      $.each(cms, function(k, v) {
        mth_cms_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_cms_ctn += "<td>" + item + "</td>"; 
        })
        mth_cms_ctn += "</tr>"; 
      })
      $("#mth-cms-ctn").html(mth_cms_ctn);

      var mth_chemical_ctn = ''; 
      $.each(chemical, function(k, v) {
        mth_chemical_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_chemical_ctn += "<td>" + item + "</td>"; 
        })
        mth_chemical_ctn += "</tr>"; 
      })
      $("#mth-chemical-ctn").html(mth_chemical_ctn);

      var mth_power_ctn = ''; 
      $.each(power, function(k, v) {
        mth_power_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_power_ctn += "<td>" + item + "</td>"; 
        })
        mth_power_ctn += "</tr>"; 
      })
      $("#mth-power-ctn").html(mth_power_ctn);

      var mth_mud_ctn = ''; 
      $.each(mud, function(k, v) {
        mth_mud_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_mud_ctn += "<td>" + item + "</td>"; 
        })
        mth_mud_ctn += "</tr>"; 
      })
      $("#mth-mud-ctn").html(mth_mud_ctn);

      var mth_md_ctn = ''; 
      $.each(md, function(k, v) {
        mth_md_ctn += "<tr>"; 
        $.each(v, function(vk, item) {
          mth_md_ctn += "<td>" + item + "</td>"; 
        })
        mth_md_ctn += "</tr>"; 
      })
      $("#mth-md-ctn").html(mth_md_ctn);

    });
  });

}