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

        // 이미 text가 "검사: ~" 같이 sender가 붙어있으면 중복 안 붙임
        let displayText = text;
        const prefix = sender + ":";
        if (!isUser && text.startsWith(prefix)) {
            displayText = text;
        } else if (!isUser) {
            displayText = `\${sender}: \${text}`;
        } else {
            displayText = `나: \${text}`;
        }

        const htmlText = displayText.replace(/\n/g, '<br>');

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

                if (data.answer) {
                    const idx = data.answer.indexOf(':');
                    if (idx !== -1) {
                        const aiRole = data.answer.substring(0, idx).trim();
                        const aiText = data.answer.substring(idx + 1).trim();
                        addMessage(aiRole, aiText, false);
                    } else {
                        addMessage('AI', data.answer.trim(), false);
                    }
                }

                if (data.caseSummary) {
                    addMessage('시스템', `📄 사건 요약:\n${data.caseSummary}`, false);
                }

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

                if (data.currentPhase) {
                    addMessage("시스템", `🧭 현재 단계: \${data.currentPhase}`, false);
                }

                if (data.nextPhase && data.nextPhase !== '서론') {
                    addMessage('시스템', `📌 다음 단계: \${data.nextPhase}`, false);
                }

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

    function getAiActualRole(aiRoleRaw, userRole, aiText) {
        const lowered = aiRoleRaw.toLowerCase();
        const text = aiText.toLowerCase();

        if (lowered.includes('판사')) return '판사';
        if (lowered.includes('검사')) return '검사';
        if (lowered.includes('변호사')) return '변호사';
        if (lowered.includes('시스템')) return '시스템';

        if (text.includes('공소사실') || text.includes('기소') || text.includes('유죄') || text.includes('엄벌')) {
            return '검사';
        }

        if (text.includes('무죄') || text.includes('알리바이') || text.includes('변론') || text.includes('방어') || text.includes('정황') || text.includes('의문을 제기')) {
            return '변호사';
        }

        if (text.includes('재판부는') || text.includes('공정하게') || text.includes('절차') || text.includes('판단') || text.includes('중립')) {
            return '판사';
        }

        if (userRole === '검사') return '변호사';
        if (userRole === '변호사') return '검사';
        return '판사';
    }

    function showQuestionButton(role, buttonText) {
        const container = $("#question-button-container");
        container.html(`<button id="role-question-btn">\${buttonText}</button>`);
        $("#role-question-btn").off("click").on("click", () => {
            const caseName = currentCaseName;
            sendAskAi(caseName, role, `${role}의 질문을 입력하세요.`);
            container.empty();
        });
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
                caseName: caseName,
                userRole: role
            }),
            success: function(data) {
                const idx = data.answer.indexOf(':');
                if (idx !== -1) {
                    const aiRole = data.answer.substring(0, idx).trim();
                    const aiText = data.answer.substring(idx + 1).trim();
                    addMessage(aiRole, aiText, false);
                } else {
                    addMessage(role, data.answer.trim(), false);
                }

                // ✅ 증인 자동 응답이 있다면 추가로 출력
                if (data.witnessAnswer) {
                    const witnessIdx = data.witnessAnswer.indexOf(':');
                    if (witnessIdx !== -1) {
                        const witnessRole = data.witnessAnswer.substring(0, witnessIdx).trim();
                        const witnessText = data.witnessAnswer.substring(witnessIdx + 1).trim();
                        addMessage(witnessRole, witnessText, false); // ex) 증인: ~
                    } else {
                        addMessage("증인", data.witnessAnswer.trim(), false);
                    }
                }

                // 검사 질문 이후 증인 직접 호출 (기존 로직 유지)
                if (role === "검사" && data.currentPhase === "증인신문" && data.answer.includes("증인 신문을 시작")) {
                    setTimeout(() => {
                        sendAskAi(caseName, "증인", "검사님의 질문에 대해 증언해 주세요.");
                    }, 1000);
                    return;
                }

                if (role === "증인" && data.currentPhase === "반대신문") {
                    if (data.answer.includes("더 질문하실 내용 있나요")) {
                        showQuestionButton("변호사", "변호인 반대신문 질문하기");
                    }
                }
            },
            error: function() {
                alert('⚠️ AI 응답 처리 중 오류 발생');
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
    <div id="question-button-container"></div>
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