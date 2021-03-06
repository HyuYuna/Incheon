<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	ServiceUtil sUtil = new ServiceUtil();
	String returnUrl = "reservation.do";

	List codeList1 = (List)request.getAttribute("codeList1");
	List codeList2 = (List)request.getAttribute("codeList2");
	int awitCount = CommonUtil.getNullInt( (String )request.getAttribute( "awitCount" ), 0);

	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	String strParam ="page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
/* 	if (!CommonUtil.nvl( reqMap.get( "name")).equals("") && !CommonUtil.nvl( reqMap.get( "tel")).equals("")) {
		strParam += "&name="       + CommonUtil.nvl( reqMap.get( "name"));
		strParam += "&tel="       + CommonUtil.nvl( reqMap.get( "tel"));
	} */
	strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));

	String tel2 = "";
	String tel3 = "";
	String email1 = "";
	String email2 = "";

	if (CommonUtil.nvl(reqMap.get("tel"),"").length() == 11) {
		tel2 = CommonUtil.nvl(reqMap.get("tel"),"").substring(3, 7);
		tel3 = CommonUtil.nvl(reqMap.get("tel"),"").substring(7, 11);
	} else if (CommonUtil.nvl(reqMap.get("tel"),"").length() == 10) {
		tel2 = CommonUtil.nvl(reqMap.get("tel"),"").substring(3, 6);
		tel3 = CommonUtil.nvl(reqMap.get("tel"),"").substring(6, 10);
	}

	if (!CommonUtil.nvl(dbMap.get("EMAIL"),"").equals("")) {
		String[] email = CommonUtil.nvl(dbMap.get("EMAIL"),"").split("@");
		email1 = email[0];
		email2 = email[1];
	}
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
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

				<!-- facilitylnb -->
				<jsp:include page="/home/inc/lnb2.do"></jsp:include>
				<!-- facilitylnb -->

				<div id="subCont">

				<!-- subtitle -->
				<jsp:include page="/home/inc/subtitle.do"></jsp:include>
				<!-- subtitle -->

				<form name="writeform" action="/reservationWork.do" method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" onsubmit="return formcheck(this)">
					<input type="hidden" name="wcd" id="wcd" value="<%=CommonUtil.nvl(reqMap.get("wcd"))%>"/>
					<input type="hidden" name="menuno" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>"/>
					<% if (dbMap != null) { %>
			            <input name="returl"      type="hidden" value="/regList.do">
			            <input name="param"			type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
				        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
				        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
				        <input name="mode" type="hidden" value=""/>
						<input name="tel"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("tel")) %>">
						<input name="name"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("name")) %>">
						<input name="dd"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("dd")) %>">
					<% } else { %>
						<input type="hidden" name="returl" value="<%=returnUrl%>"/>
					<% } %>

                    <fieldset>
                        <h4 class="ctit2">???????????? ?????? ??? ??????</h4>
                        <div class="agreement"><strong>???1??? (???????????? ????????? ?????? ??????)</strong>

?????????????????? ??????????????? ????????? ???????????????????????? ?????? ??????????????? ????????? ????????? ?????????????????? ?????? ????????????????????? ????????? ??? ?????? ????????? ????????????, ????????????????????? ???????????? ???????????? ????????? ?????? ????????? ????????? ?????????.

<strong>???2??? (???????????? ????????????)</strong>

????????? ????????? ?????? ????????? ?????? ???????????? ???????????? ????????? ????????? ????????????.
???????????? : ??????, ?????????, ?????????, ????????????, ????????????, ????????????

<strong>???3??? (??????????????? ????????????)</strong>

?????????????????? ???????????? ?????? ?????? ????????? ???????????? ?????? ????????? ???????????? ?????????, ????????? ????????????, ?????? ???????????? ????????? ?????? ????????? ?????? ??????????????? ???????????? ????????????. ?????? ????????? ?????? ????????? ????????? ?????? ???????????? ???????????? ????????? ?????? ????????? ????????? ?????? ??????, ????????? ????????? ????????? ????????? ?????? ????????? ?????? ????????????.

- ??????
??????????????? ??????
- ?????????, ?????????
?????? ????????? ?????? ?????? ??????
- ?????? ?????? ????????? ?????? ??????
????????????, ????????????, ????????????

