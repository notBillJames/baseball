WITH upr_list AS(
SELECT
    p.yearid AS Year,
    p.teamID AS Team,
    m.nameFirst,
    m.nameLast,
    p.SO,
    p.ERA,
    p.IPouts / 3 AS innings_pitched,
   ROUND((9 * p.SO / (p.IPouts / 3)), 2) AS Kper9,
    ROUND((p.SO / p.BB), 2) AS SO2BBratio,
    ROUND((p.ERA) / (p.so / p.bb), 2) AS UPR
FROM
    Pitching p
        JOIN
    People m ON p.playerID = m.playerID
WHERE
    p.yearID >= 1900
        AND (p.IPouts / 3) > 100
ORDER BY UPR ASC
), franches AS (
SELECT
	t.teamID,
    t.yearID,
    f.franchID
FROM Teams t
JOIN TeamsFranchises f
	ON f.franchID = t.franchID
)

SELECT 
	p.Year as year,
    f.franchID as franch,
    p.nameFirst,
    p.nameLast,
    p.SO,
    p.ERA,
    p.innings_pitched,
    p.Kper9,
    p.SO2BBratio,
    p.UPR
FROM upr_list p
JOIN franches f
	on f.teamID = p.Team
    and f.yearID = p.Year
ORDER BY p.UPR;
    
