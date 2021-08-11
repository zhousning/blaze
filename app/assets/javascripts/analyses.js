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

  chart_static_ctn = $(chart_ctn).find(".chart-statistic-ctn")
  chart_static_ctn.each(function(index, that_chart) {
    var chart_type = that_chart.dataset['chart'];
    var search_type = that_chart.dataset['type'];
    var pos_type = that_chart.dataset['pos'];

    var ctg_cms = ['0', '1', '2', '3', '4', '5', '6', '16']
    var ctg_mud = ['7', '8', '9', '10', '11']
    var ctg_power = ['12']
    var ctg_md = ['13', '14', '15']

    if (search_type == '0' && ctg_cms.indexOf(qcodes) != -1) {
      
      chart_static_ctn.each(function(index, that_chart) {
        var search_type_cache = that_chart.dataset['type'];
        if (search_type_cache == '0') {
          $(that_chart).removeClass("d-none");
          $(that_chart).addClass("d-block");
        } else {
          $(that_chart).removeClass("d-block");
          $(that_chart).addClass("d-none");
        }
      })

      monthChartConfig(url, that_chart, year, months, qcodes)
    } else if (search_type == '2' && ctg_mud.indexOf(qcodes) != -1) {
      chart_static_ctn.each(function(index, that_chart) {
        var search_type_cache = that_chart.dataset['type'];
        if (search_type_cache == '2') {
          $(that_chart).removeClass("d-none");
          $(that_chart).addClass("d-block");
        } else {
          $(that_chart).removeClass("d-block");
          $(that_chart).addClass("d-none");
        }
      })
      monthChartConfig(url, that_chart, year, months, qcodes)
    } else if (search_type == '3' && ctg_power.indexOf(qcodes) != -1) {
      chart_static_ctn.each(function(index, that_chart) {
        var search_type_cache = that_chart.dataset['type'];
        if (search_type_cache == '3') {
          $(that_chart).removeClass("d-none");
          $(that_chart).addClass("d-block");
        } else {
          $(that_chart).removeClass("d-block");
          $(that_chart).addClass("d-none");
        }
      })
      monthChartConfig(url, that_chart, year, months, qcodes)
    } else if (search_type == '4' && ctg_md.indexOf(qcodes) != -1) {
      chart_static_ctn.each(function(index, that_chart) {
        var search_type_cache = that_chart.dataset['type'];
        if (search_type_cache == '4') {
          $(that_chart).removeClass("d-none");
          $(that_chart).addClass("d-block");
        } else {
          $(that_chart).removeClass("d-block");
          $(that_chart).addClass("d-none");
        }
      })
      monthChartConfig(url, that_chart, year, months, qcodes)
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
