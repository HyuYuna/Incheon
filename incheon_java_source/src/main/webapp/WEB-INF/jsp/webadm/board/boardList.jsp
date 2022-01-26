<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>

<%
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List noticeList     = (List) request.getAttribute( "noticeList" );
  	List lstRs     = (List) request.getAttribute( "list" );
  	ServiceUtil sUtil = new ServiceUtil();

  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);

 	String strLinkPage   = CommDef.ADM_PATH + "/board/boardList.do"; // request.getRequestURL().toString(); // 현재 페이지

  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT );

  	int nCols = 6;
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">

		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>

		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<jsp:include page="/webadm/inc/search.do"  flush="false"/>

			<div style="text-align:right;">
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite();">게시글 등록</button>
			</div>
			<br/>
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" id="allCheck" name="allCheck"></th>
						<th scope="col" class="__p">순번</th>
						<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) { %>
						<th scope="col">카테고리</th>
						<% nCols = nCols + 1; } %>
						<th class="subject" scope="col">제목</th>
						<th scope="col">작성자</th>
						<th scope="col">작성일</th>
						<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) { %>
						<th scope="col">강제순번</th>
						<% nCols = nCols + 1; } %>
						<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { %>
						<th scope="col">접수상태</th>
						<% nCols = nCols + 1; } %>
						<th scope="col">수정/삭제</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post">

                     <input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
                     <input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
                     <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                     <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                     <input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

                     <input name="returl"      type="hidden" value="<%=strLinkPage%>"/>
                     <input name="param" type="hidden" value="<%=strParam %>"/>

                     <input name="seq"   type="hidden" value=""/>
                     <input name="mode" type="hidden" value=""/>
                     <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>
                     <input name="brd_mgrno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("brd_mgrno"))%>"/>
                     <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
			<%
			    if(noticeList != null && noticeList.size() > 0){

			       for( int noticeLoop = 0; noticeLoop < noticeList.size(); noticeLoop++ ) {
			            Map rsNoticeMap = ( Map ) noticeList.get( noticeLoop );
			%>
					<tr>
						<td>
							<input type="checkbox" name="seqno" id="seqno" value="<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>">
						</td>
						<td class="__p"><b>공지</b></td>
						<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) { %>
						<td><%=CommonUtil.nvl(rsNoticeMap.get("CATE_NM")) %></td>
						<% } %>
						<td class="subject">
							<a href="javascript:fView('<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>')"><%=CommonUtil.getStrCut(CommonUtil.nvl(rsNoticeMap.get("TITLE")),150) %></a>
							<%=CommonUtil.getReplyComma(CommonUtil.nvl(rsNoticeMap.get("COMMENT_CNT"))) %>
							<%=CommonUtil.getNewImage(CommonUtil.nvl(rsNoticeMap.get("REG_DT"))) %>
						</td>
						<td><%=CommonUtil.nvl(rsNoticeMap.get("REG_NAME")) %></td>
						<td><%=CommonUtil.getDateFormat(rsNoticeMap.get("REG_DT"), "-") %></td>
						<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) { %>
						<td><input type="text" name="board_sort<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>" id="board_sort<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>" value="<%=CommonUtil.nvl(rsNoticeMap.get("BOARD_SORT"))%>" class="__form1" style="width:50px;text-align:center;" /></td>
						<% } %>
						<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //민원신고 게시판 %>
						<td><b>[<%=sUtil.getCodeName("MINWON", CommonUtil.nvl(rsNoticeMap.get("ETC_FIELD2"))) %>]</b></td>
						<% } %>
						<td>
                              <a href="javascript:fModify('<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>')" class="__btn1 type2">수정</a>
                              <a href="javascript:fDelete('<%=CommonUtil.nvl(rsNoticeMap.get("BRD_NO"))%>')" class="__btn1 type3">삭제</a>
						</td>
					</tr>
			<%
			       }
			    }
			%>

			<%
			    if(lstRs != null && lstRs.size() > 0){

			       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );
			%>
					<tr>
						<td>
							<input type="checkbox" name="seqno" id="seqno" value="<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>">
						</td>
						<td class="__p"><%=iSeqNo%></td>
						<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) { %>
						<td><%=CommonUtil.nvl(rsMap.get("CATE_NM")) %></td>
						<% } %>
						<td class="subject">
							<%=CommonUtil.getListSecret(CommonUtil.nvl(rsMap.get("SECRET_YN")), "")%><%=CommonUtil.getReplylen(CommonUtil.nvl(rsMap.get("BOARD_REPLY")), "") %><a href="javascript:fView('<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>')">
							<%=CommonUtil.getStrCut(CommonUtil.nvl(rsMap.get("TITLE")),150) %></a>
							<%=CommonUtil.getReplyComma(CommonUtil.nvl(rsMap.get("COMMENT_CNT"))) %>
							<%=CommonUtil.getNewImage(CommonUtil.nvl(rsMap.get("REG_DT"))) %>
						</td>
						<td><%=CommonUtil.nvl(rsMap.get("REG_NAME")) %></td>
						<td><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"), "-") %></td>
						<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) { %>
						<td><input type="text" name="board_sort<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>" id="board_sort<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>" value="<%=CommonUtil.nvl(rsMap.get("BOARD_SORT"))%>" class="__form1" style="width:50px;text-align:center;" /></td>
						<% } %>
						<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //민원신고 게시판 %>
						<td><b>[<%=sUtil.getCodeName("MINWON", CommonUtil.nvl(rsMap.get("ETC_FIELD2"))) %>]</b></td>
						<% } %>
						<td>
							<a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>')" class="__btn1 type2">수정</a>
							<a href="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("BRD_NO"))%>')" class="__btn1 type3">삭제</a>
						</td>
					</tr>
			<%       iSeqNo--;
			       }
			    } else {
			%>
			          <tr>
			            <td align="center" colspan="<%=nCols%>"><%=CommDef.Message.NO_DATA %></td>
			          </tr>
			<%  } %>
					</form>
				</tbody>
			</table>

			<div class="__botarea">
				<div class="lef">
					<button type="button" class="__btn2" onclick="javascript:boardCheckDel();">선택삭제</button>
					<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) { %>
					<button type="button" class="__btn2" onclick="javascript:boardCheckUpdate();">일괄수정</button>
					<% } %>
				</div>

				<div class="cen">
					<div class="__paging">
						<%=CommonUtil.getAdmPageNavi( strLinkPage, nRowCount ,nPageNow, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
					</div>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>

</div>
<script>

	function fView(seqNo)
	{
	  vObj = document.listform;
	  vObj.seq.value = seqNo;
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardView.do";

	  vObj.submit();
	}

   function fWrite()
   {
	  vObj = document.listform;

	  vObj.seq.value = '';
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardWrite.do";

	  vObj.submit();
   }

   function fModify(strSeq)
   {
	  vObj = document.listform;

	  vObj.seq.value = strSeq;
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardWrite.do";

	  vObj.submit();
   }

   function fDelete(strSeq)
   {
	  vObj = document.listform;

	  if (!confirm("삭제하시겠습니까?"))
		  return;

	  vObj.mode.value = "del";
	  vObj.seq.value = strSeq;
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardDelete.do";

	  vObj.submit();
   }

	//선택삭제
	function boardCheckDel() {

		vObj = document.listform;

		if (!$('input:checkbox[id=seqno]').is(':checked')) {
			alert("삭제할 데이터를 체크해주세요.");
			return;
		}

		if (window.confirm("선택한 데이터를 정말로 삭제하시겠습니까?\n삭제하실 경우 모든 데이터가 사라집니다.")) {
			vObj.mode.value = "multidel";
			vObj.action = "<%=CommDef.ADM_PATH %>/board/boardDelete.do";
			vObj.submit();
		}
	}

	//일괄수정
	function boardCheckUpdate() {
		vObj = document.listform;

		if (!$('input:checkbox[id=seqno]').is(':checked')) {
			alert("수정할 데이터를 체크해주세요.");
			return;
		}

		vObj.action = "<%=CommDef.ADM_PATH %>/board/boardUpdate.do";
		vObj.submit();
	}

</script>
</body>
</html>
