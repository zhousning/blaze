$(".sday_pdt_rpts").ready(function() {

  if ($(".sday_pdt_rpts.index").length > 0) {
    var table = "#day-pdt-rpt-table";
    var url = '/sday_pdt_rpts/query_all';

    fct_date_event(table, url)
  }

});

