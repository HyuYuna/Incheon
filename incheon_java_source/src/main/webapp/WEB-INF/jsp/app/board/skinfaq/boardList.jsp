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

	<!-- skinfaq -->
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

		<!-- faq 시작 -->
		<div id="sb-faq">
			<ul class="faq_list">
			<%
				String viewUrl = "";
			    if(lstRs != null && lstRs.size() > 0){

			       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			    	   Map rsMap = ( Map ) lstRs.get( iLoop );
			%>
				<li>
					<div class="ques">
						<a href="#" class="sbj"><%=CommonUtil.getStrCut(CommonUtil.nvl(rsMap.get("TITLE")),150) %></a>
					</div>
					<div class="ans nostyle">
						<%=CommonUtil.recoveryLtGt(CommonUtil.nvl(rsMap.get("CONTENT")))%>
						<!-- 관리자인 경우에만 노출 -->
						<% if (userLevel > 9) { %>
						<br /><br />
						<a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("BRD_NO")) %>');" class="sb-btn type11">수정</a>
						<a href="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("BRD_NO")) %>');" class="sb-btn type22">삭제</a>
						<% } %>
					</div>
				</li>
			<%
					iSeqNo--;
			       }
			    } else {
			%>
				<li style="height:40px;">
					등록된 자료가 없습니다.
				</li>
			<%  } %>
			</ul>
		</div>
		<!-- faq  -->

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

	//바로삭제
	function fDelete(strSeq)
	{
		  vObj = document.viewform;

		  if (!confirm("삭제하시겠습니까?"))
			  return;

		  vObj.mode.value = "memberdel";
		  vObj.seq.value = strSeq;
		  vObj.action = "/boardDelete.do";

		  vObj.submit();
	}

	function fModify(strSeq)
	{
		  vObj = document.viewform;

		  vObj.seq.value = strSeq;
		  vObj.action = "/write.do";

		  vObj.submit();
	}

	</script>

	<!-- skinfaq -->

			<!-- board contents -->
			 	</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
<form name="viewform" method="post" enctype="multipart/form-data" action="/boardDelete.do">
<input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
<input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
<input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

<input name="boardno"	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
<input name="returl"      type="hidden" value="/board.do">
<input name="param"	type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
<input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
<input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
<input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
<input name="mode" type="hidden" value=""/>
</form>

</body>
</html>