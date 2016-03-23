<%@page import="java.util.*"%>
<jsp:useBean id="commonBean" scope="session" class="ru.flooring_nn.beans.CommonBean"/>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
HashMap <String, String> pars = new HashMap<String,String>(); 
//request.setCharacterEncoding("UTF-8");
for(Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
	String name = (String) params.nextElement();
	if(!"_".equals(name)) {
		pars.put(name, request.getParameter(name)); 
//				new String(request.getParameter(name).getBytes("ISO-8859-1"),"UTF-8"));
//		out.println(name+"= "+pars.get(name)+"\r\n");
	}
	commonBean.setPars(pars);
}
commonBean.setLevel(); 
commonBean.setPage();
int level = commonBean.getLevel();
int page_ = commonBean.getPage();
String id_parent = commonBean.getPars().get("id");
String [] names = {"SECTION", "FIRMA", "COLLECTION", "DECOR","DECOR"};
String className = "ru.flooring_nn.sql.SQLsFlooring_nn";
String methodName = "getRequests";
//Vector<HashMap<String, String>> catalog = commonBean.getResult();
HashMap<String, List<HashMap<String, String>>> result = commonBean.getResult(className, methodName);
List<HashMap<String, String>> catalog = result.get("Request_0");
List<HashMap<String, String>> catalog_pred = result.get("Request_1");
HashMap <String, String> rows = (HashMap <String, String>) catalog.get(catalog.size()-1);
int countRows = Integer.parseInt(rows.get("ROWS"));
int pages = (int) Math.ceil(countRows / (commonBean.getPageSize()*1.0));
catalog.remove(catalog.get(catalog.size()-1));
if(level > 0) {
String id_cat_parent = names[level-1]+id_parent;
if(level>=2) {
List<HashMap<String, String>> catalog_left_pred = result.get("Request_2");
catalog_left_pred.remove(catalog_left_pred.get(catalog_left_pred.size()-1));
%>
<script type="text/javascript">
<%for(HashMap<String,String> row : catalog_left_pred) {
	String section = row.get("FIRMA");
	String str_id = row.get("ID");
	String id = row.get("ID_SEC");
%>
var str_id = '<%=str_id%>';
var id = '<%=id%>';
var section = '<%=section%>';
var ahref = '<a href="level0.jsp?id='+str_id+'&amp;level=2" style="font-size : 12px;">';
if($("#catalog #SECTION"+id+" ul").length==0) {
	$("#catalog #SECTION"+id).append("<ul></ul>");
}
$("#catalog #SECTION"+id+" ul").append("<li style='margin-left: -25px;list-style-type: disc;' id='FIRMA"+str_id+"''>"+ahref+section+"</a></li>");

<%}%>
</script>
<%}%>
<script type="text/javascript">
var id_cat = '<%=id_cat_parent%>';
//$("#"+id_cat).parent().parent().find("a").css("font-weight","normal");
//alert("#"+id_cat+"\r\n"+$("#"+id_cat).parent().parent().html());
$("#"+id_cat).parent().parent().find("a").removeAttr("class");
$("#"+id_cat).children().attr("class","ovalBorder5");
//$("#"+id_cat).children().css("font-weight","bold");
//var parent = $("#"+id_cat).text();
//alert($("#"+id_cat).parent().html());
//$("#catalogArea caption h3").append("/<a href='#'>"+parent+"</a>");
<%if(level<3) {%>
$("#"+id_cat).parent().find("ul").remove();
$("#"+id_cat).html($("#"+id_cat).html()+"<ul>");
<%}%>
</script>
<%} else {%>
<script type="text/javascript">
$("#catalog").find("ul").remove();
$("#catalog").find("a").removeAttr("class");
</script>
<%} %>
<div id="catalogArea">
			 		<table>
				 		<caption>
				 			<h3>
