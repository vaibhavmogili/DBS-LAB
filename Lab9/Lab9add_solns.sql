1.

declare
	cursor c is select * from instructor order by salary desc;
	inst instructor%ROWTYPE;
begin
	open c;
	loop
		exit when c%ROWCOUNT=10;
		fetch c into inst;
		dbms_output.put_line('Name: ' || inst.name || ' Dept_Name: ' || inst.dept_name || ' Salary: ' || inst.salary);
	end loop;
	close c;
end;
/


2. 

declare 
	cursor c is select * from instructor order by salary desc;
	inst instructor%ROWTYPE;
	cnt numeric(2, 0);
begin
	cnt:=0;
	open c;
	loop
		exit when cnt=10;
		fetch c into inst;
		dbms_output.put_line('Name: ' || inst.name || ' Dept_Name: ' || inst.dept_name || ' Salary: ' || inst.salary);
		cnt:=cnt+1;
	end loop;
	close c;
end;
/


3.

create table Item_Master(
ItemID numeric(5, 0) primary key,
Description varchar(50),
Bal_Stock numeric(3, 0));

insert into Item_Master values(100, 'Chocolates', 30);
insert into Item_Master values(101, 'Milk', 20);
insert into Item_Master values(102, 'Tomatoes', 100);
insert into Item_Master values(103, 'Soap', 15);
insert into Item_Master values(104, 'Brush', 40);

create table Item_Transaction(
TransID numeric(5, 0) primary key,
ItemID numeric(5, 0),
Quantity numeric(3, 0));

declare 
	cursor c(ID Item_Master.ItemID%TYPE) is select * from Item_Master where ItemID=ID;
	item Item_Master%ROWTYPE;
	ID Item_Master.ItemID%TYPE;
	cnt Item_Transaction.TransID%TYPE;
	quan Item_Transaction.Quantity%TYPE;
begin
	cnt:=200;
	ID:='&Enter_ID';
	quan:='&Enter_Quantity';
	open c(ID);
	fetch c into item;
	insert into Item_Transaction values(cnt, ID, quan);
	item.bal_stock:=item.bal_stock-quan;
	update Item_Master set Bal_Stock=item.bal_stock where ItemID=ID;
	close c;
end;
/


4.

declare
	cursor c1(dept department.dept_name%TYPE) is select count(course_id) as courses from department natural join course group by dept_name having dept_name=dept;
	cursor c2(dept department.dept_name%TYPE) is select count(ID) as students from student where dept_name=dept;
	dept department.dept_name%TYPE;
	crs numeric(3, 0);
	sts numeric(3, 0);
begin
	dept:='&Enter_Department';
	open c1(dept);
	open c2(dept);
	fetch c1 into crs;
	fetch c2 into sts;
	dbms_output.put_line('Courses Offered: ' || c1.crs);
	dbms_output.put_line('Number of Students: ' || c1.sts);
	close c1;
	close c2;
end;
/


5.

declare
	cursor c is select count(ID) from takes where course_id='CS-101';
	ID takes.ID%TYPE;
	course_id takes.course_id%TYPE;
	section_id takes.sec_id%TYPE;
	semester takes.semester%TYPE;
	year takes.year%TYPE;
	grade takes.grade%TYPE;
	cnt numeric(3, 0);
begin
    ID:='&Enter_ID';
    course_id:='&Enter_Course';
    section_id:='&Enter_Section';
    semester:='&Enter_Semester';
    year:='&Enter_Year';
  	grade:=0;

  	savepoint before_update;

  	insert into takes values(ID, course_id, section_id, semester, year, grade);
  	open c;
  	fetch c into cnt;	
  	if cnt>30 then rollback to savepoint before_update;
  	end if;
  	commit;
end;
/








