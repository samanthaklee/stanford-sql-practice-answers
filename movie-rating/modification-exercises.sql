-- Movie ( mID, title, year, director )
-- English: There is a movie with ID number mID, a title, a release year, and a director.
--
-- Reviewer ( rID, name )
-- English: The reviewer with ID number rID has a certain name.
--
-- Rating ( rID, mID, stars, ratingDate )
-- English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.


-- Add the reviewer Roger Ebert to your database, with an rID of 209.
insert into reviewer
    values (209, 'Roger Ebert');


-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

insert into Rating
  select Reviewer.rID , Movie.mID, 5, null from Movie
  left outer join Reviewer
  where Reviewer.name='James Cameron';


-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

update movie
    set year = year + 25
    where mId in (
       select mID from (
        select mID, avg(stars) from rating
        where mID = rating.mID
        group by 1
        having avg(stars) >= 4
        )
      );


-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

delete from rating
where mID in (
    select mID from movie
    where (movie.year < 1970 or movie.year > 2000)
  )
and rating.stars < 4;
