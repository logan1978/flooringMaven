<%@page import="java.util.*"%><jsp:useBean id="commonBean" scope="session" class="ru.flooring_nn.beans.CommonBean"/>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
HashMap <String, String> pars = new HashMap<String,String>(); 
for(Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
	String name = (String) params.nextElement();
	if(!"_".equals(name)) {
		pars.put(name, request.getParameter(name));
//		out.println(name+"= "+pars.get(name)+"\r\n");
	}
	commonBean.setPars(pars);
}
commonBean.setLevel(); 
commonBean.setPage();
String idParent = pars.get("id");
int level = commonBean.getLevel();
String [] names = {"SECTION", "FIRMA", "COLLECTION", "DECOR"};
String className = "ru.flooring_nn.sql.SQLsFlooring_nn";
String methodName = "getRequests";
HashMap<String, List<HashMap<String, String>>> result = commonBean.getResult(className, methodName);
List<HashMap<String, String>> catalog = new ArrayList<HashMap<String, String>>(result.get("Request_0"));
catalog.remove(catalog.get(catalog.size()-1));
%>
			 		<ul>
						<%	//for(Enumeration elements = catalog.elements();elements.hasMoreElements();) {
							//HashMap <String, String> row = ((HashMap<String, String>) elements.nextElement());
						for(HashMap<String, String> row : catalog) {
							String section = row.get(names[level]);
							String picture = row.get("PICTURE");
							String id = row.get("ID");%>
							<li id='<%=id%>' style="cursor: pointer">
				 				<a onclick="setLeftCatalog('<%=names[level-1]%>',<%=idParent%>, <%=id%>, <%=level+1%>);$('#menu ul li').css('display','none');">
				 						<%=section%>
				 				</a>
				 			</li>
						<%	}%>				 		
				 	</ul>
