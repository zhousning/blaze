$(".cmpy_mth_rpts").ready(function() {
  if ($(".cmpy_mth_rpts.smth_report_finish_index").length > 0) {
    var table = "#mth-pdt-rpt-table";
    var url = '/cmpy_mth_rpts/query_mth_reports';

    fct_date_event(table, url)
  }

  if ($(".cmpy_mth_rpts.edit").length > 0) {
    $('#mth-pdt-sync-btn').on('click', function(e) {
      var data_fct = $("#fct").val();
      var data_mth = $("#mth").val();
      var url = "/sfactories/" + data_fct + "/cmpy_mth_rpts/" + data_mth + "/smth_rpt_sync";

      $.get(url).done(function (data) {
        var cms = data.cms;

        $.each(cms, function(k, v) {
          var attr = k;
          $.each(v, function(item_k, item_v) {
            var item = item_k;
            var val = item_v;
            var id = "#cmpy_mth_rpt_" + attr + "_attributes_" + item;
            $(id).val(val);
          })
        })
      });
    });
  }

});
