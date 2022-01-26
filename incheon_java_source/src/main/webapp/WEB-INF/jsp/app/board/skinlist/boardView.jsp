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
	<!-- skinlist -->
	<div id="sb-wrap">
		<div id="sb-view">

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

			<!-- 타이틀 영역 -->
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(dbMap.get("TITLE")) %> <%=CommonUtil.getListSecret(CommonUtil.nvl(dbMap.get("SECRET_YN")), "")%></h5>
				<ul class="info">
					<li><em>작성일</em><%=CommonUtil.getDateFormat(dbMap.get("REG_DT")) %></li>
					<li><em>조회</em><%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("VIEW_CNT"))) %></li>
				</ul>
			</div>

			<% if (CommonUtil.nvl(brdMgrMap.get("URL_USE_YN")).equals("Y")) {  //URL 링크 사용 %>
			<div class="titWrap">
				<h5 class="sbj">링크 : <a href="<%=CommonUtil.nvl(dbMap.get("URL_TEXT"))%>" target="_blank"><%=CommonUtil.nvl(dbMap.get("URL_TEXT"))%></a></h5>
			</div>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_USE_YN")).equals("Y")) {  //추가항목1 사용 %>
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_TITLE")) %> : <%=CommonUtil.nvl(dbMap.get("ETC_FIELD1"))%></h5>
			</div>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_USE_YN")).equals("Y")) {  //추가항목2 사용 %>
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_TITLE")) %> : <%=CommonUtil.nvl(dbMap.get("ETC_FIELD2"))%></h5>
			</div>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_USE_YN")).equals("Y")) {  //추가항목3 사용 %>
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_TITLE")) %> : <%=CommonUtil.nvl(dbMap.get("ETC_FIELD3"))%></h5>
			</div>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_USE_YN")).equals("Y")) {  //추가항목4 사용 %>
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_TITLE")) %> : <%=CommonUtil.nvl(dbMap.get("ETC_FIELD4"))%></h5>
			</div>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_USE_YN")).equals("Y")) {  //추가항목5 사용 %>
			<div class="titWrap">
				<h5 class="sbj"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_TITLE")) %> : <%=CommonUtil.nvl(dbMap.get("ETC_FIELD5"))%></h5>
			</div>
			<% } %>

			<!-- 내용 영역 -->
			<div class="memoWrap nostyle">
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
				<%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(dbMap.get("CONTENT")))%>
			</div>

			<% if (lstFile.size() > 0) { %>
			<!-- 첨부파일 -->
			<ul class="file">
                <%
                   for (int nLoop =0; nLoop < lstFile.size(); nLoop++)
                   {
                       Map dbFile = (Map)lstFile.get(nLoop);
                %>
				<li>

						<strong><img src="<%=CommDef.APP_CONTENTS %>/images/sb_ico_file.jpg" /> 첨부파일</strong>
						<a href="javascript:download(<%=CommonUtil.getNullTrans(dbFile.get("FILE_NO"))%>)" class="filename"><%=CommonUtil.getFileName(CommonUtil.getNullTrans(dbFile.get("FILE_NM")))%></a>
						<span class="byte">(용량 : <%=CommonUtil.getFileSize(dbFile.get("FILE_SIZE")) %> / 다운로드수 : <%=CommonUtil.nvl(dbFile.get("FILE_DOWN_CNT")) %>)</span>
						<a href="javascript:download(<%=CommonUtil.getNullTrans(dbFile.get("FILE_NO"))%>)"><img src="<%=CommDef.APP_CONTENTS %>/images/sb_ico_down.jpg" alt="다운로드" /></a>
				</li>
                <% }%>	
			</ul>
			<% } %>

			<% if (CommonUtil.nvl(brdMgrMap.get("CMT_USE_YN")).equals("Y")) { //코멘트 사용여부 확인 %>

<div id="sb-comment">
	<!-- 등록 -->
	<div class="writeWrap">
			<!-- 댓글영역 comment  사용 -->
			<form name="commentform" action="/commentUpdate.do" method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" onsubmit="return commentWrite(this)">
                <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                <input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>
	            <input name="boardno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
	            <input name="returl"      type="hidden" value="/view.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
		        <input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
		        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
		        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
		        <input name="mode" type="hidden" value="w"/>
		        <input type="hidden" name="comment_id" id="comment_id" value="" />
		        <% if (!CommonUtil.nvl(reqMap.get("viewpass")).equals("")) { %><input name="viewpass" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("viewpass"))%>"/><% } %>
			<% if (userLevel < 2)  {  //비회원일 경우%>
			<dl>
				<dt>
					<input type="text" name="cm_name" id="cm_name" class="inp" placeholder="글쓴이" maxlength="10"/>
					<input type="password" name="cm_pwd" id="cm_pwd" class="inp" placeholder="비밀번호" maxlength="10"/>
				</dt>
				<dd>
					<textarea name="cmm_content" id="cmm_content" cols="30" rows="10" placeholder="내용을 입력해주세요."></textarea>
				</dd>
				<dd class="btnWrap">
					<label>&nbsp;</label>
					<input type="submit" value="등록" class="sbm sb-btn type1" />
				</dd>
			</dl>

			<% } else { //로그인 회원일 경우 %>
			<dl>
				<dd>
					<textarea name="cmm_content" id="cmm_content" cols="30" rows="10" placeholder="내용을 입력해주세요."></textarea>
				</dd>
				<dd class="btnWrap">
			<%
				if (!userid.equals("guest")) { //회원 또는 관리자가 쓴 글만 비공개 설정가능
			%>
					<label><input type="radio" name="cm_secret" id="cm_secret1" value="N" checked/> 공개</label>
					<label><input type="radio" name="cm_secret" id="cm_secret2" value="Y"/> 비공개</label>
			<% } else { %>
					<label>&nbsp;</label>
			<% } %>
					<input type="submit" value="등록" class="sbm sb-btn type1" />
				</dd>
			</dl>
			<% } %>

		</form>
	</div>

	<!-- 댓글 리스트 -->
	<ul class="list">
			<%
			    if(commentList != null && commentList.size() > 0){

			       for( int commentLoop = 0; commentLoop < commentList.size(); commentLoop++ ) {
			            Map cmMap = ( Map ) commentList.get( commentLoop );

			            String replyComYN = "Y";
			            int cmt_depth = CommonUtil.nvl(cmMap.get("COMMENT_REPLY")).length();
			            String cmtext = CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(cmMap.get("CONTENT")));

			            if (CommonUtil.nvl(cmMap.get("SECRET_YN")).equals("Y")) { //비밀글 체크

							//관리자 또는 회원 본인이 쓴글 본인이 쓴 댓글은 보이게 설정한다.
							if (userid.equals(CommonUtil.nvl(cmMap.get("REG_ID"))) || (userid.equals(dbMap.get("REG_ID")) || userLevel == 10)) {
								cmtext = cmtext + " <img src=\"" + CommDef.APP_CONTENTS + "/images/sb_ico_secret.png\" alt=\"비밀글\" />";
							} else {
								cmtext = "비공개로 등록된 댓글입니다. <img src=\"" + CommDef.APP_CONTENTS + "/images/sb_ico_secret.png\" alt=\"비밀글\" />";
							}

			            	replyComYN = "N";
			            }
			%>
				<li class="<%=CommonUtil.getReplylen(CommonUtil.nvl(cmMap.get("COMMENT_REPLY")),"comment") %>">
					<div class="info">
						<span class="name"><%=CommonUtil.nvl(cmMap.get("REG_NAME")) %></span>
						<span class="date">(<%=CommonUtil.getDateFormat(cmMap.get("REG_DT")) %>)</span>
					</div>
					<span class="memo" id="cm_content<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>"><%=cmtext%></span>
					<div class="btnWrap">
					<% if (replyComYN.equals("Y")) { %><input type="button" value="답변" class="sb-btn type11" onclick="javascript:commentReWrite('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>');"/><% } %>
					<% if ((userLevel > 1 && userid.equals(cmMap.get("REG_ID"))) || userLevel == 10 ) { %>
						<input type="button" value="삭제" class="sb-btn type22" onclick="javascript:commentDelete('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>');"/>
					<%
						} else {
							if (CommonUtil.nvl(cmMap.get("REG_ID")).equals("guest")) {
					%>
						<input type="button" value="삭제" class="sb-btn type22" onclick="javascript:pwdCommentLink('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>','commentDelete');"/>
					<%
							}
						}
					%>
					</div>
				</li>
			<%
					}
			    }
			%>
	</ul>

