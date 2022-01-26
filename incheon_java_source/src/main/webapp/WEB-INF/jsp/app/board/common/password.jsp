<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
	strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
	strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));	
	strParam += "&page_now="      + CommonUtil.nvl( reqMap.get( "page_now"));
	strParam += "&boardno="       + CommonUtil.nvl( reqMap.get( "boardno"));	
	strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_board.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/board/skinlist/style.css"/>
<body>
<div id="wrap">
	
	<!-- topmenu -->
	<jsp:include page="/home/inc/topmenu.do"></jsp:include>
	<!-- topmenu -->
	
		<section id="sub">
		
			<!-- subvisual -->
			<jsp:include page="/home/inc/subvisual.do"></jsp:include>
			<!-- subvisual -->
			
			<!-- navigator -->
			<%-- <jsp:include page="/home/inc/navigator.do"></jsp:include> --%>
			<!-- navigator -->
			
            <!-- start content -->
			<div id="content">

				<!-- lnb -->
				<jsp:include page="/home/inc/lnb.do"></jsp:include>
				<!-- lnb -->
				
				<div id="subCont">
				
				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->

	<!-- board contents -->
	<!-- skinlist -->	

<div id="sb-wrap">
	<div id="sb-password">
		<form name="writeform" action="/passwordChk.do" method="post" autocomplete="off" onsubmit="return formcheck(this)">

			<input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
			<input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
			<input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>
			<input name="boardno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
			<input name="returl"      type="hidden" value="<%=CommonUtil.nvl(reqMap.get("returl"))%>">
			<input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">			
			<input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
			<input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
			<input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
			<input name="mode" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("mode"))%>"/>
			<input type="hidden" name="comment_id" id="comment_id" value="<%=CommonUtil.nvl(reqMap.get("comment_id"))%>" />			
			
			<fieldset>
				<h4>비밀번호 입력</h4>
				<input type="password" name="pwd" class="inp" />
			</fieldset>
			
			<div id="sb-footer">
				<div class="center">
					<input type="submit" value="확인" class="sb-btn type1" />
					<input type="button" value="취소" class="sb-btn type2" onclick="javascript:formcancel();"/>
				</div>
			</div>

		</form>
	</div>
</div>
<script type="text/javascript">

function formcheck(f) {
	
	if (f.pwd.value == "")
	{
		alert("비밀번호를 입력해주세요.");
		f.pwd.focus();
		return false;
	}

	return true;
}

function formcancel() {
	history.back(-1);
}
</script>

	<!-- skinlist -->
	<!-- board contents -->

				</div>
				
			</div>
			
		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->
		
</div>
</body>
</html>