--1--
-- Select type,COUNT(type) AS num  from Paper,Venue Where Paper.VenueId = Venue.VenueId Group By type Order By num desc,type; 

--2--


-- Select COUNT(PaperId)/COUNT(DISTINCT PaperId) as "the aggregate value" from PaperByAuthors;

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

-- Select PaperId,COUNT(PaperId),count(name) from PaperByAuthors,Author  where PaperByAuthors.AuthorId=Author.AuthorId Group By (PaperId) having count(PaperId)=1;

Select  DISTINCT PaperId,AuthorId from PaperByAuthors ;