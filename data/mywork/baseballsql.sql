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
Determine the number of putouts made by each of these three groups in 2016.*/

SELECT 
SUM(po) AS total_putout,
CASE WHEN pos = 'OF' THEN 'Outfield'
	 WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR pos = '3B' THEN 'Infield'
	 ELSE 'Battery' END AS position
FROM fielding
WHERE yearid = '2016'
GROUP BY position;
Answer: Battery-41424, Infield-58934, Outfield-29560