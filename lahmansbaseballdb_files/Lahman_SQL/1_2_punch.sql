 WITH rotation_spots AS (
SELECT 
	RANK () OVER (
		PARTITION BY
			yearID, teamID
		ORDER BY IPouts DESC
	) rotation_spot,
    yearID as yearID2,
    playerID as playerID2,
    teamID as teamID2
FROM Pitching
), pitching AS (
	SELECT *
    FROM Pitching
    WHERE yearID >= 1947
), top_two AS (
SELECT *
FROM rotation_spots r
JOIN pitching p
	ON p.playerID = r.playerID2
    AND p.teamID = r.teamID2
    AND p.yearID = r.yearID2
WHERE rotation_spot = 1 or rotation_spot = 2
)

SELECT
	teamID,
	yearID,
    RANK() OVER(
		ORDER BY
			SUM(IPouts / 3) DESC) 
            AS IP,
    RANK() OVER(
		ORDER BY
			AVG(ERA)) 
            AS ERA,
	RANK() OVER(
		ORDER BY
			SUM(SO) DESC) 
            as K,
	RANK() OVER(
		ORDER BY
			SUM(BB)) 
            AS BB,
	RANK() OVER(
		ORDER BY
			AVG(HR)) 
            AS HR_allowed ,
	RANK() OVER(
		ORDER BY
			AVG(SO / BB) DESC) 
            AS K_BB,
	RANK() OVER(
		ORDER BY
			AVG(BAopp))
            AS BAopp
FROM top_two
GROUP BY yearID, teamID
ORDER BY 8;
            
			

    
    