<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.CommDef" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<title><%=CommDef.CONFIG_COMPANY%> 관리자</title>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/global.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/respond.css"/>
<script src="<%=CommDef.APP_CONTENTS%>/js/jquery.min.js"></script>
<script src="<%=CommDef.APP_CONTENTS%>/js/global.js"></script>
<script src="<%=CommDef.APP_CONTENTS%>/js/web.util.js"></script>

<!--[if lt IE 9]>
<script src="<%=CommDef.APP_CONTENTS%>/js/html5.js"></script>
<![endif]-->
<script type="text/javascript">
$(document).ready(function() {
	var cookieid = "__<%=CommDef.CONFIG_COOKIE%>_admin__";
	var savedId = $.cookie(cookieid);

	if (savedId != "") {

		$("#login-con-id").val(savedId);
		$("#login-con-id").focus();
		$("#login-con-pass").focus();
		$("input:checkbox[id=chkid]").attr("checked", true);
	}

	//로그인 클릭
	$('.sbm').bind('click', function() {

		if ($("#chkid").is(":checked")) {
			$.cookie(cookieid, $("#login-con-id").val(), { expires: 365, path: '/', secure: false });
		}
		else {
			$.cookie(cookieid, null, { expires: -1, path: '/', secure: false });
		}

	});

});

function formcheck(f) {

	if (f.memberid.value == "")
	{
		alert("로그인 아이디를 입력해주세요.");
		f.memberid.focus();
		return false;
	}

	if (f.passwd.value == "")
	{
		alert("로그인 비밀번호를 입력해주세요.");
		f.passwd.focus();
		return false;
	}

	return true;
}

</script>
</head>
<body class="loginBody">
	
	
	<div id="login">
		<h1 class="loginTit">
			<img src="<%=CommDef.CONFIG_LOGO_IMG%>" alt="관리자 로그인" />
		</h1>
		<form action="<%=CommDef.ADM_PATH %>/login.proc.do" method="post" name="adminForm" onsubmit="return formcheck(this)" class="loginFrm">
			<legend>관리자 로그인 입력폼</legend>
			<fieldset>
				<h2 class="tit">
					<span>LOGIN</span>
					<em>웹사이트 운영을 위한 관리자 모드입니다.</em>
				</h2>
				<div class="inp">
					<input type="text" name="memberid" id="login-con-id" class="id" tabindex="1"/>
					<input type="password" name="passwd" id="login-con-pass" class="pw" tabindex="2"/>
					<input type="submit" value="로그인" class="sbm"  tabindex="3"/>
					<label class="chk"><input type="checkbox" name="chkid" id="chkid" /> 아이디 저장</label>
				</div>
			</fieldset>
		</form>
		<ul class="ftbtn">
			<li class="hpg"><a href="http://www.webper.co.kr" target="_blank">www.webper.co.kr</a></li>
			<li class="tel"><a href="tel:070-4323-0410">070-4323-0410</a></li>
			<li class="email"><a href="mailto:info@webmaker21.net">info@webmaker21.net</a></li>
		</ul>
		
		<footer>
			<address>
				<%=CommDef.CONFIG_COMPANY%>&nbsp;&nbsp;&nbsp;&nbsp;<br /><%=CommDef.CONFIG_ADDR1%>&nbsp;<%=CommDef.CONFIG_ADDR2%>&nbsp;&nbsp;&nbsp;&nbsp;<br />TEL: <%=CommDef.CONFIG_TEL%>&nbsp;&nbsp;&nbsp;&nbsp;<br />FAX: <%=CommDef.CONFIG_FAX%> <br />
			</address>
			<span class="copy">COPYRIGHT(C) <%=CommDef.CONFIG_YEAR%> <%=CommDef.CONFIG_COMPANY%> ALL RIGHT RESERVED.</span>
		</footer>
		
	</div>
	
	
</body>
</html>