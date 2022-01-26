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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/history/historyWork.do" onsubmit="return formcheck(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag %>">
	            <input name="seq"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/history/historyList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
	            <input name="menu_gb"         	type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>					
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
				
					<tr>
						<th scope="row">날짜</th>
						<td>
							<select name="year_text" id="year_text" class="__form1">
								<% for (int y = CommonUtil.getNullInt(CommDef.SEARCH_YEAR, 2019); y >= 1970; y--) { %>
									<option value="<%=y%>" <%=CommonUtil.nvl(dbMap.get("YEAR_TEXT")).equals(CommonUtil.nvl(y)) ? "selected" : "" %>><%=y%></option>
								<% } %>
							</select> 년 &nbsp;
							<input type="text" class="__form1"  name="MONTH_TEXT" id="MONTH_TEXT" style="width:200px;" maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("MONTH_TEXT"))%>"/>
						</td>
					</tr>

					<tr>
						<th scope="row">내용</th>
						<td>
							<textarea rows="10" cols="5" name="title" id="title" style="width:100%;height:250px;"><%=(strIFlag.equals(CommDef.ReservedWord.UPDATE) ? CommonUtil.recoveryLtGt((String)dbMap.get("TITLE")) : "") %></textarea>
						</td>
					</tr>
					
					<tr>
						<th scope="row">순번</th>
						<td><input type="text" class="__form1" name="ord" style="width:80px;" maxlength="10" value="<%=CommonUtil.nvl(dbMap.get("ORD"))%>">
							- 숫자가 낮은 순서대로 우선 출력됩니다. (범위 -2147483648 ~ 2147483648 )
						</td>
					</tr>
					 	
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">작성완료</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/history/historyList.do?<%=strParam%>">취소</a>
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
		alert("내용을 입력해주세요.");
		f.title.focus();
		return false;
	}

	if (checkEngNumValue(f.ord.value, "순번은 숫자로만 입력해주세요.", 2) == "N")
	{
		f.ord.focus();
		return false;
	}

	return true;
}

</script>
</body>
</html>