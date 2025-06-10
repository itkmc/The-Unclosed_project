<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%> 
<!-- 공통 헤더 파일 포함 (HTML <head> 등 기본 설정) -->

<title>모의재판 시뮬레이터</title>

<style>
/* 전체 페이지 기본 스타일 */
body {
	font-family: Arial, sans-serif; /* 기본 글꼴 */
	background: #f2f2f2; /* 연한 회색 배경 */
	margin: 0;
	padding: 20px; /* 페이지 여백 */
}

/* 채팅창 영역 스타일 */
#chat {
	max-width: 600px; /* 최대 가로폭 600px */
	margin: 0 auto; /* 가운데 정렬 */
	background: white; /* 흰 배경 */
	padding: 15px; /* 내부 여백 */
	border-radius: 8px; /* 둥근 모서리 */
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 약간의 그림자 */
	height: 300px; /* 높이 고정 */
	overflow-y: auto; /* 세로 스크롤 자동 */
	overflow-x: hidden; /* 가로 스크롤 숨김 */
	word-break: break-word; /* 단어가 길어도 줄바꿈 */
}

/* 메시지 하나하나 박스 스타일 */
.message {
	clear: both; /* float 해제 */
	margin: 5px 0; /* 위아래 간격 */
	padding: 8px 12px; /* 안쪽 여백 */
	border-radius: 5px; /* 모서리 둥글게 */
	max-width: 80%; /* 최대 너비 80% */
	word-wrap: break-word; /* 긴 단어 줄바꿈 */
	color: #000; /* 글자색 검정 */
}

/* 판사 메시지 스타일 - 연파랑 배경, 왼쪽 정렬 */
.judge {
	background-color: #cce5ff;
	float: none !important; /* float 없애기 (중요!) */
	margin-right: auto; /* 왼쪽 정렬 */
}

/* 검사 메시지 스타일 - 연분홍 배경, 오른쪽 정렬 */
.prosecutor {
	background-color: #f8d7da;
	float: none !important;
	margin-left: auto; /* 오른쪽 정렬 */
}

/* 변호사 메시지 스타일 - 연초록 배경, 오른쪽 정렬 */
.lawyer {
	background-color: #d4edda;
	float: none !important;
	margin-left: auto; /* 오른쪽 정렬 */
}

/* 입력 영역 컨테이너 */
#input-section {
	max-width: 600px; /* 최대 600px */
	margin: 20px auto 0; /* 위쪽 여백 20px, 가운데 정렬 */
	display: flex; /* 가로 플렉스 박스 */
	gap: 10px; /* 아이템 간 간격 */
	flex-wrap: wrap; /* 줄바꿈 가능 */
}

/* select 박스와 텍스트 입력창 공통 스타일 */
#input-section select, #input-section input {
	padding: 10px; /* 안쪽 여백 */
	font-size: 16px; /* 글자 크기 */
}

/* select 박스 너비 및 유연성 */
#input-section select {
	min-width: 150px; /* 최소 너비 150px */
	flex: 1 0 150px; /* 플렉스 성장/축소, 기본 너비 */
}

/* 텍스트 입력창 너비 및 유연성 */
#input-section input {
	flex: 3 0 250px; /* 더 넓게 차지 */
}

/* 전송 버튼 스타일 */
#input-section button {
	padding: 10px 20px; /* 안쪽 여백 */
	flex: 1 0 100px; /* 너비 조절 */
	cursor: pointer; /* 마우스 커서 포인터 */
}

/* 구분선 스타일 */
hr {
	border: none;
	border-top: 1px solid #ccc;
	margin: 20px 0;
	clear: both; /* float 해제 */
}
</style>

