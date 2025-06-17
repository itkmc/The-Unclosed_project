<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>    

<style>
#map {
    width: 90vw;
    height: 80vh; /* 화면 높이의 60% */
    margin: 0 auto;
}
</style>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a78659f2d020c9aaa72c30fea087ff6a"></script>

<div class="text-center">
	<h2>COLD CASE MAP</h2>
	<p>대한민국 미제사건 정보</p>
</div>

<div id="map"></div>

<!-- 2. 모듈 스크립트 안에 caseData import & 지도 코드 -->
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

// 마커 이미지 경로 설정
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

// 오버레이 상태 관리
let activeOverlay = null;

// 마커 찍기
allData.forEach((item, index) => {
    if (item.latlng && item.latlng.lat && item.latlng.lng) {
        const position = new kakao.maps.LatLng(item.latlng.lat, item.latlng.lng);

        // 마커 이미지 적용
        const markerImage = new kakao.maps.MarkerImage(
            markerImages[item.type],
            new kakao.maps.Size(24, 35),
            { offset: new kakao.maps.Point(20, 42) }
        );

        // 마커 생성
        const marker = new kakao.maps.Marker({
            position: position,
            image: markerImage,
            map: map
        });

        // 오버레이 HTML 전체 문자열로 구성
        const overlayHTML = `
            <div class="customOverlay" style="
                position: relative; bottom: 40px; border-radius:6px; border:1px solid #ccc;
                background:#fff; padding:10px; width:250px; box-shadow:0 2px 6px rgba(0,0,0,0.3);
            ">
                <div style="font-weight:bold; margin-bottom:5px;">\${item.title}</div>
                <img src="\${item.img}" style="width:250px; height:150px; margin-bottom:8px;">
                <a href="\${item.link}" target="_blank" style="color:blue; text-decoration:underline;">자세히 보기</a>
                <button class="closeBtn" style="
                    position:absolute; top:5px; right:5px; border:none; background:#f00;
                    color:#fff; border-radius:50%; width:20px; height:20px; cursor:pointer;
                ">×</button>
            </div>
        `;

        const customOverlay = new kakao.maps.CustomOverlay({
            position: position,
            content: overlayHTML,
            yAnchor: 1,
            map: null
        });

        // 마커 클릭 이벤트
        kakao.maps.event.addListener(marker, 'click', function () {
            // 기존 오버레이 닫기
            if (activeOverlay) {
                activeOverlay.setMap(null);
                activeOverlay = null;
            }

            // 현재 오버레이 열기
            customOverlay.setMap(map);
            activeOverlay = customOverlay;

            // 닫기 버튼 이벤트 바인딩 (DOM 반영 이후 실행)
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