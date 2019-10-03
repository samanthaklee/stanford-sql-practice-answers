-- Highschooler ( ID, name, grade )
-- English: There is a high school student with unique ID and a given first name in a certain grade.
--
-- Friend ( ID1, ID2 )
-- English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).
--
-- Likes ( ID1, ID2 )
-- English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.

-- Find the names of all students who are friends with someone named Gabriel.

select h1.name
from highschooler h1
inner join friend on h1.id = friend.id1
inner join highschooler h2 on friend.id2 = h2.id
where h2.name = 'Gabriel';

-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1
inner join likes on h1.id = likes.id1
inner join highschooler h2 on likes.id2 = h2.id
where h1.grade - h2.grade >= 2;

-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l1, likes l2
where (h1.id = l1.id1 and h2.id = l1.id2) and (h2.id = l2.id1 and h1.id = l2.id2)
and h1.name < h2.name
order by h1.name, h2.name;

-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

select name, grade
from highschooler
where id not in (
    select distinct id1
    from likes
    union
    select distinct id2
    from likes
    )
 order by grade, name;

 -- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes
where (h1.id = likes.id1 and h2.id = likes.id2) and
    h2.id not in (
        select id1 from likes
    );

-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

select name, grade
from highschooler h1
where id not in (
    select id1 from
    friend, highschooler h2
    where h1.id = friend.id1 and h2.id = friend.id2
    and h1.grade != h2.grade
    )
 order by grade, name;

 -- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

 select a.name, a.grade, b.name, b.grade, c.name, c.grade
 from highschooler a, highschooler b, highschooler c, likes, friend f1, friend f2
 where a.id = likes.id1 and b.id = likes.id2 and b.id not in (
     select id2 from friend
     where a.id = friend.id1
     )
  and (a.id = f1.id1 and c.id = f1.id2) and
      (b.id = f2.id1 and c.id = f2.id2)

-- Find the difference between the number of students in the school and the number of different first names.

select count(name) - count(distinct name)
from

-- Find the name and grade of all students who are liked by more than one other student.

select name, grade
from highschooler, likes
where highschooler.id = likes.id2
group by id2
having count(*) > 1;
