<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
	List commentList = (List) request.getAttribute("commentList");
	List lstFile   = (List) request.getAttribute( "lstFile" );

	ServiceUtil sUtil = new ServiceUtil();
	Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");

    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));
    strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&brd_mgrno="       + CommonUtil.nvl( reqMap.get( "brd_mgrno"));
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));

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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/board/boardWork.do">
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
		        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
		        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
		        <input name="mode" type="hidden" value=""/>

			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
				<% if (CommonUtil.nvl(brdMgrMap.get("CATE_CD_USE_YN")).equals("Y")) {  //???????????? ?????? %>
					<tr>
						<th scope="row">????????????</th>
						<td>
							<%=sUtil.getCodeName(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(dbMap.get("CATEGORY_CD")))%>
						</td>
					</tr>
				<% } %>
					<tr>
						<th scope="row">??????</th>
						<td><%=CommonUtil.nvl(dbMap.get("TITLE")) %></td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("REG_NAME")) %></td>
					</tr>
				<% if (CommonUtil.nvl(brdMgrMap.get("NOTICE_YN")).equals("Y")) {  //????????? ???????????? %>
					<tr>
						<th scope="row">????????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("NOTICE_YN")) %></td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("SECRET_USE_YN")).equals("Y")) {  //????????? ???????????? %>
					<tr>
						<th scope="row">???????????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("SECRET_YN")) %></td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ORDER_CD")).equals("BOARD_NUM ASC")) {  //?????? ???????????? ?????? %>
					<tr>
						<th scope="row">?????? ????????????</th>
						<td><%=CommonUtil.nvl(dbMap.get("BOARD_SORT"))%></td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("URL_USE_YN")).equals("Y")) {  //URL ?????? ?????? %>
					<tr>
						<th scope="row">URL ??????</th>
						<td><a href="<%=CommonUtil.nvl(dbMap.get("URL_TEXT"))%>" target="_blank"><%=CommonUtil.nvl(dbMap.get("URL_TEXT"))%></a></td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_USE_YN")).equals("Y")) {  //????????????1 ?????? %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD1_TITLE")) %></th>
						<td>
							<%=CommonUtil.nvl(dbMap.get("ETC_FIELD1"))%>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_USE_YN")).equals("Y")) {  //????????????2 ?????? %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD2_TITLE")) %></th>
						<td>
							<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //???????????? ????????? %>
								<select name="etc_field2" id="etc_field2" style="width:150px;">
									<%=sUtil.getSelectBox("MINWON", CommonUtil.nvl(dbMap.get("ETC_FIELD2"))) %>
								</select>
								<a href="#" class="__btn2 type2" onclick="stateModify('<%=CommonUtil.nvl(dbMap.get("BRD_NO"))%>');">??????</a>
							<% } else { %>
								<%=CommonUtil.nvl(dbMap.get("ETC_FIELD2"))%>
							<% } %>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_USE_YN")).equals("Y")) {  //????????????3 ?????? %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD3_TITLE")) %></th>
						<td>
							<%=CommonUtil.nvl(dbMap.get("ETC_FIELD3"))%>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_USE_YN")).equals("Y")) {  //????????????4 ?????? %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD4_TITLE")) %></th>
						<td>
							<%=CommonUtil.nvl(dbMap.get("ETC_FIELD4"))%>
						</td>
					</tr>
				<% } %>
				<% if (CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_USE_YN")).equals("Y")) {  //????????????5 ?????? %>
					<tr>
						<th scope="row"><%=CommonUtil.nvl(brdMgrMap.get("ETC_FIELD5_TITLE")) %></th>
						<td>
							<%=CommonUtil.nvl(dbMap.get("ETC_FIELD5"))%>
						</td>
					</tr>
				<% } %>
	                <tr>
					    <th scope="row">??????</th>
					    <td>
						<%
							if (CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).equals("SKINVIDEO")) {  //????????? ?????? ??????
								for (int i = 1; i <= 3; i++) {
									if (!CommonUtil.nvl(dbMap.get("YOUTUBE_CODE" + i)).equals("")) {
						%>
						<iframe width="854" height="480" src="https://www.youtube.com/embed/<%=CommonUtil.nvl(dbMap.get("YOUTUBE_CODE" + i))%>" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe> <br/>
						<%
									}
								}
							}
						%>
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
	                    </td>
					</tr>
					<tr>
						<th scope="row">????????????</th>
						<td>
						<%
		                   for (int nLoop =0; nLoop < lstFile.size(); nLoop++)
		                   {
		                	   Map dbFile = (Map)lstFile.get(nLoop);
						%>
							<a href="javascript:download(<%=CommonUtil.getNullTrans(dbFile.get("FILE_NO"))%>)"><%=CommonUtil.getFileName(CommonUtil.getNullTrans(dbFile.get("FILE_NM")))%></a><br/>
						<% }%>
						</td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td>
							<%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("VIEW_CNT"))) %>
						</td>
					</tr>
					<tr>
						<th scope="row">?????????</th>
						<td>
							<%=CommonUtil.getDateFormat(dbMap.get("REG_DT")) %>
						</td>
					</tr>
				</tbody>
			</table>

			</form>

			<br/>

			<% if (CommonUtil.nvl(brdMgrMap.get("CMT_USE_YN")).equals("Y")) { //????????? ???????????? ?????? %>

			<form name="commentform" action="<%=CommDef.ADM_PATH %>/board/commentUpdate.do" method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" onsubmit="return commentWrite(this)">

                <input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
                <input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
                <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                <input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

	            <input name="brd_mgrno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("brd_mgrno")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/board/boardView.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
		        <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
		        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
		        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
		        <input name="mode" type="hidden" value="w"/>
		        <input type="hidden" name="comment_id" id="comment_id" value="" />

			<div class="__commw">
				<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //???????????? ????????? %>
					<input type="hidden" name="cm_secret" value="N"/>
					&nbsp;<b>??? ?????? ????????? ?????????????????? ???????????? ??????????????? ???????????????.</b>
					<br/><br/>
					<textarea name="cmm_content" id="cmm_content" class="txt" placeholder="" style="height:200px;"></textarea>
					<button type="submit" class="btn">????????????</button>
				<% } else { %>
					&nbsp;<label><input type="checkbox" name="cm_secret" id="cm_secret" value="Y"/> ????????? </label>
					<br/><br/>
					<textarea name="cmm_content" id="cmm_content" class="txt" placeholder=""></textarea>
					<button type="submit" class="btn">????????????</button>
				<% } %>
			</div>

			<%
			    if(commentList != null && commentList.size() > 0){

			       for( int commentLoop = 0; commentLoop < commentList.size(); commentLoop++ ) {
			            Map cmMap = ( Map ) commentList.get( commentLoop );

			            String secretcmText = "";
			            int cmt_depth = CommonUtil.nvl(cmMap.get("COMMENT_REPLY")).length();
			            if (CommonUtil.nvl(cmMap.get("SECRET_YN")).equals("Y")) secretcmText = "<font color='red'>[?????????]</font>&nbsp;";
			%>
				<input type="hidden" name="cm_secret<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>" id="cm_secret<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>" value="<%=CommonUtil.nvl(cmMap.get("SECRET_YN")) %>" />
				<div class="__comm">
					<div class="box" <% if (cmt_depth > 0)  { %>style="margin-left:<%=cmt_depth%>>px;border-top-color:#e0e0e0"<% } %>>
						<dl>
							<dt><%=secretcmText%><%=CommonUtil.getReplylen(CommonUtil.nvl(cmMap.get("COMMENT_REPLY")),"") %><strong><%=CommonUtil.nvl(cmMap.get("REG_NAME")) %></strong> <span>(<%=CommonUtil.getDateFormat(cmMap.get("REG_DT")) %>)</span></dt>
							<dd id="cm_content<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>"><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(cmMap.get("CONTENT")))%></dd>
						</dl>
						<div class="btn">
							<button type="button" class="__btn2 type2" onclick="javascript:commentReWrite('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>');">??????</button>
							<button type="button" class="__btn2 type2" onclick="javascript:commentModify('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>');">??????</button>
							<button type="button" class="__btn2 type3" onclick="javascript:commentDelete('<%=CommonUtil.nvl(cmMap.get("BRD_NO")) %>');">??????</button>
						</div>
					</div>
				</div>
			<%
					}
			    }
			%>

			</form>

			<% } %>

			<div class="__botarea">
				<div class="cen">

					<button type="button" class="__btn2 type4" onclick="location.href='<%=CommDef.ADM_PATH %>/board/boardList.do?<%=strParam%>';">?????????</button>
					<% if (CommonUtil.nvl(brdMgrMap.get("REPLY_USE_YN")).equals("Y") && CommonUtil.nvl(dbMap.get("NOTICE_YN")).equals("N")) { %>
						<% if (CommonUtil.getNullInt(brdMgrMap.get("REPLY_LEVEL_CD"), 0) <= CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 0)) { %>
						<a href="#" class="__btn2 type2" onclick="fReply('<%=CommonUtil.nvl(dbMap.get("BRD_NO"))%>');">??????</a>
						<% } %>
					<% } %>
					<a href="#" class="__btn2 type2" onclick="fModify('<%=CommonUtil.nvl(dbMap.get("BRD_NO"))%>');">??????</a>
					<a href="#" class="__btn2 type3" onclick="fDelete('<%=CommonUtil.nvl(dbMap.get("BRD_NO"))%>');">??????</a>
				</div>
			</div>

		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>

