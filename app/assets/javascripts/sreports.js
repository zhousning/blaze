$(".sreports").ready(function() {

  if ($(".sreports.day_report").length > 0) {
    var table = "#sday-pdt-table";
    var url = '/sday_pdt_rpts/query_all';

    fct_date_event(table, url)

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

  }

  if ($(".sreports.mth_report").length > 0) {
    var table = "#mth-pdt-rpt-table";
    var url = '/sreports/query_mth_reports';

    fct_date_event(table, url)

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

    mth_pdt_modal();
  }
});

