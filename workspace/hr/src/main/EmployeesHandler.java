package main;

import java.util.List;
import java.util.Scanner;

import dao.EmployeesDao;
import dto.EmployeesDto;

public class EmployeesHandler {

	// field
	private EmployeesDao dao = EmployeesDao.getInstance();
	private Scanner sc = new Scanner(System.in);
	
	// method
	public void menu() {
		System.out.println("=====회원조회=====");
		System.out.println("0. 프로그램 종료");
		System.out.println("1. 부서 조회");
		System.out.println("==================");
	}
	public void execute() {
		while (true) {
			menu();
			System.out.print("선택 >>> ");
			switch (sc.nextInt()) {
			case 0 : System.out.println("회원조회 서비스를 종료합니다."); sc.close(); return;
			case 1 : inquiryByDepartmentId(); break;
			}
		}
	}
	// 부서 조회
	public void inquiryByDepartmentId() {
		System.out.print("부서(10~110) 입력 >>> ");
		int departmentId = sc.nextInt();
		List<EmployeesDto> list = dao.selectEmployeesByDepartmentId(departmentId);
		System.out.println("총 사원 수: " + list.size());
		for (EmployeesDto dto : list) {
			System.out.println(dto);
		}
	}
	
}