</div>
<script>
var commentCheck = "<%=replyYN%>";

//코멘트 입력
function commentWrite(f){

	if (commentCheck == 'N')
	{
		alert("댓글을 작성할 권한이 없습니다.");
		return false;
	}

	<% if ((CommonUtil.getNullInt(dbMap.get("REG_ID_SEQ"), 0) == 0) && (userLevel > 1)) { //비회원 글에는 비공개 댓글 금지 %>
		if ($('input[name="cm_secret"]:checked').val() == "Y") {
			alert('비회원이 작성한 게시글에는\n비공개 댓글을 작성할수 없습니다.');
			return false;
		}
	<% } %>

	<% if (userLevel < 2) { %>

	if (f.cm_name.value == "")
	{
		alert("글쓴이를 입력해주세요.");
		f.cm_name.focus();
		return false;
	}

	if (f.cm_pwd.value == "")
	{
		alert("비밀번호를 입력해주세요.");
		f.cm_pwd.focus();
		return false;
	}

	<% } %>

	if (f.cmm_content.value == "")
	{
		alert("내용을 입력해주세요.");
		f.cmm_content.focus();
		return false;
	}
}

//코멘트 수정
function commentReWrite(comment_id) {

	var f = document.commentform;

	$('#comment_id').val(comment_id);
	$('#cmm_content').val("[답변]\n" + replaceAll($('#cm_content' + comment_id).html(),'<br>', '\n'));
	f.mode.value = "r";
}

