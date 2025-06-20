<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<section class="max-w-4xl mx-auto px-6 py-12">
  <h2 class="text-3xl font-bold text-sky-300 mb-10 border-b pb-3">${mainTitle}</h2>

  <div class="space-y-10">
    <c:forEach items="${coldCases}" var="coldCase">
      <div class="bg-white/10 backdrop-blur-md border border-gray-700 shadow-xl rounded-2xl p-6 text-white">
        <!-- 사건 제목 -->
        <div class="mb-4">
          <h3 class="text-2xl font-semibold text-rose-400 mb-1">
            🔎 ${coldCase.getSubTitle() != null ? coldCase.getSubTitle() : coldCase.getMainTitle()}
          </h3>
          <p class="text-sm text-gray-300">👤 피해자: ${coldCase.getVictim()}</p>
        </div>

        <!-- 정보 목록 -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm text-gray-100 mb-4">
          <p>📅 <span class="font-semibold text-sky-300">발생일:</span> ${coldCase.getOccDate()}</p>
          <p>📍 <span class="font-semibold text-sky-300">발생장소:</span> ${coldCase.getOccPlace()}</p>
          <p>🕵️ <span class="font-semibold text-sky-300">시신발견일:</span> ${coldCase.getBodyFoundDate()}</p>
          <p>🗺️ <span class="font-semibold text-sky-300">시신발견장소:</span> ${coldCase.getFoundPlace()}</p>
        </div>

        <!-- 수사 내용 -->
        <div class="mt-4 bg-gray-800 border border-rose-500 rounded-xl p-5 whitespace-pre-line leading-relaxed">
          <div class="flex items-center mb-2">
            <span class="text-rose-400 text-lg font-bold mr-2">📝 수사 내용</span>
            <div class="flex-grow border-t border-rose-400"></div>
          </div>
          <p class="text-gray-200">${coldCase.getForPrintInvestigation()}</p>
        </div>
      </div>
    </c:forEach>
  </div>
</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>