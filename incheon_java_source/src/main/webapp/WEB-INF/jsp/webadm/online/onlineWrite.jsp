<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	
	int nFileInputCnt = 1;
	UploadUtil  upUtil = new UploadUtil(request);
	ServiceUtil sUtil = new ServiceUtil();
 
    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));	
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));	
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&menu_gb="        + CommonUtil.nvl( reqMap.get( "menu_gb"));
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));	
    
    Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");

    String strMenuNo = CommonUtil.nvl( reqMap.get( "menu_no"));
    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT); 
    String strCtnt = CommonUtil.nvl(dbMap.get("CONTENT"));
    String strReCtnt = CommonUtil.nvl(dbMap.get("RE_CONTENT"));
    String reEmail = "";
    
    if (CommonUtil.nvl(dbMap.get("RE_EMAIL")).equals("")) reEmail = CommDef.CONFIG_COMPANY_EMAIL;
    else reEmail = CommonUtil.nvl(dbMap.get("RE_EMAIL"));
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/online/onlineWork.do" onsubmit="return formcheck(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="seq"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/online/onlineList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
	            <input name="menu_gb"         	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>			
	            
	            <input type="hidden" name="name" value="<%=CommonUtil.nvl(dbMap.get("NAME")) %>"/>
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
				
					<tr>
						<th scope="row">문의구분</th>
						<td><%=CommonUtil.nvl(dbMap.get("CD_NM1")) %></td>
					</tr>
					<tr>
						<th scope="row">제목</th>
						<td><%=CommonUtil.nvl(dbMap.get("TITLE")) %></td>
					</tr>
					<tr>
						<th scope="row">회사명</th>
						<td><%=CommonUtil.nvl(dbMap.get("COMPANY")) %></td>
					</tr>
					<tr>
						<th scope="row">이름</th>
						<td><%=CommonUtil.nvl(dbMap.get("NAME")) %></td>
					</tr>
					<tr>
						<th scope="row">연락처</th>
						<td><%=CommonUtil.nvl(dbMap.get("TEL")) %></td>
					</tr>
					<tr>
						<th scope="row">이메일</th>
						<td><input type="text" class="__form1" name="email" value="<%=CommonUtil.nvl(dbMap.get("EMAIL")) %>" />
						</td>
					</tr>
					<tr>
						<th scope="row">내용</th>
						<td><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(strCtnt)) %></td>
					</tr>
					<tr>
						<th scope="row">작성일</th>
						<td>
							<%=CommonUtil.getDateFormat(dbMap.get("REG_DT")) %>
						</td>
					</tr>
				</tbody>
			</table>

			<br/><br/>
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">보내는사람 이메일</th>
						<td><input type="text" class="__form1" name="re_email" value="<%=reEmail%>"></td>
					</tr>
					<tr>
						<th scope="row">답변 제목</th>
						<td><input type="text" class="__form1" name="re_title" value="<%=CommonUtil.nvl(dbMap.get("RE_TITLE"))%>"></td>
					</tr>
					<tr>
						<th scope="row">답변 내용</th>
						<td>
							<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script> 
							<textarea id="re_content" name="re_content" maxlength="65536" style="width:100%;height:300px;" class='ckeditor'><%=CommonUtil.recoveryLtGt(strReCtnt) %></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">답변상태</th>
						<td>
							<b><%=CommonUtil.getYNReplytext(dbMap.get("STATE").toString()) %></b>
						</td>
					</tr>
					<tr>
						<th scope="row">답변일</th>
						<td>
							<% if (!CommonUtil.nvl(dbMap.get("RE_REGDT")).equals("")) { %>
								<%=CommonUtil.getDateFormat(dbMap.get("RE_REGDT"), "-") %>
							<% } %>						
						</td>
					</tr>
				</tbody>
			</table>
			
			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">답변보내기</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/online/onlineList.do?<%=strParam%>">취소</a>
				</div>
			</div>
			</form>
			
			
		</div>
	</div>
	

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script type="text/javascript">

function formcheck(f) {

	 if (CKEDITOR.instances.re_content.getData() == '') 
	{ 
		alert('답변 내용을 입력해주세요.'); 
		return false; 
	} 

	if (f.email.value == "")
	{
		alert("받는 사람 이메일 주소가없습니다.");
		f.email.focus();
		return false;
	}

	if (f.re_email.value == "")
	{
		alert("답변 이메일을 입력해주세요.");
		f.re_email.focus();
		return false;
	}

	if (f.re_title.value == "")
	{
		alert("답변 제목을 입력해주세요.");
		f.re_title.focus();
		return false;
	}

	if (window.confirm(f.email.value + " 로 답변 메일을 발송하시겠습니까?"))
	{
		return true;
	} else {
		return false;
	}
	
}

</script>
</body>
</html>