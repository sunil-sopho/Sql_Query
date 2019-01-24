--PREAMBLE--
Create View cs1160314_PaperAuthor AS
Select Paper.PaperId,Title, Count(AuthorId) as count From
PaperByAuthors,Paper Where PaperByAuthors.PaperId = Paper.PaperId
Group By Paper.PaperId,Paper.Title Order By Count(*);

Create View cs1160314_AuthorMin as
Select AuthorId,min(count) as num from PaperByAuthors, cs1160314_PaperAuthor
Where PaperByAuthors.PaperId = cs1160314_PaperAuthor.PaperId Group By AuthorId
Order by min(count);

Create View cs1160314_PaperAuthorSingle as
Select Count(cs1160314_PaperAuthor.PaperId),AuthorId from cs1160314_PaperAuthor,PaperByAuthors Where
PaperByAuthors.PaperId = cs1160314_PaperAuthor.PaperId and
count = 1 Group By(AuthorId) having Count(cs1160314_PaperAuthor.PaperId) > 50;

Create View cs1160314_journalWriter as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper
 Where PaperByAuthors.AuthorId=Author.AuthorId and 
 PaperByAuthors.PaperId= Paper.PaperId and
 Paper.VenueId In( Select VenueId From Venue 
 Where Venue.type = 'journals' ) Order By Author.AuthorId;

Create View cs1160314_cs1160314_nonjournalWriter as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper
 Where PaperByAuthors.AuthorId=Author.AuthorId and 
 PaperByAuthors.PaperId= Paper.PaperId and
 Paper.VenueId In( Select VenueId From Venue 
 Where Venue.type <> 'journals' ) Order By Author.AuthorId;

Create View cs1160314_Nonjournal as
(Select AuthorId From Author) Except (Select * From cs1160314_journalWriter);

create View cs1160314_journalOnly AS
(Select * From cs1160314_journalWriter ) Except (Select * From cs1160314_cs1160314_nonjournalWriter);

Create View cs1160314_Paper12 as
Select AuthorId,Count(PaperByAuthors.PaperId) as count from PaperByAuthors,Paper Where
Paper.PaperId = PaperByAuthors.PaperId and Paper.year = 2012 Group By AuthorId; 

Create View cs1160314_Paper13 as
Select AuthorId,Count(PaperByAuthors.PaperId) as count from PaperByAuthors,Paper Where
Paper.PaperId = PaperByAuthors.PaperId and Paper.year = 2013 Group By AuthorId;

Create View cs1160314_journals as 
Select VenueId,name From Venue Where 
type = 'journals'; 

Create View cs1160314_corr as 
Select VenueId From cs1160314_journals Where 
name = 'corr';

Create View cs1160314_amc as 
Select VenueId From cs1160314_journals Where 
name = 'amc'; 

Create View cs1160314_ieicet as
Select VenueId From cs1160314_journals Where 
name = 'ieicet';

Create View cs1160314_tcs AS
Select VenueId From cs1160314_journals Where 
name = 'tcs';

Create View cs1160314_Auth as
Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from cs1160314_ieicet)  Group By(Author.name) having COUNT(*) >= 10 Order by Author.name ;

Create View cs1160314_Auth1 as
Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from cs1160314_tcs) Group By(Author.name) having COUNT(*) >= 1 Order by Author.name ;

Create View cs1160314_Cited as
Select Paper.PaperId,COUNT(Paper2Id) as count from Paper,Citation Where 
Paper.PaperId = Citation.Paper2Id Group By (Paper.PaperId) order by count ;

Create View cs1160314_Cites as
Select Paper.PaperId,COUNT(Paper1Id) as count from Paper,Citation Where 
Paper.PaperId = Citation.Paper1Id Group By (Paper.PaperId) ;

Create View cs1160314_corr9to13 as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper where
Author.AuthorId = PaperByAuthors.AuthorId and
Paper.PaperId = PaperByAuthors.PaperId and
Paper.VenueId in (Select * from cs1160314_corr)and Paper.year >=2009 and Paper.year <=2013; 

Create View cs1160314_ieicet9 as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper where
Author.AuthorId = PaperByAuthors.AuthorId and
Paper.PaperId = PaperByAuthors.PaperId and
Paper.VenueId in (Select * from cs1160314_ieicet)and Paper.year =2009 ; 

create View cs1160314_journalsDetail as
Select count(PaperId),name,
sum(Case when year = 2009 then 1 else 0 end) as year2009 ,
sum(Case when year = 2010 then 1 else 0 end) as year2010 ,
sum(Case when year = 2011 then 1 else 0 end) as year2011 ,
sum(Case when year = 2012 then 1 else 0 end) as year2012 ,
sum(Case when year = 2013 then 1 else 0 end) as year2013 
from Paper,cs1160314_journals Where
year >=2009 and year <=2013 
and Paper.VenueId = cs1160314_journals.VenueId
Group By(name) order By name;