???????????? ??????????????? ??????/????????? ?????? ????????? ????????? ??? ????????????. ??????, ????????? ???????????? ?????? ????????? ????????? ?????? ????????? ???????????? ????????? ?????? ??? ?????? ????????? ????????? ?????? ??? ????????????.

<strong>???4??? (??????????????? ?????? ??? ????????????)</strong>

??????????????? ???????????? ?????? ??? ??????????????? ????????? ????????? ?????? ????????? ?????? ?????? ???????????????. ????????? ??????, ??????????????? ???????????? ?????????????????? ?????? ?????? ??? ??????????????? ????????? ????????? ????????? ????????? ?????? ?????? ????????? ?????????????????? ?????? ????????? ?????? ?????? ????????? ???????????????. ??? ?????? ????????? ???????????? ????????? ??? ????????? ??????????????? ???????????? ??????????????? ????????? ????????????.
?????? ?????? ???????????? ?????? ?????? ?????? : 5???(??????????????????????????? ?????????????????? ?????? ??????)
???????????? ?????? ?????? ??????????????? ?????? ?????? : 3???(??????????????????????????? ????????? ????????? ?????? ??????)
??????????????? ??????/?????? ??? ?????? ?????? ?????? ?????? : 3???(??????????????? ?????? ??? ????????? ?????? ??????)
?????????????????? ????????? ???????????? ??????????????? ???????????? ????????????, ????????? ????????? ????????? ????????? ?????? ????????? ????????? ??????????????? ???????????????.
????????? ????????? ??????????????? ???????????? ??????????????? ????????? ????????? ???????????????.
????????? ?????? ????????? ????????? ??????????????? ????????? ????????? ??? ?????? ????????? ????????? ???????????? ???????????????.
                    </div>
                        <label class="agree-chk"><input type="checkbox" name="agree1" id="agree1" value="Y"/> ???????????? ?????? ??? ????????? ???????????????.</label>
                        <span>??? ?????? <%=awitCount %>?????? ?????? ??????????????????.</span>
                    </fieldset>


			            <fieldset class="mt30">
			                <table class="table2 write">
			                    <colgroup>
			                        <col style="width: 20%;" />
			                        <col style="width: auto;" />
			                    </colgroup>
			                    <tbody>
			                        <tr>
			                            <th>?????????</th>
			                            <td>
			                                <input type="text" name="rsvctm" id="rsvctm" class="inp" value="<%=CommonUtil.nvl(dbMap.get("RSVCTM")) %>" style="ime-mode:inactive"/>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>?????????</th>
			                            <td>
			                                <select name="tel1" id="tel1"  style="width: 150px;">
			                                    <option value="010">010</option>
			                                </select>
			                                -
			                                <input type="text" name="tel2" id="tel2"  class="inp" style="width: 150px;min-width: 0;" maxlength="4" value="<%=tel2%>"/>
			                                -
			                                <input type="text" name="tel3" id="tel3"  class="inp" style="width: 150px;min-width: 0;" maxlength="4" value="<%=tel3%>"/>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>?????????</th>
			                            <td>
			                                <input type="text" name="email1" id="email1" class="inp" value="<%=email1%>" style="ime-mode:active"/>
			                                @
			                                <input type="text" name="email2" id="email2" class="inp" value="<%=email2%>" style="ime-mode:active"/>
											<select name="email_select" id="email_select" onchange="mail_select(this.value)" style="width: 150px;">
												<option value="">????????????</option>
												<%=sUtil.getSelectBox("EMAIL", email2) %>
											</select>

			                            </td>
			                        </tr>
			                        <tr>
			                            <th>????????????</th>
			                            <td>
			                                <select name="disable_tp" id="disable_tp" style="width: 150px;">
									<%
									    if(codeList1 != null && codeList1.size() > 0){

									       for( int cLoop = 0; cLoop < codeList1.size(); cLoop++ ) {
									            Map codeList1tMap = ( Map ) codeList1.get( cLoop );
									%>
										<option value="<%=CommonUtil.nvl(codeList1tMap.get("COMMCD")) %>" <% if (CommonUtil.nvl(dbMap.get("DISABLE_TP")).equals(CommonUtil.nvl(codeList1tMap.get("COMMCD")))) { %>selected<% } %>><%=CommonUtil.nvl(codeList1tMap.get("COMMCD_VALUE")) %></option>
									<% 		}
									    }
									%>
			                                </select>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>????????????</th>
			                            <td>
			                                <select name="disable_dgree_fg" id="disable_dgree_fg" style="width: 150px;">
									<%
									    if(codeList2 != null && codeList2.size() > 0){

									       for( int cLoop = 0; cLoop < codeList2.size(); cLoop++ ) {
									            Map codeList2tMap = ( Map ) codeList2.get( cLoop );
									%>
										<option value="<%=CommonUtil.nvl(codeList2tMap.get("COMMCD")) %>" <% if (CommonUtil.nvl(dbMap.get("DISABLE_DGREE_FG")).equals(CommonUtil.nvl(codeList2tMap.get("COMMCD")))) { %>selected<% } %>><%=CommonUtil.nvl(codeList2tMap.get("COMMCD_VALUE")) %></option>
									<% 		}
									    }
									%>
			                                </select>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>????????????</th>
			                            <td>
			                                <input type="password" name="reg_pwd" id="reg_pwd" class="inp" />
			                                <span class="tbl-sment">?????? ???????????? ????????? ????????? ?????????????????????. (??????????????? ?????? 6?????? ?????? ?????????????????????.)</span>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>???????????? ??????</th>
			                            <td>
			                                <input type="password" name="reg_pwd1" id="reg_pwd1" class="inp" />
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>????????????</th>
			                            <td>
			                                <textarea name="note" id="note" style="ime-mode:inactive"><%=CommonUtil.nvl(dbMap.get("NOTE")) %></textarea>
			                            </td>
			                        </tr>
			                    </tbody>
			                </table>

			                <div class="btnWrap tac">
			                    <button type="submit" class="bbtn1">
			                    <% if (!CommonUtil.nvl(reqMap.get("seq"), "").equals("")) { %>
			                    	????????????
			                    <% } else {  %>
			                    	????????????
			                    <% } %>
			                    </button>
			                </div>
			            </fieldset>
			        </form>

				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
