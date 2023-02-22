### Example Athena Queries used for CloudFront Data Analysis

- Number of requests, group by IP
```
SELECT  request_ip, count(*)
FROM cfn_l
WHERE "date" BETWEEN DATE '2020-10-01' AND DATE '2020-10-31'
group by request_ip
LIMIT 10000;
```
- details of requests,  by an IP
```
SELECT *
FROM cfn_l
WHERE "date" BETWEEN DATE '2020-10-01' AND DATE '2020-10-31'
AND request_ip = 'xxxxx
```
- number of downloads
```
SELECT  uri, count(*)
FROM cfn_l
WHERE "date" BETWEEN DATE '2020-10-01' AND DATE '2020-10-31'
group by uri
```
-- Using Timestamp
```
WITH ds AS (SELECT *, parse_datetime( concat( concat( format_datetime(date, 'yyyy-MM-dd'), '-' ), time ),'yyyy-MM-dd-HH:mm:ss') AS datetime FROM cfn_l) 

SELECT * FROM ds WHERE datetime BETWEEN timestamp '2023-02-02 15:00:00' AND timestamp '2023-02-02 16:00:00'
```
