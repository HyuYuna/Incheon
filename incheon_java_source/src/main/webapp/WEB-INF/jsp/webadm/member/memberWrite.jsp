<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*, java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Aria aria = new Aria(CommDef.MASTER_KEY);
	
	if ( dbMap == null )
		dbMap = new HashMap();
	
	ServiceUtil sUtil = new ServiceUtil();
	
    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&txt_sdate="       + CommonUtil.nvl( reqMap.get( "txt_sdate"));	
    strParam += "&txt_edate="       + CommonUtil.nvl( reqMap.get( "txt_edate"));	
    strParam += "&usertype="       + CommonUtil.nvl( reqMap.get( "usertype"));	
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));	
    strParam += "&menu_no="       + CommonUtil.nvl( reqMap.get( "menu_no"));	
	    
	Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");
	
	String strMenuNo = CommonUtil.nvl( reqMap.get( "menu_no"));
	String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);

	String usernmDecrypt = "";
	String hpDecrypt = "";
	String telDecrypt = "";
	String emailDecrypt =  "";
	String birthDayDecrypt = "";
	String hp1 = "";
	String hp2 = "";
	String hp3 = "";
	String tel1 = "";
	String tel2 = "";
	String tel3 = "";
	String email1 = "";
	String email2 = "";

	if (strIFlag.equals(CommDef.ReservedWord.UPDATE)) {

	 	usernmDecrypt = aria.Decrypt(CommonUtil.nvl(dbMap.get("USER_NM")));
		hpDecrypt = aria.Decrypt(CommonUtil.nvl(dbMap.get("HP")));
		telDecrypt = aria.Decrypt(CommonUtil.nvl(dbMap.get("TEL")));
		emailDecrypt =  aria.Decrypt(CommonUtil.nvl(dbMap.get("EMAIL")));
		birthDayDecrypt = aria.Decrypt(CommonUtil.nvl(dbMap.get("BIRTHDAY")));
		
		if (hpDecrypt.length() > 2) {
			String[] hp = hpDecrypt.split("-");
			hp1 = hp[0];
			hp2 = hp[1];
			hp3 = hp[2];
		}
		
		if (telDecrypt.length() > 2) {
			String[] tel = telDecrypt.split("-");
			tel1 = tel[0];
			tel2 = tel[1];
			tel3 = tel[2];
		}
		
		String[] email = emailDecrypt.split("@");
		
		email1 = email[0];
		email2 = email[1];
	}
	
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<%@include file="/common/daum.addr.jsp" %>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<form name="writeform" method="post" enctype="multipart/form-data" action="<%=CommDef.ADM_PATH %>/member/memberWork.do" onsubmit="return fSubmit(this);">
	            <input name="iflag"       type="hidden" value="<%=strIFlag%>" />
	            <input name="returl"      type="hidden" value="<%=CommDef.ADM_PATH %>/member/memberList.do">
	            <input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
	            <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
	            <input name="gender" type="hidden" value="M"/>
	            <input name="user_auth" type="hidden" value="SITE"/>
	            <input name="user_di" type="hidden" value="<%=CommonUtil.nvl(dbMap.get("USER_DI")) %>"/>	
	            
				<input type="hidden" name="member_id_Check" id="member_id_Check" value="N"/>
				<input type="hidden" name="member_id_CheckVal" id="member_id_CheckVal" value=""/>
			
			<table class="__tbl-write">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<tbody>
				
	                <tr>
					    <th scope="row">회원아이디 </th>
					    <td scope="col">
					    <% if (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>
					    	<input type="text" style="width:200px" name="user_id" id="user_id" class="__form1" value="" maxlength="25"/>
					    	&nbsp;<button type="button" class="__btn2 type3" id="idCheckbtn">중복체크</button>
					    	 &nbsp;<span id="chk_id"></span>
					   	<% } else { %>
					   		<%=CommonUtil.nvl(dbMap.get("USER_ID")) %>
					   		<input type="hidden" name="user_id" value="<%=CommonUtil.nvl(dbMap.get("USER_ID")) %>"/>
 					   	<% } %>
					    </td>
					</tr>		
										
					<tr>
					    <th scope="row">이름</th>
				    	<td scope="col"><input type="text" style="width:200px" name="user_nm" id="user_nm" class="__form1" value="<%=usernmDecrypt%>" maxlength="25"/></td>
					</tr>
					
		             <tr>
					    <th scope="row">비밀번호 </th>
				        <td>
					       <input type="password" style="width:200px" name="pwd" id="pwd" class="__form1" value="" maxlength="20"/>
                        </td>
					</tr>
					
		             <tr>
					    <th scope="row">비밀번호 확인 </th>
				        <td>
					       <input type="password" style="width:200px" name="pwd2" id="pwd2" class="__form1" value="" maxlength="20"/>
                        </td>
					</tr>

					<tr>
						<th scope="row">생년월일</th>
						<td><input type="text" class="__form1" name="birthday" id="birthday" value="<%=birthDayDecrypt%>" maxlength="8" style="width:100px;"/> - 예) 19801004</td>
					</tr>
					
	                <tr>
					    <th scope="row">회원등급 </th>
				        <td>
					       <select name="user_type" id="user_type">
					           <option value="">선택하세요</option>
					           <%=sUtil.getComboBox("USERGRD", CommonUtil.nvl(dbMap.get("USER_TYPE"))) %> 
					       </select>
                        </td>
					</tr>	
					
	                <tr>
					    <th scope="row">회원레벨 </th>
				        <td>
				        	<select name="user_level" id="user_level">
				        		<% for (int i = 2; i <= 10; i++) { %>
				        			<option value="<%=i%>" <% if (CommonUtil.getNullInt(dbMap.get("USER_LEVEL") , 2) == i ) { %>selected<% } %>><%=i%></option>
				        		<% } %>
				        	</select>
				        	&nbsp; - 레벨 1은 비회원과 같은 권한 / 레벨 2부터 가입 가능합니다. / 레벨 10은 관리자 권한입니다.
                        </td>
					</tr>	
					
	                <tr>
					    <th scope="row">이메일 </th>
				        <td>
					       <input type="text" style="width:200px" name="email1" id="email1" class="__form1" value="<%=email1 %>" maxlength="50"/> @ 
					       <input type="text" style="width:200px" name="email2" id="email2" class="__form1" value="<%=email2 %>" maxlength="50"/>
					       <select name="email_select" id="email_select" class="__form1" onchange="mail_select(this.value)">
					       		<option value="">직접입력</option>
					           <%=sUtil.getSelectBox("EMAIL", email2) %>
					       </select>			
                        </td>
					</tr>							 

	                <tr>
					    <th scope="row">이메일수신여부 </th>
				        <td>
                             <input type="radio"  name="mailling_yn" value="Y" id="mailling_yn_y" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("Y".equals(CommonUtil.nvl(dbMap.get("MAILLING_YN")))) ? " checked " : "" %><% } %> /><label for="mailling_yn_y">수신</label>
			                 <input type="radio"  name="mailling_yn" value="N" id="mailling_yn_n" <%=("N".equals(CommonUtil.nvl(dbMap.get("MAILLING_YN")))) ? " checked " : "" %>/><label for="mailling_yn_n">수신하지 않음</label>					        
                        </td>
					</tr>	
					
	                <tr>
					    <th scope="row">SMS수신여부 </th>
				        <td>
                             <input type="radio"  name="sms_yn" value="Y" id="sms_yn_y" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("Y".equals(CommonUtil.nvl(dbMap.get("SMS_YN")))) ? " checked " : "" %><% } %> /><label for="sms_yn_y">수신</label>
			                 <input type="radio"  name="sms_yn" value="N" id="sms_yn_n" <%=("N".equals(CommonUtil.nvl(dbMap.get("SMS_YN")))) ? " checked " : "" %>/><label for="sms_yn_n">수신하지 않음</label>					        
                        </td>
					</tr>	
					
	                <tr>
					    <th scope="row">연락처 </th>
				        <td>
					           <input type="text" class="__form1" style="width:60px" name="tel1" id="tel1" value="<%=tel1 %>" maxlength="3"/>-
					           <input type="text" class="__form1" style="width:60px" name="tel2" id="tel2" value="<%=tel2 %>" maxlength="4"/>-
					           <input type="text" class="__form1" style="width:60px" name="tel3" id="tel3" value="<%=tel3 %>" maxlength="4"/>
                           </td>
					</tr>							 

	                <tr>
					    <th scope="row">휴대전화 </th>
				        <td>
					           <input type="text" class="__form1" style="width:60px" name="hp1" id="hp1" value="<%=hp1 %>" maxlength="3"/>-
					           <input type="text" class="__form1" style="width:60px" name="hp2" id="hp2" value="<%=hp2 %>" maxlength="4"/>-
					           <input type="text" class="__form1" style="width:60px" name="hp3" id="hp3" value="<%=hp3 %>" maxlength="4"/>
                           </td>
					</tr>	
					
					<tr>
						<th scope="row">주소</th>
						<td>
							<input type="text" class="__form1" name="zipcode" id="zipcode" style="width:80px;" maxlength="5" value="<%=CommonUtil.nvl(dbMap.get("ZIPCODE")) %>">
							&nbsp;<button type="button" class="__btn2 type4" onclick="win_zip('writeform','zipcode', 'addr1', 'addr2');">주소검색</button><br/>
							<input type="text" class="__form1" name="addr1" id="addr1" maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("ADDR1")) %>"><br/>
							<input type="text" class="__form1" name="addr2" id="addr2" maxlength="100" value="<%=CommonUtil.nvl(dbMap.get("ADDR2")) %>">
						</td>
					</tr>
					
	                <tr>
					    <th scope="row">회원여부 </th>
				        <td>
                             <input type="radio"  name="use_yn" value="Y" id="use_yn_y" <% if  (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>checked<% } else { %><%=("Y".equals(CommonUtil.nvl(dbMap.get("USE_YN")))) ? " checked " : "" %><% } %> /><label for="use_yn_y">회원</label>
			                 <input type="radio"  name="use_yn" value="N" id="use_yn_n" <%=("N".equals(CommonUtil.nvl(dbMap.get("USE_YN")))) ? " checked " : "" %>/><label for="use_yn_n">승인대기</label>	
			                 <input type="radio"  name="use_yn" value="D" id="use_yn_d" <%=("D".equals(CommonUtil.nvl(dbMap.get("USE_YN")))) ? " checked " : "" %>/><label for="use_yn_d">탈퇴회원</label>					        
                           </td>
					</tr>	
  
				</tbody>
			</table>

			<div class="__botarea">
				<div class="cen">
					<button type="submit" class="__btn2 type3">작성완료</button>
					<a class="__btn2" href="<%=CommDef.ADM_PATH %>/member/memberList.do?<%=strParam%>">취소</a>
				</div>
			</div>
			</form>
		</div>
	</div>
	
	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>

