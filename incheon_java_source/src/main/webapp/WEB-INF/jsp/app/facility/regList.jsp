<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );

	int totalCount = CommonUtil.getNullInt((String)request.getAttribute( "count" ), 0);
	List regList = (List)request.getAttribute("regList");

	int page_now      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
	String strLinkPage   = "/regList.do"; //링크 페이지
	String strParam      = CommonUtil.getRequestQueryString( request );
	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "per_page" ),10) ;

	int nCols = 6;
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_board.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/board/skincomplaints/style.css"/>
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

			        <div class="sub-tit">
			            <h3>시설 예약 확인</h3>
			            <a href="/regCheck.do?menuno=<%=CommonUtil.nvl(reqMap.get("menuno"))%>&mode=list" class="btn2 abs-btn">나의 이용예약 보기</a>
			        </div>

			<!-- board contents -->

		        <!-- list -->
		        <table class="table2">
		            <colgroup>
		                <col style="width: 100px;">
		                <col style="width: auto;">
		                <col style="width: 150px;">
		                <col style="width: 150px;">
		                <col style="width: 100px;">
		                <col style="width: 100px;">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>번호</th>
		                    <th>복지시설</th>
		                    <th>예약자</th>
		                    <th>예약일</th>
		                    <th>예약상태</th>
		                    <th>대기번호</th>
		                </tr>
		            </thead>
		            <tbody>
					<%
						String viewUrl = "";
					    if(regList != null && regList.size() > 0){

					       int iSeqNo = totalCount - ( page_now - 1 ) * nPerPage;
					       for( int i = 0; i < regList.size(); i++ ) {
					            Map regMap = ( Map ) regList.get(i);

					            viewUrl = "/regCheck.do?" + strParam + "&mode=pwview&dd=" + regMap.get("RECEIVE_DD") + "&seq=" + regMap.get("RECEIVE_SEQNO");
					%>
		                <tr>
		                    <td><%= iSeqNo %></td>
		                    <td><a href="<%=viewUrl%>"><%=CommonUtil.nvl(regMap.get("WFFCLTY_NM"))%></a></td>
							<td><%=CommonUtil.getMaskedName(regMap.get("RSVCTM").toString())%></td>
							<td><%=CommonUtil.getDateFormat(regMap.get("RECEIVE_DD"), "ymd") %></td>
							<td><span class="bbs-stat <% if (CommonUtil.nvl(regMap.get("PROGRESS_STS")).toString().equals("0")) { %>white<% } else { %>blue<% } %>">
		                    <%=CommonUtil.nvl(regMap.get("REG_TEXT"))%></span>
							</td>
							<td><% if (CommonUtil.nvl(regMap.get("PROGRESS_STS")).equals("0")) { %><%=CommonUtil.nvl(regMap.get("RANK"))%><% } %></td>
		                </tr>
					<%       iSeqNo--;
					       }
					    } else {
					%>
					          <tr>
					            <td style='center;' colspan='<%=nCols%>'><%=CommDef.Message.NO_DATA %></td>
					          </tr>
					<%  } %>
		            </tbody>
		        </table>

		        <!-- s:paging -->
		        <div class="paging">
					<%=CommonUtil.getFrontPageNavi( strLinkPage, totalCount ,page_now, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
		        </div>
		        <!-- e:paging -->

			<!-- board contents -->
				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>

<script type="text/javascript">
$(document).ready(function() {

});
</script>

</body>
</html>