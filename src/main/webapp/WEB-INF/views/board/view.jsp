<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta content="charset=UTF-8">
<title>게시글 작성</title>
<%@ include file="../include/header.jsp" %>
<script>
	$(document).ready(function(){
		listReply("1"); //댓글 목록 불러오기
		//listReply2(); //이 함수는 document밖에 있어서 이렇게 선언해줘야하나보다.
		
		//댓글쓰기 버튼 ajax로 처리
		$("#btnReply").click(function(){
            var replytext=$("#replytext").val();
            if(replytext == ""){
            	alert("댓글을 입력해주세요.");
            	document.replytext.focus();
            	return;
            }
            var bno="${dto.bno}";
            //비밀 여부 체크
            var secretReply ="n";
            //태그.is(":속성") ---> 체크여부 ture/false
             if( $("#secretReply").is(":checked") ){
            	secretReply ="y";
            }
            alert(secretReply);    
            var param="replytext="+replytext+"&bno="+bno+"&secretReply="+secretReply;
            $.ajax({                
                type: "post",
                url: "${path}/reply/insert.do",
                data: param,
                success: function(){
                    alert("댓글이 등록되었습니다.");
                    //listReply2();
                    listReply("1");
                }
            });
        });

	//목록 버튼 클릭이벤트: 버튼 클릭시 상세보기 화면에 있던 페이지, 검색옵션, 키워드 값을 가지고 목록으로 이동
	$("#btnList").click(function(){
		 location.href="${path}/board/list.do?curPage=${curPage}&searchOption=${searchOption}&keyword=${keyword}";
	});

    $("#btnDelete").click(function(){
    	if(confirm("삭제하시겠습니까?")){
			document.form1.action = "${path}/board/delete.do";
			document.form1.submit();
            }
     });
        
	 $("#btnUpdete").click(function(){
			//var title = document.form1.title.value; ==> name속성으로 처리할 경우
            //var content = document.form1.content.value;
            //var writer = document.form1.writer.value;
            var title = $("#title").val();
            var content = $("#content").val();
            //var writer = $("#writer").val();
            if(title == ""){
                alert("제목을 입력하세요");
                document.form1.title.focus();
                return;
            }
            if(content == ""){
                alert("내용을 입력하세요");
                document.form1.content.focus();
                return;
            }
            /*if(writer == ""){
                alert("이름을 입력하세요");
                document.form1.writer.focus();
                return;
            }*/
            document.form1.action="${path}/board/update.do";
            // 폼에 입력한 데이터를 서버로 전송
            document.form1.submit();
        });
    });
	
	//Controller방식
	//댓글 목록1
	function listReply(num){
		$.ajax({
			type:"get",
			url: "${path}/reply/list.do?bno=${dto.bno}&curPage="+num,
			success:function(result){
				//responseText가 result에 저장됨
				$("#listReply").html(result);
			}
		});
	}
	
	// RestController방식 (Json)
    // **댓글 목록2 (json)
    function listReply2(){
        $.ajax({
            type: "get",
            //contentType: "application/json", ==> 생략가능(RestController이기때문에 가능)
            url: "${path}/reply/listJson.do?bno=${dto.bno}",
            success: function(result){
                console.log(result);
                var output = "<table>";
                for(var i in result){
                    output += "<tr>";
                    output += "<td>"+result[i].userName;
                    output += "("+changeDate(result[i].regdate)+")<br>";
                    output += result[i].replytext+"</td>";
                    output += "<tr>";
                }
                output += "</table>";
                $("#listReply").html(output);
            }
        });
    }
	
	// **날짜 변환 함수 작성
    function changeDate(date){
        date = new Date(parseInt(date));
        year = date.getFullYear();
        month = date.getMonth();
        day = date.getDate();
        hour = date.getHours();
        minute = date.getMinutes();
        second = date.getSeconds();
        strDate = year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;
        return strDate;
    }
	
</script>
</head>
<body>
<%@ include file="../include/menu.jsp" %>
<h2>게시글 보기</h2>
<form name="form1" method="post">
    <div>        <!-- 원하는 날짜형식으로 출력하기 위해 fmt태그 사용 -->
        작성일자 : <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd a HH:mm:ss"/>
                <!-- 날짜 형식 => yyyy 4자리연도, MM 월, dd 일, a 오전/오후, HH 24시간제, hh 12시간제, mm 분, ss 초 -->
    </div>
    <div>
        조회수 : ${dto.viewcnt}
    </div>
    <div>
        제목
        <input name="title" id="title" size="80" value="${dto.title}" placeholder="제목을 입력해주세요">
    </div>
    <div>
        내용
        <textarea name="content" id="content" rows="4" cols="80" placeholder="내용을 입력해주세요">${dto.content}</textarea>
    </div>
    <div>
        이름 : ${dto.userName}
        <%-- <input name="writer" id="writer" value="${dto.writer}" placeholder="이름을 입력해주세요"> --%>
    </div>
    <div style="width:650px; text-align: center;">
        <!-- 게시물번호를 hidden으로 처리 -->
        <input type="hidden" name="bno" value="${dto.bno}">
        <!-- 본인이 쓴 게시물만 수정, 삭제가 가능하도록 처리 -->
    	<c:if test="${sessionScope.id == dto.writer}">
        	<button type="button" id="btnUpdete">수정</button>
        	<button type="button" id="btnDelete">삭제</button>
    	</c:if>
    	<button type="button" id ="btnList">목록</button>
    </div>
</form>

<div style = "width:650px; text-ailan:center;">
	<br>
	<!--  로그인한 회원에게만 댓들 작성 폼이 보이게 처리 -->
	<c:if test ="${sessionScope.id != null }">
		<textarea rows="5" cols ="80" id ="replytext" placeholder="댓글을 작성해주세요"></textarea>
		<br>
		<input type ="checkbox" id ="secretReply">비밀댓글
		<button type ="button" id = "btnReply">댓글작성</button>
	</c:if>
</div>
<div id ="listReply"></div>
</body>
</html>