<!-- jQuery 라이브러리 불러오기 (꼭 필요!) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function() {
    const sessionId = 'test-session-1';
    let isTrialStarted = false; // 현재 재판 시작 여부

    function addMessage(sender, text, isUser) {
        const chat = $('#chat');
        const messageDiv = $('<div>').addClass('message');
        const htmlText = (isUser ? `나: \${text}` : `\${sender}: \${text}`).replace(/\n/g, '<br>');

        if (isUser) {
            messageDiv.css('background-color', '#cce5ff');
            messageDiv.css('margin-right', 'auto');
        } else {
            if (sender === '판사') {
                messageDiv.addClass('judge');
            } else if (sender === '검사') {
                messageDiv.addClass('prosecutor');
            } else if (sender === '변호사') {
                messageDiv.addClass('lawyer');
            } else {
                messageDiv.css('background-color', '#f8d7da');
                messageDiv.css('margin-left', 'auto');
            }
        }

        messageDiv.html(htmlText);
        chat.append(messageDiv);
        chat.scrollTop(chat.prop("scrollHeight"));
    }

    $('#sendButton').on('click', function() {
        const caseName = $('#caseSelect').val();
        const role = $('#role').val();
        const question = $('#question').val().trim();

        if (!isTrialStarted) {
            // 처음 전송이면 /start-trial 먼저 호출 (질문 없어도 호출 가능!)
            $.ajax({
                url: '/usr/ai/start-trial',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                data: JSON.stringify({
                    sessionId: sessionId,
                    caseName: caseName,
                    userRole: role,
                    currentPhase: '서론' // 초기 단계는 서론으로 설정
                }),
                success: function(data) {
                    isTrialStarted = true; // 재판 시작 표시

                    // 판사 인트로 및 검사/변호사 발언 출력
                    if (data.answer) {
                        const lines = data.answer.split('\n').filter(line => line.trim() !== '');

                        lines.forEach(line => {
                            const idx = line.indexOf(':');
                            if (idx !== -1) {
                                const aiRole = line.substring(0, idx).trim();
                                const aiText = line.substring(idx + 1).trim();
                                addMessage(aiRole, aiText, false);
                            } else {
                                const fallbackText = line.trim();
                                if (fallbackText) {
                                    addMessage('AI', fallbackText, false);
                                }
                            }
                        });
                    }

                    // 질문이 있으면 그 다음에 /ask-ai 호출
                    if (question) {
                        addMessage('나', question, true);
                        sendAskAi(caseName, role, question);
                    }
                },
                error: function(err) {
                    addMessage('시스템', '재판 시작 중 오류 발생. 다시 시도해주세요.', false);
                }
            });
        } else {
            // 재판 시작 후에는 질문 없으면 막기
            if (!question) {
                addMessage('시스템', '질문을 입력하세요.', false);
                return;
            }

            addMessage('나', question, true);
            sendAskAi(caseName, role, question);
        }
    });

    // /ask-ai 호출 함수
    function sendAskAi(caseName, role, question) {
        $.ajax({
            url: '/usr/ai/ask',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify({
                sessionId: sessionId,
                question: question,
                caseName: caseName,
                role: role
            }),
            success: function(data) {
                if (!data.answer) {
                    addMessage('시스템', 'AI 응답이 없습니다.', false);
                    return;
                }

                const lines = data.answer.split('\n').filter(line => line.trim() !== '');

                lines.forEach(line => {
                    const idx = line.indexOf(':');
                    if (idx !== -1) {
                        const aiRole = line.substring(0, idx).trim();
                        const aiText = line.substring(idx + 1).trim();
                        addMessage(aiRole, aiText, false);
                    } else {
                        const fallbackText = line.trim();
                        if (fallbackText) {
                            addMessage('AI', fallbackText, false);
                        }
                    }
                });

                $('#question').val('');
            },
            error: function(err) {
                addMessage('시스템', '오류가 발생했습니다. 다시 시도해주세요.', false);
            }
        });
    }
});
</script>

<!-- 페이지 제목 -->
<h1>모의재판 시뮬레이터</h1>

<!-- 채팅 메시지들이 쌓이는 영역 -->
<div id="chat"></div>

<!-- 입력 영역: 사건 선택, 역할 선택, 질문 입력, 전송 버튼 -->
<div id="input-section">
	<select id="caseSelect" title="사건 선택">
		<option value="춘천 강간살인 조작사건">춘천 강간살인 조작사건</option>
		<option value="부산 어린이 연쇄살인 사건">부산 어린이 연쇄살인 사건</option>
		<option value="대구 성서초등학교 학생 살인 암매장 사건">대구 성서초등학교 학생 살인 암매장 사건</option>
		<option value="이형호 유괴 살인 사건" selected>이형호 유괴 살인 사건</option>
		<option value="치과의사 모녀 살인 사건">치과의사 모녀 살인 사건</option>
		<option value="사바이 단란주점 살인사건">사바이 단란주점 살인사건</option>
		<option value="포천 여중생 살인 사건">포천 여중생 살인 사건</option>
		<option value="신정동 연쇄폭행 살인사건">신정동 연쇄폭행 살인사건</option>
		<option value="목포 여대생 살인 사건">목포 여대생 살인 사건</option>
	</select>

	<select id="role" title="역할 선택">
		<option value="판사" selected>판사</option>
		<option value="검사">검사</option>
		<option value="변호사">변호사</option>
	</select>

	<input type="text" id="question" placeholder="질문을 입력하세요" />
	<button id="sendButton">전송</button>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>
<!-- 공통 푸터 파일 포함 -->