var userIdCheckUrl = "/common/idcheck.do";
var regExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
var regPhone = /^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/;
var loginidRegx = /^[a-z]+[a-z0-9]{5,19}$/;


$(document).ready(function () {

	//아이디 중복확인
	$('#idCheckbtn').bind('click', function () {

		if ($("#user_id").val().length == 0) {
			alert("아이디를 입력해주세요.");
			$("#user_id").focus();
			return false;
		}

		if ($("#user_id").val().length < 6) {
			alert("아이디는 6자이상 입력해주세요.");
			$("#user_id").focus();
			return false;
		}

		if ($("#user_id").val().indexOf(" ") != -1) {
			alert("아이디에는 공백을 넣을 수 없습니다.\n아이디를 다시 입력하시기 바랍니다.");
			$("#user_id").focus();
			return false;
		}

		if (!loginidRegx.test($("#user_id").val())) {
			alert('아이디는 영문 또는 숫자 조합만 가능합니다.');
			$("#user_id").focus();
			return false;
		}

		$.ajax({
			type : "POST",
			dataType : "json",
			url : userIdCheckUrl,
			data : {
				user_id : $("#user_id").val()
			},
			success : function(data) {
				if (data.cnt == '1') {
					alert("중복되는 아이디가 있습니다.\n다시 검색해주시기 바랍니다.");
					$('#member_id_Check').val("N");
				} else if (data.cnt == '0') {
					$('#chk_id').html('[사용하셔도 좋은 아이디입니다.]');
					$('#member_id_Check').val("Y");
					$('#member_id_CheckVal').val($("#user_id").val());
				}
			}
		});
	});	

});

