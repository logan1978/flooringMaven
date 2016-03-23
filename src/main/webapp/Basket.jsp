<%@page import="ru.flooring_nn.beans.Basket"%>
<jsp:useBean id="commonBean" scope="session" class="ru.flooring_nn.beans.CommonBean"/>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
int id=-1;
int count=0;
int price=-1;

if(request.getParameter("id")!=null) {
	id = Integer.parseInt(request.getParameter("id"));
}
if(request.getParameter("count")!=null) {
	count = Integer.parseInt(request.getParameter("count"));
}
if(request.getParameter("price")!=null) {
	price = Integer.parseInt(request.getParameter("price"));
}

Basket basket = commonBean.getBasket();
if("add".equals(request.getParameter("OP"))) {
	basket.addToBasket(id, count, price);
	commonBean.setBasket(basket);
} else if("remove".equals(request.getParameter("OP"))) {
	basket.removeFromBasket(id, count);
} else if("clear".equals(request.getParameter("OP"))) {
	basket.clearBasket();
}

if(basket != null && basket.getSizeBasket() > 0) {
%>
	<div id='cnt'>
		<nobr>Всего: <%=basket.getCountBasket()%> <%=commonBean.getNormPrefix(basket.getCountBasket(), "товар") %></nobr>
	</div>
	<div id='prc'>
		<nobr>Стоимость: <%= basket.getCommonPrice()%></nobr>
	</div>
				<%} else {%>
					<div id='empty'>Корзина пуста</div>
				<%}%>
