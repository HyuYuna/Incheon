<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	List  lstRs     = (List)  request.getAttribute( "dbList" );
	String chartHeight = "435px";

	String[] chartColorArray = {"#FF0F00" , "#FF6600", "#FF9E01", "#FCD202", "#F8FF01", "#B0DE09", 
			"#04D215", "#0D8ECF", "#0D52D1", "#2A0CD0", "#8A0CCF", "#CD0D74", "#754DEB", "#DDDDDD", 
			"#999999", "#333333", "#000000", "#FF0F00" , "#FF6600", "#FF9E01", "#FCD202", "#F8FF01", 
			"#B0DE09", "#04D215", "#0D8ECF", "#0D52D1", "#2A0CD0", "#8A0CCF", "#CD0D74", "#754DEB", "#DDDDDD"};

	String categorytitle = "(월별) / 검색조건 : " + CommonUtil.nvl(reqMap.get("searchyeartext"));
	String graphvalue = "월";
	
	int listcount = CommonUtil.getNullInt(reqMap.get("listRowCount"), 0);
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">
		
			<jsp:include page="/webadm/statistics/search.form.do"  flush="false"/>

			<!-- 시간별 접속 통계 -->
			<div id="chartdiv" style="width: 100%; height: <%=chartHeight%>;"></div>	
			
			<!-- 공통 통계표 -->
			<jsp:include page="/webadm/statistics/statics.do"  flush="false"/>

		</div>
	</div>
	
	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script type="text/javascript">
	var chart;

	var chartData = [
		<%
			if (listcount > 0) {
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );
			            
			            if (iLoop > 0) out.println(",");
			            
			            out.println("{");
			            out.println("\"joindate\":\"" + CommonUtil.nvl(rsMap.get("JOIN_DATE")).substring(4,6) + "\",");
			            out.println("\"visits\":\"" + rsMap.get("JOIN_COUNT") + "\",");
			            out.println("\"color\":\"" + chartColorArray[iLoop] + "\"");
			            out.println("}");
			       }
			} else {
				out.print("{ }");
			}
		%>	
	];

<% if (listcount > 0) { %>
	AmCharts.ready(function () {
		// SERIAL CHART
		chart = new AmCharts.AmSerialChart();
		chart.dataProvider = chartData;
		chart.categoryField = "joindate";
		chart.startDuration = 1.0;
		// the following two lines makes chart 3D
		chart.depth3D = 20;
		chart.angle = 30;

		//chart.addListener("dataUpdated", zoomChart);

		// AXES
		// category
		var categoryAxis = chart.categoryAxis;
		categoryAxis.labelRotation = 0;
		categoryAxis.dashLength = 5;
		categoryAxis.title = "Date <%=categorytitle%>";
		categoryAxis.titleColor = "#2d2a2a";
		categoryAxis.gridPosition = "start";
		categoryAxis.gridColor = "#81819d";
		categoryAxis.axisColor = "#797984";
		categoryAxis.color =  "#2d2a2a";

		// value
		var valueAxis = new AmCharts.ValueAxis();
		valueAxis.title = "Visitors";
		valueAxis.titleColor = "#2d2a2a";
		valueAxis.dashLength = 5;
		chart.addValueAxis(valueAxis);
		valueAxis.gridColor = "#81819d";
		valueAxis.axisColor = "#797984";
		valueAxis.color =  "#2d2a2a";

		// GRAPH
		var graph = new AmCharts.AmGraph();
		graph.valueField = "visits";
		graph.colorField = "color";
		graph.balloonText = "<span style='font-size:14px'>[[category]]<%=graphvalue%>: <b>[[value]]</b></span>";
		graph.type = "column";
		graph.lineAlpha = 0;
		graph.fillAlphas = 1;
		chart.addGraph(graph);

		// CURSOR
		var chartCursor = new AmCharts.ChartCursor();
		chartCursor.cursorAlpha = 0;
		chartCursor.zoomable = true;
		chartCursor.categoryBalloonEnabled = true;
		chart.addChartCursor(chartCursor);

		chart.creditsPosition = "top-right";

		// WRITE
		chart.write("chartdiv");
	});
<% } %>

	function zoomChart() {
		// different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
		chart.zoomToIndexes(0, 96);
	}

</script>
</body>
</html>