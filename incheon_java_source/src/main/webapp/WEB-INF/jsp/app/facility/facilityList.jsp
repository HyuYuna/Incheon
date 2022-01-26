<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	List ca1List = (List)request.getAttribute("ca1List");
	List ca2List = (List)request.getAttribute("ca2List");
	List areaList = (List)request.getAttribute("areaList");

	int totalCount = CommonUtil.getNullInt((String)request.getAttribute( "count" ), 0);
	List facilityList = (List)request.getAttribute("facilityList");

	int page_now      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
	String strLinkPage   = "/facilityList.do"; //링크 페이지
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

			<!-- 시설 1차 카테고리 -->
			        <ul class="tab1 len6" id="tabCate2">
			            <li <% if (CommonUtil.nvl(reqMap.get("ca1"), "").equals("")) { %>class="active"<% } %>><a href="javascript:;;" id="categoryAllClick">전체</a></li>
			<%
			    if(ca1List != null && ca1List.size() > 0){

			       for( int ca1Loop = 0; ca1Loop < ca1List.size(); ca1Loop++ ) {
			            Map ca1ListMap = ( Map ) ca1List.get( ca1Loop );
			            
			            if (!CommonUtil.nvl(ca1ListMap.get("CA1")).equals("")) {
			%>
						<li data-ca1='<%=CommonUtil.nvl(ca1ListMap.get("CA1")) %>' data-gu1='<%=CommonUtil.nvl(reqMap.get("gu"), "")%>' data-menuno1='<%=CommonUtil.nvl(ca1ListMap.get("MENUNO"))%>' <% if (ca1ListMap.get("CA1").equals(reqMap.get("ca1"))) { %>class="active" id="category1No" data-menuno="<%=CommonUtil.nvl(ca1ListMap.get("MENUNO"))%>"<% } %>>
						<a href="<%=strLinkPage %>?ca1=<%=CommonUtil.nvl(ca1ListMap.get("CA1")) %><% if (!CommonUtil.nvl(reqMap.get("gu"), "").equals("")) { %>&gu=<%=CommonUtil.nvl(reqMap.get("gu"), "")%><% } %>&menuno=<%=CommonUtil.nvl(ca1ListMap.get("MENUNO"))%>"><%=CommonUtil.nvl(ca1ListMap.get("CA1_NM")) %></a>

                            <ul>
								<%
									List cate2List = (List)request.getAttribute("cate2List" + ca1Loop);
									if (cate2List != null && cate2List.size() > 0) {

								       for( int bLoop = 0; bLoop < cate2List.size(); bLoop++ ) {
								            Map cate2ListMap = ( Map ) cate2List.get( bLoop );
								%>
									<li>
										<a href="<%=strLinkPage %>?ca1=<%=CommonUtil.nvl(cate2ListMap.get("CA1")) %>&ca2=<%=CommonUtil.nvl(cate2ListMap.get("CA2")) %><% if (!CommonUtil.nvl(reqMap.get("gu"), "").equals("")) { %>&gu=<%=CommonUtil.nvl(reqMap.get("gu"), "")%><% } %>&menuno=<%=CommonUtil.nvl(cate2ListMap.get("MENUNO"))%>"><%=CommonUtil.nvl(cate2ListMap.get("CA2_NM")) %></a>
									</li>
								<%
										}
									}
								 %>
							 </ul>

						</li>
			<% 		
			            }
					}
			    }
			%>
			        </ul>
			<!-- 시설 1차 카테고리 -->

			<!-- 시설 2차 카테고리 -->
			<% if(ca2List != null && ca2List.size() > 0) { %>
			        <ul class="tab2">
			            <%-- <li <% if (CommonUtil.nvl(reqMap.get("ca2"), "").equals("")) { %>class="active"<% } %>><a href="javascript:;;" id="category2AllClick" data-cate2ca1="<%=CommonUtil.nvl(reqMap.get("ca1")) %>">전체</a></li> --%>
				<%
				    for( int ca2Loop = 0; ca2Loop < ca2List.size(); ca2Loop++ ) {
				        Map ca2ListMap = ( Map ) ca2List.get( ca2Loop );
				%>
						<li <% if (ca2ListMap.get("CA2").equals(reqMap.get("ca2"))) { %>class="active"<% } %>>
						<a href="<%=strLinkPage %>?ca1=<%=CommonUtil.nvl(ca2ListMap.get("CA1")) %>&ca2=<%=CommonUtil.nvl(ca2ListMap.get("CA2")) %><% if (!CommonUtil.nvl(reqMap.get("gu"), "").equals("")) { %>&gu=<%=CommonUtil.nvl(reqMap.get("gu"), "")%><% } %>&menuno=<%=CommonUtil.nvl(ca2ListMap.get("MENUNO"))%>"><%=CommonUtil.nvl(ca2ListMap.get("CA2_NM")) %></a>
						</li>
				<%
				    }
				%>
			        </ul>
			<% } %>
			<!-- 시설 2차 카테고리 -->

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
			                <a href="#" data-ajaxpop="/sisul.do?wcd=<%=CommonUtil.nvl(facilityMap.get("WFFCLTY_CD"))%>&menuno=<%=CommonUtil.nvl(reqMap.get("menuno"), "")%>"></a>
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

	//카테고리 전체 클릭
	$('#categoryAllClick').on('click', function() {
		if (guSelected != "") {
			location.href = "<%=strLinkPage %>?gu=" + guSelected + "&menuno=" + $('#menuTopMenu').val();
		} else {
			location.href = "<%=strLinkPage %>?menuno=" + $('#menuTopMenu').val();
		}
	});

	//카테고리 2차 전체 클릭
	$('#category2AllClick').on('click', function() {
		if (guSelected != "") {
			location.href = "<%=strLinkPage %>?ca1=" + $('#category2AllClick').attr("data-cate2ca1") + "&gu=" + guSelected + "&menuno=" + $('#category1No').attr("data-menuno");
		} else {
			location.href = "<%=strLinkPage %>?ca1=" + $('#category2AllClick').attr("data-cate2ca1") + "&menuno=" + $('#category1No').attr("data-menuno");
		}
	});

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
