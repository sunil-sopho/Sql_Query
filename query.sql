--PREAMBLE--
Create View cs1160314_PaperAuthor AS
Select Paper.PaperId,Title, Count(AuthorId) as count From
PaperByAuthors,Paper Where PaperByAuthors.PaperId = Paper.PaperId
Group By Paper.PaperId,Paper.Title Order By Count(*);

Create View cs1160314_AuthorMin as
Select AuthorId,min(count) as num from PaperByAuthors, PaperAuthor
Where PaperByAuthors.PaperId = PaperAuthor.PaperId Group By AuthorId
Order by min(count);

Create View cs1160314_PaperAuthorSingle as
Select Count(PaperAuthor.PaperId),AuthorId from PaperAuthor,PaperByAuthors Where
PaperByAuthors.PaperId = PaperAuthor.PaperId and
count = 1 Group By(AuthorId) having Count(PaperAuthor.PaperId) > 50;

Create View cs1160314_journalWriter as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper
 Where PaperByAuthors.AuthorId=Author.AuthorId and 
 PaperByAuthors.PaperId= Paper.PaperId and
 Paper.VenueId In( Select VenueId From Venue 
 Where Venue.type = 'journals' ) Order By Author.AuthorId;

Create View cs1160314_nonjournalWriter as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper
 Where PaperByAuthors.AuthorId=Author.AuthorId and 
 PaperByAuthors.PaperId= Paper.PaperId and
 Paper.VenueId In( Select VenueId From Venue 
 Where Venue.type <> 'journals' ) Order By Author.AuthorId;

Create View cs1160314_Nonjournal as
(Select AuthorId From Author) Except (Select * From journalWriter);

create View cs1160314_journalOnly AS
(Select * From journalWriter ) Except (Select * From nonjournalWriter);

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
Select VenueId From journals Where 
name = 'corr';

Create View cs1160314_amc as 
Select VenueId From journals Where 
name = 'amc'; 

Create View cs1160314_ieicet as
Select VenueId From journals Where 
name = 'ieicet';

Create View cs1160314_tcs AS
Select VenueId From journals Where 
name = 'tcs';

Create View cs1160314_Auth as
Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from ieicet)  Group By(Author.name) having COUNT(*) >= 10 Order by Author.name ;

Create View cs1160314_Auth1 as
Select  Author.name,Count(Author.name) From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from tcs) Group By(Author.name) having COUNT(*) >= 1 Order by Author.name ;

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
Paper.VenueId in (Select * from corr)and Paper.year >=2009 and Paper.year <=2013; 

Create View cs1160314_ieicet9 as
Select DISTINCT Author.AuthorId from Author,PaperByAuthors,Paper where
Author.AuthorId = PaperByAuthors.AuthorId and
Paper.PaperId = PaperByAuthors.PaperId and
Paper.VenueId in (Select * from ieicet)and Paper.year =2009 ; 

create View cs1160314_journalsDetail as
Select count(PaperId),name,
sum(Case when year = 2009 then 1 else 0 end) as year2009 ,
sum(Case when year = 2010 then 1 else 0 end) as year2010 ,
sum(Case when year = 2011 then 1 else 0 end) as year2011 ,
sum(Case when year = 2012 then 1 else 0 end) as year2012 ,
sum(Case when year = 2013 then 1 else 0 end) as year2013 
from Paper,journals Where
year >=2009 and year <=2013 
and Paper.VenueId = journals.VenueId
Group By(name) order By name;

Create View cs1160314_PapersByYear as
Select count(PaperId) as count,name,year from Paper,journals Where
 Paper.VenueId = journals.VenueId
Group By(name,year) order By Count(*),name;

create View cs1160314_big as
Select PaperByAuthors.AuthorId as AuthorName,count(Paper.PaperId) as count,journals.name as name from PaperByAuthors,Paper,journals Where
PaperByAuthors.PaperId = Paper.PaperId and
Paper.VenueId = journals.VenueId 
Group By(AuthorId,journals.name);

Create View cs1160314_max  AS
Select name,Max(count) as count from Big Group By name Order by name;

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
from Paper,journals Where
(year=2008 or year <=2007) 
and Paper.VenueId = journals.VenueId
Group By(name,Paper.VenueId) order By name;


Create View cs1160314_SubCount AS
Select SubPaper.name as name, Sum( Case When Paper78.VenueId = SubPaper.VenueId 
	and (Case When Paper78.PaperId in (Select Paper2Id from Paper9) then TRUE else FALSE end)
 then 1 else 0 end) as count 
From SubPaper,Paper78
Group By(SubPaper.name);


Create View cs1160314_HindexHelper as
select AuthorId,Cited.PaperId,count,
ROW_NUMBER() OVER (PARTITION BY AuthorId ORDER BY count desc) AS PaperNum
 from Cited,PaperByAuthors Where
