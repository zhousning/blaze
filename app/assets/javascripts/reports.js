$(".reports").ready(function() {

  if ($(".reports.day_report").length > 0) {

    select_checkbox_all("select-all", "fcts");

    $("#report-download-excel").click(function() {
      var fcts = '';
      var search_date = $("#search_date").val();

      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var url = "/reports/xls_day_download?fcts=" + fcts + "&search_date=" + search_date;
      location.href = url;
      //$.get(url, {fcts: fcts, search_date: search_date})
    });

    var myChart = echarts.init(document.getElementById('chart-ctn'));

    $("#day-pdt-rpt-table").on('click', 'button', function(e) {
      myChart.showLoading();
      $('#newModal').modal();
      var that = e.target
      var data_fct = that.dataset['fct'];
      var data_rpt = that.dataset['rpt'];
      var url = "/factories/" + data_fct + "/day_pdt_rpts/" + data_rpt + "/produce_report";
      $.get(url).done(function (data) {
        myChart.hideLoading();
        var header = data.info.name + "&nbsp&nbsp<small class='text-success'>" + data.info.weather + " | " + data.info.temper + "℃</small>"
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

        var title = '进出水水质';
        var series = [{type: 'bar', label: {show: true}}, {type: 'bar', label: {show: true}}];
        var dimensions = ['source', '进水', '出水'];

        var new_Option = newOption(title, series, dimensions, data.datasets)
        myChart.setOption(new_Option);
      });
    });
  }

  if ($(".reports.mth_report").length > 0) {
    select_checkbox_all("select-all", "fcts");

    $("#report-download-excel").click(function() {
      var fcts = '';
      var year = $("#year").val();
      var month = $("#month").val();

      var check_boxes = $("input[name='fcts']:checked");

      $.each(check_boxes, function(){
        fcts += $(this).val() + ","
      });

      var url = "/factories/" + data_fct + "/mth_pdt_rpts/mth_rpt_create?month=" + month + "&year=" + year;
      var url = "/reports/xls_mth_download?fcts=" + fcts + "&month=" + month + "&year=" + year;
      location.href = url;
      //$.get(url, {fcts: fcts, search_date: search_date})
    });
  }
});

function select_checkbox_all(select_all, checkbox_name) {
  $("#" + select_all).click(function() {
    flag = $(this).is(":checked");
    if (flag) {
      $("input[name='" + checkbox_name + "']").prop('checked', true);
    } else {
      $("input[name='" + checkbox_name + "']").prop('checked', false);
    }
  })
}
