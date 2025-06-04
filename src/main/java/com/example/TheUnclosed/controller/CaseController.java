package com.example.TheUnclosed.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CaseController {
	
	@GetMapping("/usr/case/main")
	public String showMain() {
		return "usr/case/main";
	}
	
	@GetMapping("/usr/case/coldCase1")
	public String showColdCase1() {
		return "usr/case/coldCase1";
	}
	
}
