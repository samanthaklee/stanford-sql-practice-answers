-- Highschooler ( ID, name, grade )
-- English: There is a high school student with unique ID and a given first name in a certain grade.
--
-- Friend ( ID1, ID2 )
-- English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).
--
-- Likes ( ID1, ID2 )
-- English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.


-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

delete from highschooler
where grade = 12;

-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

delete from likes
where exists (
    select 1 from friend
    where friend.id1 = likes.id1 and friend.id2 = likes.id2
    )
 and not exists (
     select 1 from likes as l2
     where l2.id1 = likes.id2 and l2.id2 = likes.id1
   );

-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.

insert into friend (id1, id2)
select distinct i1, i2 from (
      select F1.id1 as i1, F2.id2 as i2
      from friend F1  join friend F2 on F1.id2 = F2.id1
      ) as t
where t.i1 != t.i2
and not exists (select 1 from Friend where id1=i1 and id2=i2)
and not exists (select 1 from Friend where id2=i1 and id1=i2)
;
