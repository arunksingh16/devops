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