function fSubmit(f) {

	<% if (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>
	
	if ($("#user_id").val().length == 0) {
		alert("아이디를 입력해주세요.");
		$("#user_id").focus();
		return false;
	}

	if ($("#user_id").val().length < 6) {
		alert("아이디는 6자이상 입력해주세요.");
		$("#user_id").focus();
		return false;
	}

	if ($("#user_id").val().indexOf(" ") != -1) {
		alert("아이디에는 공백을 넣을 수 없습니다.\n아이디를 다시 입력하시기 바랍니다.");
		$("#user_id").focus();
		return false;
	}

	if ($("#member_id_Check").val() == "N") {
		alert("아이디 중복체크를 해주세요.");
		$("#user_id").focus();
		return false;
	}

	if (webUtil.IsNull($("#pwd").val())) {
		alert("비밀번호를 입력해주세요.");
		$("#pwd").focus();
		return false;
	}

	if ($("#pwd").val().indexOf(" ") != -1) {
		alert("비밀번호에는 공백을 넣을 수 없습니다.\n비밀번호를 다시 입력하시기 바랍니다.");
		$("#pwd").focus();
		return false;
	}

	if ($("#pwd").val().length < 6) {
		alert("비밀번호는 최소 6자 이상 입력해 주세요");
		$("#pwd").focus();
		return false;
	}

	if ($("#pwd").val().length > 20) {
		alert("비밀번호는 최대 20자 이하로 입력해 주세요");
		$("#pwd").focus();
		return false;
	}

	if (!rtn_engnum_chk($("#pwd").val())) {
		alert("비밀번호는 영문,숫자 조합해야 가능합니다.");
		$("#pwd").focus();
		return false;
	}

	if ($("#pwd").val().indexOf($('#user_id').val()) > -1) {
		alert("비밀번호는 아이디를 포함할 수 없습니다.");
		$("#pwd").focus();
		return false;
	}

	if (/(\w)\1\1/.test($("#pwd").val())) {
		alert("3자 이상의 동일한 문자 혹은 숫자로 설정은 불가합니다.");
		$("#pwd").focus();
		return false;
	}

	if ($("#pwd").val() != $("#pwd2").val()) {
		alert("비밀번호를 확인해주세요.");
		$("#pwd2").focus();
		return false;
	}
	
	<% } else { %>

		if ($("#pwd").val().length > 0) {

			if ($("#pwd").val().indexOf(" ") != -1) {
				alert("비밀번호에는 공백을 넣을 수 없습니다.\n비밀번호를 다시 입력하시기 바랍니다.");
				$("#pwd").focus();
				return false;
			}

			if ($("#pwd").val().length < 6) {
				alert("비밀번호는 최소 6자 이상 입력해 주세요");
				$("#pwd").focus();
				return false;
			}

			if ($("#pwd").val().length > 20) {
				alert("비밀번호는 최대 20자 이하로 입력해 주세요");
				$("#pwd").focus();
				return false;
			}

			if (!rtn_engnum_chk($("#pwd").val())) {
				alert("비밀번호는 영문,숫자 조합해야 가능합니다.");
				$("#pwd").focus();
				return false;
			}

			if ($("#pwd").val().indexOf($('#user_id').val()) > -1) {
				alert("비밀번호는 아이디를 포함할 수 없습니다.");
				$("#pwd").focus();
				return false;
			}

			if (/(\w)\1\1/.test($("#pwd").val())) {
				alert("3자 이상의 동일한 문자 혹은 숫자로 설정은 불가합니다.");
				$("#pwd").focus();
				return false;
			}

			if ($("#pwd").val() != $("#pwd2").val()) {
				alert("비밀번호를 확인해주세요.");
				$("#pwd").focus();
				return false;
			}

		}
	<% } %>

	if ($("#user_nm").val().length < 1) {
		alert("이름을 입력해주세요.");
		$("#user_nm").focus();
		return false;
	}


	if (webUtil.IsNull($("#user_type").val())) {
		alert("회원등급을 선택해주세요.");
		$("#user_type").focus();
		return false;
	}
	
	if (checkEngNumValue(f.tel1.value, "연락처는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.tel1.focus();
		return false;
	}

	if (checkEngNumValue(f.tel2.value, "연락처는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.tel2.focus();
		return false;
	}

	if (checkEngNumValue(f.tel3.value, "연락처는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.tel3.focus();
		return false;
	}

	if (checkEngNumValue(f.birthday.value, "생년월일은 숫자로만 입력해주세요.", 2) == "N")
	{
		f.birthday.focus();
		return false;
	}

	if ($("#email1").val().length > -1) {
		if (!regExp.test($("#email1").val() + "@" + $("#email2").val())) {
			alert("이메일 형식에 맞게 입력해주세요.");
			$("#email2").focus();
			return false;
		}
	}
	
	/*
	if (webUtil.IsNull($("#txtCaptcha").val())) {
		alert("자동 입력 방지 문자를 입력해주세요.");
		$("#txtCaptcha").focus();
		return false;
	}
	*/

	<% if (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>

	if ($('#member_id_CheckVal').val() != $('#user_id').val()) {
		$('#member_id_Check').val("N");
	}

	if ($("#member_id_Check").val() == "N") {
		alert("아이디 중복체크를 해주세요.");
		$("#user_id").focus();
		return false;
	}

	<% } %>

	return true;
}

function mail_select(val) {
	$('#email2').val(val);
}
</script>
</body>
</html>