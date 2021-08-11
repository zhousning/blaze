$(".analyses").ready(function() {

  if ($(".analyses.compare").length > 0) {
    $(".sglfct-statistic-search").on('click', function(e) {
      monthCompareChartSet(e.target);
    })
  }

});

function monthCompareChartSet(that_search) {
  var factory_id = $("#fcts").val();
  var qcodes = $("#qcodes").val();
  var year = $("#year").val();
  var months = "";
  var url = "/factories/" + factory_id + "/analyses/month_compare";

  var chart_ctn = $(that_search).parents(".sglfct-chart-ctn")[0]
  var check_boxes = $(chart_ctn).find("input[name='months']:checked");

  $.each(check_boxes, function(){
    months += $(this).val() + ","
  });

  $(chart_ctn).find(".chart-statistic-ctn").each(function(index, that_chart) {
    var chart_type = that_chart.dataset['chart'];
    if (chart_type == '0') {
      monthChartConfig(url, that_chart, year, months, qcodes)
    } else if (chart_type == '3') {
      //chartTable(that_chart, factory_id, start, end, qcodes, search_type)
    }
  })
}

function monthChartConfig(url, that_chart, year, months, quota) {
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var pos_type = that_chart.dataset['pos'];

  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {year: year, months: months, quota: quota, search_type: search_type, pos_type: pos_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
}
