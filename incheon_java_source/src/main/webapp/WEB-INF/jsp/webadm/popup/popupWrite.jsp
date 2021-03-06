<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	List lstUseYn   = (List) request.getAttribute( "lstUseYn" );
	
	ServiceUtil sUtil = new ServiceUtil();
 
    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));	
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));	
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&menu_gb="        + CommonUtil.nvl( reqMap.get( "menu_gb"));
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));	

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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/popup/popupWork.do" onsubmit="return formcheck(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="seq"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/popup/popupList.do">
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
						<td><input type="text" class="__form1" name="title" value="<%=CommonUtil.nvl(dbMap.get("TITLE")) %>" maxlength="100"/></td>
					</tr>
					
	                <tr>  
					    <th scope="row">????????????</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"use_yn", CommonUtil.nvl(dbMap.get("USE_YN"), "Y")) %>
					    </td>
					</tr>
					
				<script type="text/javascript">

				$(function() {
					$('#txt_sdate').datepicker({
						changeMonth: true,
						changeYear: true,
						yearRange: '<%=CommonUtil.nvl(CommDef.SEARCH_START_YEAR)%>:<%=CommonUtil.nvl(CommDef.SEARCH_END_YEAR)%>'
					});
					$('#txt_edate').datepicker({
						changeMonth: true,
						changeYear: true,
						yearRange: '<%=CommonUtil.nvl(CommDef.SEARCH_START_YEAR)%>:<%=CommonUtil.nvl(CommDef.SEARCH_END_YEAR)%>'
					});
				});
				</script>
				
					<tr>
						<th scope="row">????????????</th>
						<td>
							<input type="text" name="start_date" class="__form1" style="cursor:pointer;width:100px;" readonly="readonly" id="txt_sdate" value="<%=CommonUtil.nvl(dbMap.get("START_DATE")) %>"/> ~ 
							<input type="text" name="end_date" class="__form1" style="cursor:pointer;width:100px;" readonly="readonly" id="txt_edate" value="<%=CommonUtil.nvl(dbMap.get("END_DATE")) %>"/>
						</td>
					</tr>

					<tr>
						<th scope="row">????????????</th>
						<td>
					       <select name="type_cd" class="__form1">
					           <%=sUtil.getSelectBox("POP_TYPE_CD", CommonUtil.nvl(dbMap.get("TYPE_CD"))) %>
					       </select>
						</td>
					</tr>

					<tr>
						<th scope="row">?????? Device</th>
						<td>
							<label><input type="radio" name="site_type" value="pc" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("pc".equals(CommonUtil.nvl(dbMap.get("SITE_TYPE")))) ? " checked " : "" %><% } %> /> PC??? ??????</label>
							<label><input type="radio" name="site_type" value="mobile" <%=("mobile".equals(CommonUtil.nvl(dbMap.get("SITE_TYPE")))) ? " checked " : "" %>/> ???????????? ??????</label>
							<label><input type="radio" name="site_type" value="all" <%=("all".equals(CommonUtil.nvl(dbMap.get("SITE_TYPE")))) ? " checked " : "" %>/> ??????</label>
							<br/><font color='red'>?????? Device??? ????????? ????????? Device??? ???????????? ???????????????.</font>
						</td>
					</tr>

					<tr>
						<th scope="row">????????? ??????</th>
						<td><input type="text" class="__form1" name="left_size" style="width:60px;" maxlength="4" value="<%=CommonUtil.nvl(dbMap.get("LEFT_SIZE")) %>"> - ?????? ???????????? ?????? px ??????</td>
					</tr>
					<tr>
						<th scope="row">????????? ??????</th>
						<td><input type="text" class="__form1" name="top_size" style="width:60px;" maxlength="4" value="<%=CommonUtil.nvl(dbMap.get("TOP_SIZE")) %>"> - ?????? ?????? ?????? px ??????</td>
					</tr>

					<tr>
						<th scope="row">????????? ??????</th>
						<td><input type="text" class="__form1" name="width_size" style="width:60px;" maxlength="4" value="<%=CommonUtil.nvl(dbMap.get("WIDTH_SIZE")) %>"> - px ??????</td>
					</tr>
					<tr>
						<th scope="row">????????? ??????</th>
						<td><input type="text" class="__form1" name="height_size" style="width:60px;" maxlength="4" value="<%=CommonUtil.nvl(dbMap.get("HEIGHT_SIZE")) %>"> - px ??????</td>
					</tr>
	                <tr>
					    <th scope="row">??????</th>
					    <td>
							<% String strCtnt = (strIFlag.equals(CommDef.ReservedWord.UPDATE)) ? CommonUtil.nvl(dbMap.get("CONTENT")) : "" ; %>
							<textarea id="content" name="content" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(strCtnt)%></textarea> 
	                    </td>
					</tr> 	
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">????????????</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/popup/popupList.do?<%=strParam%>">??????</a>
				</div>
			</div>
			</form>
		</div>
	</div>
	

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script type="text/javascript">

function formcheck(f) {

	if (f.title.value == "")
	{
		alert("?????? ????????? ??????????????????.");
		f.title.focus();
		return false;
	}

	if (f.start_date.value == "")
	{
		alert("???????????? ???????????? ??????????????????.");
		f.start_date.focus();
		return false;
	}

	if (f.end_date.value == "")
	{
		alert("???????????? ???????????? ??????????????????.");
		f.end_date.focus();
		return false;
	}

	if (checkEngNumValue(f.left_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.left_size.focus();
		return false;
	}

	if (checkEngNumValue(f.top_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.top_size.focus();
		return false;
	}

	if (checkEngNumValue(f.width_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.width_size.focus();
		return false;
	}

	if (checkEngNumValue(f.height_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.height_size.focus();
		return false;
	}

	if (CKEDITOR.instances.content.getData() == '')  {
		 alert("????????? ???????????? ????????????");
		 return false;
	}

	return true;
}

</script>
</body>
</html>