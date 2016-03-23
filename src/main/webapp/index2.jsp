<!DOCTYPE html>
<%@page import="java.util.*, java.util.concurrent.*,ru.flooring_nn.beans.Basket;"%>

<jsp:useBean id="commonBean" scope="session" class="ru.flooring_nn.beans.CommonBean"/>

<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<html style="background-color: #1DB4F7; background-image: none; ">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Ярмарка напольных покрытий!</title>
    <script type="text/javascript" src="js/jquery-latest.min.js"></script> 
    <script type="text/javascript" src="js/jquery.cross-slide.js"></script> 
    <script type="text/javascript">
    $(document).ready(function(){
        $('#menu ul li').hover(function(){
        	$('#menu ul li').css('display','block');
        });
        $("#poisk_text").keypress(function(e) {
        	if(e.keyCode==13) {
        		loadCatalog('poisk');
        		return false;
        	}
        });
    });
        $(function() {
          if ($.browser.msie && $.browser.version.substr(0,1)<7)
          {
			$('li').has('ul').mouseover(function(){
				$(this).children('ul').show();
				}).mouseout(function(){
				$(this).children('ul').hide();
				})
          }
        });
        
        $(function() {
        	$('#multyPics').crossSlide({
        	sleep: 2.5,

        	fade: 1
        	}, [
        	{ src: 'images/slides/sl1.jpg' },
        	{ src: 'images/slides/sl2.jpg' },
        	{ src: 'images/slides/sl3.jpg' },
        	{ src: 'images/slides/sl4.jpg' },
        	{ src: 'images/slides/sl5.jpg' }
        	]);

        	});
        
        function loadCatalog(id, level, page) {
//        	alert("ID="+id+" LEV="+level+" PAGE="+page);
        	if(id=='poisk') {
        		if(page==null) {
        			$("#poisk_text").removeAttr("P");
        		}
//        		alert($("#poisk_text").attr("P"));
        		var poisk = $("#poisk_text").val();
        		if(poisk !=null && poisk != "") {
//        			alert("1 "+$("#poisk_text").attr("P"));
        			$("#poisk_text").attr("P",poisk);
            		$("#poisk_text").val("");
        		} else {
//        			alert("2 "+$("#poisk_text").attr("P"));
            		poisk = $("#poisk_text").attr("P");
        		}
        		if(poisk!=null && poisk != "") {
	        		var level_parent = $("#level_parent").val();
	        		var id_parent = $("#id_parent").val();
		        	$.ajax({
	      			  url: "Catalog2.jsp",
	    			  data: {id  : id, level : 3, page : page, poisk : poisk, level_parent : level_parent, id_parent : id_parent},
	    			  cache: false
	    			}).done(function( html ) {
	    			  $("#loadBlock").html(html);
	    			});
        		}
        		return false;
        	} else {
	        	$.ajax({
	        			  url: "Catalog2.jsp",
	        			  data: {id  : id, level : level, page : page},
	        			  cache: false
	        			}).done(function( html ) {
	        			  $("#loadBlock").html(html);
	        			});
	        	 $("#level_parent").val(level);
	        	 $("#id_parent").val(id);
        		return false;
        	}
		}
        
        function loadFirm(id) {
			if($('#menu ul #menu_li_'+id+' ul').html() == null) {
	        	$.ajax({
	        		url: "Firm.jsp",
	        		data: {id : id, level : 1},
	        		cashe: false
	        	}).done(function(html) {
	        		$('#menu ul #menu_li_'+id).append(html);
//	        		alert(html);
					return false;
	        	});
			}
        }
        
        function setLeftCatalog(name, id, id_tek, level) {
//        	alert($("#"+name+id+" ul").html());
        	if($("#"+name+id+" ul").html()==null) {
        		$("#catalog #"+name+id).parent().find("a").removeAttr("class");
        		$("#catalog #"+name+id+" a").attr("class","ovalBorder5");
        		$("#catalog #"+name+id).append("<ul>");
        		alert($("#menu_li_"+id+" li").html());
        		$("#menu_li_"+id+" li").each(function() {
//        			alert($(this).attr("id"));
					var str_id = $(this).attr('id');
					var ahref = '<a href="level0.jsp?id='+str_id+'&amp;level=2" style="font-size : 12px;">';
        			$("#catalog #"+name+id+" ul").append("<li style='margin-left: -25px;list-style-type: disc;' id='FIRMA"+str_id+"''>"+ahref+$(this).text()+"</a></li>");
        		});
        	}
//        	alert($("#catalog  #"+name+id).parent().parent().html());
        	loadCatalog(id_tek, level);
        }

        function addToBasket() {
        	
            	var id_p = $("#addBasketButton").attr("idProduct");
            	var price = $("#addBasketButton").attr("price");
            	$.ajax({
            		url: "Basket.jsp",
            		data: {id : id_p, count : 1, price : price, OP : "add"},
            	cashe: false 
            	}).done(function(html) {
//	        		alert(html);
	        		$("#basketBlock > div").html("");
	 				$("#basketBlock").append(html);
//	 				alert($("#basketBlock > div").outerWidth())
					return false;
	        	});
        	return false;
        }
        
    </script> 

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
commonBean.setPars(null); 
commonBean.setLevel();
commonBean.setPage();
String className = "ru.flooring_nn.sql.SQLsFlooring_nn";
String methodName = "getRequests";
HashMap<String, List<HashMap<String, String>>> result = commonBean.getResult(className, methodName);
List<HashMap<String, String>> catalog = new ArrayList<HashMap<String, String>>(result.get("Request_0"));
HashMap <String, String> rows = (HashMap <String, String>) catalog.get(catalog.size()-1);
catalog.remove(catalog.get(catalog.size()-1));
%>
 <link href="styles/style.css" rel='stylesheet' type='text/css'>
 </head>
