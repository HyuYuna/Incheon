<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List noticeList     = (List) request.getAttribute( "noticeList" );
  	Map userMap = (Map)request.getAttribute("userMap");
  	List lstRs     = (List) request.getAttribute( "list" );
	ServiceUtil sUtil = new ServiceUtil();

  	int userLevel = 1; //기본 유저레벨
  	String userid = "guest"; //기본 아이디
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);
  	int totalListCount = noticeList.size() + nRowCount;

 	String strLinkPage   = "/board.do"; // request.getRequestURL().toString(); // 현재 페이지

  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ),  CommonUtil.getNullInt(brdMgrMap.get("LIST_CNT"), 0));

  	int nCols = 6;

  	if (userMap != null) { //로그인 유저라면
  		userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
  		userid = CommonUtil.nvl(userMap.get("USER_ID"));
  	}
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_board.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/board/<%=CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() %>/style.css"/>
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

				<!-- lnb -->
				<jsp:include page="/home/inc/lnb.do"></jsp:include>
				<!-- lnb -->

				<div id="subCont">

				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->

			<!-- board contents -->

		        <!-- list -->
		        <table class="table2">
		            <colgroup>
		                <col style="width: 100px;">
		                <col style="width: 150px;">
		                <col style="width: auto;">
		                <col style="width: 100px;">
		                <col style="width: 100px;">
		                <col style="width: 100px;">
		            </colgroup>
		            <thead>
		                <tr>
		                    <th>번호</th>
		                    <th>분류</th>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>작성일</th>
		                    <th>진행상태</th>
		                </tr>
		            </thead>
		            <tbody>
			<%
				String viewUrl = "";
			    if(lstRs != null && lstRs.size() > 0){

			       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );

			            if (CommonUtil.nvl(rsMap.get("SECRET_YN")).equals("Y")) { //비밀글일 경우

			            if (userLevel > 9) { //관리자일경우 view페이지 패스
			            	viewUrl = "/view.do?" + strParam + "&seq=" + rsMap.get("BRD_NO");
			            } else {
			            	if (userid.equals("guest")) { //비회원일 경우
			            		if (CommonUtil.nvl(rsMap.get("ORI_REG_ID")).equals("guest")) { //원글이 비회원이 작성한 글만 비밀번호 페이지로 전송
			            			viewUrl = "/minwon.do?" + strParam + "&mode=pwview&seq=" + rsMap.get("BRD_NO");
			            		} else {
			            			viewUrl = "javascript:alert('자신이 작성한 글만 열람할수 있습니다.');";
			            		}
			            	} else { //회원일 경우
			            		if (CommonUtil.nvl(rsMap.get("ORI_REG_ID")).equals("guest")) { //원글이 비회원이 작성한 글만 비밀번호 페이지로 전송
			            			viewUrl = "/minwon.do?" + strParam + "&mode=pwview&seq=" + rsMap.get("BRD_NO");
			            		} else {
			            			if (CommonUtil.nvl(rsMap.get("ORI_REG_ID")).equals(userid)) { //원글이 자신이 작성한 글일경우 패스
			            				viewUrl = "/view.do?" + strParam + "&seq=" + rsMap.get("BRD_NO");
			            			} else {
			            				viewUrl = "javascript:alert('자신이 작성한 글만 열람할수 있습니다.');";
			            			}
			            		}
			            	}
			            }
			           } else {
			        	   viewUrl = "/view.do?" + strParam + "&seq=" + rsMap.get("BRD_NO");
			           }
			%>
		                <tr>
		                    <td><%=iSeqNo%></td>
		                    <td><%=sUtil.getCodeName(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(rsMap.get("CATEGORY_CD"))) %></td>
		                    <td>
							<a href="<%=viewUrl%>"><%=CommonUtil.getNewImage(CommonUtil.nvl(rsMap.get("REG_DT")), "board") %> <%=CommonUtil.getMaskedName(rsMap.get("REG_NAME").toString())%> 님의 민원이 접수되었습니다.</a>
		                    </td>
		                    <td><%=CommonUtil.getMaskedName(rsMap.get("REG_NAME").toString())%></td>
		                    <td><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"), "ymd") %></td>
		                    <td><span class="bbs-stat <% if (CommonUtil.nvl(rsMap.get("ETC_FIELD2")).toString().equals("002")) { %>white<% } else if (CommonUtil.nvl(rsMap.get("ETC_FIELD2")).toString().equals("003")) { %>blue<% } %>">
		                    <%=sUtil.getCodeName("MINWON", CommonUtil.nvl(rsMap.get("ETC_FIELD2"))) %></span>
		                    </td>
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
		        	<%=CommonUtil.getFrontPageNavi( strLinkPage, nRowCount ,nPageNow, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
		        </div>
		        <!-- e:paging -->

				<% if (CommonUtil.getNullInt(brdMgrMap.get("WRITE_LEVEL_CD"), 1) <=  userLevel) { //글쓰기 권한 체크%>
		        <div class="btnWrap tar">
		            <a href="write.do?<%=strParam %>" class="bbtn1">등록하기</a>
		        </div>
				<% } %>

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
	//토탈카운터 설정
	var boardTotalCount = '<%=totalListCount%>';
	$('#sb-wrap #sb-search .total strong').text(boardTotalCount);
});
</script>

</body>
</html>
