<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	List lstFile   = (List) request.getAttribute( "lstFile" );
	
	List lstUseYn   = (List) request.getAttribute( "lstUseYn" );
	
	ServiceUtil sUtil = new ServiceUtil();
 
    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));	
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));	
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));	
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));	
    strParam += "&up_menu_no="     + CommonUtil.nvl( reqMap.get( "up_menu_no"));
    strParam += "&parent_menu_no=" + CommonUtil.nvl( reqMap.get( "parent_menu_no"));

    Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");

    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);    
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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/boardmgr/boardMgrWork.do" onsubmit="return fSubmit(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="brd_mgrno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("brd_mgrno")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/boardmgr/boardMgrList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">			
		        <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">게시판 명</th>
						<td><input type="text" class="__form1" name="brd_nm" value="<%=CommonUtil.nvl(dbMap.get("BRD_NM")) %>" maxlength="100"/></td>
					</tr>

	                <tr>
					    <th scope="row">게시판 유형</th>
					    <td>
					       <select name="brd_skin_cd" class="__form1">
					           <%=sUtil.getSelectBox("SKIN", CommonUtil.nvl(dbMap.get("BRD_SKIN_CD"))) %>
					       </select>						    
					    </td>
					</tr>
					
	                <tr>  
					    <th scope="row">사용여부</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"use_yn", CommonUtil.nvl(dbMap.get("USE_YN"), "Y")) %>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">리스트 갯수</th>
					    <td>
					       <input type="text"  name="list_cnt" style="width:50px;IME-MODE:disabled;"  class="__form1"  value="<%=CommonUtil.nvl(dbMap.get("LIST_CNT"), "10") %>" maxlength="3"/>
					                ※ [0]을 입력시 사용자 화면에서 페이징이 나오지 않음
					    </td>
					</tr>

	                <tr>
					    <th scope="row">목록보기 권한</th>
					    <td>
                            <select name="list_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("LIST_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">글읽기 권한</th>
					    <td>
                            <select name="read_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("READ_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">글쓰기 권한</th>
					    <td>
                            <select name="write_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("WRITE_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">글답변 권한</th>
					    <td>
                            <select name="reply_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("REPLY_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">댓글쓰기 권한</th>
					    <td>
                            <select name="comment_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("COMMENT_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">첨부파일 갯수</th>
					    <td><input type="text"  name="attach_file_cnt" style="width:50px;IME-MODE:disabled;" class="__form1"  value="<%=CommonUtil.nvl(dbMap.get("ATTACH_FILE_CNT"), "0") %>" maxlength="2"/>
					    	※ [0]을 첨부파일을 사용하지 않습니다
					    </td>
					</tr>	
						
	                <tr>
					    <th scope="row">상단공지 사용여부</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"notice_yn", CommonUtil.nvl(dbMap.get("NOTICE_YN"), "N")) %></td>
					</tr>

	                <tr>
					    <th scope="row">카테고리 사용여부</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"cate_cd_use_yn", CommonUtil.nvl(dbMap.get("CATE_CD_USE_YN"), "N")) %></td>
					</tr>
					
					<tr>
                         <th scope="row">카테고리 코드</th>						    
                         <td>
                            <select name="cate_cd">
                                <option value="">선택하세요</option>
			           			<%=sUtil.getSelectBox("*", CommonUtil.nvl(dbMap.get("CATE_CD")), "CATEGORY_") %>
			       			</select>
			       			<br/>※코드관리에 <b>CATEGORY_</b> 로 시작하는 코드 참조
			    		</td>
					</tr>
								
		                <tr>
						    <th scope="row">정렬필드 코드</th>
						    <td>
                            <select name="order_cd">
						    	<%=sUtil.getSelectBox("ORDER_CD", CommonUtil.nvl(dbMap.get("ORDER_CD"))) %>
						    </select>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">URL 사용여부</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"url_use_yn", CommonUtil.nvl(dbMap.get("URL_USE_YN"), "N")) %>
						    	 <input type="hidden" name="direct_url_use_yn" value="N"/>
						          <%-- <br/>※목록화면에서바로 이동하기 : <%=sUtil.getRadioBox(lstUseYn,"direct_url_use_yn", CommonUtil.nvl(dbMap.get("DIRECT_URL_USE_YN"), "N")) %>			 --%>			    
						    </td>
						</tr>	
						
		                <tr>
						    <th scope="row">글답변 사용여부</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"reply_use_yn", CommonUtil.nvl(dbMap.get("REPLY_USE_YN"), "N")) %>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">댓글 사용여부</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"cmt_use_yn", CommonUtil.nvl(dbMap.get("CMT_USE_YN"), "N")) %>
						    </td>
						</tr>
													 
		                <tr>
						    <th scope="row">비밀글 사용여부</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"secret_use_yn", CommonUtil.nvl(dbMap.get("SECRET_USE_YN"), "N")) %>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">썸네일 사이즈</th>
						    <td>
						    	가로 : <input type="text"  style="width:50px;IME-MODE:disabled;" name="thm_width_size" class="__form1" value="<%= (strIFlag.equals(CommDef.ReservedWord.INSERT) ? "500" : CommonUtil.nvl(dbMap.get("THM_WIDTH_SIZE"))) %>" maxlength="10" /> px
						    	세로 : <input type="text" style="width:50px;IME-MODE:disabled;"  name="thm_height_size" class="__form1" value="<%= (strIFlag.equals(CommDef.ReservedWord.INSERT) ? "400" : CommonUtil.nvl(dbMap.get("THM_HEIGHT_SIZE"))) %>" maxlength="10"/> px 
						    	&nbsp;<b>썸네일 사이즈는 게시판 이미지 첨부시 생성될때의 썸네일 사이즈를 적용합니다.</b>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">추가항목1</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field1_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD1_USE_YN"), "N")) %> 
						    	타이틀 : <input type="text" style="width:200px" name="etc_field1_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD1_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">추가항목2</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field2_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD2_USE_YN"), "N")) %> 
						    	타이틀 : <input type="text" style="width:200px" name="etc_field2_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD2_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">추가항목3</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field3_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD3_USE_YN"), "N")) %> 
						    	타이틀 : <input type="text" style="width:200px" name="etc_field3_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD3_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">추가항목4</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field4_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD4_USE_YN"), "N")) %> 
						    	타이틀 : <input type="text" style="width:200px" name="etc_field4_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD4_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">추가항목5</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field5_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD5_USE_YN"), "N")) %> 
						    	타이틀 : <input type="text" style="width:200px" name="etc_field5_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD5_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">글쓰기 내용</th>
						    <td>
								<% String strCtnt = (strIFlag.equals(CommDef.ReservedWord.UPDATE)) ? CommonUtil.nvl(dbMap.get("BRD_DESC")) : "" ; %>
								<textarea id="brd_desc" name="brd_desc" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(strCtnt))%></textarea> 
		                    </td>
						</tr> 	
					
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">작성완료</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/boardmgr/boardMgrList.do?<%=strParam%>">취소</a>
				</div>
			</div>
			</form>
		</div>
	</div>
	

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>

function fSubmit(f) {

	if (f.brd_nm.value == "")
	{
		alert("게시판명을 입력해주세요.");
		f.brd_nm.focus();
		return false;
	}

	if (f.list_cnt.value == "")
	{
		alert("리스트갯수를 입력해주세요.");
		f.list_cnt.focus();
		return false;
	}

	if (f.order_cd.value == "")
	{
		alert("정렬필드 코드를 선택해주세요.");
		f.order_cd.focus();
		return false;
	}

	if (checkEngNumValue(f.thm_width_size.value, "썸네일 가로 사이즈는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.thm_width_size.focus();
		return false;
	}

	if (checkEngNumValue(f.thm_height_size.value, "썸네일 세로 사이즈는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.thm_height_size.focus();
		return false;
	}

	return true;
}
</script>
</body>
</html>