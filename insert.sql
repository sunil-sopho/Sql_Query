CREATE TABLE Author
(
	AuthorId Int,
	name text
);
copy Author from '/home/sunil/courses/sem6/dbms/Assingments/as1/Author.tsv' DELIMITER E'\t';

CREATE TABLE Venue
(
	VenueId Int,
	name text,
	type text
);

copy Venue from '/home/sunil/courses/sem6/dbms/Assingments/as1/Venue.tsv' DELIMITER E'\t';

CREATE TABLE Citation
(
	Paper1Id Int,
	Paper2Id int
);

copy Citation from '/home/sunil/courses/sem6/dbms/Assingments/as1/Citation.tsv' DELIMITER E'\t';

CREATE TABLE Paper
(
	PaperId Int,
	Title text,
	year int,
	VenueId int
);

copy Paper from '/home/sunil/courses/sem6/dbms/Assingments/as1/Paper.tsv' DELIMITER E'\t';

CREATE TABLE PaperByAuthors
(
	PaperId int,
	AuthorId Int
);

copy PaperByAuthors from '/home/sunil/courses/sem6/dbms/Assingments/as1/PaperByAuthors.tsv' DELIMITER E'\t';
