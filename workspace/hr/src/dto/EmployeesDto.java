package dto;

import java.sql.Date;

public class EmployeesDto {

	// field (칼럼명 snake case -> 필드명 camel case)
	// employees 테이블
	private int employeeId;  // EMPLOYEE_ID NUMBER(6)
	private String firstName;  // FIRST_NAME
	private String lastName;  // LAST_NAME
	private String email;  // EMAIL
	private String phoneNumber;  // PHONE_NUMBER
	private Date hireDate;  // HIRE_DATE
	private String jobId;  // JOB_ID
	private double salary;  // SALARY NUMBER(8,2)
	private double commissionPct;  // COMMISSION_PCT NUMBER(2,2)
	private int managerId;  // MANAGER_ID
	private int departmentId;  // DEPARTMENT_ID

	// departments 테이블
	private String departmentName;  // DEPARTMENT_ID
	
	
	// method
	// Getter and Setter
	public int getEmployeeId() {
		return employeeId;
	}
	public void setEmployeeId(int employeeId) {
		this.employeeId = employeeId;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public Date getHireDate() {
		return hireDate;
	}
	public void setHireDate(Date hireDate) {
		this.hireDate = hireDate;
	}
	public String getJobId() {
		return jobId;
	}
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}
	public double getSalary() {
		return salary;
	}
	public void setSalary(double salary) {
		this.salary = salary;
	}
	public double getCommissionPct() {
		return commissionPct;
	}
	public void setCommissionPct(double commissionPct) {
		this.commissionPct = commissionPct;
	}
	public int getManagerId() {
		return managerId;
	}
	public void setManagerId(int managerId) {
		this.managerId = managerId;
	}
	public int getDepartmentId() {
		return departmentId;
	}
	public void setDepartmentId(int departmentId) {
		this.departmentId = departmentId;
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	@Override
	public String toString() {
		return "[firstName=" + firstName + ", lastName=" + lastName + ", hireDate=" + hireDate
				+ ", salary=" + salary + ", departmentName=" + departmentName + "]";
	}

}