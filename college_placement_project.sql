create database College_Placement_Analytics;
use College_Placement_Analytics; 
create table Departments(
department_id int,
department_name varchar(50)
);
insert into Departments(department_id,department_name)values
(1,'BCA'),
(2,'B.Com'),
(3,'BBA'),
(4,'B.Sc Computer Science');
select*from Departments;

create table Students(
student_id int,
student_name varchar(100),
gender varchar(10),
department_id int,
graduation_year int);
insert into Students(student_id,student_name,gender,department_id,graduation_year)values
(101,'priya','female',1,2027),
(102,'arun','male',1,2027),
(103,'divya','female',2,2027),
(104,'karthik','male',3,2027),
(105,'meena','female',4,2027);
select*from Students;
alter table Students add primary key(student_id);
describe Students;

create table Skills(
skill_id int primary key,
skill_name varchar(50));
insert into Skills(skill_id,skill_name)values
(1,'SQL'),
(2,'Python'),
(3,'Excel'),
(4,'Power BI'),
(5,'Tableau');
select*from Skills;

create table Student_Skills(
student_id int,
skill_id int,
skill_level varchar(20),
primary key(student_id,skill_id));
insert into Student_Skills(student_id,skill_id,skill_level)values
(101,1,'intermediate'),
(101,3,'beginner'),
(102,2,'advanced'),
(102,1,'interrmediate'),
(103,4,'beginner'),
(103,3,'intermediate'),
(104,5,'beginner'),
(105,2,'intermediate');
select*from Student_Skills;

select Students.student_name, Skills.skill_name, Student_Skills.skill_level from Students
join Student_Skills on Students.student_id=Student_Skills.student_id
join Skills on Student_Skills.skill_id=Skills.skill_id;

create table Projects(
project_id int primary key,
student_id int,
project_name varchar(100),
technology_used varchar(100),
completion_status varchar(20));
insert into Projects(project_id,student_id,project_name,technology_used,completion_status)values
(1,101,'sales analysis','sql','completed'),
(2,101,'student dashboard','power bi','completed'),
(3,102,'data cleaning','python','completed'),
(4,103,'college survey analysis','excel','in progress'),
(5,104,'business report','tableau','completed'),
(6,105,'placement analysis','sql','in progress');
select*from Projects

create table Placements(
placement_id int primary key,
student_id int,
company_name varchar(100),
job_role varchar(100),
salary_lpa decimal(5,2),
placement_status varchar(20));
insert into Placements(placement_id,student_id,company_name,job_role,salary_lpa,placement_status)values
(1,101,'TCS','data analyst',4.50,'placed'),
(2,102,'infosys','python developer',5.00,'placed'),
(3,103,null,null,null,'not placed'),
(4,104,'wipro','business analyst',3.80,'placed'),
(5,105,null,null,null,'not placed');
select*from  Placements;

select count(*)as total_students from Students;

select count(*)as placed_student from Placements
where placement_status = 'placed';

select count(*)as placed_student from Placements
where placement_status = 'not placed';

select round(sum(case when  placement_status = 'placed' then 1 else 0 end)* 100.0/count(*),2)as placement_percentage from Placements;

select max(salary_lpa) as highest_salary from Placements;

select round(avg(salary_lpa),2) as average_salary from Placements 
where placement_status = 'placed';

select Students.student_name, Placements.company_name,Placements.salary_lpa from Students
join Placements on Students.student_id = Placements.student_id
where Placements.salary_lpa >4;

select Departments.department_name,count(*)as placed_students from Students
join Departments on Students.department_id = Departments.department_id
join Placements on Students.student_id = Placements.student_id
where Placements.placement_status = 'placed'
group by Departments.department_name;

select Skills.skill_name,count(Student_skills.student_id) as total_students from Skills
join Student_skills on Skills.skill_id = Student_Skills.skill_id
group by Skills.skill_name
order by total_students desc;

select Skills.skill_name,count(distinct Students.student_id) as placed_students from Students
join Student_Skills on Students.student_id = Student_Skills.student_id
join Skills on Student_Skills.skill_id = Skills.skill_id 
join Placements on Students.student_id = Placements.student_id
where Placements.placement_status ='placed'
group by Skills.skill_name
order by placed_students desc;
select count(distinct Students.student_id) from Students

select completion_status, count(*) as total_projects from Projects
group by completion_status;

select Students.student_name, Projects.project_name, projects.technology_used from Students
join Projects on Students.student_id=Projects.student_id
where Projects.completion_status='completed';

select Students.student_name, count(Projects.project_id) as completed_projects from Students
left join Projects on Students.student_id = Projects.student_id and Projects.completion_status='completed'
group by Students.student_id,Students.student_name 
having count(Projects.project_id)=0;

select Students.student_name, Departments.department_name, Placements.placement_status, Placements.company_name, Placements.job_role, Placements.salary_lpa
from Students
join Departments on Students.department_id = Departments.department_id
left join Placements on Students.student_id = Placements.student_id
order by Students.student_name;

select d.department_name, count(s.student_id)as total_students,
sum(case when p.placement_status = 'placed' then 1 else 0 end) as placed_students,
round(100.0*sum(case when p.placement_status = 'placed' then 1 else 0 end)/ nullif(count(s.student_id),0),2) as placement_percentage from Departments d
left join Students s on d.department_id = s.department_id
left join Placements p on s.student_id = p.student_id 
group by d.department_id,d.department_name
order by placement_percentage desc;

create view Student_Placement_Report as
select s.student_id,
s.student_name,
d.department_name,
p.placement_status,
p.company_name,
p.job_role,
p.salary_lpa from Students s
join Departments d on s.department_id = d.department_id
left join Placements p on s.student_id = p.student_id;

select * from Student_Placement_Report;