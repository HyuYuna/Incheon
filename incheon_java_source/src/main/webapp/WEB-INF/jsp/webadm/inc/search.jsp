<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	ServiceUtil sUtil = new ServiceUtil();  

	Integer menu_no = CommonUtil.getNullInt(reqMap.get("menu_no"), 0);
	
	String pagename = request.getAttribute("javax.servlet.forward.request_uri").toString();
	String[] pagevalue = pagename.split("/"); //페이지명 추출 
%>
	<form name="search_list" id="search_list" method="get" action="<%=request.getAttribute("javax.servlet.forward.request_uri")%>">
		<input type="hidden" name="menu_no" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>
		<% if (pagevalue[3].equals("boardList.do")) { //게시판관리 %>
			<input type="hidden" name="brd_mgrno" value="<%=CommonUtil.nvl(reqMap.get("brd_mgrno")) %>"/>
		<% } %>
		<div class="__search">
			<span class="calendar">
				<button type="button" class="__btn1" onclick="javascript:set_date('오늘');">오늘</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('어제');">어제</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('이번주');">이번주</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('이번달');">이번달</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('지난주');">지난주</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('지난달');">지난달</button>
				<button type="button" class="__btn1" onclick="javascript:set_date('전체');">전체</button>
				<span class="__date"><input type="text" class="__form1" name="txt_sdate" id="txt_sdate" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>" readonly></span> ~
				<span class="__date"><input type="text" class="__form1" name="txt_edate" id="txt_edate" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>" readonly></span>
			</span>
			
			<% if (pagevalue[3].equals("memberList.do")) { //회원관리 %>
				<select name="usertype" id="usertype" class="__form1">
					<option value="">유저타입</option>
					<%=sUtil.getSelectBox("USERGRD", CommonUtil.nvl(reqMap.get("usertype"))) %>
				</select>
			<% } %>
			<% if (pagevalue[3].equals("boardList.do") && !CommonUtil.nvl(reqMap.get("catecd")).equals("")) { //게시판관리  %>
				<select name="category" id="category" class="__form1">
					<option value="">카데고리선택</option>
					<%=sUtil.getSelectBox(CommonUtil.nvl(reqMap.get("catecd")), CommonUtil.nvl(reqMap.get("category"))) %>
				</select>
			<% } %>
							
			<select name="keykind" id="keykind" class="__form1">
				<option value="" <%="".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>전체</option>
			<% if (pagevalue[3].equals("popupList.do")){ //팝업관리 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>팝업제목</option>
				<option value="content" <%="content".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>팝업내용</option>
			<% } else if (pagevalue[3].equals("bannerList.do")) { //배너관리 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>배너제목</option>
			<% } else if (pagevalue[3].equals("historyList.do")) { //연혁관리 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>내용</option>
			<% } else if (pagevalue[3].equals("referrer.list.do")) { //유입경로리스트 %>
				<option value="join_route" <%="join_route".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>접속경로</option>
				<option value="join_page" <%="join_page".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>접속페이지</option>
			<% } else if (pagevalue[3].equals("memberList.do")) { //회원관리 %>
				<option value="user_id" <%="user_id".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>아이디</option>
				<option value="user_nm" <%="user_nm".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>이름</option>
				<option value="email" <%="email".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>이메일</option>
				<option value="hp" <%="hp".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>휴대폰</option>
			<% } else if (pagevalue[3].equals("boardMgrList.do")) { //게시판관리 %>
				<option value="brd_nm" <%="brd_nm".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>게시판명</option>
			<% } else if (pagevalue[3].equals("onlineList.do")) { //온라인문의관리 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>제목</option>
				<option value="company" <%="company".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>회사명</option>
				<option value="email" <%="email".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>이메일</option>
				<option value="name" <%="name".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>이름</option>
			<% } else if (pagevalue[3].equals("emailList.do")) { //이메일발송관리 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>제목</option>
				<option value="to_email" <%="to_email".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>받는이메일</option>
				<option value="from_email" <%="from_email".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>보내는이메일</option>
			<% } else if (pagevalue[3].equals("boardList.do")) { //게시판 %>
				<option value="title" <%="title".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>제목</option>
				<option value="reg_name" <%="reg_name".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>작성자</option>
				<option value="reg_id" <%="reg_id".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>작성자ID</option>
				<option value="content" <%="content".equals(CommonUtil.nvl(reqMap.get("keykind"))) ? "selected" : "" %>>내용</option>
			<% } %>
			</select>
				<input type="text" name="keyword" id="keyword" class="__form1" style="width:120px;" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>">
				<button type="submit" class="__btn1 type3">검색</button>
		</div>
	</form>

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
	
	function set_date(today)
	{
	        if (today == "오늘") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
	    } else if (today == "어제") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "prevday")%>";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("", "prevday")%>";
	    } else if (today == "이번주") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "firstWeek")%>";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
	    } else if (today == "이번달") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("","YYYY-MM")%>-01";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("-","")%>";
	    } else if (today == "지난주") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("", "prevWeek1")%>";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("", "prevWeek2")%>";
	    } else if (today == "지난달") {
	        document.getElementById("txt_sdate").value = "<%=CommonUtil.getCurrentDate("","prevmonth1")%>";
	        document.getElementById("txt_edate").value = "<%=CommonUtil.getCurrentDate("","prevmonth2")%>";
	    } else if (today == "전체") {
	        document.getElementById("txt_sdate").value = "";
	        document.getElementById("txt_edate").value = "";
	    }
	}
	</script>