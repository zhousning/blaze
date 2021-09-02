$(".day_pdt_rpts").ready(function() {

  if ($(".day_pdt_rpts.sglfct_statistic").length > 0) {
    $(".sglfct-statistic-search").on('click', function(e) {
      chartSet(e.target);
    })
  }

  if ($(".day_pdt_rpts.index").length > 0) {
    day_pdt_modal();
  }

});


function chartSet(that_search) {
  var factory_id = $("#fcts").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var qcodes = "";
  var url = "/day_pdt_rpts/sglfct_stc_cau";

  var chart_ctn = $(that_search).parents(".sglfct-chart-ctn")[0]
  var check_boxes = $(chart_ctn).find("input[name='qcodes']:checked");

  var charts = [];

  $.each(check_boxes, function(){
    qcodes += $(this).val() + ","
  });

  $(chart_ctn).find(".chart-statistic-ctn").each(function(index, that_chart) {
    var chart_type = that_chart.dataset['chart'];
    var search_type = that_chart.dataset['type'];
    var chart;

    if (chart_type == '0') {
      chart = periodChartConfig(url, that_chart, factory_id, start, end, qcodes)
      charts.push(chart);
    } else if (chart_type == '3') {
      chartTable(that_chart, factory_id, start, end, qcodes, search_type)
    }
  })
  chartResize(charts);
}

