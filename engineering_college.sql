-- DATA CLEANING AND EDA USING SQL SERVER

select * from Portfolio_project..engineeringcollege;

-- Analysing [Genders Accepted] 

select  [Genders Accepted] ,count([Genders Accepted]) as 'Count' 
from Portfolio_project..engineeringcollege 
group by [Genders Accepted]
order by 2;

-- Analysing [Campus Size in Acres] 

select engineeringcollege.[Campus Size in Acres] 
from Portfolio_project..engineeringcollege  where [Campus Size in Acres] is not null
order by 1 desc ;

select count(engineeringcollege.[College Name] ) 
from Portfolio_project..engineeringcollege  where [Campus Size in Acres] is  null;


select count(engineeringcollege.[College Name] ) 
from Portfolio_project..engineeringcollege  where [Campus Size in Acres] is not null;


--select substring(engineeringcollege.[Campus Size in Acres],1,CHARINDEX(' ',[Campus Size])-1)
--from engineeringcollege  where [Campus Size in Acres] is not null
--order by [Campus Size] desc;

select
PARSENAME(replace(engineeringcollege.[Campus Size in Acres],' ','.'),2)
from Portfolio_project..engineeringcollege
where [Campus Size in Acres] is not null

update Portfolio_project..engineeringcollege
set  engineeringcollege.[Campus Size in Acres] = PARSENAME(replace(engineeringcollege.[Campus Size in Acres],' ','.'),2);

select sum(cast(engineeringcollege.[Campus Size in Acres] as int))/ count(engineeringcollege.[College Name] ) 
as 'Average Campus size in Acres'
from Portfolio_project..engineeringcollege 
where [Campus Size in Acres] is not  null;

select engineeringcollege.[College Name] from Portfolio_project..engineeringcollege  
where [Campus Size in Acres] is  null ;

--Analysing Total Student Enrollments

select [College Name], [Total Student Enrollments] 
from Portfolio_project..engineeringcollege
where [Total Student Enrollments] is not null
order by 2  desc;

select count(engineeringcollege.[College Name] )
from Portfolio_project..engineeringcollege
where [Total Student Enrollments] is null ;

--Analysing Total faculty

select [College Name], [Total Faculty]
from Portfolio_project..engineeringcollege
where [Total Faculty] is not null AND [Total Faculty]>10
order by 2 desc;

select count(engineeringcollege.[College Name] )
from Portfolio_project..engineeringcollege
where [Total Faculty] is null ;

--Analysing Established year

select [College Name], [Established Year]
from Portfolio_project..engineeringcollege
where [Established Year] is not null 
order by 2 ;

create view CollegeCategorybyYear as
select [College Name],
case when [Established Year] >1857 and [Established Year] <1900 then '1850-1900'
	 when [Established Year] >1900 and [Established Year] <1950 then '1900-1950'
	  when [Established Year] >1950 and [Established Year] <2000 then '1950-2000'
	 else '2000- Present'
	 end as 'Year category'
from Portfolio_project..engineeringcollege
where [Established Year] is not null 
--order by 2 ;

select [Year category], count([Year category]) 
from CollegeCategorybyYear
group by [Year category]
order by 2;

select count(engineeringcollege.[College Name] )
from Portfolio_project..engineeringcollege
where [Established Year] is null ;


--Analysing Rating 
--Most of data is missing here, hence cannot derive any insights.
select [College Name], Rating
from Portfolio_project..engineeringcollege
where Rating is not null 
order by 2 desc;

select count(engineeringcollege.[College Name] )
from Portfolio_project..engineeringcollege
where Rating is  null ;

--Analysing University

select [College Name], University
from Portfolio_project..engineeringcollege
where University is not null 
order by 2 desc;

select count(engineeringcollege.[College Name] )
from Portfolio_project..engineeringcollege
where University is not null ;

alter table engineeringcollege  add university_city_location nvarchar(255);

select
PARSENAME(replace(engineeringcollege.University,', ','.'),2), -- ', ' comma with a space is given, to avoid extra space in university_city_location
PARSENAME(replace(engineeringcollege.University,', ','.'),1)
from Portfolio_project..engineeringcollege ;

update Portfolio_project..engineeringcollege 
set university_city_location = PARSENAME(replace(engineeringcollege.University,', ','.'),1);

update Portfolio_project..engineeringcollege 
set University =PARSENAME(replace(engineeringcollege.University,', ','.'),2) ;

select top 10 University, count(university_city_location) as 'No of College affiliated'
from Portfolio_project..engineeringcollege
group by University
order by 2 desc;

