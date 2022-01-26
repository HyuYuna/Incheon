<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map reqMap = (Map) request.getAttribute("reqMap");
    List rsList = (List) request.getAttribute("rsList"); 
 
    out.clear();
%><?xml version="1.0" encoding="utf-8"?> 
    <root>
<% 
        out.println(CommonUtil.getListTransXml(rsList,     "list" ));
%></root>