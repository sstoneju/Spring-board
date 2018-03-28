package com.app.spring.model.dao;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.app.spring.model.dto.BoardVO;

public interface BoardDAO {
	//작성
		public void create(BoardVO vo)throws Exception;
		// 상세
		public BoardVO read(int bno) throws Exception;
		//수정
		public void update(BoardVO vo )throws Exception;
		//삭제
		public void delete(int bno) throws Exception;
		//전체 리스트
		public List<BoardVO> listAll() throws Exception;
		//게시글 조회
		public void increaseViewcnt	(int bno) throws	 Exception;
}
