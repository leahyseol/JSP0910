<%@page import="java.io.File"%>
<%@page import="java.nio.file.Files"%>
<%@page import="com.exam.dao.AttachDao"%>
<%@page import="com.exam.dao.BoardDao"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.UUID"%>
<%@page import="com.exam.vo.AttachVO"%>
<%@page import="com.exam.vo.BoardVO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//coas library를 이용한 file upload
//MultipartRequest 생성자 호출시에 파일업로드가 완료됨

//필요한 매개값 5개
//1 request 
//2 saveDirectory(업로드 할 경로)
String realPath=application.getRealPath("/upload");
System.out.println("realPath:"+realPath);

//3 최대 업로드 파일크기
int maxSize=1024*1024*10;//10MB

//4 한글처리 "utf-8"

//5 파일이름 중복처리

//파일업로드 수행 완료
MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, "utf-8", 
		new DefaultFileRenamePolicy());



//============= 게시판 글 등록 처리 시작 =================

//자바빈 객체 생성
BoardVO boardVO=new BoardVO();
//파라미터 찾아서 자바빈에 저장
boardVO.setUsername(multi.getParameter("username"));
boardVO.setPasswd(multi.getParameter("passwd"));
boardVO.setSubject(multi.getParameter("subject"));
boardVO.setContent(multi.getParameter("content"));

//글등록날짜, IP주소 값 저장
boardVO.setRegDate(new Timestamp(System.currentTimeMillis()));
boardVO.setIp(request.getRemoteAddr());

//BoardDao 객체 준비
BoardDao boardDao = BoardDao.getInstance();

//게시글 번호 생성하는 메소드 호출
int num = boardDao.nextBoardNum();
//생성된 번호를 자바빈 글번호 필드에 설정
boardVO.setNum(num);
boardVO.setReadcount(0); // 조회수 0
//주글일 경우 
boardVO.setReRef(num); // [글그룹번호]는 글번호와 동일함
boardVO.setReLev(0); // [들여쓰기 레벨] 0
boardVO.setReSeq(0); // [글그룹 안에서의 순서] 0

//게시글 한개 등록하는 메소드 호출 insertBoard(boardVO)
boardDao.insertBoard(boardVO);

//============= 게시판 글 등록 처리 종료 =================




//============= 첨부파일 등록 처리 시작 =================

//업로드한 원본 파일이름 a.ppt
String originalFileName=multi.getOriginalFileName("filename");
System.out.println("originalName:" + originalFileName);

//실제로 업로드 된 파일이름 a1.ppt
String realFileName=multi.getFilesystemName("filename");
System.out.println("realFileName:" + realFileName);

//자바빈 attachVO 객체생성
AttachVO attachVO=new AttachVO();

UUID uuid=UUID.randomUUID();

attachVO.setUuid(uuid.toString());
attachVO.setUploadpath(realPath);
attachVO.setFilename(realFileName);
attachVO.setBno(num);

//이미지 파일 여부 확인
File file = new File(realPath, realFileName);
String contentType=Files.probeContentType(file.toPath());
boolean isImage=contentType.startsWith("image");
if(isImage){
	attachVO.setFiletype("I");
	}else{
		attachVO.setFiletype("O");
}

//attachDao 준비
AttachDao attachDao=AttachDao.getInstance();
//첨부파일정보 한개 등록하는 메소드
attachDao.insertAttach(attachVO);

//============= 첨부파일 등록 처리 종료 =================

//이동 fnotice.jsp
response.sendRedirect("fnotice.jsp");

%>