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
- Using Timestamp
```
WITH ds AS (SELECT *, parse_datetime( concat( concat( format_datetime(date, 'yyyy-MM-dd'), '-' ), time ),'yyyy-MM-dd-HH:mm:ss') AS datetime FROM cfn_l) 

SELECT * FROM ds WHERE datetime BETWEEN timestamp '2023-02-02 15:00:00' AND timestamp '2023-02-02 16:00:00'
```
- Ceiling
```
SELECT "uri", count(*) as count, ceiling(sum(bytes)/(1024*1024*1024)) as bytes_dwnl
FROM cloudfront_logs_v2
WHERE "date" BETWEEN DATE '2022-12-01' AND DATE '2023-12-31'
```
- download for a timeframe
```
WITH ds AS (SELECT *, parse_datetime( concat( concat( format_datetime(date, 'yyyy-MM-dd'), '-' ), time ),'yyyy-MM-dd-HH:mm:ss') AS datetime FROM cfn_l) 

SELECT request_ip, uri, ceiling(sum(bytes)/(1024*1024*1024)) FROM ds WHERE datetime BETWEEN timestamp '2023-03-06 00:00:00' AND timestamp '2023-03-07 23:59:00' group by request_ip,URI
```
- Download 
```
WITH ds AS 
    (SELECT *,
         parse_datetime( concat( concat( format_datetime(date,
         'yyyy-MM-dd'), '-' ), time ),'yyyy-MM-dd-HH:mm:ss') AS datetime
    FROM cloudfront_logs)
SELECT uri, sum(bytes) as b
FROM ds
WHERE datetime
    BETWEEN timestamp '2022-04-01 12:00:00'
        AND timestamp '2022-04-01 23:59:59'
        group by uri
``` 