Create View cs1160314_PapersByYear as
Select count(PaperId) as count,name,year from Paper,cs1160314_journals Where
 Paper.VenueId = cs1160314_journals.VenueId
Group By(name,year) order By Count(*),name;

create View cs1160314_big as
Select PaperByAuthors.AuthorId as AuthorName,count(Paper.PaperId) as count,cs1160314_journals.name as name from PaperByAuthors,Paper,cs1160314_journals Where
PaperByAuthors.PaperId = Paper.PaperId and
Paper.VenueId = cs1160314_journals.VenueId 
Group By(AuthorId,cs1160314_journals.name);

Create View cs1160314_max  AS
Select name,Max(count) as count from cs1160314_Big Group By name Order by name;

Create View cs1160314_Paper9 as
Select PaperId,Paper2Id from Citation,Paper Where
Paper1Id = PaperId and Paper.year=2009
;

Create View cs1160314_Paper78 as
Select *from Paper Where
 (Paper.year=2007 or Paper.year = 2008)
;

Create View cs1160314_SubPaper as
Select count(PaperId),name,Paper.VenueId as VenueId, 
sum(Case when year = 2008 then 1 else 0 end) as year2008 ,
sum(Case when year = 2007 then 1 else 0 end) as year2007 
from Paper,cs1160314_journals Where
(year=2008 or year <=2007) 
and Paper.VenueId = cs1160314_journals.VenueId
Group By(name,Paper.VenueId) order By name;


Create View cs1160314_SubCount AS
Select cs1160314_SubPaper.name as name, Sum( Case When cs1160314_Paper78.VenueId = cs1160314_SubPaper.VenueId 
	and (Case When cs1160314_Paper78.PaperId in (Select Paper2Id from cs1160314_Paper9) then TRUE else FALSE end)
 then 1 else 0 end) as count 
From cs1160314_SubPaper,cs1160314_Paper78
Group By(cs1160314_SubPaper.name);


Create View cs1160314_HindexHelper as
select AuthorId,cs1160314_Cited.PaperId,count,
ROW_NUMBER() OVER (PARTITION BY AuthorId ORDER BY count desc) AS PaperNum
 from cs1160314_Cited,PaperByAuthors Where
PaperByAuthors.PaperId = cs1160314_Cited.PaperId Order By AuthorId,count desc
;

Create View cs1160314_HindexSerprator as 
Select AuthorId,count,PaperNum From cs1160314_HindexHelper Where
count >= PaperNum;

--1--
Select type,COUNT(type) AS num  from Paper,Venue Where Paper.VenueId = Venue.VenueId Group By type Order By num desc,type; 

--2--
Select Avg(count) as "the aggregate value" from cs1160314_PaperAuthor;

--3--
Select Distinct Title from cs1160314_PaperAuthor where 
count>20   Order By (Title);

--4--
Select Distinct Author.name From cs1160314_AuthorMin,Author where num > 1 and
Author.AuthorId = cs1160314_AuthorMin.AuthorId
Order By Author.name;

--5--
Select Author.name from Author,PaperByAuthors 
Where PaperByAuthors.AuthorId = Author.AuthorId Group By name Order By COUNT(*) desc,name Limit 20;

--6--
Select name from Author,cs1160314_PaperAuthorSingle Where
cs1160314_PaperAuthorSingle.AuthorId = Author.AuthorId Order By name;

--7--
Select name from Author,cs1160314_Nonjournal Where
Author.AuthorId = cs1160314_Nonjournal.AuthorId Order By name;

--8--
Select name from Author,cs1160314_journalOnly Where
Author.AuthorId = cs1160314_journalOnly.AuthorId Order By name;

--9--
Select DISTINCT Author.name from Author,cs1160314_Paper12,cs1160314_Paper13 Where
Author.AuthorId = cs1160314_Paper13.AuthorId and cs1160314_Paper13.count > 2 and
Author.AuthorId = cs1160314_Paper12.AuthorId and cs1160314_Paper12.count > 1
Order By Author.name ;

--10--
Select  Author.name From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from cs1160314_corr) Group By(Author.name) Order by Count(*) desc,Author.name Limit 20;

--11--
Select  Author.name From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from cs1160314_amc) Group By(Author.name) having COUNT(*)>3 Order by Author.name ;

--12--
Select cs1160314_Auth.name from cs1160314_Auth Where 
cs1160314_Auth.name NOT IN  (Select cs1160314_Auth1.name from cs1160314_Auth1) Order By cs1160314_Auth.name;

