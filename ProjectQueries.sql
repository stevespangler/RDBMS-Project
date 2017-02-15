#1, which state has the highest rate of complaints? Complaints per person. 

SELECT a.StateAbb,
	  (a.TotComplaint/b.statepop25over)*1000
		as ComplaintsPer1000
FROM 
	(SELECT cn.StateAbb,
      count(cm.complaintid) as TotComplaint
    FROM complaints cm, consumer cn
    WHERE cm.consumerid = cn.consumerid
    GROUP BY cn.stateabb) a
LEFT JOIN
	(SELECT StatePop25over, StateAbb FROM states) b
ON a.StateAbb = b.StateAbb
ORDER BY ComplaintsPer1000 DESC LIMIT 10;
####
SELECT a.StateAbb,
	  (a.TotComplaint/b.statepop25over)*1000
		as ComplaintsPer1000
FROM 
	(SELECT cn.StateAbb,
	  count(cm.complaintid) as TotComplaint
    FROM complaints cm, consumer cn
    WHERE cm.consumerid = cn.consumerid
    GROUP BY cn.stateabb) a
LEFT JOIN
	(SELECT StatePop25over, StateAbb FROM states) b
ON a.StateAbb = b.StateAbb
ORDER BY ComplaintsPer1000 LIMIT 10;

#2, Are there more complaints in areas with higher education? Or in areas with lower education?
select co.Zip3, zi.Bach/zi.Zip3Pop as 'Bach+',
	   zi.Grad/zi.Zip3Pop as 'Grad+',
       zi.NoHS/zi.zip3pop as LessThanHS,
       count(c.complaintid) as TotalComplaintsReceived
from complaints c, consumer co, (SELECT Zip3,
										sum(ZipPop25over) as Zip3Pop,
										sum(zipbachelorsorhigher*zippop25over) as Bach,
										sum(zipgraduatedeg*zippop25over) as Grad,
                                        sum((100-zipHSorHigher)*zippop25over) as NoHS
								FROM zips GROUP BY zip3) zi
where c.consumerid=co.consumerid and co.zip3 = zi.zip3
group by co.zip3
order by TotalComplaintsReceived desc;

 #### CORRECTED, using rate
select co.Zip3, zi.Bach/zi.Zip3Pop as 'Bach+',
	   zi.Grad/zi.Zip3Pop as 'Grad+',
       zi.NoHS/zi.zip3pop as LessThanHS,
       (count(c.complaintid)/zi.Zip3Pop)*1000 as ComplaintsPerThousand
from complaints c, consumer co, (SELECT Zip3,
										sum(ZipPop25over) as Zip3Pop,
										sum(zipbachelorsorhigher*zippop25over) as Bach,
										sum(zipgraduatedeg*zippop25over) as Grad,
                                        sum((100-zipHSorHigher)*zippop25over) as NoHS
								FROM zips GROUP BY zip3) zi
where c.consumerid=co.consumerid and co.zip3 = zi.zip3
group by co.zip3;

#3, Are there more complaints in areas with higher income? Or in areas with lower income?
SELECT co.zip3,
	   zi.TotEarn/zi.TotPop as 'Median Income',
       COUNT(c.complaintid) AS TotalComplaintsReceived
FROM
    complaints c, consumer co,
    (SELECT Zip3,
			sum(ZipMedianEarnings*ZipPop25over) AS TotEarn,
            sum(ZipPop25over) as TotPop
     FROM zips GROUP BY zip3) zi
WHERE c.consumerid = co.consumerid AND co.zip3 = zi.zip3
GROUP BY co.zip3
ORDER BY TotalComplaintsReceived DESC;

    #### CORRECTED
SELECT co.zip3,
	   zi.TotEarn/zi.TotPop as 'Median Income',
       (COUNT(c.complaintid)/zi.Totpop)*1000 AS ComplaintsPer1000
FROM
    complaints c, consumer co,
    (SELECT Zip3,
			sum(ZipMedianEarnings*ZipPop25over) AS TotEarn,
            sum(ZipPop25over) as TotPop
     FROM zips GROUP BY zip3) zi
