package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dto.EmployeesDto;

public class EmployeesDao {

	// field
	private Connection con;
	private PreparedStatement ps;
	private ResultSet rs;
	private String sql;

	private EmployeesDao() {}
	private static EmployeesDao dao = new EmployeesDao();
	public static EmployeesDao getInstance() {
		return dao;
	}

	// method
	private Connection getConnection() throws Exception {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		String url = "jdbc:oracle:thin:@127.0.0.1:1521:xe";
		String user = "hr";
		String password = "1111";
		return DriverManager.getConnection(url, user, password);
	}
	
	private void close(Connection con, PreparedStatement ps, ResultSet rs) {
		try {
			if (rs != null) { rs.close(); }
			if (ps != null) { ps.close(); }
			if (con != null) { con.close(); }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 부서별 조회
	public List<EmployeesDto> selectEmployeesByDepartmentId(int departmentId) {
		List<EmployeesDto> list = new ArrayList<EmployeesDto>();
		try {
			con = getConnection();
			sql = "SELECT e.first_name" +
			           ", e.last_name" +
			           ", d.department_name AS 부서명" +
					   ", e.salary AS 연봉" +
			           ", e.hire_date AS 입사일 " +
					"FROM departments d INNER JOIN employees e " +
			          "ON d.department_id = e.department_id " +
				   "WHERE e.department_id = ?";
			ps = con.prepareStatement(sql);
			ps.setInt(1, departmentId);
			rs = ps.executeQuery();
			while (rs.next()) {
				EmployeesDto dto = new EmployeesDto();
				dto.setFirstName(rs.getString("first_name"));
				dto.setLastName(rs.getString("last_name"));
				dto.setDepartmentName(rs.getString("부서명"));
				dto.setSalary(rs.getDouble("연봉"));
				dto.setHireDate(rs.getDate("입사일"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(con, ps, rs);
		}
		return list;
	}
	
}