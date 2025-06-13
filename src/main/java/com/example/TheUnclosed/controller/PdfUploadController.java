package com.example.TheUnclosed.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.TheUnclosed.service.PdfService;

@Controller
public class PdfUploadController {

    private PdfService pdfService;
    
    public PdfUploadController(PdfService pdfService) {
		this.pdfService = pdfService;
	}
    
    @GetMapping("/usr/ai/mockTrial")
    public String goToMockTrialPage(Model model) {
        // 참고 PDF 자동 저장
        pdfService.loadAndSaveReferencePdfs();
        
        return "usr/ai/mockTrial";
    }
}


