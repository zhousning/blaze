$(".emp_effs").ready(function() {

  if ($(".emp_effs.index").length > 0) {
    $(".area-time-search").on('click', function(e) {
      empEffChartSet(e.target);
    })
  }

  if ($(".emp_effs.grp_index").length > 0) {
    $(".area-time-search").on('click', function(e) {
      grpEmpEffChartSet();
    })
  }

});

function empEffChartSet(that_search) {
  var qcodes = $("#qcodes").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var fct = that_search.dataset['fct'];

  var url = "/factories/" + fct + "/emp_effs/watercms_flow";
  var that_chart = $('#chart-ctn')[0]

  empChartConfig(url, that_chart, start, end, fct, qcodes)

}


function grpEmpEffChartSet() {
  var qcodes = $("#qcodes").val();
  var start = $("#start").val();
  var end = $("#end").val();
  var fct = $("#empmodal-fcts").val();

  var url = "/factories/" + fct + "/emp_effs/watercms_flow";
  var that_chart = $('#chart-ctn')[0]

  empChartConfig(url, that_chart, start, end, fct, qcodes)
}

function empChartConfig(url, that_chart, start, end, fct, quota) {

  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {start: start, end: end, fct: fct, quota: quota}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var rain_Option = rainOption(data)
    chart.setOption(rain_Option, true);
  });
}