select top 10 University, university_city_location,count(university_city_location) as 'No of College affiliated'
from Portfolio_project..engineeringcollege
group by University,university_city_location
order by 3 desc;

-- Analysing Courses

select [College Name],Courses from Portfolio_project..engineeringcollege 
where Courses is null


--select 
--PARSENAME(replace(Courses,', ','.'),4) 
--from Portfolio_project..engineeringcollege
--where [College Name] = 'Apex Group of Institutions';

--Analysing Facilities

select [College Name],Facilities from Portfolio_project..engineeringcollege 


--Analysing City
select City from Portfolio_project..engineeringcollege  where City is null; 

select City,[College Name] from Portfolio_project..engineeringcollege 
group by City,[College Name];

select top 10 City,count(City) as 'No of Engineering Colleges' 
from Portfolio_project..engineeringcollege
group by City
order by 2 desc;

--Analysing State

select State,[College Name] from Portfolio_project..engineeringcollege 
group by State,[College Name];

select top 10 State,count(State) as 'No of Engineering Colleges'
from Portfolio_project..engineeringcollege
group by State
order by 2 desc;

select top 10 State,(count(State)/5440.0)*100 as '% of Engineering Colleges in India'
from Portfolio_project..engineeringcollege 
group by State
order by 2 desc;

select *,
ROW_NUMBER () over ( 
					partition by [College Name],[Total Student Enrollments],[City],[State] 
					order by [Established Year] ) as row_num

					from Portfolio_project..engineeringcollege
					order by [Established Year];

select [College Name],[Established Year] from Portfolio_project..engineeringcollege
where [College Name]='Government Polytechnic';

with CollegeCTE as(
select *,
ROW_NUMBER () over ( 
					partition by [College Name],[Courses],[Total Student Enrollments],[University],[City]
					order by [Established Year] ) as row_num

					from Portfolio_project..engineeringcollege
					--order by [Established Year]
					)


select * from CollegeCTE where row_num >1


--Analysing Country

select * from Portfolio_project..engineeringcollege 
where Country is null

update Portfolio_project..engineeringcollege 
set Country='India'
where [College Name] ='Ansal University';

--Analysing College type

select *  from Portfolio_project..engineeringcollege 
where [College Type] is  null

update Portfolio_project..engineeringcollege 
set [College Type] ='Private'
where [College Name] ='Ansal University';

update Portfolio_project..engineeringcollege 
set [College Type] ='Public/Government'
where [College Name] ='SV Institute of Engineering and Technology';

select [College Type],count([College Type]) 
from Portfolio_project..engineeringcollege  
group by [College Type] 
order by 2 desc;

select top 10 City,count([College Type]) as 'No of Private colleges'
from Portfolio_project..engineeringcollege  
where [College Type] ='Private'
group by City 
order by 2 desc;

select top 10 State,count([College Type]) as 'No of Private colleges'
from Portfolio_project..engineeringcollege  
where [College Type] ='Private'
group by State 
order by 2 desc;


select top 10 City,count([College Type]) as 'No of Public/Govt colleges'
from Portfolio_project..engineeringcollege  
where [College Type] ='Public/Government'
group by City 
order by 2 desc;

--Analysing Average fees

select  * from Portfolio_project..engineeringcollege 
where [Average Fees] is null

select top 10 City,[College Name],[Average Fees]
from Portfolio_project..engineeringcollege  
group by City,[College Name],[Average Fees]
order by 3 desc;

select top 10 City,Avg([Average Fees])   --Considered at least 25 colleges to decide cheapest and costliest city to study
from Portfolio_project..engineeringcollege  
group by City
having count(City)>25
order by 2 desc;  


--Removing duplicates

delete from Portfolio_project..engineeringcollege 
where [College Name] ='Ansal University'  and
State is NULL;

select * from Portfolio_project..engineeringcollege 
where [College Name]='Ansal University'

with rownumCTE as(
select *,
ROW_NUMBER () over ( 
					partition by [College Name],[Campus Size in Acres],[Total Student Enrollments],[University],[City]
					order by [Established Year] ) as row_num

					from Portfolio_project..engineeringcollege
					where [Campus Size in Acres] is not null and 
					[Total Student Enrollments] is not null
					--order by [Established Year]
					)

select * from rownumCTE where row_num >1

delete from rownumCTE where row_num >1  -- Deleting 'Institute of Engineering and Technology'

select *  from Portfolio_project..engineeringcollege 
where [College Name] in (
'Institute of Engineering and Technology'
) order by [University]





