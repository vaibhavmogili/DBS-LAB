1.

create table log_change_takes(
Time_Of_Change timestamp,
ID varchar(5),
Course_ID varchar(8),
Sec_ID varchar(8),
Semester varchar(6),
Year numeric(4, 0),
Grade varchar(2));

create or replace trigger takes_change
	before update on takes
	for each row
	begin
		insert into log_change_takes values(current_timestamp, :OLD.ID, :OLD.Course_ID, :OLD.Sec_ID, :OLD.Semester, :OLD.Year, :OLD.Grade);
	end;
/


2.

create table Old_Data_Instructor(
ID varchar(5),
Name varchar(20),
Dept_Name varchar(20),
Salary numeric(8, 2));

create or replace trigger instructor_change
	before update on instructor
	for each row
	begin
		insert into Old_Data_Instructor values(:OLD.ID, :OLD.Name, :OLD.Dept_Name, :OLD.Salary);
	end;
/


3.

create or replace trigger Check_Instructor
	before insert or update on Instructor
	for each row
	declare
	bud numeric(10, 0);
	begin
		select budget into bud from department where dept_name=:NEW.dept_name;
		if :new.name like '%0%' or :new.name like '%1%' or :new.name like '%2%' or
			:new.name like '%3%' or :new.name like '%4%' or :new.name like '%5%' or 
			:new.name like '%6%' or :new.name like '%7%' or :new.name like '%8%' or
			:new.name like '%9%' then RAISE_APPLICATION_ERROR(-20000, 'Insertion Not Allowed!');
		end if;
		if :new.salary<0 or :new.salary>bud then RAISE_APPLICATION_ERROR(-20000, 'Salary Constraint!');
		end if;
	end;
/


4.

create table Client_Master(
Client_No numeric(5, 0),
Name varchar(20),
Address varchar(50),
Bal_Due numeric(10, 2));

create table Audit_Client(
Client_No numeric(5, 0),
Name varchar(20),
Bal_Due numeric(10, 2),
Operation varchar(15),
Updated date);

create or replace trigger Client_Audit
	before insert or update or delete on Client_Master
	for each row
	begin
		case
			when inserting then
				insert into Audit_Client values(:NEW.Client_No, :NEW.Name, :NEW.Bal_Due, 'Insertion', sysdate);
			when updating then
				insert into Audit_Client values(:OLD.Client_No, :OLD.Name, :OLD.Bal_Due, 'Updation', sysdate);
			when deleting then
				insert into Audit_Client values(:OLD.Client_No, :OLD.Name, :OLD.Bal_Due, 'Deletion', sysdate);
		end case;
	end;
/


5.

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

create or replace trigger Stock_Update
	after insert on Item_Transaction
	for each row
	begin
		update Item_Master set Bal_Stock=Bal_Stock-:NEW.Quantity where Item_Master.ItemID=:NEW.ItemID;
	end;
/


