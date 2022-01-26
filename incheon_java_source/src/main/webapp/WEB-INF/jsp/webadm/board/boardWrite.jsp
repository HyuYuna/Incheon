<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map sesMap     = (Map)SessionUtil.getSessionAttribute(request,"ADM");
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
	List lstFile   = (List) request.getAttribute( "lstFile" );

	UploadUtil  upUtil = new UploadUtil(request);
	ServiceUtil sUtil = new ServiceUtil();

    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));
    strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&brd_mgrno="       + CommonUtil.nvl( reqMap.get( "brd_mgrno"));
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));

    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);

    String title = "";
    String url_text = "";
    String etc_field1 = "";
    String etc_field2 = "";
    String etc_field3 = "";
    String etc_field4 = "";
    String etc_field5 = "";
    String strCtnt = "";

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
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">

		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>

		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/board/boardWork.do" onsubmit="return fSubmit(this);">
                <input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
                <input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
                <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                <input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="brd_mgrno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("brd_mgrno")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/board/boardList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
		        <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
		        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
		        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>

			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
				<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) {  //카테고리 사용 %>
					<tr>
						<th scope="row">카테고리</th>
						<td>
							<select name="category_cd" id="category_cd" class="__form1">
								<%=sUtil.getSelectBox(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(dbMap.get("CATEGORY_CD"))) %>
							</select>
						</td>
					</tr>
				<% } %>
					<tr>
						<th scope="row">제목</th>
						<td><input type="text" class="__form1" name="title" value="<%=title %>" maxlength="100"/></td>
					</tr>
					<tr>
						<th scope="row">작성자</th>
						<td><input type="text" class="__form1" name="reg_name" value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %><%=CommonUtil.nvl(sesMap.get("USER_NM")) %><% } else { %><%=CommonUtil.nvl(dbMap.get("REG_NAME")) %><% } %>" maxlength="30"/></td>
					</tr>
				<% if (CommonUtil.nvl(brdMgrMap.get("NOTICE_YN")).equals("Y")) {  //공지글 사용여부 %>
					<tr>
						<th scope="row">공지유무</th>
						<td>
							<label><input type="radio" name="notice_yn" value="Y" <%=("Y".equals(CommonUtil.nvl(dbMap.get("NOTICE_YN")))) ? " checked " : "" %>/>Yes</label>&nbsp;
							<label><input type="radio" name="notice_yn" value="N" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("N".equals(CommonUtil.nvl(dbMap.get("NOTICE_YN")))) ? " checked " : "" %><% } %>/>No</label>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("SECRET_USE_YN")).equals("Y")) {  //비밀글 사용여부 %>
					<tr>
						<th scope="row">비밀글여부</th>
						<td>
							<label><input type="radio" name="secret_yn" value="Y" <%=("Y".equals(CommonUtil.nvl(dbMap.get("SECRET_YN")))) ? " checked " : "" %>/>Yes</label>&nbsp;
							<label><input type="radio" name="secret_yn" value="N" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("N".equals(CommonUtil.nvl(dbMap.get("SECRET_YN")))) ? " checked " : "" %><% } %>/>No</label>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_SORT ASC")) {  //강제 정렬번호 사용 %>
					<tr>
						<th scope="row">강제 정렬번호</th>
						<td>
							<input type="text" class="__form1" name="board_sort" style="width:80px;" maxlength="10" value="<%=CommonUtil.nvl(dbMap.get("BOARD_SORT"))%>">
							- 숫자가 낮은 순서대로 우선 출력됩니다. (범위 -2147483648 ~ 2147483648 )
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("URL_USE_YN")).equals("Y") || CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).equals("SKINPARTNER")) {  //URL 링크 사용 %>
					<tr>
						<th scope="row">URL 링크</th>
						<td>
							<input type="text" class="__form1" name="url_text" maxlength="200" value="<%=url_text%>">
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_USE_YN")).equals("Y")) {  //추가항목1 사용 %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_TITLE")) %></th>
						<td>
							<input type="text" class="__form1" name="etc_field1"  maxlength="100" value="<%=etc_field1%>">
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_USE_YN")).equals("Y")) {  //추가항목2 사용 %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_TITLE")) %></th>
						<td>

							<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //민원신고 게시판 %>
								<select name="etc_field2" id="etc_field2" style="width:150px;">
									<%=sUtil.getSelectBox("MINWON", CommonUtil.nvl(dbMap.get("ETC_FIELD2"))) %>
								</select>
							<% } else { %>
								<input type="text" class="__form1" name="etc_field2"  maxlength="100" value="<%=etc_field2%>">
							<% } %>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_USE_YN")).equals("Y")) {  //추가항목3 사용 %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_TITLE")) %></th>
						<td>
							<input type="text" class="__form1" name="etc_field3"  maxlength="100" value="<%=etc_field3%>">
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_USE_YN")).equals("Y")) {  //추가항목4 사용 %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_TITLE")) %></th>
						<td>
							<input type="text" class="__form1" name="etc_field4"  maxlength="100" value="<%=etc_field4%>">
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_USE_YN")).equals("Y")) {  //추가항목5 사용 %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_TITLE")) %></th>
						<td>
							<input type="text" class="__form1" name="etc_field5"  maxlength="100" value="<%=etc_field5%>">
						</td>
					</tr>
				<% } %>

				<% if (CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).equals("SKINVIDEO")) {  //비디오 스킨 사용 %>
					<tr>
						<th scope="row">유투브 코드 입력</th>
						<td>예) https://youtu.be/<b>Amq-qlqbjYA</b> (유튜브 동영상 URL 복사시 나오는 <b>볼드</b>처리된 코드 입력)
						</td>
					</tr>
					<tr>
						<th scope="row">유튜브 코드</th>
						<td>
							<input type="text" class="__form1" name="youtube_code1"  maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("YOUTUBE_CODE1"))%>">
							<br/>리스트 이미지에 노출됩니다.
						</td>
					</tr>
					<tr>
						<th scope="row">유튜브 코드</th>
						<td>
							<input type="text" class="__form1" name="youtube_code2"  maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("YOUTUBE_CODE2"))%>">

						</td>
					</tr>
					<tr>
						<th scope="row">유튜브 코드</th>
						<td>
							<input type="text" class="__form1" name="youtube_code3"  maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("YOUTUBE_CODE3"))%>">
						</td>
					</tr>
				<% } %>

	                <tr>
					    <th scope="row">내용</th>
					    <td>
							<textarea id="content" name="content" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(strCtnt) %></textarea>
	                    </td>
					</tr>
                  	<%
                  		//첨부파일 불러오기
                  		int nFileCnt = CommonUtil.getNullInt(brdMgrMap.get("ATTACH_FILE_CNT"), 0);
                     	if ( nFileCnt > 0 ) {
                    		if (strIFlag.equals(CommDef.ReservedWord.REPLY)) {
                    			out.print(upUtil.addAdminFileHtml(null, nFileCnt));
                    	 	} else {
								out.print(upUtil.addAdminFileHtml(lstFile, nFileCnt));
                    	 	}
				     	}
                   	%>
					<tr>
						<th scope="row">조회수</th>
						<td>
							<input type="text" class="__form1" name="view_cnt" id="view_cnt" style="width:60px;" maxlength="10" value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %>0<% } else { %><%=CommonUtil.nvl(dbMap.get("VIEW_CNT")) %><% } %>">
						</td>
					</tr>
					<tr>
						<th scope="row">작성일</th>
						<td>
							<input type="text" class="__form1" name="reg_dt" id="reg_dt" style="width:120px;" maxlength="10" readonly value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %><%=CommonUtil.getCurrentDate("-","")%><% } else { %><%=CommonUtil.getDateFormat(dbMap.get("REG_DT"), "ymd2") %><% } %>">
							<input type="hidden" name="reg_dt_time" value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %><%=CommonUtil.getCurrentDate("-","HHMISS")%><% } else { %><%=CommonUtil.getDateFormat(dbMap.get("REG_DT"), "HHmmss") %><% } %>"/>
						</td>
					</tr>
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">작성완료</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/board/boardList.do?<%=strParam%>">취소</a>
				</div>
			</div>
			</form>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>

