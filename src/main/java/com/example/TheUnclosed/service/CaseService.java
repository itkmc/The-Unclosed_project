package com.example.TheUnclosed.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.TheUnclosed.dao.CaseDao;
import com.example.TheUnclosed.dto.coldCase;

@Service
public class CaseService {
	
	private CaseDao caseDao;
	
	public CaseService(CaseDao caseDao) {
		this.caseDao = caseDao;
	}

	public List<coldCase> getCases(String mainTitle) {
		return this.caseDao.getCases(mainTitle);
	}
}
