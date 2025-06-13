package com.example.TheUnclosed.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.TheUnclosed.dto.pdfFile;

@Mapper
public interface PdfDao {
	
    @Select("""
    		SELECT * 
    			FROM pdfFile 
    			WHERE title = #{title}
    		""")
    pdfFile getPdfByTitle(@Param("title") String title);

    @Insert("""
    		INSERT INTO pdfFile (title, content) 
    			VALUES (#{title}, #{content})
    		""")
    void savePdf(@Param("title") String title, @Param("content") String content);
}
