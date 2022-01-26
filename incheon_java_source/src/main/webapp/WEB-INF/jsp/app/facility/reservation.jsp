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
                        <h4 class="ctit2">개인정보 수집 및 이용</h4>
                        <div class="agreement"><strong>제1조 (개인정보 수집에 대한 동의)</strong>

인천광역시는 이용자들이 회사의 개인정보취급방침 또는 이용약관의 내용에 대하여 “동의”버튼 또는 “취소”버튼을 클릭할 수 있는 절차를 마련하여, “동의”버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

<strong>제2조 (개인정보 수집항목)</strong>

온라인 문의를 통한 상담을 위해 처리하는 개인정보 항목은 아래와 같습니다.
수집항목 : 성명, 연락처, 이메일, 장애유형, 장애정도, 특이사항

<strong>제3조 (개인정보의 이용목적)</strong>

인천광역시는 이용자의 사전 동의 없이는 이용자의 개인 정보를 공개하지 않으며, 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같이 개인정보를 수집하고 있습니다. 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지 않으며 수집 정보의 범위나 사용 목적, 용도가 변경될 시에는 반드시 사전 동의를 구할 것입니다.

- 성명
민원신고자 식별
- 연락처, 이메일
민원 답변을 위한 연락 수단
- 시설 이용 예약을 위한 정보
장애유형, 장애정도, 특이사항

이용자는 개인정보의 수집/이용에 대한 동의를 거부할 수 있습니다. 다만, 동의를 거부하는 경우 온라인 문의를 통한 상담은 불가하며 서비스 이용 및 혜택 제공에 제한을 받을 수 있습니다.

<strong>제4조 (개인정보의 보유 및 이용기간)</strong>

원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 그리고 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법렵의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.
계약 또는 청약철회 등에 관한 기록 : 5년(전자상거래등에서의 소비자보호에 관한 법률)
소비자의 불만 또는 분쟁처리에 관한 기록 : 3년(전자상거래등에서의 소비자 보호에 관한 법률)
시용정보의 수집/처리 및 이용 등에 관한 기록 : 3년(신용정보의 이용 및 보호에 관한 법률)
인천광역시는 귀중한 이용자의 개인정보를 안전하게 처리하며, 유출의 방지를 위하여 다음과 같은 방법을 통하여 개인정보를 파기합니다.
종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.
전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.
                    </div>
                        <label class="agree-chk"><input type="checkbox" name="agree1" id="agree1" value="Y"/> 개인정보 수집 및 이용에 동의합니다.</label>
                        <span>※ 현재 <%=awitCount %>명이 에약 대기중입니다.</span>
                    </fieldset>


			            <fieldset class="mt30">
			                <table class="table2 write">
			                    <colgroup>
			                        <col style="width: 20%;" />
			                        <col style="width: auto;" />
			                    </colgroup>
			                    <tbody>
			                        <tr>
			                            <th>예약자</th>
			                            <td>
			                                <input type="text" name="rsvctm" id="rsvctm" class="inp" value="<%=CommonUtil.nvl(dbMap.get("RSVCTM")) %>" style="ime-mode:inactive"/>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>연락처</th>
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
			                            <th>이메일</th>
			                            <td>
			                                <input type="text" name="email1" id="email1" class="inp" value="<%=email1%>" style="ime-mode:active"/>
			                                @
			                                <input type="text" name="email2" id="email2" class="inp" value="<%=email2%>" style="ime-mode:active"/>
											<select name="email_select" id="email_select" onchange="mail_select(this.value)" style="width: 150px;">
												<option value="">직접입력</option>
												<%=sUtil.getSelectBox("EMAIL", email2) %>
											</select>

			                            </td>
			                        </tr>
			                        <tr>
			                            <th>장애유형</th>
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
			                            <th>장애정도</th>
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
			                            <th>비밀번호</th>
			                            <td>
			                                <input type="password" name="reg_pwd" id="reg_pwd" class="inp" />
			                                <span class="tbl-sment">나의 이용예약 확인시 필요한 비밀번호입니다. (비밀번호는 최소 6자리 이상 입력해야합니다.)</span>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>비밀번호 확인</th>
			                            <td>
			                                <input type="password" name="reg_pwd1" id="reg_pwd1" class="inp" />
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>특이사항</th>
			                            <td>
			                                <textarea name="note" id="note" style="ime-mode:inactive"><%=CommonUtil.nvl(dbMap.get("NOTE")) %></textarea>
			                            </td>
			                        </tr>
			                    </tbody>
			                </table>

			                <div class="btnWrap tac">
			                    <button type="submit" class="bbtn1">
			                    <% if (!CommonUtil.nvl(reqMap.get("seq"), "").equals("")) { %>
			                    	수정하기
			                    <% } else {  %>
			                    	예약하기
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
		alert("개인정보처리방침에 동의해주세요.");
		return false;
	}

	if (f.rsvctm.value == "")
	{
		alert("예약자를 입력해주세요.");
		f.rsvctm.focus();
		return false;
	}

	if (f.tel1.value == "")
	{
		alert("연락처를 입력해주세요.");
		f.tel1.focus();
		return false;
	}

	if (f.tel2.value == "")
	{
		alert("연락처를 입력해주세요.");
		f.tel2.focus();
		return false;
	}

	if (f.tel3.value == "")
	{
		alert("연락처를 입력해주세요.");
		f.tel3.focus();
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

	if ($("#email1").val().length < 7) {
		if (!regExp.test($("#email1").val() + "@" + $("#email2").val())) {
			alert("이메일 형식에 맞게 입력해주세요.");
			$("#email2").focus();
			return false;
		}
	}

	if (f.disable_tp.value == "")
	{
		alert("장애유형을 선택해주세요.");
		f.disable_tp.focus();
		return false;
	}

	if (f.disable_dgree_fg.value == "")
	{
		alert("장애정도를 선택해주세요.");
		f.disable_dgree_fg.focus();
		return false;
	}

	if ($("#reg_pwd").val().length < 6) {
		alert("비밀번호는 최소 6자 이상 입력해 주세요");
		$("#reg_pwd").focus();
		return false;
	}

	if ($("#reg_pwd").val() != $("#reg_pwd1").val()) {
		alert("비밀번호를 확인해주세요.");
		$("#reg_pwd").focus();
		return false;
	}

	if (f.note.value == "")
	{
		alert("특이사항을 입력해주세요.");
		f.note.focus();
		return false;
	}

	return true;
}

</script>
</body>
</html>
