package com.example.TheUnclosed.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.client.RestTemplate;

@Controller
public class AiController {
	
	private final RestTemplate restTemplate = new RestTemplate();
	
	@GetMapping("/usr/ai/mockTrial")
	public String showmockTrial() {
		return "usr/ai/mockTrial";
	}
	
	@PostMapping("/usr/ai/ask")
	public ResponseEntity<Map<String, String>> askAi(@RequestBody Map<String, String> requestBody){
	    String question = requestBody.get("question");
	    String caseName = requestBody.get("caseName");
	    String userRole = requestBody.get("userRole");

	    String url = "http://localhost:5000/ask-ai";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, String> aiRequest = new HashMap<>();
	    aiRequest.put("sessionId", requestBody.get("sessionId"));  // sessionId도 보내기
	    aiRequest.put("question", question);
	    aiRequest.put("caseName", caseName);
	    aiRequest.put("userRole", userRole);

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(aiRequest, headers);

	    try {
	        ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
	        String answer = (String) response.getBody().get("answer");
	        
	        // 여기 변경 → Map 으로 감싸서 반환
	        Map<String, String> result = new HashMap<>();
	        result.put("answer", answer);
	        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(result);

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, String> errorResult = new HashMap<>();
	        errorResult.put("answer", "서버 내부 오류: " + e.getMessage());
	        return ResponseEntity.status(500).body(errorResult);
	    }
	}
	
	@PostMapping("/usr/ai/start-trial")
	public ResponseEntity<Map<String, Object>> startTrial(@RequestBody Map<String, String> requestBody) {
	    String caseName = requestBody.get("caseName");
	    String userRole = requestBody.get("userRole");
	    String sessionId = requestBody.get("sessionId");
	    String currentPhase = requestBody.get("currentPhase");

	    String url = "http://localhost:5000/start-trial";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, String> aiRequest = new HashMap<>();
	    aiRequest.put("sessionId", sessionId);
	    aiRequest.put("caseName", caseName);
	    aiRequest.put("userRole", userRole);
	    aiRequest.put("currentPhase", currentPhase);

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(aiRequest, headers);

	    try {
	        ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
	        Map<String, Object> body = response.getBody(); // 전체 응답 가져오기

	        return ResponseEntity.ok().contentType(MediaType.APPLICATION_JSON).body(body);

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> errorResult = new HashMap<>();
	        errorResult.put("answer", "서버 내부 오류: " + e.getMessage());
	        return ResponseEntity.status(500).body(errorResult);
	    }
	}
}