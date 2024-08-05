1.
create table StudentTable(
    RollNo numeric(3, 0),
    GPA numeric(3, 2)
);

insert into StudentTable values(1, 5.8);
insert into StudentTable values(2, 6.5);
insert into StudentTable values(3, 3.4);
insert into StudentTable values(4, 7.8);
insert into StudentTable values(5, 9.5);

declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
begin
	roll:='&Roll';
	select gpa into gpa1 from studenttable where rollno=roll;
	dbms_output.put_line(gpa1);
end;
/


2.
declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
	grade char(2);
begin
	roll:='&Roll';
	select gpa into gpa1 from studenttable where rollno=roll;

	if gpa1<4 then grade:='F';
	elsif gpa1>=4 and gpa1<5 then grade:='E';
	elsif gpa1>=5 and gpa1<6 then grade:='D';
	elsif gpa1>=6 and gpa1<7 then grade:='C';
	elsif gpa1>=7 and gpa1<8 then grade:='B';
	elsif gpa1>=8 and gpa1<9 then grade:='A';
	else grade:='A+';
	end if;

	dbms_output.put_line('Grade is: ' || grade);
end;
/


3.
declare
	issue_date date:='&Issue_Date';
	return_date date:='&Return_Date';
	days number(4);
	fine number(5);
begin
	days:=return_date-issue_date;
	
	if days<=7 then fine:=0;
	elsif days>=8 and days<=15 then fine:=((days-7)*1);
	elsif days>=16 and days<=30 then fine:=(8*1+(days-15)*2);
	else fine:=(8*1+15*2+(days-30)*5);
	dbms_output.put_line('Fine is: ' || fine);
	end if;
end;
/


4.
declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
	grade char(2);
	counts numeric(1, 0);
begin
	counts:=1;
	while counts<=5 loop
		select gpa into gpa1 from studenttable where rollno=counts;
		if gpa1<4 then grade:='F';
		elsif gpa1>=4 and gpa1<5 then grade:='E';
		elsif gpa1>=5 and gpa1<6 then grade:='D';
		elsif gpa1>=6 and gpa1<7 then grade:='C';
		elsif gpa1>=7 and gpa1<8 then grade:='B';
		elsif gpa1>=8 and gpa1<9 then grade:='A';
		else grade:='A+';
		end if;
		dbms_output.put_line('Grade of Student ' || counts || ' is ' || grade);
		counts:=counts+1;
	end loop;
end;
/


5.
alter table studenttable add LetterGrade char(2);

declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
	grade char(2);
	counts numeric(1, 0);
begin
	counts:=1;
	while counts<=5 loop
		select gpa into gpa1 from studenttable where rollno=counts;
		if gpa1<4 then grade:='F';
		elsif gpa1>=4 and gpa1<5 then grade:='E';
		elsif gpa1>=5 and gpa1<6 then grade:='D';
		elsif gpa1>=6 and gpa1<7 then grade:='C';
		elsif gpa1>=7 and gpa1<8 then grade:='B';
		elsif gpa1>=8 and gpa1<9 then grade:='A';
		else grade:='A+';
		end if;
		update studenttable set LetterGrade=grade where rollno=counts;
		counts:=counts+1;
	end loop;
end;
/


6.
declare
	maxroll studenttable.rollno%TYPE;
	maxgpa studenttable.gpa%TYPE;
	gpa1 studenttable.gpa%TYPE;
	counts numeric(1, 0);
begin
	counts:=1;
	maxgpa:=0;
	while counts<=5 loop
		select gpa into gpa1 from studenttable where rollno=counts;
		if gpa1>maxgpa then maxgpa:=gpa1;
		maxroll:=counts;
		end if;
		counts:=counts+1;
	end loop;
	dbms_output.put_line('Studen with Max. GPA is ' || maxroll || ' with ' || maxgpa);
end;
/


7.
declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
	grade char(2);
	counts numeric(1, 0);
begin
	counts:=1;
	<<up>>
	select gpa into gpa1 from studenttable where rollno=counts;
	if gpa1<4 then grade:='F';
	elsif gpa1>=4 and gpa1<5 then grade:='E';
	elsif gpa1>=5 and gpa1<6 then grade:='D';
	elsif gpa1>=6 and gpa1<7 then grade:='C';
	elsif gpa1>=7 and gpa1<8 then grade:='B';
	elsif gpa1>=8 and gpa1<9 then grade:='A';
	else grade:='A+';
	end if;
	dbms_output.put_line('Grade of Student ' || counts || ' is ' || grade);
	counts:=counts+1;
	if counts<=5 then GOTO up;
	end if;
end;
/


8.
declare 
	inst_name instructor.name%TYPE;
	count_inst numeric(2, 0);
	no_inst exception;
	mult_inst exception;
	inst_details instructor%ROWTYPE;
begin
	inst_name:='&Instructor_Name';
	select count(*) into count_inst from instructor where name=inst_name;
	
	if count_inst=0 then raise no_inst;
	elsif count_inst>1 then raise mult_inst;
	else
		select * into inst_details from instructor where name=inst_name;
		dbms_output.put_line('ID: ' || inst_details.id || '  Name: ' || inst_details.name || '  Department: '
			 || inst_details.dept_name || '  Salary: ' || inst_details.salary);
	end if;

	exception
		when no_inst then
			dbms_output.put_line('No instructors found!');
		when mult_inst then 
			dbms_output.put_line('Multiple instructors found!');
end;
/


9.
declare
	roll studenttable.rollno%TYPE;
	gpa1 studenttable.gpa%TYPE;
	grade char(2);
	counts numeric(1, 0);
	out_of_range exception;
begin
	counts:=1;
	while counts<=5 loop
		select gpa into gpa1 from studenttable where rollno=counts;
		if gpa1<0 or gpa1>10 then raise out_of_range;
		elsif gpa1<4 then grade:='F';
		elsif gpa1>=4 and gpa1<5 then grade:='E';
		elsif gpa1>=5 and gpa1<6 then grade:='D';
		elsif gpa1>=6 and gpa1<7 then grade:='C';
		elsif gpa1>=7 and gpa1<8 then grade:='B';
		elsif gpa1>=8 and gpa1<9 then grade:='A';
		else grade:='A+';
		end if;
		update studenttable set LetterGrade=grade where rollno=counts;
		counts:=counts+1;
	end loop;

	exception
		when out_of_range then dbms_output.put_line('Invalid GPA!');
end;
/