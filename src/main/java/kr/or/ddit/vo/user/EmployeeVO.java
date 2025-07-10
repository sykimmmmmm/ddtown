package kr.or.ddit.vo.user;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class EmployeeVO extends PeopleVO{
	private String empUsername;
	private String empDepartCode;
	private String empPositionCode;
	private Date empRegDate;
	private Date empEndDate;
	private String empDepartNm;
	private String empPositionNm;

	private Integer artGroupNo;		// 담당 아티스트 그룹 조회용


}
