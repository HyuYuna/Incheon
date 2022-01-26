<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map)request.getAttribute("reqMap");
	List popuplist = (List)request.getAttribute("popuplist");
	
	String devicetype = CommonUtil.nvl(reqMap.get("devicetype"));
%>
<script type="text/javascript">
function setCookie( name, value, expirehours ) {
	var todayDate = new Date();
	todayDate.setHours( todayDate.getHours() + expirehours );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}
function getCookie( name ){
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length ){
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ){
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
				endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
			break;
	}
	return "";
}
</script>
 <%
 	if (popuplist != null && !popuplist.isEmpty()) {
	    for (int nLoop=0; nLoop < popuplist.size(); nLoop++) {
	    	Map rsMap = (Map)popuplist.get(nLoop);
	    	
	    	int left = CommonUtil.getNullInt(rsMap.get("LEFT_SIZE"), 0);
	    	int top = CommonUtil.getNullInt(rsMap.get("TOP_SIZE"), 0);
	    	int wsize = CommonUtil.getNullInt(rsMap.get("WIDTH_SIZE"), 0);
	    	int hsize = CommonUtil.getNullInt(rsMap.get("HEIGHT_SIZE"), 0);
	    	
	    	String popupCheck = "N";
	    	
	    	if (CommonUtil.nvl(rsMap.get("SITE_TYPE")).equals("pc") && devicetype.equals("pc")) { //PC 버전
	    		popupCheck = "Y";
	    	} else if (CommonUtil.nvl(rsMap.get("SITE_TYPE")).equals("mobile") && devicetype.equals("mobile")) { //모바일 버전
	    		popupCheck = "Y";
	    	} else if (CommonUtil.nvl(rsMap.get("SITE_TYPE")).equals("all")) { //전체 버전
	    		popupCheck = "Y";
	    	}
	   
	    if (popupCheck.equals("Y")) { //팝업 버전 체크후 실행
	    	if (CommonUtil.nvl(rsMap.get("TYPE_CD")).equals("LYR")) { //팝업 레이어 체크
%>
			<script type="text/javascript">
			function closeWin<%=CommonUtil.nvl(rsMap.get("SEQ"))%>(val) {
				if(val==1){
					if ( document.sp_popup_form<%=CommonUtil.nvl(rsMap.get("SEQ"))%>.chkbox.checked ){
						setCookie( "ncookie<%=CommonUtil.nvl(rsMap.get("SEQ"))%>", "done" , 24 );
					}
				}
				document.getElementById("sp_popup<%=CommonUtil.nvl(rsMap.get("SEQ"))%>").style.display = "none";
			}
			</script>

			<div id="sp_popup<%=CommonUtil.nvl(rsMap.get("SEQ"))%>" style="position:absolute;top:<%=top%>px;left:<%=left%>px;width:<%=wsize%>px;height:<%=hsize + 40%>px;z-index:10111100;">
				<div>
					<table width="<%=wsize%>" border="0" cellpadding="0" cellspacing="0">
						<tr bgcolor="ffffff">
							<td height="<%=hsize%>" style="border:1px solid #dedede;"><%=CommonUtil.recoveryLtGt((String)rsMap.get("CONTENT")) %></td>
						</tr>
						<form name="sp_popup_form<%=CommonUtil.nvl(rsMap.get("SEQ"))%>">
						<tr>
							<td align="right" valign="middle" bgcolor="#000000">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td height="20" align="left">&nbsp;<a href="#close" onclick="javascript:closeWin<%=CommonUtil.nvl(rsMap.get("SEQ"))%>();" style="color:#ffffff">창닫기</a></td>
										<td align="right">
											<span style="color:#ffffff;">오늘창안보기</span>
											<input type="checkbox" name="chkbox" value="checkbox" onclick="javascript:closeWin<%=CommonUtil.nvl(rsMap.get("SEQ"))%>(1);" class="popupstyle" />&nbsp;
										</td>
									</tr>
								</table>
							</td>
						</tr>
						</form>
					</table>
				</div>
			</div>

			<script type="text/javascript">
			cookiedata = document.cookie;
			if ( cookiedata.indexOf("ncookie<%=CommonUtil.nvl(rsMap.get("SEQ"))%>=done") < 0 ){
				document.getElementById("sp_popup<%=CommonUtil.nvl(rsMap.get("SEQ"))%>").style.display = "block";
			} else {
				document.getElementById("sp_popup<%=CommonUtil.nvl(rsMap.get("SEQ"))%>").style.display = "none";
			}
			</script>
		<% 
			} else {
				hsize = hsize + 50;
	    %>
			<script>
				if(getCookie('popup_<%=CommonUtil.nvl(rsMap.get("SEQ"))%>' ) != 'done'){
					noticeWindow = window.open('/popupwin.do?seq=<%=CommonUtil.nvl(rsMap.get("SEQ"))%>','pop_<%=CommonUtil.nvl(rsMap.get("SEQ"))%>','width=<%=wsize%>,height=<%=hsize%>,left=<%=left%>,top=<%=top%>');
					noticeWindow.opener = self;
				}
			</script>
	    <%
	    			}
			 	}
			}
 		}
		%>