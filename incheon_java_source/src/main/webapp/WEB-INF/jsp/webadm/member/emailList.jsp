<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );
	
  	int  nRowCount = CommonUtil.getNullInt( (String )request.getAttribute( "count" ), 0);

 	String strLinkPage   = CommDef.ADM_PATH + "/member/emailList.do"; // request.getRequestURL().toString(); // 현재 페이지
  	
  	String strParam      = CommonUtil.getRequestQueryString( request );
  	int    nPageNow      = CommonUtil.getNullInt(reqMap.get( "page_now" ), 1 ) ;
  	int    nPerPage      = CommonUtil.getNullInt(reqMap.get( "page_row" ), CommDef.PAGE_ROWCOUNT ) ;

	ServiceUtil sUtil = new ServiceUtil();  	
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
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite();">메일발송</button>
			</div>
			<br/>
			
			<table class="__tbl-list __tbl-respond">
				<caption>TABLE</caption>
				<colgroup>
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" id="allCheck" name="allCheck"></th>
	                  	<th scope="col"  class="__p">순번</th>
	                  	<th scope="col" class="subject">메일제목</th>
	                    <th scope="col">받는사람</th>
	                    <th scope="col">보내는사람</th>
	                    <th scope="col">등록일</th>                                                                               				    
	                    <th scope="col">보기/삭제</th>
					</tr>
				</thead>
				<tbody>
					<form name="listform" method="post">
                     <input name="txt_sdate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_sdate")) %>"/>
                     <input name="txt_edate"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("txt_edate")) %>"/>
                     <input name="keykind"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keykind")) %>"/>
                     <input name="keyword"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("keyword")) %>"/>
                     <input name="menu_gb"  type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_gb")) %>"/>		
                     <input name="param" type="hidden" value="<%=strParam %>"/>
                     <input name="returl"      type="hidden" value="<%=strLinkPage%>"/>
                     <input name="seq"   type="hidden" value=""/>
                     <input name="mode" type="hidden" value=""/>
                     <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>"/>
	                     
<% 
    if(lstRs != null && lstRs.size() > 0){
    	
       int iSeqNo = nRowCount - ( nPageNow - 1 ) * nPerPage;
       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
            Map rsMap = ( Map ) lstRs.get( iLoop );
    
%>     
                            <tr>
                     			<td>
									<input type="checkbox" name="seqno" id="seqno" value="<%=CommonUtil.nvl(rsMap.get("SEQ"))%>">
								</td>
                            	<td><%=iSeqNo%></td>
                                <td><%=CommonUtil.nvl(rsMap.get("TITLE")) %></td>
                                <td><%=CommonUtil.nvl(rsMap.get("TO_EMAIL")) %></td>
                                <td><%=CommonUtil.nvl(rsMap.get("FROM_EMAIL")) %></td>
                                <td><%=CommonUtil.getDateFormat(CommonUtil.nvl(rsMap.get("REG_DT")), "-") %></td>                                
                                <td>
                                	<a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("SEQ"))%>');" class="__btn1 type1">보기</a>
                                	<a href="javascript:;;" class="__btn1 type3" onclick="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("SEQ"))%>');">삭제</a>
                                </td>
                            </tr>
<%       iSeqNo--;
       }
    } else {
%>               
          <tr>
            <td align="center" colspan="7"><%=CommDef.Message.NO_DATA %></td>
          </tr>       
<%  } %> 
	                  
					</form>
				</tbody>
			</table>

			<div class="__botarea">
			
				<div class="lef">
					<button type="button" class="__btn2" onclick="javascript:boardCheckDel();">선택삭제</button>
				</div>
				
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
	
	  vObj.seq.value = '';
	  vObj.action = "<%=CommDef.ADM_PATH %>/member/emailWrite.do";
	  
	  vObj.submit();
}   

function fModify(strSeq)
{
	  vObj = document.listform;   
	
	  vObj.seq.value = strSeq; 
	  vObj.action = "<%=CommDef.ADM_PATH %>/member/emailWrite.do";
	  
	  vObj.submit();
}

function fDelete(strSeq)
{
	  vObj = document.listform;   
	
	  if (!confirm("삭제하시겠습니까?"))
		  return;
	  
	  vObj.mode.value = "del";
	  vObj.seq.value = strSeq; 
	  vObj.action = "<%=CommDef.ADM_PATH %>/member/emailDelete.do";
	  
	  vObj.submit();
}   

	//선택삭제
	function boardCheckDel() {
		
		vObj = document.listform;   
		
		if (!$('input:checkbox[id=seqno]').is(':checked')) {
			alert("삭제할 데이터를 체크해주세요.");
			return;
		}

		if (window.confirm("선택한 데이터를 정말로 삭제하시겠습니까?\n삭제하실 경우 모든 데이터가 사라집니다.")) {
			vObj.mode.value = "multidel";
			vObj.action = "emailDelete.do";
			vObj.submit();
		}		
	}
</script>
</body>
</html>