<script type="text/javascript">

var regExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

function mail_select(val) {
	$('#email2').val(val);
}

function formcheck(f) {

	if (!$('input:checkbox[name=agree1]').is(':checked')) {
		alert("??????????????????????????? ??????????????????.");
		return false;
	}

	if (f.rsvctm.value == "")
	{
		alert("???????????? ??????????????????.");
		f.rsvctm.focus();
		return false;
	}

	if (f.tel1.value == "")
	{
		alert("???????????? ??????????????????.");
		f.tel1.focus();
		return false;
	}

	if (f.tel2.value == "")
	{
		alert("???????????? ??????????????????.");
		f.tel2.focus();
		return false;
	}

	if (f.tel3.value == "")
	{
		alert("???????????? ??????????????????.");
		f.tel3.focus();
		return false;
	}

	if (checkEngNumValue(f.tel1.value, "???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.tel1.focus();
		return false;
	}

	if (checkEngNumValue(f.tel2.value, "???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.tel2.focus();
		return false;
	}

	if (checkEngNumValue(f.tel3.value, "???????????? ???????????? ??????????????????.", 2) == "N")
	{
		f.tel3.focus();
		return false;
	}

	if ($("#email1").val().length < 7) {
		if (!regExp.test($("#email1").val() + "@" + $("#email2").val())) {
			alert("????????? ????????? ?????? ??????????????????.");
			$("#email2").focus();
			return false;
		}
	}

	if (f.disable_tp.value == "")
	{
		alert("??????????????? ??????????????????.");
		f.disable_tp.focus();
		return false;
	}

	if (f.disable_dgree_fg.value == "")
	{
		alert("??????????????? ??????????????????.");
		f.disable_dgree_fg.focus();
		return false;
	}

	if ($("#reg_pwd").val().length < 6) {
		alert("??????????????? ?????? 6??? ?????? ????????? ?????????");
		$("#reg_pwd").focus();
		return false;
	}

	if ($("#reg_pwd").val() != $("#reg_pwd1").val()) {
		alert("??????????????? ??????????????????.");
		$("#reg_pwd").focus();
		return false;
	}

	if (f.note.value == "")
	{
		alert("??????????????? ??????????????????.");
		f.note.focus();
		return false;
	}

	return true;
}

</script>
</body>
</html>
