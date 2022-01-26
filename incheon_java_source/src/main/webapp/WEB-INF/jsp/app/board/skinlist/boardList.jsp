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

  	int nCols = 5;

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

	<!-- skinlist -->
	<div id="sb-wrap">

		<!-- s:게시판 검색 -->
		<div id="sb-search">
			<span class="total">전체 <strong></strong>건</span>
			<form name="search_list" id="search_list" method="get" action="<%=request.getAttribute("javax.servlet.forward.request_uri")%>">
				<input type="hidden" name="menuno" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>"/>
				<input type="hidden" name="boardno" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>"/>
				<fieldset>
					<legend>게시판 검색</legend>

					<!--카테고리 검색 -->
					<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) { //카테고리 관리  %>
					<div class="where">
						<select name="category" id="category">
							<option value="">카데고리선택</option>
							<%=sUtil.getSelectBox(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(reqMap.get("category"))) %>
						</select>
					</div>
					<% } %>
					<!--카테고리 검색 -->

					<!-- select 검색바 출력-->
					<div class="where">
						<select name="keykind" id="keykind" >
							<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>제목</option>
							<option value="reg_name" <%="reg_name".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>작성자</option>
							<option value="reg_id" <%="reg_id".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>작성자ID</option>
							<option value="content" <%="content".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>내용</option>
						</select>
					</div>
					<!-- select 검색바 출력-->

					<div class="inp">
						<input type="text" name="keyword" id="keyword" class="keyword" placeholder="검색어를 입력해주세요." value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>" maxlength="30"/>
						<input type="submit" value="검색" class="sbm" />
					</div>
				</fieldset>
			</form>
		</div>
		<!-- e:게시판 검색 -->


		<div id="sb-list">
			<table class="list_tbl">
				<colgroup>
					<col style="width: 70px;" />
					<col style="width: auto;" />
					<col style="width: 120px;" />
					<col style="width: 70px;" />
					<col style="width: 70px;" />
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회</th>
					</tr>
				</thead>
				<tbody>
			<!-- 공지글 -->
			<%
			    if(noticeList != null && noticeList.size() > 0){

			       for( int noticeLoop = 0; noticeLoop < noticeList.size(); noticeLoop++ ) {
			            Map rsNoticeMap = ( Map ) noticeList.get( noticeLoop );
			%>
					<tr class="tr_notice">
						<td class="no"><b>공지</b></td>
						<td class="sbj">
							<a href="/view.do?<%=strParam%>&seq=<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>"><%=CommonUtil.getNewImage(CommonUtil.nvl(rsNoticeMap.get("REG_DT")), "board") %><%=CommonUtil.getStrCut(CommonUtil.nvl(rsNoticeMap.get("TITLE")),150) %></a>
							<%=CommonUtil.getReplyComma(CommonUtil.nvl(rsNoticeMap.get("COMMENT_CNT"))) %>
						</td>
						<td><%=CommonUtil.nvl(rsNoticeMap.get("REG_NAME")) %></td>
						<td><%=CommonUtil.getDateFormat(rsNoticeMap.get("REG_DT"), "ymd") %></td>
						<td><%=CommonUtil.getComma(CommonUtil.nvl(rsNoticeMap.get("VIEW_CNT"))) %></td>
					</tr>
			<%
			       }
			    }
			%>
			<!-- 공지글 -->

			<!-- 일반글 -->
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
			            			viewUrl = "/password.do?" + strParam + "&mode=pwview&seq=" + rsMap.get("BRD_NO");
			            		} else {
			            			viewUrl = "javascript:alert('자신이 작성한 글만 열람할수 있습니다.');";
			            		}
			            	} else { //회원일 경우
			            		if (CommonUtil.nvl(rsMap.get("ORI_REG_ID")).equals("guest")) { //원글이 비회원이 작성한 글만 비밀번호 페이지로 전송
			            			viewUrl = "/password.do?" + strParam + "&mode=pwview&seq=" + rsMap.get("BRD_NO");
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
						<td class="no"><%=iSeqNo%></td>
						<td class="sbj">
							<%=CommonUtil.getListSecret(CommonUtil.nvl(rsMap.get("SECRET_YN")), "board")%><%=CommonUtil.getReplylen(CommonUtil.nvl(rsMap.get("BOARD_REPLY")), "") %>
							<a href="<%=viewUrl%>"><%=CommonUtil.getNewImage(CommonUtil.nvl(rsMap.get("REG_DT")), "board") %><%=CommonUtil.getStrCut(CommonUtil.nvl(rsMap.get("TITLE")),150) %></a>
							<%=CommonUtil.getReplyComma(CommonUtil.nvl(rsMap.get("COMMENT_CNT"))) %>
						</td>
						<td><%=CommonUtil.nvl(rsMap.get("REG_NAME")) %></td>
						<td><em>작성일</em><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"), "ymd") %></td>
						<td><em>조회</em><%=CommonUtil.getComma(CommonUtil.nvl(rsMap.get("VIEW_CNT"))) %></td>
					</tr>
			<%       iSeqNo--;
			       }
			    } else {
			%>
			          <tr>
			            <td style='center;' colspan='<%=nCols%>'><%=CommDef.Message.NO_DATA %></td>
			          </tr>
			<%  } %>
			<!-- 일반글 -->
				</tbody>
			</table>
		</div>


		<!-- 리스트 페이징 -->
		<div class='paging'>
			<%=CommonUtil.getFrontPageNavi( strLinkPage, nRowCount ,nPageNow, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
		</div>
		<!-- 리스트 페이징 -->


		<!-- s:foot button -->
		<% if (CommonUtil.getNullInt(brdMgrMap.get("WRITE_LEVEL_CD"), 1) <=  userLevel) { //글쓰기 권한 체크%>
		<div id="sb-footer">
			<div class="right">
				<a href="write.do?<%=strParam %>" class="sb-btn type1">글쓰기</a>
			</div>
		</div>
		<% } %>
		<!-- e:foot button -->

	</div>

	<script type="text/javascript">
	$(document).ready(function() {
		//토탈카운터 설정
		var boardTotalCount = '<%=totalListCount%>';
		$('#sb-wrap #sb-search .total strong').text(boardTotalCount);
	});
	</script>

	<!-- skinlist -->

			<!-- board contents -->
				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>

</body>
</html>