--13--
Select year as "Year",COUNT(*) AS "No. of Publication"  from Paper  where year>=2004 and year <=2013 Group By (year)  Order By year ;

--14--
Select Count(DISTINCT Author.name) as count from Author,Paper,PaperByAuthors Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
lower(Paper.Title) Like '%query%optimization%'; 

--15--
Select Paper.Title From Paper,cs1160314_Cited where
cs1160314_Cited.PaperId = Paper.PaperId Order By cs1160314_Cited.count desc,Paper.Title;

--16--
Select Distinct Paper.Title from Paper,cs1160314_Cited Where 
Paper.PaperId = cs1160314_Cited.PaperId and cs1160314_Cited.count >10 Group By (Paper.Title) Order By Title;

--17--
Select Title from Paper,cs1160314_Cited,cs1160314_Cites Where
cs1160314_Cited.PaperId = cs1160314_Cites.PaperId and
cs1160314_Cited.PaperId = Paper.PaperId and
cs1160314_Cited.count >= 10+cs1160314_Cites.count Order By Title;

--18--
Select Distinct Title from Paper where 
Paper.PaperId Not in (Select PaperId from cs1160314_Cited) Order By Title ;

--19--
Select DISTINCT name from Author,PaperByAuthors as Pa1 Where
Author.AuthorId = Pa1.AuthorId and
exists (Select * from PaperByAuthors as Pa2,Citation Where
Pa2.AuthorId = Pa1.AuthorId and 
Pa2.PaperId = Citation.Paper1Id and
Pa1.PaperId = Citation.Paper2Id and
Citation.Paper1Id != Citation.Paper2Id
) Order By name;

--20--
Select Distinct name from Author Where
Author.AuthorId In (Select * from cs1160314_corr9to13) and Author.AuthorId Not in 
(Select * from cs1160314_ieicet9 ) Order By name;

-- 21--
select distinct name from cs1160314_journalsDetail where
year2009 <= year2010 and year2010 <= year2011 and
year2011 <= year2012 and year2012 <= year2013 and 
year2009 != 0
order by name;

--22--
Select name,year from cs1160314_PapersByYear where 
count = (Select Max(count) from cs1160314_PapersByYear)
Order By year,name;

--23--
select cs1160314_Big.name,Author.name from cs1160314_Big,cs1160314_max,Author Where 
cs1160314_Big.name = cs1160314_max.name and
cs1160314_Big.count = cs1160314_max.count and
cs1160314_Big.AuthorName = Author.AuthorId Order By cs1160314_Big.name,Author.name;

--24--
Select cs1160314_journals.name , CAST( (cs1160314_SubCount.count) as float)/(cs1160314_SubPaper.year2007 + cs1160314_SubPaper.year2008) as "impact value" 
 From cs1160314_journals,cs1160314_SubPaper,cs1160314_SubCount 
where cs1160314_journals.name = cs1160314_SubPaper.name and cs1160314_journals.name = cs1160314_SubCount.name AND
( year2008 >0 or year2007 > 0) Group By(cs1160314_journals.name,cs1160314_SubCount.count,cs1160314_SubPaper.year2008,cs1160314_SubPaper.year2007) Order By journals.name;

--25--
Select DISTINCT Author.name ,max(PaperNum) as index from cs1160314_HindexSerprator,Author Where
cs1160314_HindexSerprator.AuthorId = Author.AuthorId
Group By Author.name
Order By index desc,Author.name;

--CLEANUP--
Drop View cs1160314_HindexSerprator;
Drop View cs1160314_PaperAuthorSingle;
Drop view cs1160314_AuthorMin;
Drop view cs1160314_PaperAuthor;
Drop View cs1160314_amc;
Drop View cs1160314_journalOnly;
Drop View cs1160314_Nonjournal;
Drop View cs1160314_journalWriter;
Drop View cs1160314_cs1160314_nonjournalWriter;
Drop View cs1160314_Paper12;
Drop View cs1160314_Paper13;
Drop View cs1160314_Auth;
Drop View cs1160314_Auth1;
Drop View cs1160314_tcs;
Drop View cs1160314_HindexHelper;
Drop View cs1160314_SubCount;
Drop View cs1160314_SubPaper;
Drop View cs1160314_Paper78;
Drop View cs1160314_Paper9;
Drop View cs1160314_max;
Drop View cs1160314_Big;
Drop View cs1160314_PapersByYear;
Drop View cs1160314_journalsDetail;
Drop View cs1160314_ieicet9;
Drop View cs1160314_corr9to13;
Drop View cs1160314_corr;
Drop View cs1160314_ieicet;
Drop view cs1160314_Cites;
Drop view cs1160314_Cited;
Drop View cs1160314_journals;
