package com.example.TheUnclosed.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.TheUnclosed.dto.coldCase;
import com.example.TheUnclosed.service.CaseService;

@Controller
public class CaseController {
	
	private CaseService caseService;
	
	public CaseController(CaseService caseService) {
		this.caseService = caseService;
	}
	
	@GetMapping("/usr/case/main")
	public String showMain() {
		return "usr/case/main";
	}
	
	@PostMapping("/usr/case/coldCase")
	public String showcoldCase(Model model, String mainTitle) {
		
		List<coldCase> coldCases = this.caseService.getCases(mainTitle);
		
		model.addAttribute("mainTitle", mainTitle);
		model.addAttribute("coldCases", coldCases);
		
		return "usr/case/coldCase";
	}
	
	@GetMapping("/usr/case/coldCaseMap")
	public String showcoldCaseMap() {
		return "usr/case/coldCaseMap";
	}
	
}