//코멘트 삭제
function commentDelete(comment_id) {
	var f = document.commentform;

	if (window.confirm("정말로 삭제하시겠습니까?"))
	{
		$('#comment_id').val(comment_id);
		f.mode.value = "d";
		f.action = "/commentDelete.do";
		f.submit();
	}
}

//코멘트 비밀번호 페이지
function pwdCommentLink(strSeq, strmode) {
  vObj = document.commentform;

  vObj.comment_id.value = strSeq;
  vObj.mode.value = strmode;
  vObj.action = "/password.do";

  vObj.submit();
}
</script>
			<!-- 댓글영역 comment  사용 -->
			<% } %>

		</div>

		<!-- s:foot button -->
		<div id="sb-footer" class="no-abs">

			<div class="left">
				<a href="/board.do?<%=strParam %>" class="sb-btn type3">목록</a>

				<% if (prevMap != null)  { //이전 글 조회 %>
					<a href="/view.do?<%=strParam %>&seq=<%=CommonUtil.nvl(prevMap.get("BRD_NO")) %>" class="sb-btn type4">이전</a>
				<% } %>
				<% if (nextMap != null) { //다음 글 조회 %>
					<a href="/view.do?<%=strParam %>&seq=<%=CommonUtil.nvl(nextMap.get("BRD_NO")) %>" class="sb-btn type4">다음</a>
				<% } %>

			</div>

			<div class="right">
		<% if (CommonUtil.getNullInt(brdMgrMap.get("WRITE_LEVEL_CD"), 1) <= userLevel) { //글쓰기 권한 체크 %>
				<a href="/write.do?<%=strParam %>" class="sb-btn type1">글쓰기</a>
		<% } %>

		<% if ((CommonUtil.getNullInt(brdMgrMap.get("REPLY_LEVEL_CD"), 1) <= userLevel) && (CommonUtil.nvl(brdMgrMap.get("REPLY_USE_YN")).equals("Y"))) { //답변 권한 체크 %>
				<a href="javascript:fReply('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>');" class="sb-btn type1">답변</a>
		<% } %>

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
				<a href="javascript:fModify('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>');" class="sb-btn type2">수정</a>
				<a href="javascript:fDelete('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>');" class="sb-btn type2">삭제</a>
		<%
			} else {
				if (CommonUtil.nvl(dbMap.get("REG_ID")).equals("guest")) { //해당 게시글이 비회원이 작성한 경우에 수정 삭제 버튼 노출
		%>
		<script>
			function pwdLink(strSeq, strmode) {
			  vObj = document.writeform;

			  vObj.seq.value = strSeq;
			  vObj.mode.value = strmode;
			  vObj.action = "/password.do";

			  vObj.submit();
			}
		</script>
				<a href="javascript:pwdLink('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>', 'pwmodify');" class="sb-btn type2">수정</a>
				<a href="javascript:pwdLink('<%=CommonUtil.nvl(dbMap.get("BRD_NO")) %>', 'pwdelete');" class="sb-btn type2">삭제</a>
		<%
				}
			}
		%>
			</div>

		</div>
		<!-- e:foot button -->

	</div>
	<!-- skinlist -->
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
