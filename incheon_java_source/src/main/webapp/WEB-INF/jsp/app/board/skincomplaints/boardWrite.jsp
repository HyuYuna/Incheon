<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map userMap     = (Map) request.getAttribute("userMap");
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	Map  brdMgrMap = (Map)  request.getAttribute( "brdMgrMap" );
	List lstFile   = (List) request.getAttribute( "lstFile" );

	UploadUtil  upUtil = new UploadUtil(request);
	ServiceUtil sUtil = new ServiceUtil();

    String strParam  = "keykind="  + CommonUtil.nvl( reqMap.get( "keykind" ));
    strParam += "&keyword="        + URLEncoder.encode(CommonUtil.nvl( reqMap.get( "keyword" )),"UTF-8");
    strParam += "&category="       + CommonUtil.nvl( reqMap.get( "category"));
    strParam += "&page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
    strParam += "&boardno="       + CommonUtil.nvl( reqMap.get( "boardno"));
    strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));

    String strIFlag  = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);
    String noticeFlag = "N";
    String secertFlag = "Y";

    String title = "";
    String url_text = "";
    String etc_field1 = "";
    String etc_field2 = "";
    String etc_field3 = "";
    String etc_field4 = "";
    String etc_field5 = "";
    String strCtnt = "";
    int userLevel = 1; //기본 유저레벨
    String userName = ""; //기본 이름
    String pwdCheck = "";

    if (strIFlag.equals(CommDef.ReservedWord.UPDATE)) {
    	title = CommonUtil.nvl(dbMap.get("TITLE"));
    	url_text = CommonUtil.nvl(dbMap.get("URL_TEXT"));
    	etc_field1 = CommonUtil.nvl(dbMap.get("ETC_FIELD1"));
    	etc_field2 = CommonUtil.nvl(dbMap.get("ETC_FIELD2"));
    	etc_field3 = CommonUtil.nvl(dbMap.get("ETC_FIELD3"));
    	etc_field4 = CommonUtil.nvl(dbMap.get("ETC_FIELD4"));
    	etc_field5 = CommonUtil.nvl(dbMap.get("ETC_FIELD5"));
    	strCtnt = CommonUtil.nvl(dbMap.get("CONTENT"));
    } else if (strIFlag.equals(CommDef.ReservedWord.REPLY)) {
    	title = "Re : " + CommonUtil.nvl(dbMap.get("TITLE"));
    	strCtnt = CommonUtil.nvl(dbMap.get("CONTENT")) + "<br/>-----------------------------------------원문내용-----------------------------------------";
    } else {
    	strCtnt = CommonUtil.nvl(brdMgrMap.get("BRD_DESC"));
    }

  	if (userMap != null) { //로그인 유저라면
  		userName = CommonUtil.nvl(userMap.get("USER_NM"));
  		userLevel = CommonUtil.getNullInt(userMap.get("USER_LEVEL"), 1);
  	}
