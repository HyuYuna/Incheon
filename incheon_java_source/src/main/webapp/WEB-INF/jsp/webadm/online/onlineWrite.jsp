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
						<th scope="row">????????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("CD_NM1")) %></td>
					</tr>
					<tr>
						<th scope="row">??????</th>
						<td><%=CommonUtil.nvl(dbMap.get("TITLE")) %></td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("COMPANY")) %></td>
					</tr>
					<tr>
						<th scope="row">??????</th>
						<td><%=CommonUtil.nvl(dbMap.get("NAME")) %></td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("TEL")) %></td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td><input type="text" class="__form1" name="email" value="<%=CommonUtil.nvl(dbMap.get("EMAIL")) %>" />
						</td>
					</tr>
					<tr>
						<th scope="row">??????</th>
						<td><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(strCtnt)) %></td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
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
						<th scope="row">??????????????? ?????????</th>
						<td><input type="text" class="__form1" name="re_email" value="<%=reEmail%>"></td>
					</tr>
					<tr>
						<th scope="row">?????? ??????</th>
						<td><input type="text" class="__form1" name="re_title" value="<%=CommonUtil.nvl(dbMap.get("RE_TITLE"))%>"></td>
					</tr>
					<tr>
						<th scope="row">?????? ??????</th>
						<td>
							<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script> 
							<textarea id="re_content" name="re_content" maxlength="65536" style="width:100%;height:300px;" class='ckeditor'><%=CommonUtil.recoveryLtGt(strReCtnt) %></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">????????????</th>
						<td>
							<b><%=CommonUtil.getYNReplytext(dbMap.get("STATE").toString()) %></b>
						</td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
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
					<button type="submit" class="__btn2 type3">???????????????</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/online/onlineList.do?<%=strParam%>">??????</a>
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
		alert('?????? ????????? ??????????????????.'); 
		return false; 
	} 

	if (f.email.value == "")
	{
		alert("?????? ?????? ????????? ?????????????????????.");
		f.email.focus();
		return false;
	}

	if (f.re_email.value == "")
	{
		alert("?????? ???????????? ??????????????????.");
		f.re_email.focus();
		return false;
	}

	if (f.re_title.value == "")
	{
		alert("?????? ????????? ??????????????????.");
		f.re_title.focus();
		return false;
	}

	if (window.confirm(f.email.value + " ??? ?????? ????????? ?????????????????????????"))
	{
		return true;
	} else {
		return false;
	}
	
}

</script>
</body>
</html>