<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*,  java.net.URLEncoder" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );

	String strParam ="page_now="       + CommonUtil.nvl( reqMap.get( "page_now"));
/* 	if (!CommonUtil.nvl( reqMap.get( "name")).equals("") && !CommonUtil.nvl( reqMap.get( "tel")).equals("")) {
		strParam += "&name="       + CommonUtil.nvl( reqMap.get( "name"));
		strParam += "&tel="       + CommonUtil.nvl( reqMap.get( "tel"));
	} */
	strParam += "&menuno="       + CommonUtil.nvl( reqMap.get( "menuno"));

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

			        <div class="sub-tit">
			            <h3>시설 예약 확인</h3>
			        </div>

				<form name="writeform"  method="post" enctype="MULTIPART/FORM-DATA" autocomplete="off" >
		            <input name="returl"      type="hidden" value="/regList.do">
		            <input name="param"	type="hidden" value="<%=CommonUtil.nvl(strParam) %>">
			        <input name="menuno"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menuno")) %>">
			        <input name="page_now"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now"))%>"/>
			        <input name="seq"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("seq")) %>">
			        <input name="mode" type="hidden" value=""/>
			        <input name="req_pwd" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("req_pwd")) %>"/>
					<input name="tel"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("tel")) %>">
					<input name="name"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("name")) %>">
					<input name="dd"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("dd")) %>">
					<input name="wcd"     type="hidden" value="<%=CommonUtil.nvl(dbMap.get("WFFCLTY_CD")) %>">

			            <fieldset class="mt30">
			                <table class="table2 write">
			                    <colgroup>
			                        <col style="width: 20%;" />
			                        <col style="width: auto;" />
			                    </colgroup>
			                    <tbody>
			                        <tr>
			                            <th>상태</th>
			                            <td>
											<span class="bbs-stat <% if (CommonUtil.nvl(dbMap.get("PROGRESS_STS")).toString().equals("0")) { %>white<% } else { %>blue<% } %>">
		                    				<%=CommonUtil.nvl(dbMap.get("REG_TEXT"))%></span>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>복지시설</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("WFFCLTY_NM"))%>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>예약자</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("RSVCTM"))%>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>연락처</th>
			                            <td>
											<%=CommonUtil.makePhoneNumber(CommonUtil.nvl(reqMap.get("tel"), "")) %>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>이메일</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("EMAIL"))%>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>장애유형</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("DISABLE_TEXT"))%>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>장애정도</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("DISABLE_DGREE_TEXT"))%>
			                            </td>
			                        </tr>

			                        <tr>
			                            <th>특이사항</th>
			                            <td>
											<%=CommonUtil.nvl(dbMap.get("NOTE")).replaceAll("\r\n", "<br/>")%>
			                            </td>
			                        </tr>
			                    </tbody>
			                </table>

			                <div class="btnWrap tac">
					            <a href="/regList.do?<%=strParam %>" class="btn2">뒤로가기</a>
								<% if (CommonUtil.nvl(dbMap.get("PROGRESS_STS")).equals("0")) { //접수 상태일때만 수정 취소 가능 %>
								<script>
									function pwdLink(strmode) {
									  vObj = document.writeform;


									  vObj.mode.value = strmode;
									  vObj.action = "/regCheck.do";

									  vObj.submit();
									}
								</script>
							            <a href="javascript:fModify();" class="btn2">수정</a>
							            <a href="javascript:pwdLink('pwdelete');" class="btn2">예약취소</a>
								<%
									}
								%>
					        </div>

			        </form>

				</div>
			</div>

		</section>

		<!-- s:footer -->
		<jsp:include page="/home/inc/footer.do"></jsp:include>
		<!-- e:footer -->

</div>
<script type="text/javascript">
function fModify()
{
	  vObj = document.writeform;
	  vObj.action = "/reservation.do";

	  vObj.submit();
}
</script>
</body>
</html>
