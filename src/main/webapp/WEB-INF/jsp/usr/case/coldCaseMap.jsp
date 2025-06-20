<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>    

<!-- 스타일 보정 -->
<style>
  #map {
    width: 90vw;
    height: 80vh;
    margin: 0 auto;
    border-radius: 1rem;
    box-shadow: 0 8px 20px rgba(0,0,0,0.5);
    overflow: hidden;
  }
</style>

<!-- 카카오맵 SDK -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a78659f2d020c9aaa72c30fea087ff6a"></script>

<!-- 헤더 영역 -->
<section class="bg-gray-900 text-center py-12 text-white">
  <h2 class="text-4xl font-bold text-rose-400 mb-2">COLD CASE MAP</h2>
  <p class="text-lg text-sky-200">대한민국 미제사건의 위치를 지도로 확인하세요.</p>
</section>

<!-- 지도 본체 -->
<div id="map" class="my-10 rounded-xl"></div>

<!-- 스크립트 -->
<script type="module">
import missingData from '/resource/missingdata.js';
import murderData from '/resource/murderdata.js';
import unknownData from '/resource/unknowndata.js';

const kakao = window.kakao;

// 지도 초기화
const mapContainer = document.getElementById('map');
const mapOption = {
    center: new kakao.maps.LatLng(36.5, 127.8),
    level: 12,
    mapTypeId: kakao.maps.MapTypeId.ROADMAP
};
const map = new kakao.maps.Map(mapContainer, mapOption);

// 마커 이미지 경로
const markerImages = {
    missing: '/resource/markerImgs/missing.png',
    murder: '/resource/markerImgs/kill.png',
    unknown: '/resource/markerImgs/unknown.png'
};

// 전체 데이터 합치기
const allData = [
    ...missingData.map(item => ({ ...item, type: 'missing' })),
    ...murderData.map(item => ({ ...item, type: 'murder' })),
    ...unknownData.map(item => ({ ...item, type: 'unknown' }))
];

let activeOverlay = null;

allData.forEach(item => {
    if (item.latlng?.lat && item.latlng?.lng) {
        const position = new kakao.maps.LatLng(item.latlng.lat, item.latlng.lng);

        const markerImage = new kakao.maps.MarkerImage(
            markerImages[item.type],
            new kakao.maps.Size(28, 40),
            { offset: new kakao.maps.Point(14, 40) }
        );

        const marker = new kakao.maps.Marker({
            position: position,
            image: markerImage,
            map: map
        });

        const overlayHTML = `
            <div class="customOverlay" style="
                position: relative; bottom: 40px; border-radius: 12px;
                background: rgba(255, 255, 255, 0.95);
                padding: 12px 16px;
                width: 260px;
                box-shadow: 0 6px 18px rgba(0,0,0,0.4);
                font-family: 'Pretendard', sans-serif;
            ">
                <div style="font-size: 1.1rem; font-weight: bold; margin-bottom: 6px; color: #1f2937;">
                    ${item.title}
                </div>
                <img src="${item.img}" alt="사건 이미지" style="width: 100%; height: 150px; object-fit: cover; border-radius: 8px; margin-bottom: 8px;" />
                <a href="${item.link}" target="_blank" style="
                    display: inline-block;
                    margin-top: 4px;
                    color: #2563eb;
                    font-weight: 500;
                    text-decoration: underline;
                ">자세히 보기</a>
                <button class="closeBtn" style="
                    position: absolute;
                    top: 8px; right: 8px;
                    border: none;
                    background: #ef4444;
                    color: white;
                    width: 24px;
                    height: 24px;
                    border-radius: 50%;
                    font-size: 14px;
                    cursor: pointer;
                ">×</button>
            </div>
        `;

        const customOverlay = new kakao.maps.CustomOverlay({
            position,
            content: overlayHTML,
            yAnchor: 1,
            map: null
        });

        kakao.maps.event.addListener(marker, 'click', function () {
            if (activeOverlay) activeOverlay.setMap(null);
            customOverlay.setMap(map);
            activeOverlay = customOverlay;

            setTimeout(() => {
                document.querySelector('.customOverlay .closeBtn')?.addEventListener('click', () => {
                    customOverlay.setMap(null);
                    activeOverlay = null;
                });
            }, 0);
        });
    }
});
</script>