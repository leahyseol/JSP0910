package com.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.exam.vo.AttachVO;

public class AttachDao {
	private static AttachDao instance = new AttachDao();

	public static AttachDao getInstance() {
		return instance;
	}

	private AttachDao() {}
	
	
	// 첨부파일정보 입력하기 메소드
	public void insertAttach(AttachVO attachVO) {
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = DBManager.getConnection();
			String sql = "INSERT INTO attach (uuid, filename, filetype, bno) ";
			sql += "VALUES (?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, attachVO.getUuid());
			pstmt.setString(2, attachVO.getFilename());
			pstmt.setString(3, attachVO.getFiletype());
			pstmt.setInt(4, attachVO.getBno());
			//실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(con, pstmt);
		}
	} // insertAttach method
	
	
}
