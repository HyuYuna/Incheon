<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map userMap     = (Map) request.getAttribute("userMap");
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
	List lstFile   = (List) request.getAttribute( "lstFile" );
	
	UploadUtil  upUtil = new UploadUtil(request);
	ServiceUtil sUtil = new ServiceUtil();
 
    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&boardno="       + CommonUtil.nvl( reqMap.get( "boardno"));
    strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));

    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);
    String noticeFlag = "N";
    String secertFlag = "N";
    
    String title = "";
    String url_text = "";
    String etc_field1 = "";
    String etc_field2 = "";
    String etc_field3 = "";
    String etc_field4 = "";
    String etc_field5 = "";
    String strCtnt = "";
    int userLevel = 1; //기본 유저레벨
    String userName = ""; //기본 이름
    String pwdCheck = "";
    
    if (strIFlag.equals(CommDef.ReservedWord.UPDATE)) {
    	title = CommonUtil.nvl(dbMap.get("TITLE"));
    	url_text = CommonUtil.nvl(dbMap.get("URL_TEXT"));
    	etc_field1 = CommonUtil.nvl(dbMap.get("ETC_FIELD1"));
    	etc_field2 = CommonUtil.nvl(dbMap.get("ETC_FIELD2"));
    	etc_field3 = CommonUtil.nvl(dbMap.get("ETC_FIELD3"));
    	etc_field4 = CommonUtil.nvl(dbMap.get("ETC_FIELD4"));
    	etc_field5 = CommonUtil.nvl(dbMap.get("ETC_FIELD5"));
    	strCtnt = CommonUtil.nvl(dbMap.get("CONTENT"));
    } else if (strIFlag.equals(CommDef.ReservedWord.REPLY)) {
    	title = "Re : " + CommonUtil.nvl(dbMap.get("TITLE"));
    	strCtnt = CommonUtil.nvl(dbMap.get("CONTENT")) + "<br/>-----------------------------------------원문내용-----------------------------------------";
    } else {
    	strCtnt = CommonUtil.nvl(brdMgrMap.get("BRD_DESC"));
    }
    
  	if (userMap != null) { //로그인 유저라면
  		userName = CommonUtil.nvl(userMap.get("USER_NM"));
  		userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
  	} 
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_board.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/board/<%=CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() %>/style.css"/>
<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script> 
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
	<!-- skinwebzine -->	
	<div id="sb-wrap">
			<form name="writeform" action="/boardWork.do" method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" onsubmit="return formcheck(this)">
				<input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
				<input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
				<input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>
				        
				<input name="iflag"       type="hidden" value="<%=strIFlag %>">
				<input name="boardno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
				<input name="returl"      type="hidden" value="/board.do">
				<input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">			
				<input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
				<input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
				<input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
		        
			<div id="sb-write">
				<table class="write_tbl">
					<colgroup>
						<col style="width: 150px;" />
						<col style="width: auto;" />
					</colgroup>

					<!-- 기본항목 -->
					<tbody>
						<% 
							if (userLevel > 9 && CommonUtil.nvl(brdMgrMap.get("NOTICE_YN")).equals("Y")) { //관리자 권한일 경우에만 조건 검색 
								if (!strIFlag.equals(CommDef.ReservedWord.REPLY)) {
									noticeFlag = "Y";
						%>
						<tr>
							<th>공지사항</th>
							<td>
								<label><input type="radio" name="notice_yn" value="Y" <%=("Y".equals(CommonUtil.nvl(dbMap.get("NOTICE_YN")))) ? " checked " : "" %> />Yes</label>&nbsp;
								<label><input type="radio" name="notice_yn" value="N" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("N".equals(CommonUtil.nvl(dbMap.get("NOTICE_YN")))) ? " checked " : "" %><% } %>/>No</label>
							</td>
						</tr>
						<% } } %>
						<% if (userLevel > 9 && CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) {  //관리자 권한일 경우에만 조건 검색 %>
						<tr>
							<th>강제순번</th>
							<td>
							<input type="text" name="board_sort" maxlength="9" value="<%=CommonUtil.nvl(dbMap.get("BOARD_SORT"))%>" class="inp w30">
							- 숫자가 낮은 순서대로 우선 출력됩니다. ( -마이너스 입력가능 ) 
							</td>
						</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) {  //카테고리 사용 %>
						<tr>
							<th>카테고리</th>
							<td>
								<select name="category_cd" id="category_cd">
									<%=sUtil.getSelectBox(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(dbMap.get("CATEGORY_CD"))) %>
								</select>
							</td>
						</tr>
						<% } %>
						<tr>
							<th>제목</th>
							<td>
								<input type="text" name="title" value="<%=title %>" maxlength="100" class="inp w100" />
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><input type="text" maxlength="20" class="inp w30" name="reg_name" value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %><%=userName %><% } else { %><%=CommonUtil.nvl(dbMap.get("REG_NAME")) %><% } %>" maxlength="30"></td>
						</tr>
						<%
							if (!(strIFlag.equals(CommDef.ReservedWord.REPLY) && CommonUtil.nvl(dbMap.get("SECRET_YN")).equals("Y"))) {  //비밀글의 답변을 작성할 경우 비번 노출안함 (관리자만 답변을 단다고 가정하고)
								if ((!strIFlag.equals(CommDef.ReservedWord.UPDATE) && userLevel < 2)) { //수정이 아니면서 비회원일때 노출
									pwdCheck = "if (f.reg_pwd.value == '') { alert(\"비밀번호를 입력해주세요.\"); f.reg_pwd.focus(); return false; }";
						%>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="reg_pwd" id="reg_pwd" class="inp w30"/>
							</td>
						</tr>
						<% } } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("URL_USE_YN")).equals("Y")) {  //URL 링크 사용 %>
							<tr>
								<th>URL 링크</th>
								<td>
									<input type="text" class="inp w100" name="url_text" maxlength="200" value="<%=url_text%>">
								</td>
							</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_USE_YN")).equals("Y")) {  //추가항목1 사용 %>
							<tr>
								<th><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_TITLE")) %></th>
								<td>
									<input type="text" class="inp w100" name="etc_field1"  maxlength="100" value="<%=etc_field1%>">
								</td>
							</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_USE_YN")).equals("Y")) {  //추가항목2 사용 %>
							<tr>
								<th><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_TITLE")) %></th>
								<td>
									<input type="text" class="inp w100"  name="etc_field2"  maxlength="100" value="<%=etc_field2%>">
								</td>
							</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_USE_YN")).equals("Y")) {  //추가항목3 사용 %>
							<tr>
								<th><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_TITLE")) %></th>
								<td>
									<input type="text" class="inp w100" name="etc_field3"  maxlength="100" value="<%=etc_field3%>">
								</td>
							</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_USE_YN")).equals("Y")) {  //추가항목4 사용 %>
							<tr>
								<th><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_TITLE")) %></th>
								<td>
									<input type="text" class="inp w100" name="etc_field4"  maxlength="100" value="<%=etc_field4%>">
								</td>
							</tr>
						<% } %>
						<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_USE_YN")).equals("Y")) {  //추가항목5 사용 %>
							<tr>
								<th><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_TITLE")) %></th>
								<td>
									<input type="text" class="inp w100" name="etc_field5"  maxlength="100" value="<%=etc_field5%>">
								</td>
							</tr>
						<% } %>
					</tbody>

					<!-- 내용 -->
					<tbody class="memo">
						<tr>
							<td colspan="2">
								<textarea id="content" name="content" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(strCtnt) %></textarea> 
							</td>
						</tr>
					</tbody>
					
					<%
						//첨부파일 불러오기
	              		int nFileCnt = CommonUtil.getNullInt(brdMgrMap.get("ATTACH_FILE_CNT"), 0);
						if (nFileCnt > 0) {
					%>
					<!-- 첨부파일 -->
					<tbody class="fileWrap">
	                  	<%
	                  		
	                     	if ( nFileCnt > 0 ) {
	                    		if (strIFlag.equals(CommDef.ReservedWord.REPLY)) {
	                    			out.print(upUtil.addHomeFileHtml(null, nFileCnt));	 
	                    	 	} else {
									out.print(upUtil.addHomeFileHtml(lstFile, nFileCnt));
	                    	 	}
					     	}
	                   	%>
					</tbody>
					<% } %>
					
				</table>
			</div>

			<!-- s:foot button -->
			<div id="sb-footer">
				<div class="left">
					<a href="/board.do?<%=strParam%>" class="sb-btn type3">목록</a>
				</div>
				<div class="right">
					<input type="submit" value="확인" class="sb-btn type1" />
					<a href="/board.do?<%=strParam %>" class="sb-btn type2">취소</a>
				</div>
			</div>	
			<!-- e:foot button -->
		
		</form>
		
	</div>

<script type="text/javascript">

function formcheck(f) {

	if (f.title.value == "")
	{
		alert("제목을 입력해주세요.");
		f.title.focus();
		return false;
	}

	if (f.reg_name.value == "")
	{
		alert("작성자를 입력해주세요.");
		f.reg_name.focus();
		return false;
	}
	
	<%=pwdCheck%>
	
	if (CKEDITOR.instances.content.getData() == '')  {
		 alert("내용을 입력하여 주십시오");
		 return false;
	}
	
	<% if (userLevel > 9 && CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) {  //관리자 권한일 경우에만 조건 검색 %>
	if (f.board_sort.value.length > 0) {
		if (checkEngNumValue(f.board_sort.value, "강제정렬번호는 숫자만 입력할수 있습니다.", 2) == "N")
		{
			f.board_sort.focus();
			return false;
		}
	}
	<% } %>
	
	return true;
}

</script>
<!-- skinwebzine -->

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