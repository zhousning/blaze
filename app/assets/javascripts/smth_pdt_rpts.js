$(".smth_pdt_rpts").ready(function() {
  if ($(".smth_pdt_rpts.smth_report_finish_index").length > 0) {
    var table = "#mth-pdt-rpt-table";
    var url = '/smth_pdt_rpts/query_mth_reports';

    fct_date_event(table, url)
  }

  if ($(".smth_pdt_rpts.index").length > 0) {
    $('#mth-rpt-create').on('click', function(e) {
      var month = $("#months").val(); 
      var year = $("#year").val(); 
      var that = e.target
      var data_fct = that.dataset['fct'];
      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month + "&year=" + year;

      location.href = url; 
    });
  }

  if ($(".smth_pdt_rpts.edit").length > 0) {
    $('#mth-pdt-sync-btn').on('click', function(e) {
      var data_fct = $("#fct").val();
      var data_mth = $("#mth").val();
      var url = "/sfactories/" + data_fct + "/smth_pdt_rpts/" + data_mth + "/smth_rpt_sync";

      $.get(url).done(function (data) {
        var cms = data.cms;

        $.each(cms, function(k, v) {
          var attr = k;
          $.each(v, function(item_k, item_v) {
            var item = item_k;
            var val = item_v;
            var id = "#smth_pdt_rpt_" + attr + "_attributes_" + item;
            $(id).val(val);
          })
        })
      });
    });
  }

});
