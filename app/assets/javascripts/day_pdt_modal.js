function day_pdt_modal() {
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
      var header = data.header.name + "&nbsp&nbsp<small class='text-success'>" + data.header.weather + " | " + data.header.min_temper + "一" + data.header.max_temper + "摄氏度 </small>"
      $("#day-pdt-rpt-header").html(header);

      var flow = data.flow;
      var emq = data.cms_emq;
      var emr = data.cms_emr;
      var inf_huayan = data.inf_huayan;
      var eff_huayan = data.eff_huayan;
      var mud = data.mud;
      var power = data.power;
      var md = data.md;
      var tspmuds = data.tspmuds;
      var chemicals = data.chemicals.chemicals_data;
      var chemical_per_cost = data.chemicals.per_cost;
      var chemical_tpcost = data.chemicals.tpcost;
      var chemical_tncost = data.chemicals.tncost;
      var chemical_tputcost = data.chemicals.tputcost;
      var chemical_tnutcost = data.chemicals.tnutcost;
      var fct_id = data.fct_id;
      var day_rpt_id = data.day_rpt_id;
      
      var xls_download = "/factories/" + fct_id + "/day_pdt_rpts/" + day_rpt_id + "/xls_day_download";
      $("#xls-download").attr("href", xls_download);

      var day_flow_ctn = ''; 
      $.each(flow, function(k, v) {
        day_flow_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-flow-ctn").html(day_flow_ctn);

      var emq_table = '<tr><th></th><th>COD</th><th>BOD</th><th>NH3-N</th><th>TP</th><th>TN</th><th>SS</th></tr>';
      emq_table += '<tr><td>进水化验(mg/l)</td>'; 
      $.each(inf_huayan, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      emq_table += '<tr><td>出水化验(mg/l)</td>'; 
      $.each(eff_huayan, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      emq_table += '<tr><td>削减量(吨)</td>'; 
      $.each(emq, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      emq_table += '<tr><td>削减率(%)</td>'; 
      $.each(emr, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 

      $("#day-emq-ctn").html(emq_table);


      var day_power_ctn = ''; 
      $.each(power, function(k, v) {
        day_power_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-power-ctn").html(day_power_ctn);


      var chemical_table = '<tr><th></th><th>单价(元/吨)</th><th>药剂浓度(%)</th><th>投加量(吨)</th><th>药剂投加浓度(mg/l)</th><th>吨水药剂成本(元/千吨)</th></tr>';
      for (var i=0; i<chemicals.length; i++){
        chemical_table += '<tr>';
        $.each(chemicals[i], function(k, v) {
          chemical_table += "<td>" + v + "</td>"; 
        })
        chemical_table += '</tr>';
      }
      $("#day-chemical-ctn").html(chemical_table);

      $("#day-chemical-per-cost").html(chemical_per_cost);
      $("#day-chemical-tpcost").html(chemical_tpcost);
      $("#day-chemical-tncost").html(chemical_tncost);
      $("#day-chemical-tputcost").html(chemical_tputcost);
      $("#day-chemical-tnutcost").html(chemical_tnutcost);


      var day_mud_ctn = ''; 
      $.each(mud, function(k, v) {
        day_mud_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-mud-ctn").html(day_mud_ctn);

      var tspmud_table = '<tr><th>处置单位</th><th>转运泥量</th><th>处置单位接收量</th><th>价格(元/吨)</th><th>处置方式</th><th>后续产品走向</th></tr>';
      for (var i=0; i<tspmuds.length; i++){
        tspmud_table += '<tr>';
        $.each(tspmuds[i], function(k, v) {
          tspmud_table += "<td>" + v + "</td>"; 
        })
        tspmud_table += '</tr>';
      }
      $("#day-tspmud-ctn").html(tspmud_table);


      var day_md_ctn = ''; 
      $.each(md, function(k, v) {
        day_md_ctn += "<li class='list-group-item m-2'>" + k  + "&nbsp&nbsp : &nbsp&nbsp" + v + "</li>"; 
      })
      $("#day-md-ctn").html(day_md_ctn);

      var title = '进水水质';
      var series = [{type: 'bar', label: {show: true}}, {type: 'bar', label: {show: true}}];
      var dimensions = ['source', '进水', '出水'];
      var new_Option = newOption(title, series, dimensions, data.datasets)
      myChart.setOption(new_Option);
    });
  });

}
