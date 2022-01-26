<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.util.*, java.util.*" %>
<%
	Map  reqMap    = (Map)  request.getAttribute( "reqMap" );
	Map  dbMap     = (Map)  request.getAttribute( "dbMap" );
%>

			<table class="__tbl-write">
				<colgroup>
				<col style="width:200px;" />
				<col style="width:auto;" />
				</colgroup>
				<tbody>
					<tr>
						<th >총 접속자</th>
						<td><%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("TOTALCOUNT"))) %></td>
					</tr>
					<tr>
						<th >이달의 접속자</th>
						<td><%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("MONTHCOUNT"))) %></td>
					</tr>
					<tr>
						<th >오늘 접속자</th>
						<td><%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("DAYCOUNT"))) %></td>
					</tr>
					<tr>
						<th >일 평균 접속자</th>
						<td><%=CommonUtil.getComma(CommonUtil.nvl(dbMap.get("DAYSUM"))) %></td>
					</tr>
				</tbody>
			</table>