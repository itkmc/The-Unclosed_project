<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp"%>

<link rel="stylesheet" href="/resource/mockTrial.css" />

<title>모의재판 시뮬레이터</title>

<script>
$(document).ready(function() {
    const sessionId = 'test-session-1';
    let isTrialStarted = false; // 재판 시작 여부

    function addMessage(sender, text, isUser, alignRight = false) {
        const chat = $('#chat');
        const messageDiv = $('<div>').addClass('message');
        const htmlText = (isUser ? `나: \${text}` : `\${sender}: \${text}`).replace(/\n/g, '<br>');

        if (isUser || alignRight) {
            messageDiv.css({
                'background-color': '#cce5ff',
                'align-self': 'flex-end',
                'margin-left': 'auto',
                'text-align': 'right'
            });
        } else {
            if (sender === '판사') {
                messageDiv.addClass('judge');
            } else if (sender === '검사') {
                messageDiv.addClass('prosecutor');
            } else if (sender === '변호사') {
                messageDiv.addClass('lawyer');
            } else {
                messageDiv.css('background-color', '#f8d7da');
            }
            messageDiv.css({
                'margin-right': 'auto',
                'align-self': 'flex-start',
                'text-align': 'left'
            });
        }

        messageDiv.html(htmlText);
        chat.append(messageDiv);
        chat.scrollTop(chat.prop("scrollHeight"));
    }

    $('#sendButton').on('click', function(event) {
        event.preventDefault();

        const caseName = $('#caseSelect').val();
        const role = $('#role').val();
        const question = $('#question').val().trim();

        if (!isTrialStarted) {
            startTrialAndSendQuestion(caseName, role, question);
        } else {
            if (!question) {
                alert('질문을 입력하세요.');
                return;
            }
            addMessage('나', question, true);
            sendAskAi(caseName, role, question);
        }
    });

    function startTrialAndSendQuestion(caseName, role, question) {
        $.ajax({
            url: '/usr/ai/start-trial',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify({
                sessionId: sessionId,
                caseName: caseName,
                userRole: role,
                currentPhase: '서론'
            }),
            success: function(data) {
                isTrialStarted = true;

                // 1. 판사 및 역할 발언 출력
                if (data.answer) {
                    const lines = data.answer.split('\n').filter(line => line.trim() !== '');
                    lines.forEach(line => {
                        const idx = line.indexOf(':');
                        if (idx !== -1) {
                            const aiRole = line.substring(0, idx).trim();
                            const aiText = line.substring(idx + 1).trim();
                            addMessage(aiRole, aiText, false);
                        } else {
                            addMessage('AI', line.trim(), false);
                        }
                    });
                }

                // 2. 사건 요약 출력
                if (data.caseSummary) {
                    addMessage('시스템', `📄 사건 요약:\n\${data.caseSummary}`, false);
                }

                // 3. 가이드 박스 출력
                const guideHtml = data.guideMessage
                    ? `<div class="guide-message">💡 \${data.guideMessage.replace(/\n/g, "<br>")}</div>`
                    : `<div class="guide-message">💡 가이드 메시지가 없습니다.</div>`;

                const questionHtml = (data.exampleQuestions || []).map(q => `<li>\${q}</li>`).join("");

                $('#guide-box').html(`
                    \${guideHtml}
                    <ul class="example-questions">
                        \${questionHtml}
                    </ul>
                `);

             	// 4-1. 현재 단계 출력
                if (data.currentPhase) {
                    addMessage("시스템", `🧭 현재 단계: ${data.currentPhase}`, false);
                }

                // 4-2. 다음 단계 출력 (단, '서론' 단계는 출력하지 않음)
                if (data.nextPhase && data.nextPhase !== '서론') {
                    addMessage('시스템', `📌 다음 단계: ${data.nextPhase}`, false);
                }

                // 5. 질문이 있다면 바로 전송
                if (question) {
                    addMessage('나', question, true);
                    sendAskAi(caseName, role, question);
                }
            },
            error: function() {
                alert('⚠️ 재판 시작 중 오류가 발생했습니다.');
            }
        });
    }

    // AI 역할 추론 함수
    function getAiActualRole(aiRoleRaw, userRole, aiText) {
    const lowered = aiRoleRaw.toLowerCase();
    const text = aiText.toLowerCase();

    // 1. 직접적으로 역할이 명시된 경우 우선
    if (lowered.includes('판사')) return '판사';
    if (lowered.includes('검사')) return '검사';
    if (lowered.includes('변호사')) return '변호사';
    if (lowered.includes('시스템')) return '시스템';

    // 2. 텍스트 내용 기반 추론 (정교하게 조정)
    if (text.includes('공소사실') || text.includes('기소') || text.includes('유죄') || text.includes('엄벌')) {
        return '검사';
    }

    if (text.includes('무죄') || text.includes('알리바이') || text.includes('변론') || text.includes('방어') || text.includes('정황') || text.includes('의문을 제기')) {
        return '변호사';
    }

    if (text.includes('재판부는') || text.includes('공정하게') || text.includes('절차') || text.includes('판단') || text.includes('중립')) {
        return '판사';
    }

    // 3. fallback: 사용자 역할 반대로
    if (userRole === '검사') return '변호사';
    if (userRole === '변호사') return '검사';
    return '판사';
}

    function sendAskAi(caseName, role, question) {
        $.ajax({
            url: '/usr/ai/ask',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify({
                sessionId: sessionId,
                question: question,
                userRole: role,
                caseName: caseName
            }),
            success: function(data) {
                if (data.answer) {
                    const lines = data.answer.split('\n').filter(line => line.trim() !== '');
                    lines.forEach(line => {
                        const idx = line.indexOf(':');
                        if (idx !== -1) {
                            const aiRoleRaw = line.substring(0, idx).trim();
                            const aiText = line.substring(idx + 1).trim();
                            const finalRole = getAiActualRole(aiRoleRaw, role, aiText);
                            addMessage(finalRole, aiText, false);
                        } else {
                            const fallbackText = line.trim();
                            if (fallbackText) {
                                const inferredRole = getAiActualRole('AI', role, fallbackText);
                                addMessage(inferredRole, fallbackText, false);
                            }
                        }
                    });
                }

                let systemMessage = "";

                if (data.guideMessage) {
                    systemMessage += `💡 가이드: ${data.guideMessage}\n`;
                }
                if (data.nextPhase) {
                    systemMessage += `📌 다음 단계: ${data.nextPhase}\n`;
                }
                if (data.exampleQuestions && data.exampleQuestions.length > 0) {
                    systemMessage += `🧭 예시 질문:\n`;
                    data.exampleQuestions.forEach(q => {
                        systemMessage += `- ${q}\n`;
                    });
                }
                if (systemMessage.trim() !== "") {
                    addMessage("시스템", systemMessage.trim(), false);
                }

                // 가이드 박스 업데이트
                if (data.guideMessage || (data.exampleQuestions && data.exampleQuestions.length > 0)) {
                    let guideText = "";
                    if (data.guideMessage) {
                        guideText += "👉 " + data.guideMessage.replace(/\n/g, "<br>") + "<br><br>";
                    }
                    if (data.exampleQuestions && data.exampleQuestions.length > 0) {
                        guideText += "💡 예시 질문:<br>";
                        data.exampleQuestions.forEach(q => {
                            guideText += `- ${q}<br>`;
                        });
                    }
                    $('#guide-box').html(guideText).show();
                }
            },
            error: function(xhr, status, error) {
                alert('AI 응답 중 오류가 발생했습니다: ' + error);
                console.error(xhr, status, error);
            }
        });
    }
});
</script>

<div id="guide-box" class="guide-container"></div>

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

<!-- 입력 영역 -->
<div id="input-section">
    <select id="caseSelect" title="사건 선택">
        <option value="춘천 강간살인 조작사건">춘천 강간살인 조작사건</option>
        <option value="부산 어린이 연쇄살인 사건">부산 어린이 연쇄살인 사건</option>
        <option value="대구 성서초등학교 학생 살인 암매장 사건">대구 성서초등학교 학생 살인 암매장 사건</option>
        <option value="이형호 유괴살인 사건" selected>이형호 유괴 살인 사건</option>
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
    <input type="text" id="question" placeholder="" />
    <button id="sendButton">전송</button>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp"%>