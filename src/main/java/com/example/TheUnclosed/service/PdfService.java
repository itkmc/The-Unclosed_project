package com.example.TheUnclosed.service;

import java.io.InputStream;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import com.example.TheUnclosed.dao.PdfDao;

@Service
public class PdfService {
    
	private PdfDao pdfDao;
	private ResourceLoader resourceLoader;
	
	public PdfService(PdfDao pdfDao, ResourceLoader resourceLoader) {
		this.pdfDao = pdfDao;
		this.resourceLoader = resourceLoader;
	}
	
    public void loadAndSaveReferencePdfs() {
        List<String> fileNames = List.of("형법.pdf", "형사소송법.pdf");
        
        for (String fileName : fileNames) {
            try {
                Resource resource = resourceLoader.getResource("classpath:static/resource/pdf/" + fileName);
                if (!resource.exists()) {
                    System.out.println("리소스를 찾을 수 없습니다: " + fileName);
                    continue;
                }

                try (InputStream input = resource.getInputStream()) {
                    PDDocument document = PDDocument.load(input);
                    String text = new PDFTextStripper().getText(document);
                    String title = fileName.replace(".pdf", "");

                    if (pdfDao.getPdfByTitle(title) == null) {
                        pdfDao.savePdf(title, text);
                        System.out.println("저장됨: " + title);
                    } else {
                        System.out.println("이미 저장됨: " + title);
                    }

                    document.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