</div>
<script>
<% if (CommonUtil.nvl(reqMap.get("brd_mgrno")).equals("61")) { //???????????? ????????? %>
	function stateModify() {
	    $.ajax({
	        type : 'POST',
	        url :  '<%=CommDef.ADM_PATH %>/board/boardStateUpdate.do',
	        data : {
	        	etc_field2 : $("#etc_field2 option:selected").val(), brd_no : <%=CommonUtil.nvl(dbMap.get("BRD_NO"))%>
			},
			dataType : "json",
	        success : function(data) {

				if (data == 1) {
					alert("?????????????????? ?????????????????????.");
				} else {
					alert("????????? ?????????????????????.");
				}

	        }, error : function (){
	        	alert("????????? ?????????????????????.");
	        }

	    });
	}
<% } %>

	function fDelete(strSeq)
	{
		  vObj = document.writeform;

		  if (!confirm("?????????????????????????"))
			  return;

		  vObj.mode.value = "del";
		  vObj.seq.value = strSeq;
		  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardDelete.do";

		  vObj.submit();
	}

   function fModify(strSeq)
   {
	  vObj = document.writeform;

	  vObj.seq.value = strSeq;
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardWrite.do";

	  vObj.submit();
   }

   function fReply(strSeq)
   {
	  vObj = document.writeform;

	  vObj.seq.value = strSeq;
	  vObj.iflag.value = "<%=CommDef.ReservedWord.REPLY%>";
	  vObj.action = "<%=CommDef.ADM_PATH %>/board/boardWrite.do";

	  vObj.submit();
   }

	//????????? ??????
	function commentWrite(f){
		if (f.cmm_content.value == "")
		{
			alert("????????? ????????? ??????????????????.");
			f.cmm_content.focus();
			return false;
		}
	}

	//????????? ??????
	function commentModify(comment_id) {

		var f = document.commentform;

		$('#comment_id').val(comment_id);
		if ($('#cm_secret' + comment_id).val() == "Y") {
			$('#cm_secret').prop("checked", true);
		} else {
			$('#cm_secret').prop("checked", false);
		}

		$('#cmm_content').val(replaceAll($('#cm_content' + comment_id).html(),'<br>', '\n'));
		f.mode.value = "u";
	}

	//????????? ??????
	function commentReWrite(comment_id) {

		var f = document.commentform;

		$('#comment_id').val(comment_id);
		$('#cmm_content').val("[??????]\n" + replaceAll($('#cm_content' + comment_id).html(),'<br>', '\n'));
		f.mode.value = "r";
	}

	//????????? ??????
	function commentDelete(comment_id) {
		var f = document.commentform;

		if (window.confirm("????????? ?????????????????????????"))
		{
			$('#comment_id').val(comment_id);
			f.mode.value = "d";
			f.action = "<%=CommDef.ADM_PATH %>/board/commentDelete.do";
			f.submit();
		}

	}


</script>
</body>
</html>