%>
<jsp:include page="/home/inc/header.do"></jsp:include>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_common.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/common/sb_board.css"/>
<link rel="stylesheet" type="text/css" href="<%=CommDef.APP_CONTENTS%>/board/<%=CommonUtil.nvl(brdMgrMap.get("BRD_SKIN_CD")).toLowerCase() %>/style.css"/>
<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script>
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

			<form name="writeform" action="/boardWork.do" method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" onsubmit="return formcheck(this)">
				<input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
				<input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
				<input name="category"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("category"))%>"/>

				<input name="iflag"       type="hidden" value="<%=strIFlag %>">
				<input name="boardno"   type="hidden" value="<%=CommonUtil.nvl(reqMap.get("boardno")) %>">
				<input name="returl"      type="hidden" value="/board.do">
				<input name="param"       type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
				<input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
				<input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
				<input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
				<input name="secret_yn" type="hidden" value="<%=secertFlag%>"/>
				<% if (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>
					<input name="etc_field2" type="hidden" value="001"/>
		            <fieldset>
		                <h4 class="ctit2">개인정보 수집 및 이용</h4>
		                <div class="agreement"><strong>제1조 (개인정보 수집에 대한 동의)</strong>

인천광역시는 이용자들이 회사의 개인정보취급방침 또는 이용약관의 내용에 대하여 “동의”버튼 또는 “취소”버튼을 클릭할 수 있는 절차를 마련하여, “동의”버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

<strong>제2조 (개인정보 수집항목)</strong>

온라인 문의를 통한 상담을 위해 처리하는 개인정보 항목은 아래와 같습니다.
수집항목 : 성명, 연락처

<strong>제3조 (개인정보의 이용목적)</strong>

인천광역시는 이용자의 사전 동의 없이는 이용자의 개인 정보를 공개하지 않으며, 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같이 개인정보를 수집하고 있습니다. 모든 정보는 상기 목적에 필요한 용도 이외로는 사용되지 않으며 수집 정보의 범위나 사용 목적, 용도가 변경될 시에는 반드시 사전 동의를 구할 것입니다.

- 성명
민원신고자 식별
- 연락처
민원 답변을 위한 연락 수단

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
		            </fieldset>
				<% } else { %>
					<input name="etc_field2" type="hidden" value="<%=etc_field2%>"/>
				<% } %>
		            <fieldset class="mt30">
		                <table class="table2 write">
		                    <tbody>
		                        <tr>
		                            <th>민원신고 분류</th>
		                            <td>
										<select name="category_cd" id="category_cd" style="width:250px;">
											<%=sUtil.getSelectBox(CommonUtil.nvl(brdMgrMap.get("CATE_CD")), CommonUtil.nvl(dbMap.get("CATEGORY_CD"))) %>
										</select>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>성명</th>
		                            <td>
		                                <input type="text" name="reg_name" id="reg_name" class="inp" style="ime-mode:inactive" value="<% if  (strIFlag.equals(CommDef.ReservedWord.INSERT) || strIFlag.equals(CommDef.ReservedWord.REPLY)) { %><%=userName %><% } else { %><%=CommonUtil.nvl(dbMap.get("REG_NAME")) %><% } %>" maxlength="30"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>연락처</th>
		                            <td>
		                                <input type="text" name="etc_field1" id="etc_field1" class="inp" value="<%=etc_field1%>" maxlength="11"/>
		                                <span class="tbl-sment">하이픈(-) 없이 입력하세요.</span>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>비밀번호</th>
		                            <td>
		                                <input type="password" name="reg_pwd" id="reg_pwd" class="inp" />
		                                <span class="tbl-sment">나의 민원 확인시 필요한 비밀번호입니다. (비밀번호는 최소 6자리 이상 입력해야합니다.)</span>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>비밀번호 확인</th>
		                            <td>
		                                <input type="password" name="reg_pwd1" id="reg_pwd1" class="inp" />
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>민원신고 제목</th>
		                            <td>
		                                <input type="text" name="title" id="title" maxlength="100" class="inp w100p" style="ime-mode:inactive" value="<%=title %>"/>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>민원신고 내용</th>
		                            <td>
										<textarea name="content" id=""  maxlength="65536" style="width:100%;height:200px" style="ime-mode:inactive"><%=CommonUtil.recoveryLtGt(strCtnt) %></textarea>
		                            </td>
		                        </tr>
		                    </tbody>
							<%
								//첨부파일 불러오기
			              		int nFileCnt = CommonUtil.getNullInt(brdMgrMap.get("ATTACH_FILE_CNT"), 0);
								if (nFileCnt > 0) {
							%>
							<!-- 첨부파일 -->
							<tbody class="fileWrap">
			                  	<%

			                     	if ( nFileCnt > 0 ) {
			                    		if (strIFlag.equals(CommDef.ReservedWord.REPLY)) {
			                    			out.print(upUtil.addHomeFileHtml(null, nFileCnt));
			                    	 	} else {
											out.print(upUtil.addHomeFileHtml(lstFile, nFileCnt));
			                    	 	}
							     	}
			                   	%>
							</tbody>
							<% } %>
		                </table>
		            </fieldset>

		            <div class="btnWrap tac">
		            	<% if (strIFlag.equals(CommDef.ReservedWord.UPDATE)) { %>
		            		<button type="submit" class="bbtn1">수정</button>
		            	<% } else { %>
		                	<button type="submit" class="bbtn1">민원 신고하기</button>
		                <% } %>
		            </div>
		        </form>

			<!-- board contents -->
				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
<script type="text/javascript">

function formcheck(f) {

	<% if (strIFlag.equals(CommDef.ReservedWord.INSERT)) { %>
	if (!$('input:checkbox[name=agree1]').is(':checked')) {
		alert("개인정보처리방침에 동의해주세요.");
		return false;
	}
	<% } %>

	if (f.reg_name.value == "")
	{
		alert("성명을 입력해주세요.");
		f.reg_name.focus();
		return false;
	}

	if ($("#etc_field1").val().length < 1) {
		alert("연락처를 입력해주세요.");
		$("#etc_field1").focus();
		return false;
	}

	if (checkEngNumValue(f.etc_field1.value, "연락처는 숫자로만 입력해주세요.", 2) == "N")
	{
		f.etc_field1.focus();
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

	if (f.title.value == "")
	{
		alert("민원신고 제목을 입력해주세요.");
		f.title.focus();
		return false;
	}


	if (f.content.value == '')  {
		 alert("내용을 입력하여 주십시오");
		 return false;
	}


	return true;
}

</script>
</body>
</html>
