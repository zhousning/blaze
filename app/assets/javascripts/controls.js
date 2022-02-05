$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    var start = $("#start").val();
    var end = $("#end").val();
    var fcts = gon.fct;
    $("input[name='select-all']").prop('checked',true);
    $("input[name='fcts']").prop('checked',true);

    var width = $('.chart-statistic-ctn').width();
    $('.chart-statistic-ctn').css("width", width); 

    mainQuotaChartSet(start, end, fcts);

    $(".area-time-search").on('click', function(e) {
      var start = $("#start").val();
      var end = $("#end").val();
      var fcts = "";
      var check_boxes = $("input[name='fcts']:checked");
      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      mainQuotaChartSet(start, end, fcts);
    })
  }
});

function mainQuotaChartSet(start, end, fcts) {
  //var qcodes = $("#qcodes").val();
  var charts = [];
  var power_chart = $(".power-chart")[0]
  var tpcost_chart = $(".tpcost-chart")[0]
  var tncost_chart = $(".tncost-chart")[0]
  var tputcost_chart = $(".tputcost-chart")[0]
  var tnutcost_chart = $(".tnutcost-chart")[0]
  var ctputcost_chart = $(".ctputcost-chart")[0]
  var ctnutcost_chart = $(".ctnutcost-chart")[0]
  var percost_chart = $(".percost-chart")[0]
  var sdzjtbz_chart = $("#sdzjtbz-chart")
  var jnzsbz_chart = $("#jnzsbz-chart")
  var qzbbz_chart = $("#qzbbz-chart")

  var power_url = '/analyses/power_bom';
  var tpcost_url = '/analyses/tpcost';
  var tncost_url = '/analyses/tncost';
  var tputcost_url = '/analyses/tputcost';
  var tnutcost_url = '/analyses/tnutcost';
  var ctputcost_url = '/analyses/ctputcost';
  var ctnutcost_url = '/analyses/ctnutcost';
  var percost_url = '/analyses/percost';
  var zbdblv_url = '/analyses/zbdblv';

  charts.push(controlChartConfig(power_url, power_chart, start, end, fcts));
  charts.push(controlChartConfig(tpcost_url, tpcost_chart, start, end, fcts));
  charts.push(controlChartConfig(tncost_url, tncost_chart, start, end, fcts));
  charts.push(controlChartConfig(tputcost_url, tputcost_chart, start, end, fcts));
  charts.push(controlChartConfig(tnutcost_url, tnutcost_chart, start, end, fcts));
  charts.push(controlChartConfig(ctputcost_url, ctputcost_chart, start, end, fcts));
  charts.push(controlChartConfig(ctnutcost_url, ctnutcost_chart, start, end, fcts));
  charts.push(controlChartConfig(percost_url, percost_chart, start, end, fcts));
  controlBiaoZhunTable(zbdblv_url, sdzjtbz_chart, start, end, fcts, 0);
  controlBiaoZhunTable(zbdblv_url, jnzsbz_chart, start, end, fcts, 1);
  controlBiaoZhunTable(zbdblv_url, qzbbz_chart, start, end, fcts, 2);

  chartResize(charts);
}

function controlChartConfig(url, that_chart, start, end, fcts) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {start: start, end: end, fcts: fcts}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}

function controlBiaoZhunTable(url, that_chart, start, end, fcts, type) {
  var obj = {start: start, end: end, fcts: fcts, type: type}
  $.get(url, obj).done(function (data) {
    var table = "<table class='table table-bordered'>";
    $.each(data, function(k,v) {
      table += "<tr><td>" + k + "</td>"; 
      for (var i=0; i<v.length; i++) { 
        table += "<td>" + v[i] + "</td>"; 
      }
      table += "</tr>";
    })
    table += "</table>";
    that_chart.html(table);
  });
}

/*
$(".chart-statistic-ctn").each(function(index, e) {
  radarChartSet(e);
});

$(".chart-gauge-ctn").each(function(index, that_chart) {
  var qcode = that_chart.dataset['code'];
  var factory_id = that_chart.dataset['fct'];
  var chart = echarts.init(that_chart);
  chart.showLoading();

  var obj = {factory_id: factory_id, qcode: qcode }
  var url = "/day_pdt_rpts/new_quota_chart";
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = gaugeOption(data.name, data.value, data.min, data.max, data.color)
    chart.setOption(new_Option, true);
  });
});
*/
