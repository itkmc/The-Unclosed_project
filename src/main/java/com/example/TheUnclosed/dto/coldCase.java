package com.example.TheUnclosed.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class coldCase {
	private int id;
	private String mainTitle;
	private String subTitle;
	private String occDate;
	private String occPlace;
	private String bodyFoundDate;
	private String foundPlace;
	private String victim;
	private String investigation;
	
	public String getForPrintInvestigation() {
		return this.investigation.replaceAll("\n", "<br />");
	}
}
