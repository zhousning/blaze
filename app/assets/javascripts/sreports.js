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

    mth_pdt_modal();

    $("#report-search").click(function() {
      var fcts = '';
      var year = $("#year").val();
      var month = $("#month").val();
      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var url = "/reports/query_mth_reports";
      var $table = $('#mth-pdt-rpt-table')

        var data = [];
        $.get(url, {fcts: fcts, year: year, month: month}).done(function (objs) {
          $.each(objs, function(index, item) {
            var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.fct_id +"'>查看</button>"; 
            data.push({
              'id'          : index + 1,
              'name'        : item.name,
              'outflow'     : item.outflow,
              'avg_outflow' : item.avg_outflow,
              'end_outflow' : item.end_outflow,
              'state'   : item.state,
              'search'  : button
            });
          });
          $table.bootstrapTable('load', data);
        })

    });
  }
});

