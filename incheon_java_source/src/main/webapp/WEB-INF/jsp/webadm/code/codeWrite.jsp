<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map) request.getAttribute( "reqMap" );
  	Map  dbMap     = (Map) request.getAttribute( "dbMap" );
  	
  	String strCdType     = CommonUtil.nvl(reqMap.get("cd_type"));
  	String strCommCd     = CommonUtil.nvl(reqMap.get("comm_cd")); 
  	String strIFlag      = CommonUtil.nvl(reqMap.get("iflag"), CommDef.ReservedWord.INSERT);
  	
  	if ( "".equals(strCdType) ) {
  		strCommCd = "*";
  	}
  	
  	if ( dbMap == null)
  	   dbMap = new HashMap();
%>
<jsp:include page="/webadm/inc/header.do"  flush="false"/>
<body>					
					<!-- 메뉴 선택하지 않았을 때 -->
			<span class="__cont_notice">코드관리</span>
					
               <form name="frmCode" method="post" action="<%=CommDef.ADM_PATH %>/code/codeWork.do" onsubmit="return fSubmit(this);">
                   <input name="iflag" type="hidden" value="<%=strIFlag %>">
		           <input name="menu_no" type="hidden" value="<%=CommonUtil.nvl(reqMap.get("menu_no")) %>">             
		           
						<table class="__tbl-write">
							<tbody>
								<tr>
									<th>대표코드</th>
									<td>
										<input type="text" name="cd_type" value="<%=strCdType%>"   maxlength="20" class="__form1" style="width:300px;"  <%=!"".equals(strCdType) ? " readonly" : "" %>/>
									</td>
								</tr>
								<tr>
									<th>코드</th>
									<td>
										<input type="text" class="__form1" style="width: 300px;" name="comm_cd" value="<%=strCommCd%>"   maxlength="40"  <%=!"".equals(strCommCd) ? " readonly" : "" %>/>
									</td>
								</tr>
								<tr>
									<th>코드명</th>
									<td>
										<input type="text" class="__form1" style="width: 300px;" name="cd_nm" value="<%=CommonUtil.nvl(dbMap.get("CD_NM"))%>"   maxlength="100" />
									</td>
								</tr>
								<tr>
									<th>비고</th>
									<td>
										<textarea rows="5" cols="45" name="cd_desc"><%=CommonUtil.nvl(dbMap.get("CD_DESC")) %></textarea>
									</td>
								</tr>	
								<tr>
									<th>순서</th>
									<td>
										<input type="text" class="__form1"  name="ord"  value="<%=CommonUtil.nvl(dbMap.get("ORD")) %>"   maxlength="3"  style="width:50px;" style="IME-MODE:disabled;"  />
									</td>
								</tr>
							</tbody>
						</table>
						
						<div class="__botarea">
							<div class="cen">
								<button type="submit" class="__btn2 type3">저장</button>
								<% if ("UPDATE".equals(strIFlag)) { %>       
								<button type="button" class="__btn2 type2" onclick="javascript:fDelete();">삭제</button>
								<% } %>
								<button type="button" class="__btn2 type1" onclick="javascript:window.close();">닫기</button>
							</div>
						</div>
					</form>

<script>

   function fSubmit(f)
   {
		if (f.cd_type.value == "")
		{
			alert("대표코드를 입력해주세요.");
			f.cd_type.focus();
			return false;
		}

		if (f.comm_cd.value == "")
		{
			alert("코드를 입력해주세요.");
			f.comm_cd.focus();
			return false;
		}

		if (f.cd_nm.value == "")
		{
			alert("코드명를 입력해주세요.");
			f.cd_nm.focus();
			return false;
		}
		
		if (checkEngNumValue(f.ord.value, "순서는 숫자만 입력할수 있습니다.", 2) == "N")
		{
			f.ord.focus();
			return false;
		}
		
	   
	   f.iflag.value = "<%=strIFlag%>";
	   return true;
   }
   
	function fDelete()
	{
	   vObj = document.frmCode;
	   
	   strMsg = "자료를 삭제하시겠습니까?";
	   if ( vObj.comm_cd.value =='*') {
		   strMsg = "하위코드가 존재하는 경우 모두 삭제됩니다.\n\n자료를 삭제하시겠습니까?"; 
	   }
	   
	   if ( !confirm(strMsg))
	      return;
	  
	   vObj.iflag.value = "DELETE";
	   vObj.submit();	
	}   
   
</script>

</body>
</html>