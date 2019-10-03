-- Highschooler ( ID, name, grade )
-- English: There is a high school student with unique ID and a given first name in a certain grade.
--
-- Friend ( ID1, ID2 )
-- English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).
--
-- Likes ( ID1, ID2 )
-- English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.

-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

select a.name, a.grade, b.name, b.grade, c.name, c.grade
from highschooler a, highschooler b, highschooler c, likes l1, likes l2
where (a.id = l1.id1 and b.id = l1.id2)
    and (b.id = l2.id1 and c.id = l2.id2)
    and a.id != c.id;

-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.

select name, grade
from highschooler h1
where grade not in (
    select grade from highschooler h2, friend
    where h1.id = friend.id1 and h2.id = friend.id2
  );


-- What is the average number of friends per student? (Your result should be just one number.)

select avg(count)
from (
    select count(*) as count
    from friend
    group by id1
  );


-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

select count(*)
from friend
where id1 in (
    select id2 from friend
    where id1 in
        (
        select id from highschooler
        where name = 'Cassandra'
       )
     );


-- Find the name and grade of the student(s) with the greatest number of friends.

select name, grade
from highschooler, friend
where highschooler.id = friend.id1
group by id1
having count(*) = (
    select max(count) from (
    select count(*) as count
    from friend
    group by id1
    )
)
