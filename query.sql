--1--
-- Select type,COUNT(type) AS num  from Paper,Venue Where Paper.VenueId = Venue.VenueId Group By type Order By num desc,type; 

--2--

-- @check for non publishers too
-- Select COUNT(PaperId)/CONVERT(decimal(4,2), COUNT(DISTINCT PaperId) )as "the aggregate value" from PaperByAuthors;

--3--

-- Select Title,COUNT(AuthorId) as num from Paper,PaperByAuthors where Paper.PaperId = PaperByAuthors.PaperId  Group By (Title)  having COUNT(*) > 20 Order By (Title);

--4--

-- select name from Author where not exists
--     (select 1 from PaperByAuthors where PaperByAuthors.AuthorId = Author.AuthorId) Order By Author.name;

-- select name from Author left outer join PaperByAuthors on (Author.AuthorId = PaperByAuthors.AuthorId)
-- where PaperByAuthors.AuthorId is null
-- order by Author.name 

--5--

-- Select Author.name,COUNT(PaperId) from Author,PaperByAuthors 
-- Where PaperByAuthors.AuthorId = Author.AuthorId Group By name Order By COUNT(*) desc,name Limit 20;

--6--

-- Select distinct PaperId,agg(name),COUNT(PaperId) from PaperByAuthors,Author Where PaperByAuthors.AuthorId = Author.AuthorId Group By (PaperId) having COUNT(PaperId) = 1;
-- Select name from Author,PaperByAuthors where COUNT()

-- Select PaperId,COUNT(PaperId) from PaperByAuthors,Author  where PaperByAuthors.AuthorId=Author.AuthorId Group By (PaperId) having count(PaperId)=1;

-- Select  DISTINCT PaperId,AuthorId from PaperByAuthors ;

--@check--

--7--

-- @check add condition for no paper person too
-- Select DISTINCT Author.name from Author,PaperByAuthors,Paper
--  Where PaperByAuthors.AuthorId=Author.AuthorId and 
--  PaperByAuthors.PaperId= Paper.PaperId and

--  Paper.VenueId In( Select VenueId From Venue 
--  Where Venue.type <> 'journals' ) Order By Author.name;

 --8--

 -- Select DISTINCT Author.name from Author,PaperByAuthors,Paper
 -- Where PaperByAuthors.AuthorId=Author.AuthorId and 
 -- PaperByAuthors.PaperId= Paper.PaperId and

 -- Paper.VenueId In( Select VenueId From Venue 
 -- Where Venue.type <> 'journals' ) Order By Author.name;


--9--

-- Create View Paper12 as
-- Select PaperByAuthors.PaperId,AuthorId from PaperByAuthors,Paper Where
-- Paper.PaperId = PaperByAuthors.PaperId and Paper.year = 2012 ; 

-- Create View Paper13 as
-- Select PaperByAuthors.PaperId,AuthorId from PaperByAuthors,Paper Where
-- Paper.PaperId = PaperByAuthors.PaperId and Paper.year = 2013 ;

-- Select DISTINCT Author.name from Author Where
-- (Select Count(AuthorId) From Paper12 ) > 1 and (Select Count(AuthorId) From Paper13 ) > 2 Order By Author.name;

-- Drop View Paper12;
-- Drop View Paper13;

--10--
Create View journals as 
Select VenueId,name From Venue Where 
type = 'journals'; 

-- Create View corr as 
-- Select VenueId From journals Where 
-- name = 'corr'; 

-- Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
-- Author.AuthorId = PaperByAuthors.AuthorId and 
-- PaperByAuthors.PaperId = Paper.PaperId and 
-- Paper.VenueId in (Select * from corr) Group By(Author.name) Order by Count(*) desc,Author.name Limit 20;




--11--

-- Create View amc as 
-- Select VenueId From journals Where 
-- name = 'amc'; 

-- Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
-- Author.AuthorId = PaperByAuthors.AuthorId and 
-- PaperByAuthors.PaperId = Paper.PaperId and 
-- Paper.VenueId in (Select * from amc) Group By(Author.name) having COUNT(*)>3 Order by Author.name ;

-- Drop View amc;

--12--

-- Create View ieicet as
-- Select VenueId From journals Where 
-- name = 'ieicet';

-- Create View tcs AS
-- Select VenueId From journals Where 
-- name = 'tcs';

-- Create View Auth as
-- Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
-- Author.AuthorId = PaperByAuthors.AuthorId and 
-- PaperByAuthors.PaperId = Paper.PaperId and 
-- Paper.VenueId in (Select * from ieicet)  Group By(Author.name) having COUNT(*) >= 10 Order by Author.name ;

-- Create View Auth1 as
-- Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
-- Author.AuthorId = PaperByAuthors.AuthorId and 
-- PaperByAuthors.PaperId = Paper.PaperId and 
-- Paper.VenueId in (Select * from tcs) Group By(Author.name) having COUNT(*) >= 1 Order by Author.name ;

