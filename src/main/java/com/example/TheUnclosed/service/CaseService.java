package com.example.TheUnclosed.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.TheUnclosed.dao.CaseDao;
import com.example.TheUnclosed.dto.Case;

@Service
public class CaseService {
	
	private CaseDao caseDao;
	
	public CaseService(CaseDao caseDao) {
		this.caseDao = caseDao;
	}

	public List<Case> getCases(String mainTitle) {
		return this.caseDao.getCases(mainTitle);
	}

	public Case getColdCase(int id) {
		return this.caseDao.getColdCase(id);
	}

}
