package com.example.TheUnclosed.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.client.RestTemplate;

@Controller
public class AiController {
	
	private final RestTemplate restTemplate = new RestTemplate();
	
	@PostMapping("/usr/ai/ask")
	public ResponseEntity<Map<String, String>> askAi(@RequestBody Map<String, String> requestBody){
	    String question = requestBody.get("question");
	    String caseName = requestBody.get("caseName");
	    String role = requestBody.get("role");

	    String url = "http://localhost:5000/ask-ai";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, String> aiRequest = new HashMap<>();
	    aiRequest.put("sessionId", requestBody.get("sessionId"));  // sessionId도 보내기
	    aiRequest.put("question", question);
	    aiRequest.put("caseName", caseName);
	    aiRequest.put("role", role);

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(aiRequest, headers);

	    try {
	        ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
	        Map<String, Object> responseBody = response.getBody();

	        String answer = (String) responseBody.get("answer");
	        String guideMessage = (String) responseBody.get("guideMessage"); // 선택적으로 받을 수도 있음

	        Map<String, String> result = new HashMap<>();
	        result.put("answer", answer);
	        if (guideMessage != null) {
	            result.put("guideMessage", guideMessage);
	        }

	        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(result);

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, String> errorResult = new HashMap<>();
	        errorResult.put("answer", "서버 내부 오류: " + e.getMessage());
	        return ResponseEntity.status(500).body(errorResult);
	    }
	}
	
	@PostMapping("/usr/ai/start-trial")
	public ResponseEntity<Map<String, String>> startTrial(@RequestBody Map<String, String> requestBody) {
	    String caseName = requestBody.get("caseName");
	    String userRole = requestBody.get("userRole");
	    String sessionId = requestBody.get("sessionId");
	    String currentPhase = requestBody.get("currentPhase");

	    String url = "http://localhost:5000/start-trial";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, String> aiRequest = new HashMap<>();
	    aiRequest.put("session_id", sessionId);  // key 수정
	    aiRequest.put("caseName", caseName);
	    aiRequest.put("role", userRole);          // key 수정
	    aiRequest.put("currentPhase", currentPhase);

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(aiRequest, headers);

	    try {
	        ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
	        Map<String, Object> responseBody = response.getBody();

	        if (responseBody == null) {
	            throw new RuntimeException("AI 서버 응답이 비어있습니다.");
	        }

	        String answer = (responseBody.get("answer") != null) ? responseBody.get("answer").toString() : "";
	        String guideMessage = (responseBody.get("guideMessage") != null) ? responseBody.get("guideMessage").toString() : null;

	        if (answer.trim().isEmpty()) {
	            answer = "판사: 재판을 시작합니다. 검사와 변호사께서는 준비해 주시기 바랍니다.";
	        }

	        Map<String, String> result = new HashMap<>();
	        result.put("answer", answer);
	        if (guideMessage != null) {
	            result.put("guideMessage", guideMessage);
	        }

	        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(result);

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, String> errorResult = new HashMap<>();
	        errorResult.put("answer", "서버 내부 오류: " + e.getMessage());
	        return ResponseEntity.status(500).body(errorResult);
	    }
	}
}