1.

create table salary_raise(
Instructor_ID varchar(5),
Raise_Date date,
Raise_Amt number(8, 2));

declare
	cursor c(dname instructor.dept_name%TYPE)
	is select * from instructor where dept_name=dname;
	str_dept instructor.dept_name%TYPE;
	inst instructor%ROWTYPE;
begin
	str_dept:='&Enter_Department';
	open c(str_dept);
	loop
		fetch c into inst;
		exit when c%NOTFOUND;
		insert into salary_raise values(inst.ID, sysdate, inst.salary*0.05);
		update instructor set salary=salary*1.05 where id=inst.id;
	end loop;
	close c;
end;
/


2.

declare
	cursor c is select * from student order by tot_cred asc;
	stud student%ROWTYPE;
begin
	open c;
	loop
		fetch c into stud;
		exit when c%ROWCOUNT>10;
		dbms_output.put_line('ID: ' || stud.id || ' Name: ' || stud.name || ' Dept_Name: ' || stud.dept_name || ' Tot_Cred: ' || stud.tot_cred);
	end loop;
	close c;
end;
/


3.

declare
	cursor c is select course_id, title, dept_name, credits
				from course natural join (select course_id, count(*) as tot
    									  from takes group by course_id);
begin
	open c;
	for co in c loop
		dbms_output.put_line('Course ID: ' || co.course_id || ' Title: ' || co.title || ' Dept_Name: ' || co.dept_name || ' Credits: ' || co.credits);
	end loop;
	close c;
end;
/


4.

declare
	cursor c is select * from student natural join takes where course_id='CS-101';
	cred student.tot_cred%TYPE;
	cnt numeric(3, 0);
begin
	cnt:=0;
	open c;
	for s in c loop
		select tot_cred into cred from student where id=s.id;
		if cred<30 then 
			delete from takes where id=s.id and course_id=s.course_id;
			cnt:=cnt+1;
		end if;
	end loop;
	close c;
	dbms_output.put_line('De-registered ' || cnt || ' students.');
end;
/


5.

create table StudentTable(
    RollNo numeric(3, 0),
    GPA numeric(3, 2)
);

insert into StudentTable values(1, 5.8);
insert into StudentTable values(2, 6.5);
insert into StudentTable values(3, 3.4);
insert into StudentTable values(4, 7.8);
insert into StudentTable values(5, 9.5);

alter table studenttable add LetterGrade char(2);
update StudentTable set LetterGrade='F';

declare
	cursor c is select gpa from StudentTable for update;
begin
	for s in c loop
        if s.gpa<4 then update StudentTable set LetterGrade='F' where current of c;
		elsif s.gpa>4 and s.gpa<=5 then update StudentTable set LetterGrade='E' where current of c;
		elsif s.gpa>5 and s.gpa<=6 then update StudentTable set LetterGrade='D' where current of c;
		elsif s.gpa>6 and s.gpa<=7 then update StudentTable set LetterGrade='C' where current of c;
		elsif s.gpa>7 and s.gpa<=8 then update StudentTable set LetterGrade='B' where current of c;
		elsif s.gpa>8 and s.gpa<=9 then update StudentTable set LetterGrade='A' where current of c;
		else update StudentTable set LetterGrade='A+' where current of c;
		end if;
	end loop;
end;


6.

declare
	cursor c(c_id teaches.course_id%TYPE) is select * from instructor natural join teaches where course_id=c_id;
	course teaches.course_id%TYPE;
begin
	course:='&Course';
	for inst in c(course) loop
		dbms_output.put_line(' ID: ' || inst.id || ' Name: ' || inst.name || ' Dept_Name: ' || inst.dept_name || ' Salary: ' || inst.salary);
	end loop;
end;
/


7.




8.

declare
	cursor c is select * from instructor where dept_name='Biology' for update;
	budget department.budget%TYPE;
	sum_sal department.budget%TYPE;
	bud department.budget%TYPE;
begin
    savepoint before_update;
	for s in c loop
		update instructor set salary=salary*1.2 where id=s.id;
	end loop;
	select sum(salary) into sum_sal from instructor where dept_name='Biology';
	select budget into bud from department where dept_name='Biology';

	if sum_sal>bud then rollback to savepoint before_update;
	end if;
	commit;
end;
/


