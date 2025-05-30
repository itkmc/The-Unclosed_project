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
				<time>부산 어린이 연쇄 살인사건</time>
				<p></p>
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">1990년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time>개구리 소년 사건</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time>이형호 유괴 살인 사건</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time>치과의사 모녀 살인 사건</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time>대구 어린이 황산테러사건(태완이 사건)</time>
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">2010년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<time>목포 여대생 살인 사건</time>
			</div>
		</li>
	</ul>
</section>

<script src="/resource/timeline.js"></script>
<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>