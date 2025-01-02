# Write your MySQL query statement below
WITH Playersinfo AS (
    SELECT match_id, first_player AS player_id, first_score AS score FROM matches
    UNION ALL
    SELECT match_id, second_player AS player_id, second_score AS score FROm matches
),
PlayerGroup AS (
    SELECT playersinfo.player_id, group_id, SUM(score) AS TotalScores
    FROM Playersinfo
    LEFT JOIN Players 
    ON Playersinfo.player_id = players.player_id
    GROUP BY player_id, group_id
),
GroupRank AS (
    SELECT player_id, group_id, DENSE_RANK() OVER (PARTITION BY group_id ORDER BY TotalScores DESC, player_id) AS GroupRanks
    FROM PlayerGroup
)

SELECT group_id, player_id FROM GroupRank
WHERE GroupRanks = 1

