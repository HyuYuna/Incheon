<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
  	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
    Map  userMap   = (Map)  request.getAttribute( "userMap" );

  	List lstRs     = (List) request.getAttribute( "list" );
  	List lstMenu   = (List) request.getAttribute( "menuList" );
  	
  	String strTreeMenu = (String) request.getAttribute("treeMenu");   
  	Aria aria = new Aria(CommDef.MASTER_KEY);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" />
<title>권한설정</title>

<!--  Tree Menu Include Start -->

	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery.js" type="text/javascript"></script>
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery-ui.custom.js" type="text/javascript"></script>
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery/jquery.cookie.js" type="text/javascript"></script>
	<link href="<%=CommDef.APP_CONTENTS%>/js/tree/skin/ui.dynatree.css" rel="stylesheet" type="text/css" id="skinSheet">
	<script src="<%=CommDef.APP_CONTENTS%>/js/tree/jquery.dynatree.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/common.css"/>
	<link rel="stylesheet" type="text/css" href="<%=CommDef.ADM_CONTENTS%>/css/global.css"/>

<script type="text/javascript">

  var gMenuPrefix   = "menu_id_";
  
  $(function(){
  	
    $("#tree").dynatree({
      fx: { height: "toggle", duration: 200 },
      autoCollapse: false,
      checkbox:true, 
      selectMode:3,
      onActivate: function(node) {
        //$("#echoActive").text(node.data.title);
        
        vMenuId = (node.data.key).replace(/menu_id_/g,'');
        
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
  
  function fInit()
  {

		$("#tree").dynatree("getRoot").visit(function(node){
			//node.select(true);			
		<% if ( lstMenu != null && !lstMenu.isEmpty()) 
		   {
			  for(int nLoop=0; nLoop < lstMenu.size(); nLoop++)
			  {
				  Map rsMap = (Map)lstMenu.get(nLoop);
        %>
				if ( node.data.key  == gMenuPrefix + "<%=CommonUtil.nvl(rsMap.get("MENU_NO"))%>" ) {
					node._select(true, false, false);
				}        
        <%
			  }
		   }
		%>	
			 
		});
  }
  
</script>
</head>

<body onload="fInit()">

<div id="main">

	<span class="__cont_notice">권한설정&nbsp;[<%=userMap.get("USER_ID") %> <%=aria.Decrypt(CommonUtil.nvl(userMap.get("USER_NM"))) %>]</span>
	
    <form name="frmAuth" id="frmAuth" method="post">
       <input name="user_id" type="hidden" value="<%=reqMap.get("user_id") %>"/>
       
         <div id="content" class="box">
	            <div id="tree" style="height:480px">
			       <ul>
	                <%=strTreeMenu %>
	               </ul>	   
	            </div> 
	          </div>
		     <div align="center">
		         <ul >		             
					<button type="submit" class="__btn2 type3">권한설정</button>
					<a class="__btn2" onclick="self.close()" style="cursor:pointer;">닫기</a>
					
		         </ul>
		     </div>
		     
     </form>   
</div> <!-- /main -->

<script>

$("#frmAuth").submit(function() {
	
	// Serialize standard form fields:
	var formData = $(this).serializeArray();

	// then append Dynatree selected 'checkboxes':
	var tree = $("#tree").dynatree("getTree");
	
	formData = formData.concat(tree.serializeArray());

	// and/or add the active node as 'radio button':
	if(tree.getActiveNode()){
		formData.push({name: "activeNode", value: tree.getActiveNode().data.key});
	}
	
	$.post("<%=CommDef.ADM_PATH%>/member/memberAuthWork.do",
		    formData,
			function(response, textStatus, xhr){
				  // alert("POST returned " + response + ", " + textStatus);
			  alert("권한 설정을 완료했습니다.");
			  self.close();
			}
	);
	
	
	return false;
});
</script>
			 

</body>
</html>	