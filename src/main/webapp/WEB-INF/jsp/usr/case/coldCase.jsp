<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<section class="mt-8">
	<div class="container mx-auto space-y-8">
		<!-- 각 그룹을 카드 형태로 감쌈 -->
		<div class="bg-white shadow-lg rounded-xl p-6 border border-gray-200">
			<h2 class="text-xl font-bold mb-4 border-b pb-2 text-gray-800">${mainTitle}</h2>

			<!-- 각 사건을 표로 출력 -->
			<c:forEach items="${coldCases}" var="coldCase">
				<table class="w-full table-auto mb-6 border border-gray-300 rounded-md overflow-hidden">
					<tbody class="text-sm text-gray-700">
						<c:if test="${coldCase.getSubTitle() != null }">
							<tr class="bg-gray-50">
								<th class="w-32 px-4 py-2 text-left font-semibold">세부 사건명</th>
								<td class="px-4 py-2">${coldCase.getSubTitle()}</td>
							</tr>
						</c:if>
						<tr>
							<th class="px-4 py-2">피해자</th>
							<td class="px-4 py-2">${coldCase.getVictim()}</td>
						</tr>
						<tr class="bg-gray-50">
							<th class="px-4 py-2">발생일</th>
							<td class="px-4 py-2">${coldCase.getOccDate()}</td>
						</tr>
						<tr>
							<th class="px-4 py-2">발생장소</th>
							<td class="px-4 py-2">${coldCase.getOccPlace()}</td>
						</tr>
						<tr class="bg-gray-50">
							<th class="px-4 py-2">시신발견일</th>
							<td class="px-4 py-2">${coldCase.getBodyFoundDate()}</td>
						</tr>
						<tr>
							<th class="px-4 py-2">시신발견장소</th>
							<td class="px-4 py-2">${coldCase.getFoundPlace()}</td>
						</tr>
						<tr class="bg-gray-50">
							<th class="px-4 py-2">수사 내용</th>
							<td class="px-4 py-2 whitespace-pre-line">${coldCase.getForPrintInvestigation()}</td>
						</tr>
					</tbody>
				</table>
			</c:forEach>
		</div>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>