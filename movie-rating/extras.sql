-- Movie ( mID, title, year, director )
-- English: There is a movie with ID number mID, a title, a release year, and a director.
--
-- Reviewer ( rID, name )
-- English: The reviewer with ID number rID has a certain name.
--
-- Rating ( rID, mID, stars, ratingDate )
-- English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.

-- Find the names of all reviewers who rated Gone with the Wind.

select distinct reviewer.name
from reviewer, movie, rating
where reviewer.rID = rating.rID
       and movie.mID = rating.mID
       and movie.title = 'Gone with the Wind';

-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

select reviewer.name, movie.title, stars
from rating, movie, reviewer
where rating.rID = reviewer.rID
and rating.mID = movie.mID
and reviewer.name = movie.director
;

-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

select name from reviewer
union
select title from movie
order by name, title;

-- Find the titles of all movies not reviewed by Chris Jackson.

select title from movie
where mID not in (
select mID from rating
left join reviewer on rating.rID = reviewer.rID
where name = 'Chris Jackson'
);

-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.

select distinct name1, name2
from (
    select R1.rID, Re1.name as name1, R2.rID, Re2.name as name2, R1.mID
    from Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
    where R1.mID = R2.mID
    and R1.rID = Re1.rID
    and R2.rID = Re2.rID
    and Re1.name <> Re2.name
    order by Re1.name
  ) as Pair
where name1 < name2
;

-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

select reviewer.name, movie.title, stars
from reviewer, movie, rating
where stars in (select min(stars) from rating)
and reviewer.rid = rating.rid
and rating.mid = movie.mid;

-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

select movie.title, avg(stars) avg_stars
from rating, movie
where rating.mID = movie.mID
group by 1
order by avg_stars desc, title ;

-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

select reviewer.name
from reviewer, rating
where reviewer.rID = rating.rID
group by 1
having count(stars) >= 3;

-- Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

select movie.title, movie.director
from movie
where director in (
    select director from movie
    group by 1
    having count(*)> 1
    )
    order by director, title ;

-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

select title, av
from
(
select movie.title, avg(stars) as av
from rating, movie
where rating.mID = movie.mID
group by title
) a
where av in (select max(av)
    from (select title, avg(stars) av
    from rating, movie
    where rating.mID = movie.mID
    group by title)
    )
;

-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)

select title, av
from
(
select movie.title, avg(stars) as av
from rating, movie
where rating.mID = movie.mID
group by title
) a
where av in (select min(av)
    from (select title, avg(stars) av
    from rating, movie
    where rating.mID = movie.mID
    group by title)
  );

-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

select distinct director, title, stars
from (movie join rating using (mID)) m
where stars in (select max(stars)
                from rating join movie using (mid)
                where m.director = director);
