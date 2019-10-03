-- Movie ( mID, title, year, director )
-- English: There is a movie with ID number mID, a title, a release year, and a director.
--
-- Reviewer ( rID, name )
-- English: The reviewer with ID number rID has a certain name.
--
-- Rating ( rID, mID, stars, ratingDate )
-- English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.


-- Find the titles of all movies directed by Steven Spielberg.

select title
from movie
where director = 'Steven Spielberg';

-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select distinct year from movie
where mID in (
    select mID from rating
    where stars in (4,5)
);

-- Find the titles of all movies that have no ratings.

select title from movie
where mID not in (
select mID from rating
);

-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

select reviewer.name
from rating, reviewer
where rating.rID = reviewer.rID
and ratingDate is null;

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select reviewer.name reviewer_name, movie.title, stars, ratingDate
from rating
left join movie on rating.mID = movie.mID
left join reviewer on rating.rID = reviewer.rID
order by reviewer_name, title, stars;

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

select reviewer.name reviewer_name, movie.title
from movie
inner join rating r1 on movie.mID = r1.mID
inner join reviewer on reviewer.rID = r1.rID
inner join rating r2 on r2.rID = reviewer.rID
where r1.mID = r2.mID
      and r1.ratingDate < r2.ratingDate
      and r1.stars < r2.stars;

-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

select title, max(stars)
from rating
left join movie on rating.mID = movie.mID
group by 1
order by title ;

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select title, (max(stars) - min(stars)) spread
from rating
inner join movie on rating.mID = movie.mID
group by 1
order by spread desc, title ;

-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

select avg(before_1980.avg) - avg(after_1980.avg) from

(select avg(stars) avg
from rating
inner join movie on rating.mID = movie.mID
where year > 1980
group by rating.mID
) after_1980,

 (
select avg(stars) avg
from rating
inner join movie on rating.mID = movie.mID
where year < 1980
group by rating.mID
) before_1980;
