package com.example.TheUnclosed.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class pdfFile {
	private int id;
	private String title;
	private String content;
}
