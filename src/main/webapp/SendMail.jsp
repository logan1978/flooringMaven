<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript" src="js/jquery-latest.min.js"></script> 
<link href="styles/styleSendMail.css" rel='stylesheet' type='text/css'>
<script type="text/javascript">
$(document).ready(function(){
$("input[type='button']").click(function(){
	var emailFrom = $("div>input[type='text']").val();
	var text = $("div>textarea").val();
	$.ajax({
		  url: "EmailSender",
		  data: {emailFrom : emailFrom, text : text},
		  cache: false
		}).done(function( html ) {
			if(html.trim() == "Email Sent successfully....") {
				$("#commDiv").remove();				
				$("#result").css("color" , "green");
			} else {
				$("#result").css("color", "red");
				$("#result").html("Ошибка отправки: <br/>");
			}
	  		$("#result").append(html);
		});
	return false;
});
});

</script>
</head>
<body>
<div id='commDiv'>
	<div>
	<span>Введите свой email для ответа:</span><br/>
	<input id='email' type="text" placeholder='email'></input>
	</div>
	<div>
	<span>Ввод текста письма:</span><br/>
	<textarea id='text' rows="10" cols="50"></textarea>
	</div>
	<input type="button" value="отправить">
</div>
<div id='result'>
</div>
</body>
</html>