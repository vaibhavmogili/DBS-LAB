q1.
declare
	year numeric(4, 0);
begin
	year:'&Enter_Year';

	if MOD(year, 4)=0 then
		dbms_output.put_line('It IS a leap year!');
	else
		dbms_output.put_line('It is NOT a leap year!');
	end if;
end;
/


q2.
declare
	day numeric(2, 0);
	month numeric(2, 0);
	year numeric(4, 0);
begin
	day:='&Enter_Day';
	month:='&Enter_Month';
	year:='&Enter_Year';

	if month=1 or month=3 or month=5 or month=7 or month=8 or month=10 or month=12 then
		day:=day+3;
		if day>31 then
			month:=month+1;
			day:=day-31;
		end if;
	elsif month=4 or month=6 or month=9 or month=11 then
		day:=day+3;
		if day>30 then
			month:=month+1;
			day:=day-30;
		end if;
	else
		day:=day+3;
		if day>28 then
			month:=month+1;
			day:=day-28;
		end if;
	end if;

	dbms_output.put_line('Return Date: ' || day || '/' || month || '/' || year);
end;
/

q3.
declare
	counts numeric(3, 0);
	max numeric(3, 0);
begin
	max:=100;
	counts:=0;
	while counts<=100 loop
		dbms_output.put_line('Loop Count: ' || counts);
		counts:=counts+1;
	end loop;
	dbms_output.put_line('Loop Exited!');
end;
/


q4.
declare
	counts numeric(5, 0);
begin
	counts:=0;
	while counts<=100 loop
		if mod(counts, 2)=1 then
			dbms_output.put_line(counts);
		end if;
		counts:=counts+1;
	end loop;
end; 
/


q5.
declare
	string varchar(20);
	revstring varchar(20);
	len numeric(3, 0);
begin
	string:='Saurabh';
	len:=Length(string);

	for i in reverse 1.. len loop
		revstring:=revstring || Substr(string, i, 1);
	end loop;
	dbms_output.put_line('Reverse is: ' || revstring);
end;
/


q6.
declare
	input_number numeric(10, 0);
	rev_number numeric(10, 0);
begin
	input_number:='&Enter_Number';
	rev_number:=0;

	while input_number>0 loop
		rev_number:=(rev_number*10)+MOD(input_number, 10);
		input_number:=floor(input_number/10);
	end loop;
	dbms_output.put_line('Reverse is: ' || rev_number);
end;
/


q7.
create table Product(
	Product_No numeric(3, 0),
	Sell_Price numeric(7, 2)
);

create table Old_Product(
	Product_No numeric(3, 0),
	Date_Change date,
	Old_Price numeric(7, 2)
);

insert into Product values(1, 9000);
insert into Product values(2, 8000);
insert into Product values(3, 1000);
insert into Product values(4, 2000);
insert into Product values(5, 3000);

declare
	counts numeric(3, 0);
	cnt numeric(3, 0);
	details product%ROWTYPE;
begin
	select count(*) into counts from Product;
	cnt:=1;

	while cnt<=counts loop
		select * into details from Product where Product_No=cnt;
		if details.sell_price<4000 then
			insert into Old_Product values(details.Product_No, sysdate, details.sell_price);
			update Product set Sell_Price=4000 where Product_No=details.Product_No;
		end if;
		cnt:=cnt+1;
	end loop;
end;
/


q8.
declare
	first numeric(6, 2);
	second numeric(6, 2);
	result numeric(6, 2);
	operator char(2);
	invalid_operator exception;
	divide_zero exception;
begin
	first:='&Enter_First_Number';
	second:='&Enter_Second_Number';
	operator:='&Enter_Operator';

	if operator='+' then
		dbms_output.put_line(first || operator || second || '=' || (first+second));
	elsif operator='-' then
		dbms_output.put_line(first || operator || second || '=' || (first-second));
	elsif operator='*' then
		dbms_output.put_line(first || operator || second || '=' || (first*second));
	elsif operator='/' then
		if second=0 then 
			raise divide_zero;
		end if;
		dbms_output.put_line(first || operator || second || '=' || (first/second));
	else
		raise invalid_operator;
	end if;

	exception	
		when divide_zero then dbms_output.put_line('Cannot divide by zero!');
		when invalid_operator then dbms_output.put_line('Invalid operator!');
end;
/


		
