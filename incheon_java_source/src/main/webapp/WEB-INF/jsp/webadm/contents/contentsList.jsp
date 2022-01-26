<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
  	List lstRs     = (List) request.getAttribute( "list" );

  	String strTreeMenu = (String) request.getAttribute("treeMenu");   
%>

<jsp:include page="/webadm/inc/header.do"  flush="false"/>

 	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery.js" type="text/javascript"></script>
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery-ui.custom.js" type="text/javascript"></script>
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery.cookie.js" type="text/javascript"></script>
	<link href="<%=CommDef.APP_CONTENTS%>/js/tree/skin/ui.dynatree.css" rel="stylesheet" type="text/css" id="skinSheet">
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery.dynatree.js" type="text/javascript"></script>
	
<body>
<div id="wrap">
	<jsp:include page="/webadm/inc/top.do"  flush="false"/>

	<div id="contain">
	
		<jsp:include page="/webadm/inc/nav.do"  flush="false"/>
	
		<jsp:include page="/webadm/inc/tit.do"  flush="false"/>

		<div id="content">

			<div style="text-align:right;">
				<button type="button" class="__btn1 type3" onclick="javascript:fWrite();">컨텐츠 등록</button>
				<button type="button" class="__btn1 type2" onclick="javascript:fHistory();">이력보기</button>
			</div>
			<br/>
			
			※  2개이상은 <font color="blue">사용[Y]</font>으로 하시면 <font color="red"><strong>사용자 화면에 텝 형식</strong></font>으로 표현이 됩니다.
			<table>
                 <colgroup>
                    <col width="20%"/>
                    <col width="*"/>
                 </colgroup>
			   <tr>
			      <td  valign="top" style="height:400px;">
	                 <span id="tree">
					    <ul>
		                 <%=strTreeMenu %>
		                </ul>	   
		             </span> 
			      </td>
			    </tr>
			  </table>
			  <br/>
			      
						<!-- Table (TABLE) -->
						<table class="__tbl-list __tbl-respond">
							<caption>TABLE</caption>
							<colgroup>
								<col>
							</colgroup>
							<thead>
							<tr>
			                  	<th scope="col">번호</th>
			                    <th scope="col">제목</th>
			                    <th scope="col">사용</th>
			                    <th scope="col">등록일</th>                      
			                    <th scope="col">관리</th>   
							</tr>
			                </thead>
			                <tbody id="tbodyData" >
			 
			<% 
			    if(lstRs != null && lstRs.size() > 0){
			    	
			       for( int iLoop = 0; iLoop < lstRs.size(); iLoop++ ) {
			            Map rsMap = ( Map ) lstRs.get( iLoop );
			    
			%>     
                          <tr>
                          	<td >
                          	    <% if ("Y".equals(CommonUtil.nvl(rsMap.get("USE_YN")))){ %>
                          	       <b>사용</b>
                          	    <%} else { %>
                          	       <%=iLoop + 1%>
                          	    <% } %>   
                          	</td>
                              <td class="textLeft"><%=CommonUtil.recoveryLtGt(CommonUtil.nvl(rsMap.get("TTL"))) %></td>
                              <td ><%=CommonUtil.getYNusetext((String)rsMap.get("USE_YN"))%></td>
                              <td ><%=CommonUtil.getDateFormat(rsMap.get("REG_DT"), "-") %></td>                                                                
                              <td ><a href="javascript:fPrev('<%=CommonUtil.nvl(rsMap.get("MENU_NO"))%>','<%=CommonUtil.nvl(rsMap.get("CTS_NO"))%>')">[보기]</a>
                                   <a href="javascript:fModify('<%=CommonUtil.nvl(rsMap.get("CTS_NO"))%>')">[수정]</a>
                                   <a href="javascript:fDelete('<%=CommonUtil.nvl(rsMap.get("CTS_NO"))%>')">[삭제]</a></td>
                          </tr>
			<%      
			       }
			    } else {
			%>              			 		
			          <tr >
			            <td align="center" colspan="5"><%=CommDef.Message.NO_DATA %></td>
			          </tr>       
			<%  } %> 
			                </tbody>
						</table>

		</div>
	</div>

	<jsp:include page="/webadm/inc/foot.do"  flush="false"/>
	