<body>
<div id="menu_" >
<nav>
<center>    
<ul id="menu"> 
	<li>
			<a href="index2.jsp">Главная</a>
	</li> 
	<li> 
		<a href="#">Каталог товаров</a> 
		<ul> 
		<%for(HashMap<String, String> row : catalog) {
//			for(Enumeration elements = catalog.elements();elements.hasMoreElements();) {
//			HashMap <String, String> row = ((HashMap<String, String>) elements.nextElement()); 
			String section = row.get("SECTION");
			String picture = row.get("PICTURE");
			String id = row.get("ID");%>
			<li id="menu_li_<%=id%>" style="cursor: pointer"> 
				<a onclick="loadCatalog(<%=id%>, 1);$('#menu ul li').css('display','none');" onmouseover="loadFirm(<%=id%>);"><%=section%></a> 
			</li>						
		<%}%>
		</ul> 
	</li> 
	<li> 
		<a href="#">Услуги</a> 
				
	</li> 
	<li> 
		<a href="#">Как заказать</a>	
	</li> 
	<li> 
		<a href="#">Контактная информация</a>	
	</li> 
	<li> 
		<a href="#" style="color: red">Акции</a> 
	</li>
	<li>
			<div id='basketBlock'>
				<img alt="" height='35px;' src="images/basketShop.png">
				<jsp:include page="Basket.jsp"></jsp:include>
			</div>
	</li> 
</ul> 
</center>
</nav>
</div>
<div style="height: 55px;"></div>
<div id="body">
		<table>
			<tr id="firstRow">
				<td style="width: 25%">
					Логотип магазина
				</td>
				<td style="width: 50%">
					<p>
						<span class="nameShop1">
							<span style="font-size: 18px;"> ИНТЕРНЕТ-МАГАЗИН</span><br/>
							Ярмарка Напольных Покрытий
						</span>
					</p>
					<p>
						<span class="nameShop2">
							Широкий выбор, лучшая цена!
						</span>
					</p>
					<p>
						<span class="nameShop3">
							часы работы с 9:00 до 21:00
						</span>
					</p>
				</td>
				<td style="width: 25%;text-align: left;" >
					<ul>
						<li>
							<span class="bigPhoneNumber">
								+7 (915) 955-03-05
							</span>
						</li>
						<li>
							<p>
								<a href="#"> <img alt="" style="height: 1.2em;" src="images/mail.png"> Напишите нам</a>
							</p>
						</li>
						<li>
							<p>
								<a href="#"> <img alt="" style="height: 1.2em;" src="images/call_back.png"> Обратный звонок</a>
							</p>
						</li>
					</ul>
				</td>
			</tr>
			<tr>
				<td rowspan="1" style="vertical-align: top;">
					<table id="leftTable">
						<caption class="nameShop1">Каталог товаров</caption>
						<tr>
							<td>
								<ul id="catalog">
								<%for(HashMap<String, String> row : catalog) {
//								for(Enumeration elements = catalog.elements();elements.hasMoreElements();) {
//									HashMap<String, String> row = (HashMap<String, String>) elements.nextElement();
									String section = row.get("SECTION");
									String id = row.get("ID");
									%>
									<li id='SECTION<%=id%>'> 
										<a href="level0.jsp?id=<%=id%>&amp;level=1">
											<%=section%>
										</a>
									</li>						
								<%}%>
								</ul>
								<hr/>
							</td>
						</tr>
						<tr>
							<td>
								<table id="contact">
									<tr>
										<td colspan="2">
											<a href="#">Контактная информация</a>
										</td>
									</tr>
									<tr>
									<td>
										<div><img style="height: 1.2em;" src="images/map_marker.png"></div>
									</td>
									<td>										
										<div>ООО "ТМ- Сервис", Нижний Новгород, Интернациональная, д. 100</div>
										<a href="#">Посмотреть на карте</a>
									</td>
									</tr>
									<tr>
									<td>
										<div><img style="height: 1.2em;" src="images/phone.png"></div>
									</td>
									<td colspan="1">
										+7 (915) 955-03-05
									</td>
									</tr>
									<tr>
									<td>
										<div><img style="height: 1.2em;" src="images/email.png"></div>
									</td>
									<td colspan="1">
										<a href="mailto:info@flooring-nn.ru">info@flooring-nn.ru</a>
									</td>
									</tr>
								</table>
								<hr/>
							</td>
						</tr>
					</table>
				</td>
				<td colspan="2" style="width: 75%;vertical-align: top;text-align: center; overflow: hidden;">
					<table id="rightTable">
						<tr>
							<td id='poisk' style="width: 100%;vertical-align: top;text-align: center; overflow: hidden;">
									<form style="width: 100%">
										<input type="hidden" id='level_parent' value=0>
										<input type="hidden" id='id_parent' value=0>
										<input type="text" id='poisk_text' value='' style="margin: 0 auto; width: 70%" placeholder="Поиск по сайту">&nbsp;
										<button type="button" onclick="loadCatalog('poisk');">Найти</button> 
									</form>
								<br/>
							</td>
						</tr>
						<tr>
							 <td colspan="2"  style="width: 75%;vertical-align: top;text-align: center;">
							 	<div id="loadBlock" style="vertical-align: top;">
								 	<div align="center" id="multyPics">
								 	</div><br/>
<%
commonBean.setPars(pars);
%>								 	
									<jsp:include page="Catalog2.jsp"/>								 	
							 	</div>
					 			<br/>
							 </td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</div>
</body>
</html>