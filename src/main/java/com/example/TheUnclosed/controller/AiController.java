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
	public String showAiMain() {
	    return "usr/ai/mockTrial"; // JSP 경로
	}

	@PostMapping("/usr/ai/ask")
	public ResponseEntity<String> askAi(@RequestBody Map<String, String> requestBody) {
	    String question = requestBody.get("question");
	    String caseName = requestBody.get("caseName");   // 사건명 추가로 받음
	    String role = requestBody.get("role");           // 역할 추가로 받음

	    String url = "http://localhost:5000/ask-ai";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, String> aiRequest = new HashMap<>();
	    aiRequest.put("question", "사건명: " + caseName + ", 역할: " + role + ", 질문: " + question);

	    HttpEntity<Map<String, String>> entity = new HttpEntity<>(aiRequest, headers);

	    ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

	    String answer = (String) response.getBody().get("answer");

	    return ResponseEntity.ok(answer);
	}
}
