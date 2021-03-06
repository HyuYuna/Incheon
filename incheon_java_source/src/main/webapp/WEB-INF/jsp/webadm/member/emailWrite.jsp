<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	List lstUseYn   = (List) request.getAttribute( "lstUseYn" );
	
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
	
    String strWritePage = CommonUtil.nvl(reqMap.get("writepage"));
    
    Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");

    String strMenuNo = CommonUtil.nvl( reqMap.get( "menu_no"));
    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);    
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/member/emailWork.do" onsubmit="return formcheck(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="seq"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/member/emailList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
	            <input name="menu_gb"         	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>					
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
					
					<tr>
						<th scope="row">????????????</th>
						<td>
                            <select name="user_level">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("USER_LEVEL"))) %>
					    	</select>
						</td>
					</tr>
					<tr>
						<th scope="row">????????????</th>
						<td><input type="text" class="__form1" name="to_email" value="<%=CommonUtil.nvl(dbMap.get("TO_EMAIL"))%>">
							<br/>??????(,)??? ??????????????? ?????? ??? ????????????. ???????????? ????????? ???????????? ????????? ??????????????? 
						</td>
					</tr>
					<tr>
						<th scope="row">???????????????</th>
						<td><input type="text" class="__form1" name="from_email" value="<%=(strIFlag.equals(CommDef.ReservedWord.UPDATE) ? CommonUtil.nvl(dbMap.get("FROM_EMAIL")) : CommDef.CONFIG_COMPANY_EMAIL)%>"></td>
					</tr>
					<tr>
						<th scope="row">????????????</th>
						<td><input type="text" class="__form1" name="title" value="<%=CommonUtil.nvl(dbMap.get("TITLE"))%>"></td>
					</tr>
					
					<tr>
						<th scope="row">??????</th>
						<td>
							<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script>  
							<textarea id="content" name="content" maxlength="65536" style="width:100%;height:300px;" class='ckeditor'><%=(strIFlag.equals(CommDef.ReservedWord.UPDATE) ? CommonUtil.recoveryLtGt((String)dbMap.get("CONTENT")) : "") %></textarea>
							
						</td>
					</tr>
					 	
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">???????????????</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/member/emailList.do?<%=strParam%>">??????</a>
				</div>
			</div>
			</form>
		</div>
	</div>
	

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script type="text/javascript">

function formcheck(f) {

	 if (CKEDITOR.instances.content.getData() == '') 
		{ 
			alert('????????? ??????????????????.'); 
			return false; 
		} 

		if (f.from_email.value == "")
		{
			alert("?????????????????? ??????????????????.");
			f.from_email.focus();
			return false;
		}

		if (f.title.value == "")
		{
			alert("?????? ????????? ??????????????????.");
			f.title.focus();
			return false;
		}

		if (window.confirm("????????? ?????????????????????????"))
		{
			return true;
		} else {
			return false;
		}
		
	return true;
}

</script>
</body>
</html>