pragma solidity >=0.4.21 <0.6.0;

// Using Kelsen framework for authentification of stakeholders.
// More info on https://github.com/97network/Kelsen
// What you need to know for this session: https://github.com/97network/Kelsen/blob/master/docs/01_standardOrgan.md
import "./utils/Kelsen/solidity/contracts/Organ.sol";

/*
Exam points manager

Students and teachers are registered in studentsOrgan and teachersOrgan respectively.
Smart contracts that are allowed to credit points are registered in exercicesOrgan.

The grade of each student is registered in the grades mapping. 
*/


contract pointsManager {

	// Pointing at Kelsen organs listing stakeholders
  address payable public teachersOrgan;
  address payable public exercicesOrgan;
  address payable public studentsOrgan;

  constructor( address payable _studentsOrgan, address payable _teachersOrgan, address payable _exercicesOrgan) public {
    teachersOrgan = _teachersOrgan;
    exercicesOrgan = _exercicesOrgan;
    studentsOrgan = _studentsOrgan;
  }

  mapping(address => uint) public grades;

  // Function for exercices to attribute points
  function grantPoints(uint _points, address _studentAddress) public onlyExercices {
  	grades[_studentAddress] += _points;

  }

  // Function for the teacher to attribute extra points, if students find a bug in exercices for example
  function grantExtraPoint(uint _extraPoints, address _studentAddress) public onlyTeachers {
  	grades[_studentAddress] += _extraPoints;
  }


  modifier onlyExercices() {
    Organ exercicesOrganInstance = Organ(exercicesOrgan);
    require(exercicesOrganInstance.getAddressPositionInNorm(msg.sender) != 0);
    _;
  }

  modifier onlyTeachers() {
    Organ teachersOrganInstance = Organ(teachersOrgan);
    require(teachersOrganInstance.getAddressPositionInNorm(msg.sender) != 0);
    _;
  }

}
