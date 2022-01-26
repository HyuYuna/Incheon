<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);

 	String strLinkPage   = CommDef.ADM_PATH + "/boardmgr/boardMgrList.do"; // request.getRequestURL().toString(); // 현재 페이지
  	
  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT ) ;
   
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
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite();">게시판 등록</button>
			</div>
			<br/>
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
	                  	<th scope="col" class="__p">번호</th>
	                    <th scope="col">유형</th>
	                    <th scope="col">게시판번호</th>
	                    <th scope="col" class="subject">게시판명</th>
	                    <th scope="col">사용여부</th>
	                    <th scope="col">등록일</th>                      
	                    <th scope="col">게시물건수</th> 
	                    <th scope="col">관리</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post" >
                     <input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
                     <input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
                     <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                     <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword"))%>"/>
                     <input name="param" type="hidden" value="<%=strParam %>"/>
                     
                     <input name="page_now"    type="hidden" value="<%=CommonUtil.nvl(reqMap.get("page_now")) %>"/>
                     
                     <input name="returl"      type="hidden" value="<%=strLinkPage%>"/>
                     <input name="brd_mgrno"   type="hidden" value=""/>
                     <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>

<% 
    if(lstRs != null && lstRs.size() > 0){
    	
       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>     
                            <tr>
                            	<td class="__p"><%=iSeqNo%></td>
                                <td ><%=CommonUtil.nvl(rsMap.get("CD_NM"))%></td>
                                <td ><%=CommonUtil.nvl(rsMap.get("BRD_MGRNO"))%></td>
                                <td class="subject"><a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("BRD_MGRNO"))%>')"><%=CommonUtil.nvl(rsMap.get("BRD_NM")) %></a></td>
                                <td ><%=CommonUtil.getYNusetext((String)rsMap.get("USE_YN")) %></td>
                                <td ><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"),"-") %></td>                                
                                <td ><%=CommonUtil.nvl(rsMap.get("BRD_REG_CNT")) %></td>   
                                <td >
                                     <a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("BRD_MGRNO"))%>')" class="__btn1 type2">수정</a>
                                     <a href="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("BRD_MGRNO"))%>')" class="__btn1 type3">삭제</a>
                                </td>                             
                            </tr>
<%       iSeqNo--;
       }
    } else {
%>              
          <tr>
            <td colspan="8"><%=CommDef.Message.NO_DATA %> </td>
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

   function fWrite()
   {
	  vObj = document.listform;   
	
	  vObj.brd_mgrno.value = '';
	  vObj.action = "<%=CommDef.ADM_PATH %>/boardmgr/boardMgrWrite.do";
	  
	  vObj.submit();
   }   
   function fModify(strMgrno)
   {
	  vObj = document.listform;   
	
	  vObj.brd_mgrno.value = strMgrno; 

	  vObj.action = "<%=CommDef.ADM_PATH %>/boardmgr/boardMgrWrite.do";
	  
	  vObj.submit();
   }
   
   function fDelete(strMgrno)
   {
	  vObj = document.listform;   
	
	  if (!confirm("삭제하시겠습니까?"))
		  return;
	  
	  vObj.brd_mgrno.value = strMgrno; 
	  vObj.action = "<%=CommDef.ADM_PATH %>/boardmgr/boardMgrDelete.do";
	  
	  vObj.submit();
   }   
</script>
</body>
</html>
