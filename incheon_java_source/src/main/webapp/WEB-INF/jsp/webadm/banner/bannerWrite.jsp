<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	List lstUseYn   = (List) request.getAttribute( "lstUseYn" );
	List lstFile     = (List) request.getAttribute( "lstFile" );

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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/banner/bannerWork.do" onsubmit="return formcheck(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="seq"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/banner/bannerList.do">
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
						<td><input type="text" class="__form1" name="title" value="<%=CommonUtil.nvl(dbMap.get("TITLE"))%>"></td>
					</tr>
	                <tr>
					    <th scope="row">????????????</th>
					    <td><%=sUtil.getRadioBox(lstUseYn,"use_yn", CommonUtil.nvl(dbMap.get("USE_YN"), "Y")) %>
					    </td>
					</tr>
					<tr>
						<th scope="row">????????????</th>
						<td>
							<select name="type_cd" id="type_cd" class="__form1">
								<%=sUtil.getSelectBox("BANNER_TYPE_CD", CommonUtil.nvl(dbMap.get("TYPE_CD"))) %>
							</select>
						</td>
					</tr>

					<tr>
						<th scope="row">????????????</th>
						<td>
							<select name="type2_cd" id="type2_cd" class="__form1" onchange="bannerTypeSelect(this.value);">
								<%=sUtil.getSelectBox("BANNER_TYPE2_CD", CommonUtil.nvl(dbMap.get("TYPE2_CD"))) %>
							</select>
						</td>
					</tr>

					<tr id="bannerimgtr">
						<th scope="row">???????????????(pc)</th>
						<td>
							<%=upUtil.addInnerFileHtml(lstFile, nFileInputCnt, "FILE1")%>
						</td>
					</tr>
					<tr id="bannerimgtr2">
						<th scope="row">???????????????(mobile)</th>
						<td>
							<%=upUtil.addInnerFileHtml(lstFile, nFileInputCnt, "FILE2")%>
						</td>
					</tr>

					<tr id="bannerlinktr">
						<th scope="row">????????????</th>
						<td><input type="text" class="__form1" name="link_text" value="<%=CommonUtil.nvl(dbMap.get("LINK_TEXT"))%>"><br/>
							  ???) /notice/notice.do
						</td>
					</tr>

					<tr id="bannerlinktargettr">
						<th scope="row">????????????</th>
						<td>
							<select name="link_target" id="link_target" class="__form1">
								<option value="_blank" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>selected<% } else { %><%=("_blank".equals(CommonUtil.nvl(dbMap.get("LINK_TARGET")))) ? " selected " : "" %><% } %>>_blank</option>
								<option value="_self" <%=("_self".equals(CommonUtil.nvl(dbMap.get("LINK_TARGET")))) ? " selected " : "" %>>_self</option>
							</select>
						</td>
					</tr>

					<tr id="movielinktr">
						<th scope="row">???????????????</th>
						<td>
							<input type="text" class="__form1" name="movie_link" value="<%=CommonUtil.nvl(dbMap.get("MOVIE_LINK"))%>"><br/>
							???) https://www.youtube.com/embed/p-1r2X3HOBQ
						</td>
					</tr>

					<tr>
						<th scope="row">??????</th>
						<td><input type="text" class="__form1" name="ord" style="width:80px;" maxlength="10" value="<%=CommonUtil.nvl(dbMap.get("ORD"))%>">
							- ????????? ?????? ???????????? ?????? ???????????????. (?????? -2147483648 ~ 2147483648 )
						</td>
					</tr>

				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">????????????</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/banner/bannerList.do?<%=strParam%>">??????</a>
				</div>
			</div>
			</form>
		</div>
	</div>


	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>

</div>
<script type="text/javascript">

$(document).ready(function() {

	bannerTypeSelect($('#type2_cd').val());

});

//?????? ?????? ????????? ???????????? ??????
function bannerTypeSelect(val) {

	//????????? ???????????????
	if (val == "IMAGE") {
		$('#bannerimgtr').show();
		$('#bannerimgtr2').show();
		$('#bannerlinktr').show();
		$('#bannerlinktargettr').show();
		$('#movielinktr').hide();
	} else if (val == "TEXTCODE") { //????????? ???????????????
		$('#bannerimgtr').hide();
		$('#bannerimgtr2').hide();
		$('#bannerlinktr').show();
		$('#bannerlinktargettr').show();
		$('#movielinktr').hide();
	}
}

function formcheck(f) {

	if (f.title.value == "")
	{
		alert("?????? ????????? ??????????????????.");
		f.title.focus();
		return false;
	}

	if (checkEngNumValue(f.ord.value, "????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.ord.focus();
		return false;
	}

	return true;
}

</script>
</body>
</html>