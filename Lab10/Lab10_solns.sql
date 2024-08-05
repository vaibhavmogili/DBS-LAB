1.

create or replace procedure greeting is
begin
	dbms_output.put_line('Good Day To You!');
end;
/

declare
begin
	greeting;
end;
/


2.

create or replace procedure department_courses(dept department.dept_name%TYPE) is
	cursor c1 is select * from instructor where dept_name=dept;
	cursor c2 is select * from course where dept_name=dept;
begin
	open c1;
	dbms_output.put_line('Instructors from ' || dept || ' are: ');
	for c in c1 loop
		dbms_output.put_line('ID: ' || c.id || ' Name: ' || c.name || ' Salary: ' || c.salary);
	end loop;
	close c1;
	open c2;
	dbms_output.put_line('Courses offered by ' || dept || ' are: ');
	for c in c2 loop
		dbms_output.put_line('Course ID: ' || c.course_id);
	end loop;
	close c2;
end;
/

declare
	dname department.dept_name%TYPE;
begin
	dname:='&Enter_Department';
	department_courses(dname);
end;
/


3.

create or replace procedure popular_course is
	cursor c1 is with temp(cid, c_count) as
					(select t.course_id, count(distinct ID) as stu_count
						from takes t, course
						where t.course_id=course.course_id
						group by t.course_id)
					select dept_name, max(c_count) as max_count
					from temp t, course c  
					where t.cid=c.course_id
					group by dept_name;
begin
	for c in c1 loop
		dbms_output.put_line('Department ' || c.dept_name || ' with ' || c.max_count || ' students.');
	end loop;
end;
/

declare  
begin
	popular_course;
end;
/


4.

create or replace procedure students_courses(dname department.dept_name%TYPE) is 
	cursor c1 is select * from student where dept_name=dname;
	cursor c2 is select * from course where dept_name=dname;
begin
	for c in c1 loop
		dbms_output.put_line('ID: ' || c.id || ' Name: ' || c.name || ' Credits: ' || c.tot_cred);
	end loop;
	for c in c2 loop
		dbms_output.put_line('Course ID: ' || c.course_id);
	end loop;
end;
/

declare
	dname department.dept_name%TYPE;
begin
	dname:='&Enter_Department';
	students_courses(dname);
end;
/


5.

create or replace function square(n number)  
	return number as 
	begin
		return (n*n);
	end;
/

declare
	n number;
begin
	n:='&Enter_Number';
	dbms_output.put_line(' Square of ' || n || ' is ' || square(n));
end;
/


6.

create or replace function highest_paid_inst(dept instructor.dept_name%TYPE) as
	cursor c1 is select * from instructor where dept_name=dept order by salary desc;
	inst instructor%ROWTYPE;
begin
	fetch c1 into inst;
	loop 
		exit when c1%ROWCOUNT=1;
		dbms_output.put_line('Highest Paid of ' || dept || ' is: ' || c1.name);
	end loop;
end;
/

declare
	dept instructor.dept_name%TYPE;
begin
	dept:='&Enter_Department';
	highest_paid_inst(dept);
end;
/


create or replace function highest_paid_inst(dept instructor.dept_name%TYPE)
	return instructor%ROWTYPE as
	cursor c1 is select name, dept_name, max(salary) from instructor group by dept_name having dept_name=dept;
	inst instructor%ROWTYPE;
begin
	open c1;
	fetch c1 into inst;
	return inst;
end;
/

declare
	dept instructor.dept_name%TYPE;
	inst instructor%ROWTYPE;
begin
	dept:='&Enter_Department';
	inst=highest_paid_inst(dept);
	dbms_output.put_line('Highest paid of ' || dept || ' is: ' || inst.name);
end;
/


