<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap      = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap       = (Map)  request.getAttribute( "dbMap" );
	List lstFile     = (List) request.getAttribute( "lstFile" );

	List lstUserList = (List) request.getAttribute( "userList" );	
	List lstMrg      = (List) request.getAttribute( "mrgList" );
	
	int nFileInputCnt = 1;
	UploadUtil  upUtil = new UploadUtil(request);
	ServiceUtil sUtil  = new ServiceUtil();
	
    String strParam  = "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));	
    strParam += "&up_menu_no="     + CommonUtil.nvl( reqMap.get( "up_menu_no"));
    strParam += "&parent_menu_no=" + CommonUtil.nvl( reqMap.get( "parent_menu_no"));
    strParam += "&menu_gb="        + CommonUtil.nvl( reqMap.get( "menu_gb"));
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));	
    
    String strIFlag  = CommonUtil.nvl( reqMap.get( "iflag"));
	String iconCheck = "N";
	Aria aria = new Aria(CommDef.MASTER_KEY);
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

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/menu/menuWork.do" onsubmit="return fSubmit(this);">
	            <input name="iflag"           type="hidden" value="<%=CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT) %>">
	            <input name="menu_no"         type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
	            <input name="up_menu_no"      type="hidden" value="<%=CommonUtil.nvl(reqMap.get("up_menu_no")) %>">		            
	            <input name="parent_menu_no"  type="hidden" value="<%=CommonUtil.nvl(reqMap.get("parent_menu_no")) %>">
	            <input name="menu_gb"         type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>">		            
	            <input name="returl"          type="hidden" value="<%=CommDef.ADM_PATH %>/menu/menuList.do">
	            <input name="param"           type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
	            <input name="strregno"			type="hidden" value="<%=CommonUtil.nvl(dbMap.get("MENU_NO"))%>"/>
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">메뉴명</th>
						<td><input type="text" class="__form1" name="menu_nm"  value="<%=CommonUtil.nvl(dbMap.get("MENU_NM")) %>" maxlength="50"/></td>
					</tr>
					<tr>
						<th scope="row">메뉴URL</th>
						<td>
							<input type="text" class="__form1" name="menu_url" value="<%=CommonUtil.nvl(dbMap.get("MENU_URL")) %>"  maxlength="250">
							<% if (CommonUtil.nvl( reqMap.get( "menu_gb")).equals("ADMIN")) { //관리모드일때 %>
							<br/> ※ 게시판 페이지 생성시 : <b><%=CommDef.ADM_PATH %>/board/boardList.do</b> 입력
							<% } else { //사용자모드일때 %>
							<br/> ※ 게시판 페이지 생성시 : <b>/board.do</b> 입력
							<br/> ※ 컨텐츠 페이지 생성시 : <b>/contents.do</b> 입력
							<br/> ※ 연혁 페이지 생성시 : <b>/history.do</b> 입력
							<% } %>
						</td>
					</tr>
					<tr>
						<th scope="row">메뉴 Target</th>
						<td>
						       <select name="url_target" class="__form1">
						           <%=sUtil.getSelectBox("URLTGT", CommonUtil.nvl(dbMap.get("URL_TARGET"))) %>
						       </select>	
						</td>
					</tr>
					<tr>
						<th scope="row">게시판 번호</th>
						<td>
						       <select name="brd_mgrno" id="brd_mgrno" class="__form1">
                                    <option value="">선택하세요</option>						           
						                <%  if ( lstMrg != null && !lstMrg.isEmpty()) { 
						                        for (int nLoop=0; nLoop < lstMrg.size(); nLoop++) {
						                        	Map mapMgr = (Map)lstMrg.get(nLoop);
						                        	
						                        	String strSel = "";
						                        	
						                        	if ( CommonUtil.nvl(dbMap.get("BRD_MGRNO")).equals(CommonUtil.nvl(mapMgr.get("BRD_MGRNO")) )) {
						                        		strSel = " selected " ;
						                        	}
						                %>
						                             <option value="<%=mapMgr.get("BRD_MGRNO") %>" <%=strSel%>>[<%=mapMgr.get("BRD_MGRNO") %>] <%=mapMgr.get("BRD_NM") %></option>		
						                <%     }
						                    }
						                %>
						       </select>	
						</td>
					</tr>
					<% if (CommonUtil.nvl(reqMap.get("menu_gb")).equals("ADMIN")) { %>
					<tr>
						<th scope="row">관리자메인게시판 노출</th>
						<td>
					    	<input type="radio"  name="main_adm_yn" value="Y" id="main_adm_y"  <%=("Y".equals(CommonUtil.nvl(dbMap.get("MAIN_ADM_YN")))) ? " checked " : "" %>/><label for="main_adm_y">사용</label>
					        <input type="radio"  name="main_adm_yn" value="N" id="main_adm_n"  <%=("N".equals(CommonUtil.nvl(dbMap.get("MAIN_ADM_YN"))) || "".equals(CommonUtil.nvl(dbMap.get("MAIN_ADM_YN")))) ? " checked " : "" %>/><label for="main_adm_n">사용하지 않음</label>
				       		* 게시판 번호 선택시에만 관리자메인에 노출됩니다.
				        </td>
					</tr>
					<% } else { %>
						<input type="hidden" name="main_adm_yn" value="N"/>
 					<% } %>
	                <tr>
					    <th scope="row">메뉴설명<br/>(서브비주얼 내용)</th>
					    <td>
							<% String strCtnt = (strIFlag.equals(CommDef.ReservedWord.UPDATE)) ? CommonUtil.nvl(dbMap.get("MENU_DESC")) : "" ; %>
							<textarea id="menu_desc" name="menu_desc" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=CommonUtil.recoveryLtGt(CommonUtil.getReplaceToHtml(strCtnt))%></textarea> 
	                    </td>
					</tr> 						  

				<% if (CommonUtil.nvl(reqMap.get("up_menu_no")).equals("0") && !CommonUtil.nvl(reqMap.get("menu_gb")).equals("ADMIN")) { %>
					<tr>
						<th scope="row">서브비주얼이미지</th>
						<td>
							<%=upUtil.addInnerFileHtml(lstFile, nFileInputCnt, CommDef.IMG_VISUAL)%>
						</td>
					</tr>
				<% } %>
				
		            <tr>
					    <th scope="row">관리부서</th>
					    <td><input type="text" name="dept_nm" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("DEPT_NM")) %>"  maxlength="50"/></td>
					</tr>

 		            <tr>
					    <th scope="row">부서전화번호</th>
					    <td><input type="text" name="dept_telno" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("DEPT_TELNO")) %>"  maxlength="30"/></td>
					</tr>

  		            <tr>
					    <th scope="row">담당자명</th>
					    <td><input type="text" name="dept_charge_nm" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("DEPT_CHARGE_NM")) %>"  maxlength="50"/></td>
					</tr>

   		            <tr>
					    <th scope="row">담당자 이메일</th>
					    <td><input type="text" name="dept_email" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("DEPT_EMAIL")) %>"  maxlength="50"/></td>
					</tr>
 
    		        <tr>
					    <th scope="row">콘텐츠 관리 담당자</th>
					    <td>
						       <select name="cont_user_id" class="__form1">
                                    <option value="">선택하세요</option>						           
                <%  if ( lstUserList != null && !lstUserList.isEmpty()) { 
                        for (int nLoop=0; nLoop < lstUserList.size(); nLoop++) {
                        	Map mapUser = (Map)lstUserList.get(nLoop);
                        	
                        	String strSel = "";
                        	
                        	if ( CommonUtil.nvl(dbMap.get("CONT_USER_ID")).equals(CommonUtil.nvl(mapUser.get("USER_ID")) )) {
                        		strSel = " selected " ;
                        	}
                %>
                             <option value="<%=mapUser.get("USER_ID") %>" <%=strSel%>><%=aria.Decrypt(CommonUtil.nvl(mapUser.get("USER_NM"))) %> [<%=mapUser.get("USER_TYPE_NM") %> / <%=mapUser.get("USER_ID") %>]</option>		
                <%     }
                    }
                %>
						       </select> 선택된 담당자는 해당 메뉴의 콘텐츠를 관리 할 수 있습니다.
					    </td>
					</tr>
				<% if (CommonUtil.nvl(reqMap.get("up_menu_no")).equals("0") && CommonUtil.nvl(reqMap.get("menu_gb")).equals("ADMIN")) { 
						iconCheck = "Y";
				%>
  		            <tr>
					    <th scope="row">관리 아이콘</th>
					    <td><input type="text" name="icon_value" class="__form1" value="<%= (strIFlag.equals(CommDef.ReservedWord.INSERT) ? "axi axi-content-copy" : CommonUtil.nvl(dbMap.get("ICON_VALUE"))) %>"  maxlength="30"/></td>
					</tr>
				<% } %>
				
	                <tr>
					    <th scope="row">사용여부</th>
					    <td>
					    	<input type="radio"  name="use_yn" value="Y" id="use_yn_y"  <%=("Y".equals(CommonUtil.nvl(dbMap.get("USE_YN"))) || "".equals(CommonUtil.nvl(dbMap.get("USE_YN")))) ? " checked " : "" %>/><label for="use_yn_y">사용</label>
					        <input type="radio"  name="use_yn" value="N" id="use_yn_N"  <%=("N".equals(CommonUtil.nvl(dbMap.get("USE_YN")))) ? " checked " : "" %>/><label for="use_yn_N">사용하지 않음</label>
					    </td>
					</tr>
				<% if (!CommonUtil.nvl(reqMap.get("menu_gb")).equals("ADMIN")) { %>
	                <tr>
					    <th scope="row">GNB 노출여부</th>
					    <td>
					    	<input type="radio"  name="gnb_show_yn" value="Y" id="gnb_show_yn_y"  <%=("Y".equals(CommonUtil.nvl(dbMap.get("GNB_SHOW_YN"))) || "".equals(CommonUtil.nvl(dbMap.get("GNB_SHOW_YN")))) ? " checked " : "" %>/><label for="gnb_show_yn_y">사용</label>
					        <input type="radio"  name="gnb_show_yn" value="N" id="gnb_show_yn_N"  <%=("N".equals(CommonUtil.nvl(dbMap.get("GNB_SHOW_YN")))) ? " checked " : "" %>/><label for="gnb_show_yn_N">사용하지 않음</label>
					    </td>
					</tr>
	                <tr>
					    <th scope="row">LNB 노출여부</th>
					    <td>
					    	<input type="radio"  name="lnb_show_yn" value="Y" id="lnb_show_yn_y"  <%=("Y".equals(CommonUtil.nvl(dbMap.get("LNB_SHOW_YN"))) || "".equals(CommonUtil.nvl(dbMap.get("LNB_SHOW_YN")))) ? " checked " : "" %>/><label for="lnb_show_yn_y">사용</label>
					        <input type="radio"  name="lnb_show_yn" value="N" id="lnb_show_yn_N"  <%=("N".equals(CommonUtil.nvl(dbMap.get("LNB_SHOW_YN")))) ? " checked " : "" %>/><label for="lnb_show_yn_N">사용하지 않음</label>
					    </td>
					</tr>
				<% } else { %>
					<input type="hidden" name="gnb_show_yn" value="Y"/>
					<input type="hidden" name="lnb_show_yn" value="Y"/>
				<% } %>
	                <tr>
					    <th scope="row">순서</th>
					    <td><input type="text"  name="ord" style="width:50px;IME-MODE:disabled;"  class="__form1"  value="<%=CommonUtil.nvl(dbMap.get("ORD")) %>" maxlength="5"/></td>
					</tr>				

				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">작성완료</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/menu/menuList.do?<%=strParam%>">취소</a>
				</div>
			</div>
			</form>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>

function fSubmit(f) {
	
	var iconcheck = "<%=iconCheck%>";
	
	if (iconcheck == "Y") {
		if (f.icon_value.value == "")
		{
			alert("관리 아이콘을 입력해주세요.");
			f.icon_value.focus();
			return false;
		}
	}

	if ($('input[name="main_adm_yn"]:checked').val() == "Y") {
		if ($('#brd_mgrno').val() == "") {
			alert('게시판을 선택해주세요.');
			return false;
		}
	}
	
	if (f.menu_nm.value == "")
	{
		alert("메뉴명을 입력해주세요.");
		f.menu_nm.focus();
		return false;
	}

	if (f.menu_url.value == "")
	{
		alert("메뉴URL을 입력해주세요.");
		f.menu_url.focus();
		return false;
	}

	if (checkEngNumValue(f.ord.value, "순서는 숫자만 입력할수 있습니다.", 2) == "N")
	{
		f.ord.focus();
		return false;
	}

	return true;
}
</script>
</body>
</html>