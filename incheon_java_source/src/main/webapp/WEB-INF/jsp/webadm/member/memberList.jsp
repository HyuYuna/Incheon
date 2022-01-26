<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
	
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);

 	String strLinkPage   = CommDef.ADM_PATH + "/member/memberList.do"; // request.getRequestURL().toString(); // 현재 페이지
  	
  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT ) ;

	ServiceUtil sUtil = new ServiceUtil();
	Aria aria = new Aria(CommDef.MASTER_KEY);
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<jsp:include page="/webadm/inc/search.do"  flush="false"/>

			<div style="text-align:right;">
				<button type="button" class="__btn1 type2" onclick="javascript:fExcel();">엑셀 다운로드</button>
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite();">회원등록</button>
			
			</div>
			<br/>
			
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
	                  	<th scope="col"  class="__p">번호</th>
	                  	<th scope="col">회원등급</th>
	                  	<th scope="col">레벨</th>
	                    <th scope="col" class="subject">회원아이디</th>
	                    <th scope="col">회원명</th>
	                    <th scope="col">이메일</th>                    
	                    <th scope="col">가입일</th>
	                    <th scope="col">마지막로그인</th>                                                               				    
	                    <th scope="col">권한</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post">
						<input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
						<input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
						<input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
						<input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
						<input name="usertype"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("usertype"))%>"/>
						
						<input name="page_now"    type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now")) %>">
						<input name="user_id"     type="hidden" value="">
						<input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">
	                     
<% 
    if(lstRs != null && lstRs.size() > 0){
    	
       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>     
                            <tr>
                            	<td><%=iSeqNo%></td>
                                <td><%=CommonUtil.nvl(rsMap.get("USER_TYPE_NM"))%> (<%=CommonUtil.getMemberType(rsMap.get("USE_YN")) %>)</td>
                                <td><%=CommonUtil.nvl(rsMap.get("USER_LEVEL")) %></td>
                                <td><a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("USER_ID"))%>')"><%=CommonUtil.nvl(rsMap.get("USER_ID")) %></a></td>
                                <td><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("USER_NM"))) %></td>
                                <td><%=aria.Decrypt(CommonUtil.nvl(rsMap.get("EMAIL"))) %></td>
                                <td><%=CommonUtil.getDateFormat(CommonUtil.nvl(rsMap.get("REG_DT")), "-") %></td>                                
                                <td><%=CommonUtil.getDateFormat(CommonUtil.nvl(rsMap.get("LAST_LOGIN")), "-")%></td>
                                <td>
                                	<a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("USER_ID"))%>');" class="__btn1 type1">보기</a>
                                	<a href="javascript:fAuth('<%=CommonUtil.nvl(rsMap.get("USER_ID"))%>');" class="__btn1 type2">권한설정</a>
                                </td>
                            </tr>
<%       iSeqNo--;
       }
    } else {
%>               
          <tr>
            <td align="center" colspan="9"><%=CommDef.Message.NO_DATA %></td>
          </tr>       
<%  } %> 
	                  
					</form>
				</tbody>
			</table>

			<div class="__botarea">
			
				<!--  
				<div class="lef">
					<button type="button" class="__btn2" onclick="javascript:boardCheckDel();">선택삭제</button>

					<button type="button" class="__btn2" onclick="javascript:boardCheckUpdate();">일괄수정</button>
				</div>
				-->
				
				<div class="cen">
					<div class="__paging">
						<%=CommonUtil.getAdmPageNavi( strLinkPage, nRowCount ,nPageNow, strParam, CommDef.PAGE_PER_BLOCK, nPerPage ) %>
					</div>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script>
	function fExcel()
	{
		  vObj = document.listform;
		  vObj.user_id.value = "";
		  vObj.action = "<%=CommDef.ADM_PATH%>/member/memberListExcel.do";
		  vObj.submit();
	}   
	
	function fWrite()
	{
		  vObj = document.listform;   
		  vObj.user_id.value = ""; 
		  vObj.action = "<%=CommDef.ADM_PATH%>/member/memberWrite.do";
		  
		  vObj.submit();
	}
	
	function fModify(strUserId)
	{
		  vObj = document.listform;   
		  vObj.user_id.value = strUserId; 
		  vObj.action = "<%=CommDef.ADM_PATH%>/member/memberWrite.do";
		  
		  vObj.submit();
	}
	
	function fAuth(strUserId) {
		  vUrl = "<%=CommDef.ADM_PATH%>/member/memberAuth.do?user_id=" + strUserId; 
		  
		  popupWin(vUrl, 'memberAuth', 500, 640, '');	  
	}
</script>
</body>
</html>