PaperByAuthors.PaperId = Cited.PaperId Group By(AuthorId,Cited.PaperId,count) Order By AuthorId,count desc
;


--1--
Select type,COUNT(type) AS num  from Paper,Venue Where Paper.VenueId = Venue.VenueId Group By type Order By num desc,type; 

--2--
Select Avg(count) as "the aggregate value" from PaperAuthor;

--3--
Select Distinct Title from PaperAuthor where 
count>20   Order By (Title);

--4--
Select Distinct Author.name From AuthorMin,Author where num > 1 and
Author.AuthorId = AuthorMin.AuthorId
Order By Author.name;


--5--
Select Author.name from Author,PaperByAuthors 
Where PaperByAuthors.AuthorId = Author.AuthorId Group By name Order By COUNT(*) desc,name Limit 20;

--6--
Select name from Author,PaperAuthorSingle Where
PaperAuthorSingle.AuthorId = Author.AuthorId Order By name;

--7--
Select name from Author,Nonjournal Where
Author.AuthorId = Nonjournal.AuthorId Order By name;

 --8--
Select name from Author,journalOnly Where
Author.AuthorId = journalOnly.AuthorId Order By name;

--9--
Select DISTINCT Author.name from Author,Paper12,Paper13 Where
Author.AuthorId = Paper13.AuthorId and Paper13.count > 2 and
Author.AuthorId = Paper12.AuthorId and Paper12.count > 1
Order By Author.name ;

--10--
Select  Author.name From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from corr) Group By(Author.name) Order by Count(*) desc,Author.name Limit 20;

--11--
Select  Author.name From Author,PaperByAuthors,Paper Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
Paper.VenueId in (Select * from amc) Group By(Author.name) having COUNT(*)>3 Order by Author.name ;

--12--
Select Auth.name from Auth Where 
Auth.name NOT IN  (Select Auth1.name from Auth1) Order By Auth.name;

--13--
Select year as "Year",COUNT(*) AS "No. of Publication"  from Paper  where year>=2004 and year <=2013 Group By (year)  Order By year ;

--14--
Select Count(DISTINCT Author.name) as count from Author,Paper,PaperByAuthors Where
Author.AuthorId = PaperByAuthors.AuthorId and 
PaperByAuthors.PaperId = Paper.PaperId and 
lower(Paper.Title) Like '%query%optimization%'; 

--15--
Select Paper.Title From Paper,Cited where
Cited.PaperId = Paper.PaperId Order By Cited.count desc,Paper.Title;

--16--
Select Distinct Paper.Title from Paper,Cited Where 
Paper.PaperId = Cited.PaperId and Cited.count >10 Group By (Paper.Title) Order By Title;

--17--
Select Title from Paper,Cited,Cites Where
Cited.PaperId = Cites.PaperId and
Cited.PaperId = Paper.PaperId and
Cited.count >= 10+Cites.count Order By Title;

--18--
Select Distinct Title from Paper where 
Paper.PaperId Not in (Select PaperId from Cited) Order By Title ;

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
Author.AuthorId In (Select * from corr9to13) and Author.AuthorId Not in 
(Select * from ieicet9 ) Order By name;

--21--
select distinct name from journalsDetail where
year2009 <= year2010 and year2010 <= year2011 and
year2011 <= year2012 and year2012 <= year2013 and 
year2009 != 0
order by name;

--22--
Select name,year from PapersByYear where 
count = (Select Max(count) from PapersByYear)
Order By year,name;

--23--
select Big.name,Author.name from Big,max,Author Where 
Big.name = max.name and
Big.count = max.count and
Big.AuthorName = Author.AuthorId Order By Big.name,Author.name;

--24--
Select journals.name , CAST( (SubCount.count) as real)/(SubPaper.year2007 + SubPaper.year2008) as "impact value" 
 From journals,SubPaper,SubCount 
where journals.name = SubPaper.name and journals.name = SubCount.name AND
( year2008 >0 or year2007 >0) Group By(journals.name,SubCount.count,SubPaper.year2008,SubPaper.year2007);

--25--
Select DISTINCT Author.name ,max(PaperNum) as num from HindexHelper,Author Where
PaperNum <= count and
HindexHelper.AuthorId = Author.AuthorId
Group By Author.name
 Order By num desc,Author.name;

--CLEANUP--

Drop View cs1160314_PaperAuthorSingle;
Drop view cs1160314_AuthorMin;
Drop view cs1160314_PaperAuthor;
Drop View cs1160314_amc;
Drop View cs1160314_journalOnly;
Drop View cs1160314_Nonjournal;
Drop View cs1160314_journalWriter;
Drop View cs1160314_nonjournalWriter;
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
