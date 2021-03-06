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
						<th scope="row">????????? ???</th>
						<td><input type="text" class="__form1" name="brd_nm" value="<%=CommonUtil.nvl(dbMap.get("BRD_NM")) %>" maxlength="100"/></td>
					</tr>

	                <tr>
					    <th scope="row">????????? ??????</th>
					    <td>
					       <select name="brd_skin_cd" class="__form1">
					           <%=sUtil.getSelectBox("SKIN", CommonUtil.nvl(dbMap.get("BRD_SKIN_CD"))) %>
					       </select>						    
					    </td>
					</tr>
					
	                <tr>  
					    <th scope="row">????????????</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"use_yn", CommonUtil.nvl(dbMap.get("USE_YN"), "Y")) %>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">????????? ??????</th>
					    <td>
					       <input type="text"  name="list_cnt" style="width:50px;IME-MODE:disabled;"  class="__form1"  value="<%=CommonUtil.nvl(dbMap.get("LIST_CNT"), "10") %>" maxlength="3"/>
					                ??? [0]??? ????????? ????????? ???????????? ???????????? ????????? ??????
					    </td>
					</tr>

	                <tr>
					    <th scope="row">???????????? ??????</th>
					    <td>
                            <select name="list_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("LIST_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">????????? ??????</th>
					    <td>
                            <select name="read_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("READ_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">????????? ??????</th>
					    <td>
                            <select name="write_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("WRITE_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">????????? ??????</th>
					    <td>
                            <select name="reply_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("REPLY_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>

	                <tr>
					    <th scope="row">???????????? ??????</th>
					    <td>
                            <select name="comment_level_cd">
					    		<%=sUtil.getSelectBox("WAUTH", CommonUtil.nvl(dbMap.get("COMMENT_LEVEL_CD"))) %>
					    	</select>
					    </td>
					</tr>
					
	                <tr>
					    <th scope="row">???????????? ??????</th>
					    <td><input type="text"  name="attach_file_cnt" style="width:50px;IME-MODE:disabled;" class="__form1"  value="<%=CommonUtil.nvl(dbMap.get("ATTACH_FILE_CNT"), "0") %>" maxlength="2"/>
					    	??? [0]??? ??????????????? ???????????? ????????????
					    </td>
					</tr>	
						
	                <tr>
					    <th scope="row">???????????? ????????????</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"notice_yn", CommonUtil.nvl(dbMap.get("NOTICE_YN"), "N")) %></td>
					</tr>

	                <tr>
					    <th scope="row">???????????? ????????????</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"cate_cd_use_yn", CommonUtil.nvl(dbMap.get("CATE_CD_USE_YN"), "N")) %></td>
					</tr>
					
					<tr>
                         <th scope="row">???????????? ??????</th>						    
                         <td>
                            <select name="cate_cd">
                                <option value="">???????????????</option>
			           			<%=sUtil.getSelectBox("*", CommonUtil.nvl(dbMap.get("CATE_CD")), "CATEGORY_") %>
			       			</select>
			       			<br/>?????????????????? <b>CATEGORY_</b> ??? ???????????? ?????? ??????
			    		</td>
					</tr>
								
		                <tr>
						    <th scope="row">???????????? ??????</th>
						    <td>
                            <select name="order_cd">
						    	<%=sUtil.getSelectBox("ORDER_CD", CommonUtil.nvl(dbMap.get("ORDER_CD"))) %>
						    </select>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">URL ????????????</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"url_use_yn", CommonUtil.nvl(dbMap.get("URL_USE_YN"), "N")) %>
						    	 <input type="hidden" name="direct_url_use_yn" value="N"/>
						          <%-- <br/>??????????????????????????? ???????????? : <%=sUtil.getRadioBox(lstUseYn,"direct_url_use_yn", CommonUtil.nvl(dbMap.get("DIRECT_URL_USE_YN"), "N")) %>			 --%>			    
						    </td>
						</tr>	
						
		                <tr>
						    <th scope="row">????????? ????????????</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"reply_use_yn", CommonUtil.nvl(dbMap.get("REPLY_USE_YN"), "N")) %>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">?????? ????????????</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"cmt_use_yn", CommonUtil.nvl(dbMap.get("CMT_USE_YN"), "N")) %>
						    </td>
						</tr>
													 
		                <tr>
						    <th scope="row">????????? ????????????</th>
						    <td><%=sUtil.getRadioBox(lstUseYn,"secret_use_yn", CommonUtil.nvl(dbMap.get("SECRET_USE_YN"), "N")) %>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">????????? ?????????</th>
						    <td>
						    	?????? : <input type="text"  style="width:50px;IME-MODE:disabled;" name="thm_width_size" class="__form1" value="<%= (strIFlag.equals(CommDef.ReservedWord.INSERT) ? "500" : CommonUtil.nvl(dbMap.get("THM_WIDTH_SIZE"))) %>" maxlength="10" /> px
						    	?????? : <input type="text" style="width:50px;IME-MODE:disabled;"  name="thm_height_size" class="__form1" value="<%= (strIFlag.equals(CommDef.ReservedWord.INSERT) ? "400" : CommonUtil.nvl(dbMap.get("THM_HEIGHT_SIZE"))) %>" maxlength="10"/> px 
						    	&nbsp;<b>????????? ???????????? ????????? ????????? ????????? ??????????????? ????????? ???????????? ???????????????.</b>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">????????????1</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field1_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD1_USE_YN"), "N")) %> 
						    	????????? : <input type="text" style="width:200px" name="etc_field1_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD1_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">????????????2</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field2_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD2_USE_YN"), "N")) %> 
						    	????????? : <input type="text" style="width:200px" name="etc_field2_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD2_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">????????????3</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field3_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD3_USE_YN"), "N")) %> 
						    	????????? : <input type="text" style="width:200px" name="etc_field3_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD3_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">????????????4</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field4_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD4_USE_YN"), "N")) %> 
						    	????????? : <input type="text" style="width:200px" name="etc_field4_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD4_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>

		                <tr>
						    <th scope="row">????????????5</th>
						    <td>
						    	<%=sUtil.getRadioBox(lstUseYn,"etc_field5_use_yn", CommonUtil.nvl(dbMap.get("ETC_FIELD5_USE_YN"), "N")) %> 
						    	????????? : <input type="text" style="width:200px" name="etc_field5_title" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("ETC_FIELD5_TITLE")) %>" maxlength="50"/>
						    </td>
						</tr>
						
		                <tr>
						    <th scope="row">????????? ??????</th>
						    <td>
								<% String strCtnt = (strIFlag.equals(CommDef.ReservedWord.UPDATE)) ? CommonUtil.nvl(dbMap.get("BRD_DESC")) : "" ; %>
								<textarea id="brd_desc" name="brd_desc" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(strCtnt))%></textarea> 
		                    </td>
						</tr> 	
					
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">????????????</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/boardmgr/boardMgrList.do?<%=strParam%>">??????</a>
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
		alert("??????????????? ??????????????????.");
		f.brd_nm.focus();
		return false;
	}

	if (f.list_cnt.value == "")
	{
		alert("?????????????????? ??????????????????.");
		f.list_cnt.focus();
		return false;
	}

	if (f.order_cd.value == "")
	{
		alert("???????????? ????????? ??????????????????.");
		f.order_cd.focus();
		return false;
	}

	if (checkEngNumValue(f.thm_width_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.thm_width_size.focus();
		return false;
	}

	if (checkEngNumValue(f.thm_height_size.value, "????????? ?????? ???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.thm_height_size.focus();
		return false;
	}

	return true;
}
</script>
</body>
</html>