$('select[data-value]').each(function(index, el) {
	const $el = $(el);

	defaultValue = $el.attr('data-value').trim();

	if (defaultValue.length > 0) {
		$el.val(defaultValue);
	}
});


(function() {
	"use strict";

	// ".timeline li" 선택자에 해당하는 모든 요소를 찾아서 items 변수에 저장
	var items = document.querySelectorAll(".timeline li");

	// 뷰포트 내에 요소가 있는지 확인하는 함수
	// http://stackoverflow.com/questions/123999/how-to-tell-if-a-dom-element-is-visible-in-the-current-viewport
	function isElementInViewport(el) {
		var rect = el.getBoundingClientRect();
		return (rect.top >= 0
			&& rect.left >= 0
			// 요소의 하단이 뷰포트의 높이 이내인지 확인
			&& rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) 
			// 요소의 오른쪽이 뷰포트의 너비 이내인지 확인
			&& rect.right <= (window.innerWidth || document.documentElement.clientWidth));
	}

	function callbackFunc() {
		// 모든 타임라인 항목을 순회
		for (var i = 0; i < items.length; i++) {
			// 항목이 뷰포트 안에 있으면 해당 항목에 "in-view" 클래스를 추가
			if (isElementInViewport(items[i])) {
				items[i].classList.add("in-view");
			// 뷰포트에 없으면 "in-view" 클래스 제거
			} else {
				items[i].classList.remove("in-view");
			}
		}
	}

	// 페이지 로드 시 함수 실행
	window.addEventListener("load", callbackFunc);
	// 뷰포트 크기 변경 시 함수 실행
	window.addEventListener("resize", callbackFunc);
	// 스크롤 시 함수 실행
	window.addEventListener("scroll", callbackFunc);
	
//	// 여기부터 고정 연도 표시 구현
//		window.addEventListener('DOMContentLoaded', () => {
//		  const fixedYear = document.getElementById('fixedYear');
//		  const periods = document.querySelectorAll('.period');
//
//		  function updateFixedYear() {
//		    let currentYear = periods[0].textContent; // 기본 초기값
//		    const offset = fixedYear.offsetHeight + 10; // 고정영역 높이 보정값
//
//		    // periods를 위에서 아래로 돌면서 화면 상단과의 상대 위치 체크
//		    for (let i = 0; i < periods.length; i++) {
//		      const rect = periods[i].getBoundingClientRect();
//		      if (rect.top <= offset) {
//		        currentYear = periods[i].textContent;
//		      } else {
//		        break;
//		      }
//		    }
//
//		    fixedYear.textContent = currentYear;
//		  }
//
//		  // 초기 호출
//		  updateFixedYear();
//
//		  // 스크롤시 계속 갱신
//		  window.addEventListener('scroll', updateFixedYear);
//		  window.addEventListener('resize', updateFixedYear);
//		});
})();