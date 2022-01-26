<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
	Map prevMap = (Map) request.getAttribute("prevMap"); //이전글
	Map nextMap = (Map) request.getAttribute("nextMap"); //다음글
	List commentList = (List) request.getAttribute("commentList");
	List lstFile   = (List) request.getAttribute( "lstFile" );
	int userLevel = 1; //기본 유저레벨
	String userid = "guest"; //기본 아이디
	String replyYN = "N"; //기본 댓글 권한

	ServiceUtil sUtil = new ServiceUtil();
	Map userMap      = 	(Map)request.getAttribute("userMap");

    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&boardno="       + CommonUtil.nvl( reqMap.get( "boardno"));
    strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));

    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);

  	if (userMap != null) { //로그인 유저라면
  		userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
  		userid = CommonUtil.nvl(userMap.get("USER_ID"));
  	}

  	if (CommonUtil.getNullInt(brdMgrMap.get("COMMENT_LEVEL_CD"), 1) <= userLevel) {
  		replyYN = "Y";
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
			<form name="writeform" method="post" enctype="multipart/form-data" action="/boardWork.do">
                <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                <input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="boardno"	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
	            <input name="returl"      type="hidden" value="/board.do">
	            <input name="param"	type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
		        <input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
		        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
		        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
		        <input name="mode" type="hidden" value=""/>
		        <% if (!CommonUtil.nvl(reqMap.get("viewpass")).equals("")) { %><input name="viewpass" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("viewpass"))%>"/><% } %>
		    </form>

			        <!-- view -->
			        <table class="table2 write">
			            <tbody>
			                <tr>
			                    <th>상태</th>
			                    <td>
									<span class="bbs-stat <% if (CommonUtil.nvl(dbMap.get("ETC_FIELD2")).toString().equals("002")) { %>white<% } else if (CommonUtil.nvl(dbMap.get("ETC_FIELD2")).toString().equals("003")) { %>blue<% } %>">
		                   		 		<%=sUtil.getCodeName("MINWON", CommonUtil.nvl(dbMap.get("ETC_FIELD2"))) %></span>
			                    </td>
			                </tr>
			                <tr>
			                    <th>민원신고 분류</th>
			                    <td>
			                        <%=sUtil.getCodeName(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(dbMap.get("CATEGORY_CD"))) %>
			                    </td>
			                </tr>
			                <tr>
			                    <th>성명</th>
			                    <td>
			                        <%=CommonUtil.nvl(dbMap.get("REG_NAME"))%>
			                    </td>
			                </tr>
			                <tr>
			                    <th>연락처</th>
			                    <td>
			                        <%=CommonUtil.nvl(dbMap.get("ETC_FIELD1"))%>
			                    </td>
			                </tr>
			                <tr>
			                    <th>민원신고 제목</th>
			                    <td>
			                        <%=CommonUtil.nvl(dbMap.get("TITLE")) %>
			                    </td>
			                </tr>
			                <tr>
			                    <th>민원신고 내용</th>
			                    <td>
									<%
										String strImgFile = "";
						                   if ( lstFile != null && !lstFile.isEmpty()) {
						                   for (int nLoop =0; nLoop < lstFile.size(); nLoop++)
						                   {
						                	   Map dbFile = (Map)lstFile.get(nLoop);
						                	   String strFileName = CommonUtil.nvl(dbFile.get("FILE_REALNM"));

						                	   if ( CommonUtil.isImageFile(strFileName) ) {
						                		   //String strSize = CommonUtil.getImageResizeStr(request, strFileName, 3000);
										%>
						                		   <img src="<%=strFileName%>"><br/>
										<%
						                	   }
						                     }
						                }
						                %>
										<%=CommonUtil.nvl(dbMap.get("CONTENT")).replaceAll("\r\n", "<br/>")%>
			                    </td>
			                </tr>
			            </tbody>
			        </table>

					<% if (lstFile.size() > 0) { %>
					<!-- 첨부파일 -->
					<ul class="file">
						<li>
							<%
			                   for (int nLoop =0; nLoop < lstFile.size(); nLoop++)
			                   {
			                	   Map dbFile = (Map)lstFile.get(nLoop);
							%>
								<strong><img src="<%=CommDef.APP_CONTENTS %>/images/sb_ico_file.jpg" /> 첨부파일</strong>
								<a href="javascript:download(<%=CommonUtil.getNullTrans(dbFile.get("FILE_NO"))%>)" class="filename"><%=CommonUtil.getFileName(CommonUtil.getNullTrans(dbFile.get("FILE_NM")))%></a>
								<span class="byte">(용량 : <%=CommonUtil.getFileSize(dbFile.get("FILE_SIZE")) %> / 다운로드수 : <%=CommonUtil.nvl(dbFile.get("FILE_DOWN_CNT")) %>)</span>
								<a href="javascript:download(<%=CommonUtil.getNullTrans(dbFile.get("FILE_NO"))%>)"><img src="<%=CommDef.APP_CONTENTS %>/images/sb_ico_down.jpg" alt="다운로드" /></a>
							<% }%>
						</li>
					</ul>
					<% } %>

			        <table class="table2 write mt20">
			            <tbody>
						<%
						    if(commentList != null && commentList.size() > 0){

						       for( int commentLoop = 0; commentLoop < commentList.size(); commentLoop++ ) {
						            Map cmMap = ( Map ) commentList.get( commentLoop );
						            String cmtext = CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(cmMap.get("CONTENT")));

						%>
						                <tr>
						                    <th>답변</th>
						                    <td>
						                        <%=cmtext%>
						                        <br/><br/><b>※ 법적 책임이 없음을 안내해드립니다.</b>
						                    </td>
						                </tr>
						<%
								}
						    }
						%>

			            </tbody>
			        </table>


			        <div class="btnWrap tac">
			            <a href="/board.do?<%=strParam %>" class="btn2">뒤로가기</a>
						<% if ((userLevel > 1 && CommonUtil.nvl(dbMap.get("REG_ID")).equals(userid)) || (userLevel == 10)) { //수정 삭제 회원권한 체크 %>
								<script type="text/javascript">
								//바로삭제
								function fDelete(strSeq)
								{
									  vObj = document.writeform;

									  if (!confirm("삭제하시겠습니까?"))
										  return;

									  vObj.mode.value = "memberdel";
									  vObj.seq.value = strSeq;
									  vObj.action = "/boardDelete.do";

									  vObj.submit();
								}
								</script>
								<a href="javascript:fModify('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>');" class="btn2">수정</a>
								<a href="javascript:fDelete('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>');" class="btn2">삭제</a>
						<%
							} else {
								if (CommonUtil.nvl(dbMap.get("REG_ID")).equals("guest")) { //해당 게시글이 비회원이 작성한 경우에 수정 삭제 버튼 노출
						%>
						<% if (CommonUtil.nvl(dbMap.get("ETC_FIELD2")).equals("001")) { //접수 상태일때만 수정 삭제 가능 %>
						<script>
							function pwdLink(strSeq, strmode) {
							  vObj = document.writeform;

							  vObj.seq.value = strSeq;
							  vObj.mode.value = strmode;
							  vObj.action = "/minwon.do";

							  vObj.submit();
							}
						</script>
					            <a href="javascript:pwdLink('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>', 'pwmodify');" class="btn2">수정</a>
					            <a href="javascript:pwdLink('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>', 'pwdelete');" class="btn2">삭제</a>
						<%
									}
								}
							}
						%>
			        </div>

	<!-- board contents -->


				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>

<script>

	function fModify(strSeq)
	{
		  vObj = document.writeform;

		  vObj.seq.value = strSeq;
		  vObj.action = "/write.do";

		  vObj.submit();
	}

   function fReply(strSeq)
   {
		  vObj = document.writeform;

		  vObj.seq.value = strSeq;
		  vObj.iflag.value = "<%=CommDef.ReservedWord.REPLY%>";
		  vObj.action = "/write.do";

		  vObj.submit();
   }

</script>

</body>
</html>