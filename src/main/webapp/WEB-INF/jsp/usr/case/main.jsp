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
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="춘천 강간살인 조작사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">춘천 강간살인 조작사건</a></time>
					<img src="/resource/caseImgs/춘천 조작.jpg" />
				</form>	
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="부산 어린이 연쇄살인 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">부산 어린이 연쇄살인 사건</a></time>
					<img src="/resource/caseImgs/부산 어린이.png" />
				</form>	
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">1990년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="대구 성서초등학교 학생 살인 암매장 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">대구 성서초등학교 <br />학생 살인 암매장 사건</a></time>
					<img src="/resource/caseImgs/개구리소년.jpg" />
				</form>	
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="이형호 유괴살인 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">이형호 유괴 살인 사건</a></time>
					<img src="/resource/caseImgs/이형호.jpg" />
				</form>	
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="치과의사 모녀 살인 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">치과의사 모녀 살인 사건</a></time>
					<img src="/resource/caseImgs/치과의사 모녀.png" />
				</form>	
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="사바이 단란주점 살인사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">사바이 단란주점 살인사건</a></time>
					<img src="/resource/caseImgs/사바이 단란주점.jpg" />
				</form>
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">2000년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="포천 여중생 살인 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">포천 여중생 살인 사건</a></time>
					<img src="/resource/caseImgs/포천 여중생.jpg" />
				</form>	
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="신정동 연쇄폭행 살인사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">신정동 연쇄폭행 살인사건</a></time>
					<img src="/resource/caseImgs/신정동 사건.jpg" />
				</form>	
			</div>
		</li>
		<li>
			<div class="solid">
				<time class="period">2010년대</time>
			</div>
		</li>
		<li>
			<div class="double">
				<form action="coldCase" method="post">
					<input type="hidden" name="mainTitle" value="목포 여대생 살인 사건" />
					<time><a href="#" onclick="this.closest('form').submit(); return false;">목포 여대생 살인 사건</a></time>
					<img src="/resource/caseImgs/목포 여대생.jpg"/>
				</form>	
			</div>
		</li>
	</ul>
</section>

<script src="/resource/timeline.js"></script>
<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>