<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	List areaList = (List)request.getAttribute("areaList");

	int totalCount = CommonUtil.getNullInt((String)request.getAttribute( "count" ), 0);
	List facilityList = (List)request.getAttribute("facilityList");

	int page_now      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
	String strLinkPage   = "/supportList.do"; //링크 페이지
	String strParam      = CommonUtil.getRequestQueryString( request );
	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "per_page" ),5) ;
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<body>
<div id="wrap">

	<!-- topmenu -->
	<jsp:include page="/home/inc/topmenu.do"></jsp:include>
	<!-- topmenu -->

		<section id="sub">

			<!-- subvisual -->
			<jsp:include page="/home/inc/subvisual.do"></jsp:include>
			<!-- subvisual -->

			<!-- navigator -->
			<%-- <jsp:include page="/home/inc/navigator.do"></jsp:include> --%>
			<!-- navigator -->

            <!-- start content -->
			<div id="content">

				<!-- facilitylnb -->
				<jsp:include page="/home/inc/lnb2.do"></jsp:include>
				<!-- facilitylnb -->

				<div id="subCont">

				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->

			        <div class="ctit1">
			            <h4 id="ctit1H4">전체지역 시설</h4>
			        </div>

			<!-- 지역 카테고리 -->
			        <div class="areaslt">
			            <select name="gu" id="gu" onchange="guChange(this.value);">
			                <option value="" <% if (CommonUtil.nvl(reqMap.get("gu"), "").equals("")) { %>selected<% } %>>전체지역</option>
						<%
						    if(areaList != null && areaList.size() > 0){

						       for( int areaLoop = 0; areaLoop < areaList.size(); areaLoop++ ) {
						            Map areaListMap = ( Map ) areaList.get( areaLoop );
						%>
							<option value="<%=CommonUtil.nvl(areaListMap.get("GU")) %>" <% if (CommonUtil.nvl(reqMap.get("gu"), "").equals(areaListMap.get("GU").toString())) { %>selected<% } %>><%=CommonUtil.nvl(areaListMap.get("GU_NM")) %></option>
						<% 		}
						    }
						%>
			            </select>
			        </div>
			<!-- 지역 카테고리 -->

			        <!-- list -->
			        <div class="listsch">
			            <span class="lec-total">
			                <strong class="blue"><%=CommonUtil.number_format(totalCount) %></strong> 개의 시설이 검색되었습니다.
			            </span>
			            <div class="sch">
			                <form action="facilityList.do" method="get">
			                	<input type="hidden" name="ca1" value="<%=CommonUtil.nvl(reqMap.get("ca1"), "")%>"/>
			                	<input type="hidden" name="ca2" value="<%=CommonUtil.nvl(reqMap.get("ca2"), "")%>"/>
			                	<input type="hidden" name="gu" value="<%=CommonUtil.nvl(reqMap.get("gu"), "")%>"/>
			                	<input type="hidden" name="menuno" value="<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>"/>
			                	<input type="text" name="shtext" id="shtext" placeholder="시설명을 입력하세요." class="inp" maxlength="50" value="<%=CommonUtil.nvl(reqMap.get("shtext"), "")%>"/><button type="submit" class="sbm"><i class="axi axi-search"></i></button>
			                </form>
			            </div>
			        </div>

			        <ul class="sisullist">

					<%
					    if(facilityList != null && facilityList.size() > 0){

					       for( int i = 0; i < facilityList.size(); i++ ) {
					            Map facilityMap = ( Map ) facilityList.get(i);
					%>
			            <li>
							<% if (CommonUtil.getNullInt(facilityMap.get("REGCNT"), 1) > 0) { %>
			                <span class="prgr-ico"><img src="<%=CommDef.HOME_CONTENTS %>/images/sub/sisul-prgr-ico.jpg" />이용예약가능</span>
			                <% } %>
			                <a href="#" data-ajaxpop="/supportSisul.do?wcd=<%=CommonUtil.nvl(facilityMap.get("WFFCLTY_CD"))%>&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>"></a>
			                <div class="types">
			                    <p><strong>시설종류</strong><%=CommonUtil.nvl(facilityMap.get("CA1NM")) %></p>
			                    <p><strong>시설유형</strong><%=CommonUtil.nvl(facilityMap.get("CA2NM")) %></p>
			                </div>
			                <span class="tit"><%=CommonUtil.nvl(facilityMap.get("WFFCLTY_NM")) %></span>
			                <div class="info">
			                    <p><i class="axi axi-map-marker"></i><%=CommonUtil.nvl(facilityMap.get("ADDR_BASE")) %> <%=CommonUtil.nvl(facilityMap.get("ADDR_DETAIL")) %></p>
			                    <p><i class="axi axi-phone"></i><%=CommonUtil.nvl(facilityMap.get("PHONE_NUM")) %></p>
			                </div>
			            </li>
					<% 		}
					    }
					%>

			        </ul>

					<!-- 리스트 페이징 -->
					<div class='paging'>
						<%=CommonUtil.getFrontPageNavi( strLinkPage, totalCount ,page_now, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
					</div>
					<!-- 리스트 페이징 -->

			    </div>

			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>

<script>
$(document).ready(function() {

	//구 선택값
	var guSelected = $('#gu option:selected').val();
	var guSelectedName = $('#gu option:selected').text();

	//타이틀 입력
	$('#ctit1H4').text(guSelectedName + " 시설");
});

//지역 선택
function guChange(value) {
	var guvalue = value;
	if (guvalue != "") {
		location.href = "<%=strLinkPage %>?menuno=" + $('#menuTopMenu').val() + "&gu=" + guvalue;
	} else {
		location.href = "<%=strLinkPage %>?menuno=" + $('#menuTopMenu').val();
	}
}
</script>

</body>
</html>