</div>
<script type="text/javascript">
  
  var gMenuPrefix   = "menu_id_";
  var gDataTrPreFix = "dataTr_";

  
  $(function(){
  	
    $("#tree").dynatree({
      fx: { height: "toggle", duration: 200 },
      autoCollapse: false,
      onActivate: function(node) {
        //$("#echoActive").text(node.data.title);
        
        vMenuId = (node.data.key).replace(/menu_id_/g,'');
        
        fSearch(vMenuId, node.data.title);
      },
      onDeactivate: function(node) {
        // $("#echoActive").text("-");
      }
    });
    
    $("#cbAutoCollapse")
    .attr("checked", true) // set state, to prevent caching
    .click(function(){
      var f = $(this).attr("checked");
      $("#tree").dynatree("option", "autoCollapse", f);
    });
        
    $("#cbEffects")
    .attr("checked", true) // set state, to prevent caching
    .click(function(){
      var f = $(this).attr("checked");
      if(f){
        $("#tree").dynatree("option", "fx", { height: "toggle", duration: 200 });
      }else{
        $("#tree").dynatree("option", "fx", null);
      }
    });
    
    $("#skinCombo")
    .val(0) // set state to prevent caching
    .change(function(){
      var href = "../src/"
        + $(this).val()
        + "/ui.dynatree.css"
        + "?reload=" + new Date().getTime();
      $("#skinSheet").attr("href", href);
    });
    
  });
  
  
	  var gMenuNo  = "";
	  var gMenuTtl = "";

	  function fWrite()
	  {
	  	  if ( gMenuNo == "") {
	  		  alert("메뉴를 먼저 선택하세요");
	  		  return;
	  	  } 
	  	   
	  	  var d = new Date();
	  	  vUrl = "<%=CommDef.ADM_PATH%>/contents/contentsWrite.do?menu_no=" + gMenuNo + "&menu_ttl=" + encodeURIComponent(gMenuTtl) + "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();
	  	  popupWin(vUrl, "contentsWrite", "900", "700", " resizable=no, scrollbar=no ");
	  }   
	  
	  function fModify(strCtsNo)
	  {
	  	  var d = new Date();
	  	  vUrl = "<%=CommDef.ADM_PATH%>/contents/contentsWrite.do?menu_no=" + gMenuNo + "&menu_ttl=" + encodeURIComponent(gMenuTtl) + "&cts_no=" + strCtsNo +  "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();
	  	  popupWin(vUrl, "contentsWrite", "900", "700", " resizable=no, scrollbar=no ");
	  }

  	function fHistory()
  	{
  		  if ( gMenuNo == "") {
  			  alert("메뉴를 먼저 선택하세요");
  			  return;
  		  } 
  		  var d = new Date();
  		  vUrl = "<%=CommDef.ADM_PATH%>/contents/contentsHistList.do?menu_no=" + gMenuNo + "&menu_ttl=" + encodeURIComponent(gMenuTtl)+  "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();
  		  popupWin(vUrl, "contentsHistList", "970", "700", " scrollbars=1,resizable=0 ");
  	}  

  	function  fPrev(vMenuNo, vCtsNo) {
  		var d = new Date();  
  		vUrl = "<%=CommDef.ADM_PATH%>/contents/contentsPreview.do?menuno=" + vMenuNo + "&cts_no=" + vCtsNo +"&menu_gb=<%=CommonUtil.nvl(reqMap.get("menu_gb"))%>"+  "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();
  		  popupWin(vUrl, "contentsPreview", "1100", "850", " scrollbars=1,resizable=0 ");
  	}

  	/*------------------- 자료 삭제 시작 ---------------------*/
    var vDelCtsNo = "";
    
    function fDelete(strCtsNo) {
		
		if ( !confirm("자료를 삭제하시겠습니까?"))
			return;
		
		vDelCtsNo = strCtsNo;
		
		var d = new Date();
		var vUrl = "<%=CommDef.ADM_PATH%>/contents/contensAjexDelete.do?cts_no=" + strCtsNo +  "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();
		
		  $.ajax({
			    type: "GET",
			    url: vUrl,
			    dataType: "text",
			    success: fSuccessDelete,
			    error: fErrorDelete
			  });	
    }
  
    function fSuccessDelete(strProc) {
        if ( strProc.indexOf("SUCCESS") >= 0 ) {
        	//$("#datarow_" + vDelCtsNo).remove();
   	
        	fSearch(gMenuNo, gMenuTtl);
        } else {
        	alert("오류가 발생하여 삭제를 하지 못하였습니다.");
        }
         
    }  
   
	function fErrorDelete()
	{
		alert("삭제 과정에서 오류가 발생하였습니다.");
	}    
    
	/*------------------- 자료 삭제 종료 ---------------------*/    	
	
	/*------------------- 하위 메뉴를 조회한 후 목록에 데이터를 표시 시작 ---------------------*/
  
   function fReload() { // 글을 저장 후 팝업에서 호출한다.
	   fSearch(gMenuNo, gMenuTtl);
	}
	
   function fSearch(vMenuNo, vTitle) {
	    gMenuNo  = vMenuNo;
	    gMenuTtl = vTitle;
		 
	    var d = new Date();
	    var vUrl = "<%=CommDef.ADM_PATH%>/contents/contensAjexList.do?menu_no=" + gMenuNo +  "&stime=" +d.getHours() +d.getMinutes() +d.getSeconds();

		  $.ajax({
			    type: "GET",
			    url: vUrl,
			    dataType: "xml",
			    success: fParseXml,
			    error: fErrorMsg
			  });	
	}
	
	function fErrorMsg()
	{
		alert("목록을 조회하는 과정에서 오류가 발생을 하였습니다.");
	}
 	
	
	function fParseXml(xml)
	{
		nCnt = 0;
		
		$("#tbodyData").html("");
          
	    vHtml = $("#copyDataTr").html();	
 		
	    $(xml).find("list").each(function()
	    {
	    	//strTrClass = ((nCnt % 2) == 0 ) ? "class='bg'" : "";
	    	
	    	nCnt++;
	    	
	    	vCtsNo  = $(this).find("cts_no").text(); 
	    	vRegDt  = $(this).find("reg_dt").text().substring(0, 8); 	    	
	    	vRegDt  = vRegDt.substring(0, 4) + "-" + vRegDt.substring(4, 6) + "-" + vRegDt.substring(6);
	    	
	    	vUseYn  = $(this).find("use_yn").text(); 
	    	vTitle  = $(this).find("ttl").text(); 
	    	vMenuNo  = $(this).find("menu_no").text();
	     
	    	if ( vUseYn == "Y") {
	    		vNum = "<b>사용</b>";
	    	} else {
	    		vNum = nCnt;	
	    	}
	    	
	    	if (vUseYn == "Y") {
	    		vUseYnText = "<b>사용</b>";
	    	} else {
	    		vUseYnText = "미사용";
	    	}
	    	 	    	
	    	vChgHtml = vHtml.replace(/chg_cts_no/g,       vCtsNo);  // ID 변경
	    	//vChgHtml = vChgHtml.replace(/chg_class/g,     strTrClass  ); // Tr class
	    	
	    	vChgHtml = vChgHtml.replace(/chg_num/g,       vNum );  // 사용여부
	    	vChgHtml = vChgHtml.replace(/chg_title/g,     vTitle ); // 제목
	    	vChgHtml = vChgHtml.replace(/chg_date/g,      vRegDt );  // 등록일
	    	vChgHtml = vChgHtml.replace(/chg_useyn/g,     vUseYnText );  // 사용여부
	    	
	    	vChgHtml = vChgHtml.replace(/menu_no/g,       vMenuNo );  // 메뉴번호
	    	
	    	
	     	vChgHtml = vChgHtml.replace(/<tbody>/gi,         ''    );  
	     	vChgHtml = vChgHtml.replace(/<\/tbody>/gi,         ''    );
 	
	    	$("#tbodyData").append(vChgHtml);
	    	
	    });
	    
	    if (nCnt == 0 ) { // 데이터가 없는 경우
	    	 vChgHtml = $("#copyNodataTr").html();	
	    	 vChgHtml = vChgHtml.replace(/chg_dataTr/g,        "dataTr");  // ID 변경
	    	 
		     vChgHtml = vChgHtml.replace(/<tbody>/gi,         ''    );  
		     vChgHtml = vChgHtml.replace(/<\/tbody>/gi,         ''    );	    	 
	    	 
	    	 $("#tbodyData").html(vChgHtml);
	    }  
	}
</script>

			<table style="display:none">
                <tbody id="copyDataTr">
                     <tr id="datarow_chg_cts_no">
                       	<td chg_class>chg_num</td>
                        <td class="textLeft">chg_title</td>
                        <td >chg_useyn</td>
                        <td >chg_date</td>                                                                
                        <td >
                        		<a href="javascript:fPrev('menu_no','chg_cts_no')" class="__btn1 type1">보기</a>
                                <a href="javascript:fModify('chg_cts_no')" class="__btn1 type2">수정</a>
                                <a href="javascript:fDelete('chg_cts_no')" class="__btn1 type3">삭제</a>
                         </td>
                     </tr>
                </tbody>
                
                <tbody id="copyNodataTr">
			          <tr>
			            <td align="center" colspan="5"><%=CommDef.Message.NO_DATA %> </td>
			          </tr>   
                </tbody>                
                
			</table>
			
</body>
</html>