-- Select Auth.name from Auth Where 
-- Auth.name NOT IN  (Select Auth1.name from Auth1);


-- Drop View Auth;
-- Drop View Auth1;
-- Drop View tcs;

--13--

-- Select year as "Year",COUNT(*) AS "No. of Publication"  from Paper  where year>=2004 and year <=2013 Group By (year)  Order By year desc; 


--14--

-- Select Count(DISTINCT Author.name) as count from Author,Paper,PaperByAuthors Where
-- Author.AuthorId = PaperByAuthors.AuthorId and 
-- PaperByAuthors.PaperId = Paper.PaperId and 
-- lower(Paper.Title) Like '%query%optimization%'; 

--15--

-- Create View Cited as
-- Select Paper.PaperId,COUNT(Paper2Id) as count from Paper,Citation Where 
-- Paper.PaperId = Citation.Paper2Id Group By (Paper.PaperId) ;

-- Create View Cites as
-- Select Paper.PaperId,COUNT(Paper1Id) as count from Paper,Citation Where 
-- Paper.PaperId = Citation.Paper1Id Group By (Paper.PaperId) ;


-- Select Paper.Title from Paper,Citation Where 
-- Paper.PaperId = Citation.Paper2Id Group By (Paper.Title) Order By COUNT(*) desc,Title;

--16--
-- Select Paper.Title from Paper,Citation Where 
-- Paper.PaperId = Citation.Paper2Id Group By (Paper.Title) having COUNT(*) > 10 Order By COUNT(*) desc,Title;

--17--
-- @check using joint 
-- Select Title from Paper,Cited,Cites Where
-- Cited.PaperId = Cites.PaperId and
-- Cited.PaperId = Paper.PaperId and
-- Cited.count >= 10+Cites.count;




--18--

-- Select Title from Paper where 
-- Paper.PaperId Not in (Select PaperId from Cited) ;

-- Drop view Cites;
-- Drop view Cited;

--19--

-- Select DISTINCT name from Author,PaperByAuthors as Pa1 Where
-- Author.AuthorId = Pa1.AuthorId and
-- exists (Select * from PaperByAuthors as Pa2,Citation Where
-- Pa2.AuthorId = Pa1.AuthorId and 
-- Pa2.PaperId = Citation.Paper1Id and
-- Pa1.PaperId = Citation.Paper2Id
-- ) Order By name;

--20--

-- Create View corr9to13 as
-- Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper where
-- Author.AuthorId = PaperByAuthors.AuthorId and
-- Paper.PaperId = PaperByAuthors.PaperId and
-- Paper.VenueId in (Select * from corr)and Paper.year >=2009 and Paper.year <=2013; 

-- Create View ieicet9to13 as
-- Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper where
-- Author.AuthorId = PaperByAuthors.AuthorId and
-- Paper.PaperId = PaperByAuthors.PaperId and
-- Paper.VenueId in (Select * from ieicet)and Paper.year >=2009 and Paper.year <=2013; 

-- Select Distinct name from Author Where
-- Author.AuthorId In (Select * from corr9to13) and Author.AuthorId Not in 
-- (Select * from ieicet9to13 ) Order By name;


-- Drop View corr9to13;
-- Drop View ieicet9to13;
-- Drop View corr;
-- Drop View ieicet;

--21--


-- create View journalsDetail as
-- Select count(PaperId),name,
-- sum(Case when year = 2009 then 1 else 0 end) as year2009 ,
-- sum(Case when year = 2010 then 1 else 0 end) as year2010 ,
-- sum(Case when year = 2011 then 1 else 0 end) as year2011 ,
-- sum(Case when year = 2012 then 1 else 0 end) as year2012 ,
-- sum(Case when year = 2013 then 1 else 0 end) as year2013 
-- from Paper,journals Where
-- year >=2009 and year <=2013 
-- and Paper.VenueId = journals.VenueId
-- Group By(name) order By name;

-- select distinct name from journalsDetail where
-- year2009 < year2010 and year2010 < year2011 and
-- year2011 < year2012 and year2012 < year2013
-- order by name;

-- Drop View journalsDetail;

--22--
-- Create View PapersByYear as
-- Select count(PaperId) as count,name,year from Paper,journals Where
--  Paper.VenueId = journals.VenueId
-- Group By(name,year) order By Count(*),name;

-- Select name,year from PapersByYear where 
-- count = (Select Max(count) from PapersByYear)
-- Order By year,name;

-- Drop View PapersByYear;

--23--
create View big as
Select Author.name as AuthorName,count(Paper.PaperId) as count,journals.name as name from Author,PaperByAuthors,Paper,journals Where
PaperByAuthors.AuthorId = Author.AuthorId and
PaperByAuthors.PaperId = Paper.PaperId and
Paper.VenueId = journals.VenueId Group By(Author.name,journals.name);

select AuthorName,name from Big Where 
count = (Select Max(count) from Big as b where b.name = Big.name)
;

Drop View journals;
