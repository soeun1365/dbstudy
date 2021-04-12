package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.MembersDto;

public class MembersDao {
	
	// field
	private Connection con;		//접속
	private PreparedStatement ps;	//쿼리처리	
	private ResultSet rs;	//select 결과
	private String sql;	
	int result;	//insert, update, delete 결과(실제로 수행된 row개수)
	
	//singleton패턴
	//MembersDao 내부에서 1개의 객체를 미리 생성해두고,
	//getInstance메소드를 통해 외부에서 사용할 수 있도록 처리
	private MembersDao() {}	//private생성자(내부에서만 생성이 가능하다.)
	private static MembersDao dao = new MembersDao(); 	//static : 미리 1개를 만들어 둔다.
	public static MembersDao getInstance() {	//클래스 필드(static 필드)를 사용은 클래스 메소드(static 메소드)만 가능하다.
		return dao;
	}
	
	// getInstance() 메소드 호출방법
	// 클래스 메소드는 클래스로 호출한다.
	//MembersDao dao = MembersDao.getInstance();
	
	//method
	//접속과 접속해제
	//MembersDao 내부에서만 사용하기 때문에 private해도 무방하다.
	private Connection getConnection() throws Exception {  // getConnection() 메소드를 호출하는 곳은 PreparedStatement 클래스를 사용하는 곳으로 어차피 try - catch를 하는 곳이다.
        // getConnection() 메소드를 호출하는 곳으로 예외를 던져버리자.
		Class.forName("oracle.jdbc.driver.OracleDriver");  // ClassNotFoundException
		String url = "jdbc:oracle:thin:@127.0.0.1:1521:xe";
		String user = "spring";
		String password = "1111";
		return DriverManager.getConnection(url, user, password);  // SQLException
		}
	
	private void close(Connection con, PreparedStatement ps, ResultSet rs) {
		try {
			if(rs != null) {rs.close();}
			if(ps != null) {ps.close();}
			if(con != null) {con.close();}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
		
		// 가입(Dao로 전달된 데이터를 BD에 INSERT)
		// (부가: 같은 아이디, 같은 이메일은 가입을 미리 방지)
		public int insertMembers(MembersDto dto) {	//dto(mId, mName, mEmail저장)
			result = 0;
			try {
				con = getConnection();	//커넥션은 무조건 메소드마다 열고 닫는다.
				sql = "INSERT INTO MEMBERS(MNO, MID, MNAME, MEMAIL, MDATE)"
						+ "VALUES(MEMBERS_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";	//? 자리에는 변수가 들어간다.
				ps = con.prepareStatement(sql);
				ps.setNString(1, dto.getmId());	//1번째 ?에 dto.getmId()를 넣는다.
				ps.setString(2, dto.getmName()); //2번째 ?에 getmName()를 넣는다.
				ps.setNString(3, dto.getmEmail()); //3번째 ?에 getmEmail()를 넣는다.
				result = ps.executeUpdate();	//실행결과는 실제로 삽입된 행(row)의 개수이다.	
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, null);
			}
			return result;	//실행결과 반환
		}
		
		// 탈퇴(아이디에 의한 탈퇴)
		public int deleteMembers(String mId) {
			result = 0;
			try {
				con = getConnection();
				sql = "DELETE FROM MEMBERS WHERE MID = ?";
				ps = con.prepareStatement(sql);
				ps.setNString(1, mId);
				result = ps.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, null);
			}
			return result;
		}
		
		// 회원정보수정(아이디에 의한 수정)
		// 수정가능한 요소는 mName, mEmail
		public int updateMembers(MembersDto dto) {
			result = 0;
			try {
				con = getConnection();
				sql = "UPDATE MEMBERS SET MNAME = ?, MEMAIL = ? WHERE MID = ?";
				ps = con.prepareStatement(sql);
				ps.setString(1, dto.getmName());
				ps.setString(2, dto.getmEmail());
				ps.setString(3, dto.getmId());
				result = ps.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, null);
			}
			return result;
		}
		
		// 아이디찾기(mEmail을 통해서 mId찾기)
		public String findIdBymEmail(String mEmail) {
			String findmId = null;
			try {
				con = getConnection();
				sql = "SELECT MID FROM MEMBERS WHERE MEMAIL = ?";	//MEMAIL이 유니크 이기때문에 결과는 죽었다깨어나도 하나라서 순회가 필요없음
				ps = con.prepareStatement(sql);
				ps.setString(1, mEmail);
				rs= ps.executeQuery();	//select문은 executeQuery()메소드, 실행결과는 Resultset
				//일치하는 eMail 있으면 rs.next()의 결과를 사용
				//일치하는 eMail 없으면 rs.next()의 결과가 false
				if(rs.next()) {	//일치하는 mEmail이 있으면,
					//rs에 저장된 칼럼(열)수 : 1개(select절의 칼럼과 일치) --> mId
					//rs.getNString(1) : 1번째 칼럼의 값
					//rs.getString("MID") : MID 칼럼의 값
					findmId = rs.getNString(1);   //findmId = rs.getNString("MID"); 와같음
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, rs);
			}
			return findmId;
		}
		
		//아이디 이메일 중복검사
		public boolean doubleCheck(String mId, String mEmail) {
			boolean result = false;	//join() 불가능하다.
			try {
				con = getConnection();
				sql = "SELECT MNO FROM MEMBERS WHERE MID = ? OR MEMAIL = ?";
				ps = con.prepareStatement(sql);
				ps.setNString(1, mId);
				ps.setNString(2, mEmail);
				rs = ps.executeQuery();
				if(rs.next()) {	//만약 mId와 mEamil중 일치하는 정보가 이미 DB에 없으면
					result = true;	//join() 가능하다.
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, rs);
			}
			return result;
			
		}
		
		// 아이디에 의한 검색
		public MembersDto selectMembersDtoBymId(String mId) {
			MembersDto dto = null;
			try {
				con = getConnection();
				sql = "SELECT MNO, MID, MNAME, MEMAIL, MDATE FROM MEMBERS WHERE MID = ?";
				ps = con.prepareStatement(sql);
				ps.setString(1, mId);
				rs = ps.executeQuery();
				if (rs.next()) {
					dto = new MembersDto(rs.getLong(1),
							             rs.getString(2),
							             rs.getString(3),
							             rs.getString(4), 
							             rs.getDate(5));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close(con, ps, rs);
			}
			return dto;
		}
		
		// 전체검색
		public List<MembersDto> selectMembersList(){
			List<MembersDto> list = new ArrayList<MembersDto>();
			try {
				con = getConnection();
				sql = "SELECT MNO, MID, MNAME, MEMAIL, MDATE FROM MEMBERS";
				ps = con.prepareStatement(sql);
				rs = ps.executeQuery();
				while(rs.next()) {
					list.add(new MembersDto(rs.getLong("MNO"),
											rs.getNString("MID"),
											rs.getNString("MNAME"),
											rs.getNString("MEMAIL"),
											rs.getDate("MDATE")));
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				close(con, ps, rs);
			}
			return list;
		}
	
	
}
