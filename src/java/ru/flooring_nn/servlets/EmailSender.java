package ru.flooring_nn.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.*;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EmailSender extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		resp.setContentType("text/html; charset=windows-1251");
		PrintWriter out = resp.getWriter();
		HashMap <String, String> pars = new HashMap<String,String>(); 
		for(Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
			String name = (String) params.nextElement();
			if(!"_".equals(name)) {
				pars.put(name,  new String(request.getParameter(name).getBytes("ISO-8859-1"), "utf-8")); 
			}
		}
	    InetAddress inetAddress = InetAddress.getByName(request.getServerName());
	    String user = request.getRemoteUser();
	    String addr = request.getRemoteAddr();
	    String agent = request.getHeader("User-Agent");
		String ref = request.getHeader("referer");
	    if(ref != null) {
	        String to = "IVC_HovanskiySE@grw.rzd";         // sender email 
	        String from = pars.get("emailFrom");       // receiver email 
	        String host = "uc.grw.rzd";            // mail server host 
	
	        Properties properties = System.getProperties(); 
	        properties.setProperty("mail.smtp.host", host); 
	
	        Session session = Session.getDefaultInstance(properties); // default session 
	        
	        try { 
	             MimeMessage message = new MimeMessage(session); // email message 
	
	             message.setFrom(new InternetAddress(from)); // setting header fields  
	
	             message.addRecipient(Message.RecipientType.TO, new InternetAddress(to)); 
	
	             message.setSubject("Обращение по блокировке АС СИРИУС", "koi8-r"); // subject line 
	
	             // actual mail body   
	             String text = pars.get("text");
	             text += "\r\n----------------------------------------------------------------------------------";
	             text += "\r\nАдрес: "+addr+"("+inetAddress+")";
	             text += "\r\nЛогин: "+user;
	             text += "\r\nАгент: "+agent;
	             text += "\r\nРеффер: "+ref;
	             
	            	message.setText(text, "koi8-r");
	             
	             // Send message 
	             Transport.send(message); 
	             out.println("Email Sent successfully...."); 
	            } catch (Exception mex){ out.println(mex);} 
	    } else {
	    	String error = "Использование класса с нарушением";
	    	
	    	out.println(new String(error.getBytes(), "cp1251"));
	    }
  } 
}
