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

  emq_chart_nodes = $(chart_ctn).find(".chart-statistic-emq-ctn")
  if (emq_chart_nodes.length > 0) {
    var emq_url = "/day_pdt_rpts/emq_cau";
    var that_chart = emq_chart_nodes[0];
    var chart = emqChartConfig(emq_url, that_chart, factory_id, start, end, qcodes)
    charts.push(chart);
  }

  emr_chart_nodes = $(chart_ctn).find(".chart-statistic-emr-ctn")
  if (emr_chart_nodes.length > 0) {
    var emr_url = "/day_pdt_rpts/emr_cau";
    var that_chart = emr_chart_nodes[0];
    var chart = emrChartConfig(emr_url, that_chart, factory_id, start, end, qcodes)
    charts.push(chart);
  }

  power_chart_nodes = $(chart_ctn).find(".chart-statistic-power-ctn")
  if (power_chart_nodes.length > 0) {
    var power_url = "/day_pdt_rpts/power_cau";
    var that_chart = power_chart_nodes[0];
    var chart = powerChartConfig(power_url, that_chart, factory_id, start, end, qcodes)
    charts.push(chart);
  }

  bom_chart_nodes = $(chart_ctn).find(".chart-statistic-bom-ctn")
  if (bom_chart_nodes.length > 0) {
    var bom_url = "/day_pdt_rpts/bom_cau";
    var that_chart = bom_chart_nodes[0];
    var chart = bomChartConfig(bom_url, that_chart, factory_id, start, end, qcodes)
    charts.push(chart);
  }
  chartResize(charts);
}

