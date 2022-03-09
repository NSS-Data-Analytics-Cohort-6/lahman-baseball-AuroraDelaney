/*1. What range of years for baseball games played does the provided database cover?

SELECT DISTINCT yearid
FROM collegeplaying;

Answer: 1864-2016

2. Find the name and height of the shortest player in the database. 
How many games did he play in? What is the name of the team for which he played?

SELECT DISTINCT p.playerid, p.height, p.namefirst, p.namelast, a.g_all, t.teamid, t.name
FROM people AS p
LEFT JOIN appearances AS a
ON p.playerid = a.playerid
LEFT JOIN teams AS t
ON a.teamid = t.teamid
ORDER BY p.height;

Answer:Eddie Gaedel, 1, St. Louis Browns

3. Find all players in the database who played at Vanderbilt University.
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
Sort this list in descending order by the total salary earned.
Which Vanderbilt player earned the most money in the majors?

SELECT DISTINCT s.schoolid, s.schoolname, c.playerid 
CONCAT(cast(p.namefirst as text), ' ', cast(p.namelast as text)) AS full_name,
SUM(salary) AS total_salary
FROM schools AS s
LEFT JOIN collegeplaying AS c
ON playerid = a.playerid
LEFT JOIN salaries AS l
ON a.playerid = l.playerid
ORDER BY salary DESC;----scrap that

SELECT DISTINCT CONCAT(cast(p.namefirst as text), ' ', cast(p.namelast as text)) AS full_name,
	   SUM(s.salary) AS total_salary,
	   LOWER(c.schoolid)
FROM people as p
LEFT JOIN salaries as s
ON p.playerid = s.playerid
LEFT JOIN collegeplaying as c
ON s.playerid = c.playerid
WHERE s.salary IS NOT NULL AND c.schoolid IS NOT NULL AND LOWER(C.schoolid) LIKE 'vand%'
GROUP BY full_name, c.schoolid
ORDER BY total_salary DESC

Answer: David Price

4. Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery". 
Determine the number of putouts made by each of these three groups in 2016.

SELECT 
SUM(po) AS total_putout,
CASE WHEN pos = 'OF' THEN 'Outfield'
	 WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR pos = '3B' THEN 'Infield'
	 ELSE 'Battery' END AS position
FROM fielding
WHERE yearid = '2016'
GROUP BY position;

Answer: Battery-41424, Infield-58934, Outfield-29560

5.Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. Do the same for home runs per game. 
Do you see any trends?

SELECT ROUND(AVG(so / g), 2) AS avg_strikeout_pergame,
ROUND(AVG(hr / g), 2) AS avg_homerun_game,
CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
	WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
	WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
	WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
	WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
	WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
	WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
	WHEN yearid BETWEEN 1990 AND 1999 THEN '1990S'
	WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
    WHEN yearid BETWEEN 2010 AND 2020 THEN '2010s'
	END AS decade
FROM teams
WHERE yearid >= 1920
GROUP BY decade
ORDER BY avg_strikeout_pergame DESC;

Answer: The trend here is that you can see a higher avg each year of stikeouts per game per decade than homeruns.

6. Find the player who had the most success stealing bases in 2016, where success is 
measured as the percentage of stolen base attempts which are successful. 
(A stolen base attempt results either in a stolen base or being caught stealing.) 
Consider only players who attempted at least 20 stolen bases.

SELECT SUM(b.sb) * 100.0 / NULLIF(SUM(b.sb + b.cs),0) AS percent_success,
 p.namefirst, p.namelast, sb, cs
 FROM batting AS b
 INNER JOIN people AS p
 ON p.playerid = b.playerid
 WHERE b.yearid = '2016' and sb + cs >= 20
 GROUP BY p.namefirst, p.namelast, sb, cs
 ORDER BY percent_success DESC;
 
 Answer: Chris Owings
 
7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? 
Doing this will probably result in an unusually small number of wins for a world series champion – 
determine why this is the case. Then redo your query, excluding the problem year.
How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
What percentage of the time?*/

SELECT yearid, name, MAX(w)
FROM teams AS t
WHERE wswin = 'N' AND yearid >= '1970'
GROUP BY yearid, name
ORDER BY MAX(w) DESC;
 116-Seattle Mariners
SELECT yearid, name, MIN(w)
FROM teams AS t
WHERE wswin = 'Y'
GROUP BY yearid, name
ORDER BY MIN(w) ASC;
1981 is the problem yr
SELECT yearid, name, MIN(w)
	SUM(yearid <> '1981') OVER( PARTITION BY (w)) AS highest_wins,
FROM teams AS t
WHERE wswin = 'Y'  
GROUP BY yearid, name
ORDER BY MIN(w) ASC;

 