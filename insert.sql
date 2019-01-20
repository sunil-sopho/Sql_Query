CREATE TABLE Author
(
	AuthorId Int,
	name text
);
copy Author from '/home/sunil/courses/sem6/dbms/Assingments/as1/Author.tsv' DELIMITER E'\t';

copy Venue from '/home/sunil/courses/sem6/dbms/Assingments/as1/Venue.tsv' DELIMITER E'\t';

copy Citation from '/home/sunil/courses/sem6/dbms/Assingments/as1/Citation.tsv' DELIMITER E'\t';

copy Paper from '/home/sunil/courses/sem6/dbms/Assingments/as1/Paper.tsv' DELIMITER E'\t';

copy PaperByAuthors from '/home/sunil/courses/sem6/dbms/Assingments/as1/PaperByAuthors.tsv' DELIMITER E'\t';