<%
if(catalog_pred!=null) {
String [] sect = {catalog_pred.get(0).get(names[0]), catalog_pred.get(0).get("ID_"+names[0])};
String [] firm = {catalog_pred.get(0).get(names[1]), catalog_pred.get(0).get("ID_"+names[1])};
String [] coll = {catalog_pred.get(0).get(names[2]), catalog_pred.get(0).get("ID_"+names[2])};
String [] dec = {catalog_pred.get(0).get(names[3]), catalog_pred.get(0).get("ID_"+names[3])};
if(level==2) {%>
<script type="text/javascript">
setLeftCatalog('<%=names[0]%>',<%=sect[1]%>, <%=firm[1]%>, <%=level%>)
</script>
<%}%>
								<nobr>				 			
					 				<a href="" onclick="loadCatalog(0, 0);">Каталог товаров</a>
					 				<span>
						 				<%	if(sect != null && sect[0]!=null) {%>
						 				/<a href="" onclick="loadCatalog(<%=sect[1]%>, 1);"><%=sect[0] %></a>
						 				<%} 
						 					if(firm!=null && firm[0] != null) {%>
						 				/<a href="" onclick="loadCatalog(<%=firm[1]%>, 2);"><%=firm[0] %></a>
						 				<%} 
						 					if(coll!=null && coll[0] != null) {%>
						 				/<a href="" onclick="loadCatalog(<%=coll[1]%>, 3);"><%=coll[0] %></a>
						 				<%} 
						 					if(dec !=null && dec[0] != null) {%>
						 				/<a href="" onclick="loadCatalog(<%=dec[1]%>, 4);"><%=dec[0] %></a>
						 				<%} %>
					 				</span>
				 				</nobr>
<%} else if("poisk".equals(pars.get("id"))) {
	String tov = commonBean.getNormPrefix(countRows, "товар");
%>

					 				Результат поиска:
					 				<%if(countRows==0) {%>
					 				Ничего не найдено
					 				<%} else { %> 
					 				<%=countRows %> <%=tov %>
<%									}
  } else {%>
					 				<a href="" onclick="loadCatalog(0, 0);">Каталог товаров</a>
<%} %>
				 			</h3>
				 		</caption>
						<%	if(level <4) {
								int colsCatalog = 4; //количество столбцов каталоге
								int percentWidth = 100/colsCatalog;
//								for(Enumeration elements = catalog.elements();elements.hasMoreElements();) {
								for(int k=0; k<catalog.size(); k+=4) {
//								for(HashMap<String, String> row : catalog) {
								%>
									<tr>
							<% 		for(int i=0; i<colsCatalog; i++) {		
//								for(int i=0; i<colsCatalog && elements.hasMoreElements(); i++) {
//										HashMap <String, String> row = ((HashMap<String, String>) elements.nextElement());
										HashMap <String, String> row = catalog.get(i+k);
										String nameColumn = names[level];
										String section = row.get(nameColumn);
										String picture = row.get("PICTURE");
										String id = row.get("ID");%>
										<td style='width : <%=percentWidth%>%'>
					 					<a href="level0.jsp?id=<%=id%>&amp;level=<%=level+1%>">
					 						<div>
					 							<img alt="<%=section%>" title="<%=section%>" src="<%=picture%>">
					 							<br/><%=section%>
					 						</div>
					 					</a>
					 					</td>
	<%if(level>0 && level<3) {%>
	<script type="text/javascript">
	<%String id_cat = names[level]+id;%>
	var id = "<%=id_cat%>";
	var section = '<%=section%>';
	//var countRows = <%=countRows%>;
	var ahref = '<a href="level0.jsp?id=<%=id%>&amp;level=<%=level+1%>" style="font-size : <%=13-level%>px;">';
	$("#"+id_cat+" ul").append("<li style='margin-left: -25px;list-style-type: disc;' id="+id+">"+ahref+section+" </a></li>");
	</script>
	<%} 
 
										if(catalog.indexOf(row) == (catalog.size()-1)) {
					 						for(int j=i+1; j<colsCatalog; j++) {%>
										<td style='width : <%=percentWidth%>%'>
					 						<div>
					 							&nbsp;
					 						</div>
					 					</td>
					 							
					 						<%}
					 						break; 
					 					} 
										row = catalog.get(catalog.indexOf(row)+1);
									}%>
									</tr>
									
						<%		

								}
							} else {
								//for(Enumeration elements = catalog.elements();elements.hasMoreElements();) {
									//HashMap <String, String> row = ((HashMap<String, String>) elements.nextElement());
								for(HashMap<String, String> row : catalog) {
									String nameColumn = names[level];
									String section = row.get(nameColumn);
									String picture = row.get("PICTURE");
									String price = row.get("PRICE");
									String id = row.get("ID");%>
								<tr>
									<td style='vertical-align: top;width : 50%'>
										<div>
					 						<img alt="<%=section%>" width="400px" height="280px" title="<%=section%>" src="<%=picture%>">
					 					</div>
										
									</td>
									<td style='vertical-align: top;width : 50%'>
										<table>
											<tr>
												<td>
													<div id='product'>
								 						<%=section%>
						 							</div>
						 						</td>
						 					</tr>
											<tr>
												<td>
													<%if("-1".equals(price)) { %>
														на заказ
													<%} else { %>
													<nobr>цена (м²):
													<span id='product'>
								 						<%=price%> руб.
						 							</span></nobr><br/>в наличии
							 						<%} %>
						 						</td>
						 					</tr>
											<tr>
												<td style="width: 30%;border : double;">
														<div onclick='addToBasket();' id='addBasketButton' idProduct='<%=id%>' price='<%=price%>' width='35%'>
															<img alt="добавить товар в корзину" src="images/basket_.png" width='35%'>
														</div>
						 						</td>
						 					</tr>
										</table>
									</td>
								</tr>
						<%		}
							}%>				 		
				 		</table>
			 			<br/>
			 			<% if(level<4 && pages > 1) {%>
			 				<div id="pages">
			 			<%	for(int i = 1; i<=pages; i++) {
			 					if(i!=page_) {
			 						String id = pars.get("id");
			 						if("poisk".equals(id)) {%>
			 				&nbsp;<a href="" onclick="loadCatalog('<%=id%>',3,<%=i%>);"><%=i%></a>&nbsp;
			 						<%} else { %>
			 				&nbsp;<a href="" onclick="loadCatalog(<%=id_parent%>, <%=level%>, <%=i%>);"><%=i%></a>&nbsp;
			 			<%			}
			 					} else {%>
			 						<span>&nbsp;<%=i%>&nbsp;</span>
			 			<%		}
			 				}%>
			 				</div>
				 			<br/>
				 			<br/>
			 			<%}%>
				 	</div>
