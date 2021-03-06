 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SB Admin 2 - Tables</title>

  <!-- Custom fonts for this template -->
  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="${pageContext.request.contextPath}/resources/css/sb-admin-2.min.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chat.css">
  <!-- Custom styles for this page -->
  <link href="${pageContext.request.contextPath}/resources/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
	  <script src="https://cdn.jsdelivr.net/sockjs/1/sockjs.min.js" ></script>
	  <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
</head>
	<body>
<jsp:include page="../includes/header.jsp" flush="false"></jsp:include>
<div class="container">
<h3 class=" text-center">Messaging</h3>
<input type="hidden" value='${userId}' id="sessionuserid">
<div class="messaging">
      <div class="inbox_msg">
        <div class="inbox_people">
          <div class="headind_srch">
            <div class="recent_heading">
              <h4>Recent</h4>
            </div>
            <div class="srch_bar">
              <div class="stylish-input-group">
                <input type="text" class="search-bar"  placeholder="Search" >
                <span class="input-group-addon">
                <button type="button"> <i class="fa fa-search" aria-hidden="true"></i> </button>
                </span> </div>
            </div>
          </div>
          <div class="inbox_chat">
            <div class="chat_list active_chat">
              <div class="chat_people">
                <div class="chat_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div>
                <div class="chat_ib">
                  <h5>Sunil Rajput <span class="chat_date">Dec 25</span></h5>
                  <p>Test, which is a new approach to have all solutions 
                    astrology under one roof.</p>
                </div>
              </div>
            </div>

          </div>
        </div>
        <div class="mesgs">
          <div class="msg_history">
          <!--   <div class="incoming_msg">
              <div class="incoming_msg_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div>
              <div class="received_msg">
                <div class="received_withd_msg">
                  <p>Test which is a new approach to have all
                    solutions</p>
                  <span class="time_date"> 11:01 AM    |    June 9</span></div>
              </div>
            </div>
            <div class="outgoing_msg">
              <div class="sent_msg">
                <p>Test which is a new approach to have all
                  solutions</p>
                <span class="time_date"> 11:01 AM    |    June 9</span> </div>
            </div>
            -->
          </div>
          <div class="type_msg">
            <div class="input_msg_write">
              <input type="text" class="write_msg" placeholder="Type a message" />
              <button class="msg_send_btn" type="button"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>
            </div>
          </div>
        </div>
      </div>
      </div>
      </div>
      
      <p class="text-center top_spac"> Design by <a target="_blank" href="#">Sunil Rajput</a></p>
      
    <jsp:include page="../includes/footer.jsp"></jsp:include>
    
    
<script type="text/javascript">
	$(document).ready(function() {
		$(".msg_send_btn").click(function(evt) {
			evt.preventDefault();
			if(sock.readyState!=1)return;
			sendMessage();
		});
	});

	var sock;
	//웸소켓을 지정한 url로 연결한다.
	sock = new SockJS("<c:url value="/echo"/>");
	//자바스크립트 안에 function을 집어넣을 수 있음.
	//데이터가 나한테 전달되?쩜? 때 자동으로 실행되는 function
	sock.onopen=function(){
		console.log('Info: connection opend')
	}
			
			
	sock.onmessage = onMessage;

	//데이터를 끊고싶을때 실행하는 메소드
	sock.onclose = onClose;
	sock.onerror=function(event){
		console.log('Error: ',event)
		
	}


	function sendMessage() {
		/*소켓으로 보내겠다.  */
		sock.send($(".write_msg").val());
	}

	//evt 파라미터는 웹소켓을 보내준 데이터다.(자동으로 들어옴)

	function onMessage(evt) {
		var data = evt.data;
		var sessionid = null;
		var message = null;
		
		//문자열을 splite//
		var strArray = data.split(':');
		
		for(var i=0; i<strArray.length; i++){
			console.log('str['+i+']: ' + strArray[i]);
		}
		
		//current session id//
		var currentuser_session = $('#sessionuserid').val();
		console.log('current session id: ' + currentuser_session);
		
		sessionid = strArray[0]; //현재 메세지를 보낸 사람의 세션 등록//
		message = strArray[1]; //현재 메세지를 저장//
		console.log(sessionid)
		console.log(currentuser_session)
		console.log(currentuser_session==sessionid)
		
		
		//나와 상대방이 보낸 메세지를 구분하여 영역을 나눈다.//
		if(sessionid == currentuser_session){
			console.log('내가 보냄')
			var printHTML = '<div class="outgoing_msg">';
			printHTML += '<div class="sent_msg">';
			printHTML += '<p>'+message+'</p>';
			printHTML += '<span class="time_date">'+'<fmt:formatDate value="${now}" pattern="yyyy-MM-dd hh:mm:ss" />'+'</span>';
			printHTML += '</div>';
			printHTML += '</div>';
			
			$(".msg_history").append(printHTML);
		} else{
			
			console.log('다른 사람이 보냄')
			var printHTML = '<div class="incoming_msg">';
			printHTML += '<div class="incoming_msg_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div>';
			printHTML += ' <div class="received_msg">';
			printHTML += ' <div class="received_withd_msg">'+'<p>'+message+'</p>'
			printHTML +='<span class="time_date">'+'<fmt:formatDate value="${now}" pattern="yyyy-MM-dd hh:mm:ss" />'+'</span>';
			printHTML += '</div>';
			printHTML += '</div>';
			
			$(".msg_history").append(printHTML);
		}
		
		//$(".mesgs").append(data + "<br/>");
		//sock.close();
	}

	function onClose(evt) {
		$(".mesgs").append("연결 끊김");
		console.log('Info: connection closed')
	}
</script>
    </body>
</html>
