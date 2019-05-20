/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT  name
FROM Facilities
WHERE membercost <> 0


/* Q2: How many facilities do not charge a fee to members? */
5

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid,  name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost <> 0
and membercost < monthlymaintenance*0.2

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
       (case when monthlymaintenance > 100 then 'expensive' else 'cheap' end) costlabel
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT *
FROM Members 
WHERE joindate=(SELECT max(joindate) 
                 FROM Members 
                )

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT distinct 
    Facilities.name as facname,
    concat(Members.firstname,',',surname) as memname
FROM Bookings , Members, Facilities
WHERE Bookings.facid = Facilities.facid
  and Bookings.memid = Members.memid
  and lower(Facilities.name) like '%tennis%court%'
ORDER BY concat(Members.firstname,',',surname)

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT distinct
      Facilities.name as facname,
      concat(Members.firstname,',',surname) as memname,
      (case when Members.memid = 0 then Facilities.guestcost else Facilities.membercost end) cost
FROM Bookings , Members, Facilities
WHERE Bookings.facid = Facilities.facid
  and Bookings.memid = Members.memid
  and left(Bookings.starttime, 10)='2012-09-14'
  and (case when Members.memid = 0 then Facilities.guestcost else Facilities.membercost end) > 30
ORDER BY Facilities.membercost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT f.name as facname,
       concat(m.firstname,',',m.surname) as memname,
       (case when m.memid = 0 then f.guestcost else f.membercost end) as cost
FROM
(SELECT distinct memid, facid
 FROM Bookings
 WHERE left(Bookings.starttime, 10)='2012-09-14') b,
Members m,
Facilities f
WHERE b.memid = m.memid and b.facid = f.facid
  and (case when m.memid = 0 then f.guestcost else f.membercost end) > 30

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT 
      Facilities.name as facname,
      sum((case when Members.memid = 0 then Facilities.guestcost else Facilities.membercost end)*Bookings.slots) Q3_Revenue
FROM Bookings , Members, Facilities
WHERE Bookings.facid = Facilities.facid
  and Bookings.memid = Members.memid
GROUP BY Facilities.name
HAVING Q3_Revenue < 1000