WHERE c.consumerid = co.consumerid AND co.zip3 = zi.zip3
GROUP BY co.zip3;



SELECT LEFT(zipcode,3) AS zip3, AVG(ZipMedianEarnings)
FROM zips
GROUP BY zip3;
    
SELECT LEFT(zipcode,3) AS zip3
FROM consumer
GROUP BY zip3;

#4, Does certain company have less complaints per population density.
SELECT a.Zip3, z.Density, a.CompanyName, a.NumComplaints
FROM (SELECT DISTINCT Zip3, CompanyName, 
	  count(cm.CompanyName) as NumComplaints
	  FROM complaints cm, consumer cn
      WHERE cm.consumerID = cn.consumerID
      GROUP BY cn.Zip3, cm.CompanyName
      ORDER BY NumComplaints DESC) as a,
	 (SELECT Zip3, sum(ZipPop2014)/sum(ZipArea) as Density
	  FROM zips GROUP BY Zip3) as z
WHERE a.Zip3 = z.Zip3
GROUP BY a.Zip3
ORDER BY z.Density DESC, a.NumComplaints DESC
LIMIT 15;

SELECT a.Zip3, z.Density, a.CompanyName, a.NumComplaints
FROM (SELECT DISTINCT Zip3, CompanyName,
	  count(cm.CompanyName) as NumComplaints
	  FROM complaints cm, consumer cn
      WHERE cm.consumerID = cn.consumerID
      GROUP BY cn.Zip3, cm.CompanyName
      ORDER BY NumComplaints DESC) as a,
	 (SELECT Zip3, sum(ZipPop2014)/sum(ZipArea) as Density
	  FROM zips GROUP BY Zip3) as z
WHERE a.Zip3 = z.Zip3
AND z.Density != 0
AND a.NumComplaints >= 10
GROUP BY a.Zip3
ORDER BY z.Density ASC, a.NumComplaints DESC
LIMIT 15;


#5, Does certain product have more complaints than other product?
SELECT b.ProductName, a.TC as 'Total Complaints'
FROM (SELECT c.ProductID, count(c.ProductID) as TC
	  FROM complaints c
      GROUP BY c.productID) as a
INNER JOIN
	(SELECT p.ProductID, p.ProductName FROM products p) as b
ON a.ProductID = b.ProductID
ORDER BY a.TC DESC;

#6, which company has the higher rate of timely response?
SELECT a.CompanyName, b.YesCount/a.Total as TimelyRate
FROM
	(SELECT CompanyName, count(ComplaintID) as Total
	FROM responses 
	GROUP BY companyname 
	HAVING count(ComplaintID) > 500) a,
	(SELECT CompanyName, count(ComplaintID) as YesCount
	FROM responses WHERE Timely = 'Yes'
	GROUP BY CompanyName
	HAVING count(ComplaintID) > 500) b
WHERE a.CompanyName = b.CompanyName
ORDER BY TimelyRate DESC
LIMIT 25;

SELECT count(a.CompanyName)
FROM
	(SELECT CompanyName, count(ComplaintID) as Total
	FROM responses 
	GROUP BY companyname 
	HAVING count(ComplaintID) > 100) a,
	(SELECT CompanyName, count(ComplaintID) as YesCount
	FROM responses WHERE Timely = 'Yes'
	GROUP BY CompanyName
	HAVING count(ComplaintID) > 100) b
WHERE a.CompanyName = b.CompanyName
AND b.YesCount/a.Total = 1;

#7, which company has the lower rate of the response disputed by consumer?
select CompanyName,count(consumerdisputed) as ConsumerNotDisputed 
from complaints.responses where consumerdisputed="No"
group by CompanyName 
order by ConsumerNotDisputed desc;


SELECT a.CompanyName, b.NoCount/a.Total as NotDisputedRate
FROM
	(SELECT CompanyName, count(ComplaintID) as Total
	FROM responses 
	GROUP BY companyname 
	HAVING count(ComplaintID) > 100) a,
	(SELECT CompanyName, count(ComplaintID) as NoCount
	FROM responses WHERE ConsumerDisputed = 'No'
	GROUP BY CompanyName
	HAVING count(ComplaintID) > 100) b
