// jQuery: select에 기본값 자동 설정
$('select[data-value]').each(function () {
  const $el = $(this);
  const defaultValue = $el.attr('data-value')?.trim();

  if (defaultValue?.length > 0) {
    $el.val(defaultValue);
  }
});

// 타임라인 등장 애니메이션 처리
(function () {
  "use strict";

  const items = document.querySelectorAll(".timeline li");

  // 해당 요소가 뷰포트 안에 있는지 여부
  function isElementInViewport(el) {
    const rect = el.getBoundingClientRect();
    return (
      rect.top < window.innerHeight &&
      rect.bottom >= 0
    );
  }

  // 모든 timeline item을 순회하면서 in-view class 처리
  function updateTimelineView() {
    items.forEach(item => {
      if (isElementInViewport(item)) {
        item.classList.add("in-view");
      }
    });
  }

  // 초기 실행 및 이벤트 바인딩
  window.addEventListener("load", updateTimelineView);
  window.addEventListener("resize", updateTimelineView);
  window.addEventListener("scroll", updateTimelineView);
})();