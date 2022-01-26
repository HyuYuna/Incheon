<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)  request.getAttribute( "reqMap" );
	String chartHeight = "435px";
	
	String pagecode = CommonUtil.nvl(reqMap.get("pagecode"));
	String txt_sdate = CommonUtil.nvl(reqMap.get("txt_sdate"));	
	String txt_edate = CommonUtil.nvl(reqMap.get("txt_edate"));	
	String searchyeartext = CommonUtil.nvl(reqMap.get("searchyeartext"));	
	String search_ymd = CommonUtil.getCurrentDate("","YYYY-MM-DD");
	
	if (txt_sdate.equals("")) txt_sdate = search_ymd;
	if (txt_edate.equals("")) txt_edate = search_ymd;
	if (searchyeartext.equals("")) searchyeartext = CommDef.SEARCH_YEAR;
%>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/amcharts.js"></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/serial.js"></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/pie.js" ></script>
<script type="text/javascript" src="<%=CommDef.CONTENTS_PATH%>/plugin/amcharts/themes/light.js"></script>
<style>
#chartdiv {background: #ffffff;color:#ffffff;	
	width		: 100%;
	height	: <%=chartHeight%>;
	font-size	: 11px;
}		
</style>

	<% if (!pagecode.equals("4"))  { //년별 검색이 아닐 경우에만 노출 %>
		<form name="search_list" id="search_list" method="get" action="<%=request.getAttribute("javax.servlet.forward.request_uri")%>">
			<input type="hidden" name="pagecode" value="<%=pagecode%>"/>
			<input type="hidden" name="menu_no" value="<%=CommonUtil.nvl(reqMap.get("menu_no"))%>"/>
			<div class="__search">
				<span class="calendar">
					<% if (pagecode.equals("1"))  { //시간대별 검색 %>
						<span class="__date"><input type="text" class="__form1" name="txt_sdate" id="txt_sdate" datepicker value="<%=txt_sdate%>" readonly></span>
					<% } else if (pagecode.equals("2"))  { //일별 검색 %>
						<button type="button" class="__btn1" onclick="javascript:set_date('오늘');">오늘</button>
						<button type="button" class="__btn1" onclick="javascript:set_date('어제');">어제</button>
						<button type="button" class="__btn1" onclick="javascript:set_date('이번주');">이번주</button>
						<button type="button" class="__btn1" onclick="javascript:set_date('이번달');">이번달</button>
						<button type="button" class="__btn1" onclick="javascript:set_date('지난주');">지난주</button>
						<button type="button" class="__btn1" onclick="javascript:set_date('지난달');">지난달</button>
						<span class="__date"><input type="text" class="__form1" name="txt_sdate" id="txt_sdate" datepicker value="<%=txt_sdate%>" readonly></span> ~
						<span class="__date"><input type="text" class="__form1" name="txt_edate" id="txt_edate" datepicker value="<%=txt_edate%>" readonly></span>
					<% } else if (pagecode.equals("3"))  { //월별 검색 %>
						<select name="searchyeartext" id="searchyeartext" class="__form1">
						<%
							Integer startYear = 2019;
							Integer curr_year = Calendar.getInstance().get(Calendar.YEAR);
							
							for (int y = startYear; startYear <=curr_year;  startYear++) {
						%>
							<option value="<%=startYear%>" <% if (CommonUtil.getNullInt(searchyeartext, startYear) == startYear) { %>selected<% } %>><%=startYear %></option>
						<% } %>
						</select> 년&nbsp;
					<% } %>
				</span>
				<button type="submit" class="__btn1 type3">검색</button>
			</div>
		</form>
	<% } %>
	
<script type="text/javascript">

$(function() {

	<% if (pagecode.equals("1"))  { //시간대별 검색 %>
		$('#txt_sdate').datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '<%=CommDef.SEARCH_START_YEAR%>:<%=CommDef.SEARCH_END_YEAR%>'
		});
	<% } else if (pagecode.equals("2"))  { //일별 검색 %>
		$('#txt_sdate').datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '<%=CommDef.SEARCH_START_YEAR%>:<%=CommDef.SEARCH_END_YEAR%>'
		});
		$('#txt_edate').datepicker({
			changeMonth: true,
			changeYear: true,
			yearRange: '<%=CommDef.SEARCH_START_YEAR%>:<%=CommDef.SEARCH_END_YEAR%>'
		});
	<% } %>

});

function set_date(today)
{
        if (today == "오늘") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
    } else if (today == "어제") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "prevday")%>";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("", "prevday")%>";
    } else if (today == "이번주") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "firstWeek")%>";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
    } else if (today == "이번달") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("","YYYY-MM")%>-01";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
    } else if (today == "지난주") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "prevWeek1")%>";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("", "prevWeek2")%>";
    } else if (today == "지난달") {
        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("","prevmonth1")%>";
        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("","prevmonth2")%>";
    } else if (today == "전체") {
        document.getElementById("txt_sdate").value = "";
        document.getElementById("txt_edate").value = "";
    }
}
</script>
	
	