WHERE a.CompanyName = b.CompanyName
ORDER BY NotDisputedRate DESC
LIMIT 25;

SELECT a.CompanyName, b.NoCount/a.Total as NotDisputedRate
FROM
	(SELECT CompanyName, count(ComplaintID) as Total
	FROM responses 
	GROUP BY companyname 
	HAVING count(ComplaintID) > 500) a,
	(SELECT CompanyName, count(ComplaintID) as NoCount
	FROM responses WHERE ConsumerDisputed = 'No'
	GROUP BY CompanyName
	HAVING count(ComplaintID) > 500) b
WHERE a.CompanyName = b.CompanyName
ORDER BY NotDisputedRate
LIMIT 25;

#Which companies have the highest number of complaints for certain products?

SELECT c.CompanyName, p.ProductName, count(c.ProductID) as NumComplaints
FROM complaints c, products p
WHERE c.ProductID=p.ProductID
AND p.ProductName='Mortgage'
GROUP BY c.CompanyName
ORDER BY NumComplaints DESC
LIMIT 5;

SELECT c.CompanyName, p.ProductName, count(c.ProductID) as NumComplaints
FROM complaints c, products p
WHERE c.ProductID=p.ProductID
AND p.ProductName='Debt collection'
GROUP BY c.CompanyName
ORDER BY NumComplaints DESC
LIMIT 5;

SELECT c.CompanyName, p.ProductName, count(c.ProductID) as NumComplaints
FROM complaints c, products p
WHERE c.ProductID=p.ProductID
AND p.ProductName='Credit reporting'
GROUP BY c.CompanyName
ORDER BY NumComplaints DESC
LIMIT 5;

# Companies receiving the most complaints, with info

SELECT count(cpl.ComplaintID) as NumComplaints,
	   cpl.CompanyName, cpy.ComPhone, cpy.ComStreet,
       cpy.ComCity, cpy.ComState, cpy.ComZip
FROM complaints cpl, company cpy
WHERE cpl.CompanyName = cpy.CompanyName
GROUP BY cpl.CompanyName
ORDER BY NumComplaints DESC
LIMIT 29;

SELECT sum(a.NumComplaints)/b.Tot as 'Percentage of All Complaints'
FROM
	(SELECT count(cpl.ComplaintID) as NumComplaints
	FROM complaints cpl, company cpy
	WHERE cpl.CompanyName = cpy.CompanyName
	GROUP BY cpl.CompanyName ORDER BY NumComplaints DESC LIMIT 30) a,
    (SELECT count(ComplaintID) as Tot FROM complaints) b;
    
# Most common response_to_consumer

SELECT r1.Response_to_consumer,
	   count(r1.ResponseID) as NumResponses,
       count(r1.ResponseID)/r3.Tot as Percentage
FROM responses r1,
	(SELECT count(ResponseID) as Tot
     FROM responses r2) r3
GROUP BY Response_to_consumer
ORDER BY NumResponses DESC;

# All issues, with their counts and corresponding product types

SELECT p.ProductName, c.Issue, count(c.ComplaintID) as NumComplaints
FROM complaints c, products p
WHERE c.ProductID=p.ProductID
GROUP BY c.ProductID, c.Issue
ORDER BY p.ProductName, NumComplaints DESC;

# Fictional consumer

select DISTINCT cm.ProductID, p.ProductName
FROM complaints cm, products p
WHERE cm.ProductID=p.ProductID;

select DISTINCT cm.subProductID, sp.SubProductName
FROM complaints cm, subproducts sp
WHERE cm.subProductID=sp.subProductID; #80880

SELECT DISTINCT sp.subproductname
FROM complaints cm, subproducts sp
WHERE cm.SubProductID = sp.SubProductID
AND cm.ProductID=1;

SELECT cm.CompanyName, count(cm.ComplaintID) as NumComplaints
FROM complaints cm, consumer cn
WHERE cm.consumerID=cn.consumerID
AND cm.SubProductID='80880'
AND cn.Zip3=303
GROUP BY cm.CompanyName
ORDER BY NumComplaints DESC;