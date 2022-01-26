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

	String categorytitle = "(일별선택) / 검색조건 : " + CommonUtil.nvl(reqMap.get("txt_sdate")) + " ~ " + CommonUtil.nvl(reqMap.get("txt_edate"));
	String graphvalue = "일";

	int listcount = CommonUtil.getNullInt(reqMap.get("listRowCount"), 0);
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>

		<div id="tit">
			<h2><i class="axi axi-menu2"></i> 관리자메인</h2>
			<p class="navi">
				<i class="axi axi-home"></i> <em><i class="axi axi-angle-right"></i></em><span>관리자메인</span>
			</p>
		</div>

		<div id="content" style="width: 100%;">

			<div id="mboxArea">

				<!-- 일간 통계 챠트 -->
<!-- 				<div class="box">
					<div id="chartdiv" style="width: 100%; height: 270px;"></div>
				</div> -->
				<!-- 일간 통계 챠트 -->

				<!-- 메인 게시판 노출 -->
				<%
					List boardMgrList = (List)request.getAttribute("boardMgrList");
					if (boardMgrList != null && boardMgrList.size() > 0) {

				       for( int iLoop = 0; iLoop < boardMgrList.size(); iLoop++ ) {
				            Map rsMap = ( Map ) boardMgrList.get( iLoop );
				%>
					<div class="box">
						<h5 class="tit">
							<%=CommonUtil.nvl(rsMap.get("MENU_NM")) %><a href="<%=CommonUtil.getMenuUrl(rsMap) %>" class="more">more</a>
						</h5>
						<div class="cont">
							<ul class="list">
							<%
								List boardMainList = (List)request.getAttribute("boardMainList" + iLoop);
								if (boardMainList != null && boardMainList.size() > 0) {

							       for( int bLoop = 0; bLoop < boardMainList.size(); bLoop++ ) {
							            Map boardMap = ( Map ) boardMainList.get( bLoop );
							%>
								<li><a class="sbj" href="javascript:fView('<%=CommonUtil.nvl(boardMap.get("BRD_NO"))%>','<%=CommonUtil.nvl(rsMap.get("MENU_NO")) %>','<%=CommonUtil.nvl(rsMap.get("BRD_MGRNO"))%>');"><%=CommonUtil.getStrCut(CommonUtil.nvl(boardMap.get("TITLE")),150) %></a><span class="date"><%=CommonUtil.getDateFormat(CommonUtil.nvl(boardMap.get("REG_DT")).substring(0, 8), "ymd2") %></span></li>
							<%
									}
								}
							 %>
							</ul>
						</div>
					</div>
				<%
				       }
					}
				%>
				<!-- 메인 게시판 노출 -->

			</div>

		</div>

	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
</div>

<form name="listform" method="post">
<input name="seq"   type="hidden" value=""/>
<input name="menu_no"     type="hidden" value=""/>
<input name="brd_mgrno"     type="hidden" value=""/>
</form>

<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/amcharts.js"></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/serial.js"></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/pie.js" ></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/themes/light.js"></script>
<script type="text/javascript">
	var chart;

	var chartData = [
		<%
			if (listcount > 0) {
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );

			            if (iLoop > 0) out.println(",");

			            out.println("{");
			            out.println("\"joindate\":\"" + CommonUtil.nvl(rsMap.get("JOIN_DATE")).substring(6,8) + "\",");
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

	function fView(seqNo, menu_no, brd_mgrno)
	{
	  vObj = document.listform;
	  vObj.seq.value = seqNo;
	  vObj.menu_no.value = menu_no;
	  vObj.brd_mgrno.value = brd_mgrno;
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardView.do";

	  vObj.submit();
	}

</script>
</body>
</html>
