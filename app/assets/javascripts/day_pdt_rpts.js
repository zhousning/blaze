$(".day_pdt_rpts").ready(function() {

  if ($(".day_pdt_rpts.sglfct_statistic").length > 0) {
    var stcInflow = echarts.init(document.getElementById('chart-statistic-inflow-ctn'));
    var stcOutflow = echarts.init(document.getElementById('chart-statistic-outflow-ctn'));
    var stcMud = echarts.init(document.getElementById('chart-statistic-mud-ctn'));
    var stcPower = echarts.init(document.getElementById('chart-statistic-power-ctn'));
    var stcMd = echarts.init(document.getElementById('chart-statistic-md-ctn'));

    //var inflowChart = echarts.init(document.getElementById('chart-inflow-ctn'));
    //var outflowChart = echarts.init(document.getElementById('chart-outflow-ctn'));
    //var powerChart = echarts.init(document.getElementById('chart-power-ctn'));

    chartSet('#sglfct-mud-search', stcMud, '污泥处理')
    chartSet('#sglfct-power-search', stcPower, '能耗分析')
    chartSet('#sglfct-md-search', stcMd, '中水处理')

    $("#sglfct-statistic-search").on('click', function(e) {
      stcInflow.showLoading();
      stcOutflow.showLoading();

      var that = e.target
      var search_type = that.dataset['type'];
      var factory_id = $("#fcts").val();
      var start = $("#start").val();
      var end = $("#end").val();
      var qcodes = "";

      var check_boxes = $($(that).parent().siblings()[0]).find("input[name='qcodes']:checked");

      $.each(check_boxes, function(){
        qcodes += $(this).val() + ","
      });

      var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type}
      var url = "/day_pdt_rpts/sglfct_stc_cau";
      $.get(url, obj).done(function (data) {
        stcInflow.hideLoading();
        stcOutflow.hideLoading();
        
        var stcInflowOption = newOption('进水水质', data.series, data.dimensions, data.inflow_categories)
        var stcOutflowOption = newOption('出水水质', data.series, data.dimensions, data.outflow_categories)
        //var inflowOption = { series: data.sum_inflow }
        //var outflowOption = { series: data.sum_outflow }

        stcInflow.setOption(stcInflowOption, true);
        stcOutflow.setOption(stcOutflowOption, true);
        //inflowChart.setOption(inflowOption); 
        //outflowChart.setOption(outflowOption);

        //var powerOption = { series: data.sum_power }
        //powerChart.setOption(powerOption);
      });
    });
  }

  if ($(".day_pdt_rpts.index").length > 0) {

    var myChart = echarts.init(document.getElementById('chart-ctn'));
    option = {
      title: {
        text: '水质化验'
      },
      legend: {},
      tooltip: {},
      xAxis: {type: 'category'},
      yAxis: {},
      series: [
        {type: 'bar'},
        {type: 'bar'}
      ]
    };
    myChart.setOption(option);

    $("#day-pdt-rpt-table").on('click', 'button', function(e) {
      myChart.showLoading();
      $('#newModal').modal();
      var that = e.target
      var data_fct = that.dataset['fct'];
      var data_rpt = that.dataset['rpt'];
      var url = "/factories/" + data_fct + "/day_pdt_rpts/" + data_rpt + "/produce_report";
      $.get(url).done(function (data) {
        myChart.hideLoading();
        var header = data.info.pdt_date + data.info.name + "&nbsp&nbsp<small class='text-success'>" + data.info.weather + " | " + data.info.temper + "</small>"
        $("#day-pdt-rpt-header").html(header);

        var rpt_table = "<table class='table table-bordered'>" +
          "<tr><td>进水量: " + data.info.inflow + "</td>" + 
          "    <td>出水量: " + data.info.outflow + "</td></tr>" + 
          "<tr><td>进泥量: " + data.info.inmud  + "</td>" + 
          "    <td>出泥量: " + data.info.outmud + "</td></tr>" + 
          "<tr><td>污泥含水率: " + data.info.mst + "</td>"  + 
          "    <td>耗电量: " + data.info.power  + "</td></tr>" + 
          "<tr><td>中水量: " + data.info.mdflow + "</td>" + 
          "    <td>中水回用量: " + data.info.mdrcy + "</td></tr>" +  
          "<tr><td>中水销售水量: " + data.info.mdsell + "</td>" + 
          "    <td></td></tr>" +  
          "</table>";
        $("#day-pdt-rpt-ctn").html(rpt_table);


        myChart.setOption({
          dataset: {
            dimensions: ['source', '进水', '出水'],
            source: data.categories 
          },
        });
      });
    });

  }

});

function newOption(my_title, my_series, my_dimensions, my_source) {
  var new_Option = {
    title: {
      text: my_title 
    },
    legend: {},
    tooltip: {},
    xAxis: {type: 'category'},
    yAxis: {},
    dataZoom: [
      {            
        type: 'slider',
        show: true,
        xAxisIndex: [0],
        startValue: '0'
      },
      {            
        type: 'slider',
        show: true,
        yAxisIndex: [0],
        startValue: '0'
      }
    ],
    series: my_series,
    dataset: {
      dimensions: my_dimensions,
      source: my_source  
    }
  }
  return new_Option
}

function chartSet(clickBtn, chart, title) {
  $(clickBtn).on('click', function(e) {
    chart.showLoading();

    var that = e.target
    var search_type = that.dataset['type'];
    var factory_id = $("#fcts").val();
    var start = $("#start").val();
    var end = $("#end").val();
    var qcodes = "";

    var check_boxes = $($(that).parent().siblings()[0]).find("input[name='qcodes']:checked");

    $.each(check_boxes, function(){
      qcodes += $(this).val() + ","
    });

    var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type}
    var url = "/day_pdt_rpts/sglfct_stc_cau";
    $.get(url, obj).done(function (data) {
      chart.hideLoading();
      
      console.log(data);
      var new_Option = newOption(title, data.series, data.dimensions, data.categories)
      console.log( new_Option);
      chart.setOption(new_Option, true);
    });
  })
}
