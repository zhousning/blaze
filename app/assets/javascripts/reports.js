$(".reports").ready(function() {

  if ($(".reports.day_report").length > 0) {

    $("#report-download-excel").click(function() {
      var fcts = '';
      var search_date = $("#search_date").val();

      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var url = "/reports/xls_day_download?fcts=" + fcts + "&search_date=" + search_date;
      location.href = url;
    });

    day_pdt_modal();

    $("#report-search").click(function() {
      var fcts = '';
      var search_date = $("#search_date").val();
      var url = "/reports/query_day_reports?";
      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var $table = $('#day-pdt-rpt-table')

        var data = [];
        $.get(url, {fcts: fcts, search_date: search_date}).done(function (objs) {
          $.each(objs, function(index, item) {
            var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.fct_id +"'>查看</button>"; 
            data.push({
              'id'      : index + 1,
              'name'    : item.name,
              'inf_cod' : item.inf_cod,
              'eff_cod' : item.eff_cod,
              'inf_bod' : item.inf_bod,
              'eff_bod' : item.eff_bod,
              'inf_tn'  : item.inf_tn,
              'eff_tn'  : item.eff_tn,
              'inf_tp'  : item.inf_tp,
              'eff_tp'  : item.eff_tp,
              'inf_nhn' : item.inf_nhn,
              'eff_nhn' : item.eff_nhn,
              'search'  : button
            });
          });
          $table.bootstrapTable('load', data);
        })

    });
  }

  if ($(".reports.mth_report").length > 0) {
    $("#report-download-excel").click(function() {
      var fcts = '';
      var year = $("#year").val();
      var month = $("#month").val();

      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var url = "/reports/xls_mth_download?fcts=" + fcts + "&month=" + month + "&year=" + year;
      location.href = url;
      //$.get(url, {fcts: fcts, search_date: search_date})
    });
  }
});

