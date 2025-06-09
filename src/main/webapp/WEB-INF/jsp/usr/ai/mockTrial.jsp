<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<!-- 모의재판 질문하기 화면 -->
<h2>모의재판</h2>

<label for="caseSelect">사건 선택:</label>
<select id="caseSelect">
    <option value="춘천 강간살인 조작사건">춘천 강간살인 조작사건</option>
    <option value="부산 어린이 연쇄살인 사건">부산 어린이 연쇄살인 사건</option>
    <option value="대구 성서초등학교 학생 살인 암매장 사건">대구 성서초등학교 학생 살인 암매장 사건</option>
    <option value="이형호 유괴 살인 사건">이형호 유괴 살인 사건</option>
    <option value="치과의사 모녀 살인 사건">치과의사 모녀 살인 사건</option>
    <option value="사바이 단란주점 살인사건">사바이 단란주점 살인사건</option>
    <option value="포천 여중생 살인 사건">포천 여중생 살인 사건</option>
    <option value="신정동 연쇄폭행 살인사건">신정동 연쇄폭행 살인사건</option>
    <option value="목포 여대생 살인 사건">목포 여대생 살인 사건</option>
</select>

<br><br>

<label for="roleSelect">역할 선택:</label>
<select id="roleSelect">
    <option value="판사">판사</option>
    <option value="검사">검사</option>
    <option value="변호사">변호사</option>
</select>

<br><br>

<label for="questionInput">질문:</label><br>
<input type="text" id="questionInput" placeholder="AI에게 질문">

<br><br>
<button onclick="askAi()">질문하기</button>

<p id="aiAnswer" style="white-space: pre-wrap;"></p>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function askAi() {
    const selectedCase = $('#caseSelect').val();
    const selectedRole = $('#roleSelect').val();
    const question = $('#questionInput').val();

    $.ajax({
        url: '/usr/ai/ask',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
        	caseName: selectedCase,
            role: selectedRole,
            question: question
        }),
        success: function(answer) {
            $('#aiAnswer').text(answer);
        },
        error: function(err) {
            console.error(err);
            $('#aiAnswer').text('오류 발생');
        }
    });
}
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>