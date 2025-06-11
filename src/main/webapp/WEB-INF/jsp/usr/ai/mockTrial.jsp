<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%> 

<link rel="stylesheet" href="/resource/mockTrial.css" />

<title>모의재판 시뮬레이터</title>

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
					
                    console.log(data);
                    
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
                    
                    if (data.guideMessage) {
                    	addMessage('AI', '💡 <strong>AI가 예상한 질문:</strong><br>' + data.guideMessage, false);
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

<!-- 가이드 메시지 박스 (처음 재판 시작 시 노출됨) -->
<div id="guide-box" style="display:none; background-color: #fff8e1; border-left: 4px solid #ffc107; padding: 15px; margin-bottom: 15px; max-width: 600px; margin-left: auto; margin-right: auto; border-radius: 8px;">
  <strong>AI가 예상한 당신의 질문은 다음과 같아요!</strong>
  <p id="guide-message" style="margin-top: 10px; white-space: pre-line;"></p>
</div>

<div id="main-container">
  <!-- 왼쪽 흐름도 -->
  <div id="flow-diagram">
    <h3>📌 발언 순서 흐름도</h3>
    <div class="flow-step">1️<strong>판사</strong>: 재판 개시, 모두 발언 안내</div>
    <div class="flow-step">2️<strong>검사</strong>: 공소 사실 진술</div>
    <div class="flow-step">3️<strong>변호사</strong>: 변론 요지 진술</div>
    <div class="flow-step">4️<strong>판사</strong>: 증인신문 시작</div>
    <div class="flow-step">5️<strong>검사/변호사</strong>: 증인신문 및 반대신문</div>
    <div class="flow-step">6️<strong>판사</strong>: 최종 의견 요청</div>
    <div class="flow-step">7️<strong>검사/변호사</strong>: 최종 변론</div>
    <div class="flow-step">8️<strong>판사</strong>: 판결 선고</div>
  </div>

  <!-- 오른쪽 채팅 영역 -->
  <div id="chat"></div>
</div>

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