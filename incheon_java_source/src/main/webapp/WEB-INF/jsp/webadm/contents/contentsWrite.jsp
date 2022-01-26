<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
	List lstFile   = (List) request.getAttribute( "lstFile" );
	
	List lstUseYn   = (List) request.getAttribute( "lstUseYn" );
	
	ServiceUtil sUtil = new ServiceUtil();
  
    
    Map userMap      = 	(Map)SessionUtil.getSessionAttribute(request,"ADM");

    String strMenuNo = CommonUtil.nvl( reqMap.get( "menu_no"));
    String strIFlag  = CommonUtil.nvl( reqMap.get( "iflag"));
    
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<script src="<%=CommDef.CONTENTS_PATH%>/plugin/ckeditor_4.12.1/ckeditor.js"></script> 
<body>					
					<!-- 메뉴 선택하지 않았을 때 -->
				<span class="__cont_notice">컨텐츠관리</span>
					
		         <form name="frmInput" method="post"  action="<%=CommDef.ADM_PATH %>/contents/contentsWork.do" onsubmit="return fSubmit(this);">
		            <input name="iflag"       type="hidden" value="<%=CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT) %>">
		            <input name="cts_no"      type="hidden" value="<%=CommonUtil.nvl(reqMap.get("cts_no")) %>">
		            <input name="menu_no"     type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">        
		           
						<table class="__tbl-write">
							<tbody>
				                <tr>
								    <th scope="row">제목</th>
								    <td><input type="text" style="width:700px" name="ttl" class="__form1" value="<%=CommonUtil.recoveryLtGt(CommonUtil.nvl(dbMap.get("TTL"), CommonUtil.nvl(reqMap.get("menu_ttl")))) %>" maxlength="100"/></td>
								</tr>
							
								<tr>
								    <th scope="row">URL</th>
								    <td><input type="text" style="width:700px" name="cts_url" class="__form1" value="<%=CommonUtil.nvl(dbMap.get("CTS_URL")) %>"  maxlength="250"/></td>
								</tr>
								
								<tr>
								    <th scope="row">Target</th>
								    <td>
								       <select name="url_target" class="__form1">
								           <%=sUtil.getSelectBox("URLTGT", CommonUtil.nvl(dbMap.get("URL_TARGET"))) %>
								       </select>	
			                        </td>
								</tr>
								
								<tr>  
								    <th scope="row">URL 사용여부</th>
								    <td><%=sUtil.getRadioBox(lstUseYn,"url_use_yn", CommonUtil.nvl(dbMap.get("URL_USE_YN"), "N")) %>
								    </td>
								</tr>
									
				                <tr>  
								    <th scope="row">사용여부</th>
								    <td><%=sUtil.getRadioBox(lstUseYn,"use_yn", CommonUtil.nvl(dbMap.get("USE_YN"), "N")) %>
								    </td>
								</tr>
									
			                   <tr>
							      <th scope="row">내용</th>
							      <td>
							      	<textarea id="ctnt" name="ctnt" maxlength="65536" style="width:100%;height:200px" class='ckeditor'><%=(strIFlag.equals(CommDef.ReservedWord.UPDATE) ? CommonUtil.recoveryLtGt((String)dbMap.get("CTNT")) : "") %></textarea> 
			                      </td>
							   </tr> 	
								
							</tbody>
						</table>
						
						<div class="__botarea">
							<div class="cen">
								<button type="submit" class="__btn2 type3">저장</button>
								<button type="button" class="__btn2 type1" onclick="javascript:window.close();">닫기</button>
							</div>
						</div>
					</form>

<script>

function fSubmit(f)
{

		if (f.ttl.value == "")
		{
			alert("제목을 입력해주세요.");
			f.ttl.focus();
			return false;
		}

	   if (CKEDITOR.instances.ctnt.getData() == '')  {
		   alert("내용을 입력하여 주십시오");
		   return false;
	   }
	   
}
   
</script>

</body>
</html>