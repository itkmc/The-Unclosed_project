<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<link rel="stylesheet" href="/resource/timeline.css" />
    
<!-- The Timeline -->
<section class="timeline flex justify-center">
	<ul>
		<li>
			<div class="solid">
				<time class="period">1970년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="coldCase?mainTitle=춘천 강간살인 조작사건">춘천 강간살인 조작사건</a></time>
				<img src="/resource/caseImgs/춘천 조작.jpg" />
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="coldCase?mainTitle=부산 어린이 연쇄살인 사건">부산 어린이 연쇄살인 사건</a></time>
				<img src="/resource/caseImgs/부산 어린이.png" />
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">1990년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="coldCase?mainTitle=">대구 성서초등학교 <br />학생 살인 암매장 사건</a></time>
				<img src="/resource/caseImgs/개구리소년.jpg" />
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="coldCase?mainTitle=">이형호 유괴 살인 사건</a></time>
				<img src="/resource/caseImgs/이형호.jpg" />
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="coldCase?mainTitle=">치과의사 모녀 살인 사건</a></time>
				<img src="/resource/caseImgs/치과의사 모녀.png" />
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="">대구 어린이 황산테러사건(태완이 사건)</a></time>
				<img src="/resource/caseImgs/태완이.jpg" />
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">2000년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="">포천 여중생 살인 사건</a></time>
				<img src="" />
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="">신정동 엽기토끼 연쇄살인 사건</a></time>
				<img src="" />
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">2010년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time><a href="">목포 여대생 살인 사건</a></time>
				<img src="/resource/caseImgs/목포 여대생.jpg"/>
			</div>
		</li>
	</ul>
</section>

<script src="/resource/timeline.js"></script>
<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>