create database Library;
use Library;

-- Create tables
create table Branch (Branch_no int primary key,  Manager_Id int,  Branch_address varchar(50), Contact_no varchar(10));
create table Employee(Emp_Id  int primary key, Emp_name varchar(30), Position varchar(25), Salary float, Branch_no int, 
						foreign key (Branch_no) REFERENCES Branch(Branch_no) ON DELETE CASCADE);
create table Books (ISBN int primary key, Book_title varchar(30), Category varchar(30), Rental_Price float, Status varchar(5), Author varchar(30), Publisher varchar(30));
create table Customer (Customer_Id int primary key, Customer_name varchar(30),  Customer_address varchar(50), Reg_date date);
create table IssueStatus (Issue_Id int primary key, Issued_cust int, foreign key (Issued_cust) REFERENCES Customer(Customer_Id), Issue_date date, Isbn_book int,
                            foreign key (Isbn_book) REFERENCES Books(ISBN));
create table ReturnStatus (Return_Id int primary key, Return_cust int, foreign key (Return_cust) REFERENCES Customer(Customer_Id), Return_book_name varchar(30),
							Return_date date, Isbn_book2 int, foreign key (Isbn_book2) REFERENCES Books(ISBN));
                            
insert into Branch values(8, 5, 'Medical', '999999992');
insert into Employee values(7, 'Sulu Santh', 'Professor', 20000, 5);
insert into Books values(10, 'Ancient Civilizations', 'History', 150, 'Yes', 'Felmming Tox', 'Blueberry');
insert into Customer values(10, 'Jim Jane','Lane 1, HY Nagar, Trivandrum', '2023-04-06');
insert into IssueStatus values(9, 6, '2024-05-09', 6);
insert into ReturnStatus values(5, 6, 'The Giving Tree', '2024-06-11', 6);

-- 1. Retrieve the book title, category, and rental price of all available books. 
select Book_title, Category, Rental_Price from Books where Status = 'Yes';

-- 2. List the employee names and their respective salaries in descending order of salary.
select Emp_name, Salary from Employee order by Salary desc;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books. 
select b.Book_title, c.Customer_name from IssueStatus i left join Customer c on i.Issued_cust = c.Customer_Id left join Books b on b.ISBN = i.Isbn_book;

-- 4. Display the total count of books in each category. 
select Category, count(*) as 'Count of Books' from Books group by Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000. 
select Emp_name, Position, Salary from employee where Salary>50000;

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet. 
select Customer_name, Reg_Date from Customer where 
                                        Reg_Date < '2022-01-01' and 
										Customer_Id not in (select c.Customer_Id from Customer c right join Issuestatus i on c.Customer_Id = i.Issued_cust);

-- 7. Display the branch numbers and the total count of employees in each branch. 
select b.Branch_no, b.Branch_address, count(e.Emp_Id) as 'Count of Employees' from Branch b left join Employee e on b.Branch_no = e.Branch_no group by b.Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
-- select Customer_name from Customer where Customer_Id in (select Issued_cust from Issuestatus where month(Issue_date) = 6 and year(Issue_date) = '2023');
select c.Customer_name, i.Issue_date from Customer c right join Issuestatus i on c.Customer_Id = i.Issued_cust where month(i.Issue_date) = 6 and year(i.Issue_date) = '2023';

-- 9. Retrieve book_title from book table containing history. 
select Book_title as 'History Books' from Books where Category='History';

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
select Branch_no, count(*) as 'Count of Employees' from employee group by Branch_no;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
select e.Emp_name, b.Branch_address from employee e join branch b on e.Branch_no = b.Branch_no where e.Position='HOD';

-- 12.  Display the names of customers who have issued books with a rental price higher than Rs. 25.
create view Issued_books as select b.rental_price, b.book_title, b.ISBN, i.Issued_cust from Books b right join Issuestatus i on b.ISBN = i.Isbn_book;
select c.Customer_name, i.rental_price, i.book_title from Customer c right join Issued_books i on c.Customer_Id = i.Issued_cust where i.rental_price > 25;