</div>
<script>

$(function() {
	$('#reg_dt').datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange: '<%=CommonUtil.nvl(CommDef.SEARCH_START_YEAR)%>:<%=CommonUtil.nvl(CommDef.SEARCH_END_YEAR)%>'
	});
});

function fSubmit(f) {

	<% if (CommonUtil.nvl(brdMgrMap.get("NOTICE_YN")).equals("Y") && CommonUtil.nvl(brdMgrMap.get("SECRET_USE_YN")).equals("Y")) { %>
	if ($('input[name="notice_yn"]:checked').val() == "Y") {
		if ($('input[name="secret_yn"]:checked').val() == "Y") {
			alert('공지게시글에는 비밀글로 선택할수 없습니다.');
			return false;
		}
	}
	<% } %>

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

	if (CKEDITOR.instances.content.getData() == '')  {
		 alert("내용을 입력하여 주십시오");
		 return false;
	}

	if (f.board_sort.value.length > 0) {
		if (checkEngNumValue(f.board_sort.value, "강제정렬번호는 숫자만 입력할수 있습니다.", 2) == "N")
		{
			f.board_sort.focus();
			return false;
		}
	}

	if (checkEngNumValue(f.view_cnt.value, "조회수는 숫자만 입력할수 있습니다.", 2) == "N")
	{
		f.view_cnt.focus();
		return false;
	}

	return true;
}
</script>
</body>
</html>