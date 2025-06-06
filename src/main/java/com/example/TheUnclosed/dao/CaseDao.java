package com.example.TheUnclosed.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.TheUnclosed.dto.coldCase;

@Mapper
public interface CaseDao {
	
	@Select("""
			SELECT * 
				FROM coldCase
				WHERE mainTitle = #{mainTitle}
			""")
	public List<coldCase> getCases(String mainTitle);
}
