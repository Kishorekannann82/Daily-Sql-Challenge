--Complex(Tricky) SQl Queries
--find the maximum salary without maximum function
--Query
select sal from employee where sal >= all(select sal from emp)
--Another type
select distinct sal from emp1 where sal not in (select sal from emp where sal < any(select sal from emp))