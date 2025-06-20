<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="메인" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<!-- Font Awesome 추가 (헤더에 한 번만 있으면 됨) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" integrity="sha512-..." crossorigin="anonymous" />

<!-- ✅ HERO SECTION -->
<section class="relative bg-gray-900 text-white py-32">
  <!-- 흐릿한 배경 이미지 -->
  <div class="absolute inset-0 bg-cover bg-center opacity-20 z-0" style="background-image: url('/img/crime-bg.jpg');"></div>

	<div class="relative z-10 container mx-auto px-4 text-center">
		<h1 class="text-4xl md:text-6xl font-bold leading-tight mb-4">
			미제사건의 진실을 밝혀보세요</h1>
		<p class="text-lg md:text-xl mb-8 text-gray-300">타임라인으로 사건을 탐색하고,
			모의재판에 참여해 직접 판결해보세요.</p>

		<!-- 버튼 영역 -->
		<div class="space-x-4 mt-6">
			<!-- 사건 타임라인 -->
			<a href="../case/main"
				class="inline-flex items-center gap-2 bg-amber-600 hover:bg-amber-700 text-white py-3 px-6 rounded-xl text-lg transition shadow-md">
				<i class="fa-solid fa-hourglass-half"></i> 사건 타임라인 보기
			</a>

			<!-- 사건 지도 -->
			<a href="../case/coldCaseMap"
				class="inline-flex items-center gap-2 bg-teal-600 hover:bg-teal-700 text-white py-3 px-6 rounded-xl text-lg transition shadow-md">
				<i class="fa-solid fa-map-location-dot"></i> 사건 지도 보기
			</a>

			<!-- 모의재판 -->
			<a href="../ai/mockTrial"
				class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white py-3 px-6 rounded-xl text-lg transition shadow-md">
				<i class="fa-solid fa-scale-balanced"></i> 모의재판 시작하기
			</a>
		</div>

	</div>

<!-- 스크롤 유도 화살표 -->
  <div class="relative z-10 mt-20 animate-bounce">
    <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-8 w-8 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
    </svg>
  </div>
</section>

<!-- ✅ 사건 요약 카드 섹션 -->
<section class="bg-gray-800 py-16">
	<div class="container mx-auto px-4">
		<h2 class="text-3xl text-white font-bold text-center mb-10">대표
			미제사건 둘러보기</h2>
		<div class="grid grid-cols-1 md:grid-cols-3 gap-6">

			<!-- 포천 여중생 -->
			<div class="bg-gray-700 p-6 rounded-xl shadow text-white">
				<h3 class="text-xl font-bold mb-2">🕵️ 포천 여중생 살인 사건</h3>
				<p class="text-gray-300 text-sm">2000년대 경기도 포천. 여중생이 실종 후 숨진 채
					발견. 단서 부족으로 장기 미제.</p>
			</div>

			<!-- 치과의사 모녀 -->
			<div class="bg-gray-700 p-6 rounded-xl shadow text-white">
				<h3 class="text-xl font-bold mb-2">🧪 치과의사 모녀 살인 사건</h3>
				<p class="text-gray-300 text-sm">1995년 서울. 수면제 중독·보험·의심스러운 화재.
					하지만 진범은 끝내 확인되지 않음.</p>
			</div>

			<!-- 개구리소년 (성서초) -->
			<div class="bg-gray-700 p-6 rounded-xl shadow text-white">
				<h3 class="text-xl font-bold mb-2">🧒 대구 성서초등학교 살인 사건</h3>
				<p class="text-gray-300 text-sm">1990년대 개구리소년 실종 사건. 5년 뒤 유해 발견. 사망 원인·가해자 모두 미확인.</p>
			</div>

		</div>
		<div class="text-center mt-10">
			<a href="../case/main" class="text-red-400 hover:underline text-lg">전체사건 보러가기 →</a>
		</div>
	</div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>