<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	String strParam  = "page_now="      + CommonUtil.nvl( reqMap.get( "page_now"));
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

        <!-- write -->
		<form name="writeform" action="/minwonChk.do" method="post" autocomplete="off" onsubmit="return formcheck(this)">

			<input name="boardno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
			<input name="returl"      type="hidden" value="<%=CommonUtil.nvl(reqMap.get("returl"))%>">
			<input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
			<input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
			<input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
			<input name="mode" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("mode"))%>"/>
			<input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
            <fieldset class="mt30">
                <table class="table2 write w600">
                    <tbody>
                        <tr>
                            <th>????????? ??????</th>
                            <td>
                                <input type="text" name="name" id="name" class="inp" maxlength="30" style="ime-mode:inactive"/>
                            </td>
                        </tr>
                        <tr>
                            <th>?????????</th>
                            <td>
                                <input type="text" name="tel" id="tel" class="inp" maxlength="11"/>
                                <span class="tbl-sment">?????????(-) ?????? ???????????????.</span>
                            </td>
                        </tr>
                 <% if (!CommonUtil.nvl(reqMap.get("mode"),"").equals("list")) { %>
                       <tr>
                            <th>????????????</th>
                            <td>
                                <input type="password" name="pwd" id="pwd" class="inp" />
                            </td>
                        </tr>
                 <% } %>
                    </tbody>
                </table>
            </fieldset>

            <div class="btnWrap tac">
                <button type="submit" class="bbtn1">
                <% if (CommonUtil.nvl(reqMap.get("mode"),"").equals("list") || CommonUtil.nvl(reqMap.get("mode"),"").equals("pwview")) { %>
                ?????? ?????? ????????????
                <% } else if (CommonUtil.nvl(reqMap.get("mode"),"").equals("pwmodify")) { %>
					????????????
                <% } else if (CommonUtil.nvl(reqMap.get("mode"),"").equals("pwdelete")) { %>
					????????????
                <% } %>
                </button>
            </div>
        </form>

	<!-- skinlist -->
	<!-- board contents -->

				</div>

			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

<script type="text/javascript">

function formcheck(f) {

	if (f.name.value == "")
	{
		alert("????????? ??????????????????.");
		f.name.focus();
		return false;
	}

	if (f.tel.value == "")
	{
		alert("???????????? ??????????????????.");
		f.tel.focus();
		return false;
	}

	if (checkEngNumValue(f.tel.value, "???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.tel.focus();
		return false;
	}

	<% if (!CommonUtil.nvl(reqMap.get("mode"),"").equals("list")) { %>
		if (f.pwd.value == "")
		{
			alert("??????????????? ??????????????????.");
			f.pwd.focus();
			return false;
		}
	<% } %>
	return true;
}

function formcancel() {
	history.back(-1);
}
</script>
</div>
</body>
</html>
