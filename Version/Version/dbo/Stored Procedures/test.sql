CREATE proc [dbo].[test] 
--second line with comment
as
select * from sam where id between 50 and 100 ;

with samct
as
(
--fourth line commit
select * from sam where id between 20 and 40
)
select * from samct
--First line with first commit
