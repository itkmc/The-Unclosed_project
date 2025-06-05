package com.example.TheUnclosed.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.TheUnclosed.dto.Case;

@Mapper
public interface CaseDao {
	
	@Select("""
			SELECT * 
				FROM `case`
				WHERE mainTitle = #{mainTitle}
			""")
	public List<Case> getCases(String mainTitle);
	
	@Select("""
			SELECT *
				FROM `case`
				WHERE id = #{id}
			""") 
	public Case getColdCase(int id);
	
}
