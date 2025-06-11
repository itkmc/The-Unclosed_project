const chatArea = document.getElementById('chat-area');
const userInput = document.getElementById('user-input');
const sendBtn = document.getElementById('send-btn');
const guideArea = document.getElementById('guide-area');
const roleSelect = document.getElementById('role-select');
const caseSelect = document.getElementById('case-select');
const trialStage = document.getElementById('trial-stage');
const saveLogBtn = document.getElementById('save-log');

// 대화 기록 저장용 배열
let chatLog = [];

// 역할별 가이드 텍스트 예시
const roleGuides = {
	judge: "판사 역할입니다. 재판을 공정하게 진행하세요.",
	prosecutor: "검사 역할입니다. 피고인의 유죄를 입증하는 질문을 하세요.",
	defense: "변호사 역할입니다. 피고인의 무죄 또는 형량 감경을 주장하세요."
};

// 사건별 초기 재판 단계
const trialStagesByCase = {
	pocheon: "서론",
	daegu: "서론",
	etc: "서론"
};

// 역할별 메시지 클래스
const roleClass = {
	judge: "judge",
	prosecutor: "prosecutor",
	defense: "defense"
};

// 초기 세팅
function initialize() {
	updateGuide();
	trialStage.textContent = `재판 진행 단계: ${trialStagesByCase[caseSelect.value] || "대기 중"}`;
	chatArea.innerHTML = "";
	chatLog = [];
	addMessage("judge", "판사", "재판을 시작하겠습니다. 사건 개요를 설명합니다...");
}

// 메시지 추가 함수
function addMessage(role, speaker, text) {
	const msgDiv = document.createElement('div');
	msgDiv.classList.add('msg', roleClass[role] || 'judge');
	msgDiv.innerHTML = `<strong class="user">${speaker}:</strong> ${text}`;
	chatArea.appendChild(msgDiv);
	chatArea.scrollTop = chatArea.scrollHeight;

	chatLog.push({ role, speaker, text });
}

// 사용자 발언 추가 (역할에 맞게)
function addUserMessage(text) {
	const role = roleSelect.value;
	const speaker = role.charAt(0).toUpperCase() + role.slice(1);
	addMessage(role, speaker + " (나)", text);
}

// 가이드 업데이트
function updateGuide() {
	const role = roleSelect.value;
	guideArea.textContent = roleGuides[role] || "";
}

// 전송 이벤트 처리
sendBtn.addEventListener('click', () => {
	const text = userInput.value.trim();
	if (text === "") return;

	addUserMessage(text);
	userInput.value = "";

	// 여기 AI 응답 처리 부분 (임시 예시)
	setTimeout(() => {
		let reply = "";
		switch (roleSelect.value) {
			case "judge":
				reply = "재판을 중재하는 판사 역할입니다. 다음 발언을 진행하세요.";
				break;
			case "prosecutor":
				reply = "피고인의 범죄 혐의에 대해 더 구체적으로 질문하세요.";
				break;
			case "defense":
				reply = "피고인의 무죄를 입증할 수 있는 증거를 제시하세요.";
				break;
		}
		addMessage("judge", "판사", reply);
	}, 1000);
});

// 엔터키로도 전송 가능하게
userInput.addEventListener('keypress', (e) => {
	if (e.key === 'Enter') {
		sendBtn.click();
	}
});

// 역할 또는 사건 선택 변경 시 초기화
roleSelect.addEventListener('change', () => {
	updateGuide();
	initialize();
});
caseSelect.addEventListener('change', () => {
	trialStage.textContent = `재판 진행 단계: ${trialStagesByCase[caseSelect.value] || "대기 중"}`;
	initialize();
});

// 재판 기록 다운로드 (텍스트 파일)
saveLogBtn.addEventListener('click', () => {
	if (chatLog.length === 0) {
		alert("대화 기록이 없습니다.");
		return;
	}
	let text = "=== 모의재판 기록 ===\n\n";
	chatLog.forEach(({ role, speaker, text: msg }, idx) => {
		text += `${idx + 1}. [${speaker}] (${role}) : ${msg}\n`;
	});

	const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
	const url = URL.createObjectURL(blob);

	const a = document.createElement('a');
	a.href = url;
	a.download = "trial_log.txt";
	a.click();

	URL.revokeObjectURL(url);
});

// 초기화 최초 실행
initialize();