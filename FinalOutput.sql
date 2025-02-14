use digital_marketing;
SHOW DATABASES;
show tables;
select * from finaloutput;

ALTER TABLE finaloutput 
rename COLUMN `Column1` TO `Date`;

#Updating Campaign Names

UPDATE finaloutput 
SET `Ad Campaign` = CASE 
    WHEN `Ad Campaign` = 'Campaign 1' THEN 'Black Friday Sale' 
    WHEN `Ad Campaign` = 'Campaign 2' THEN 'Spring Collection Launch' 
    WHEN `Ad Campaign` = 'Campaign 3' THEN 'New App Promotion' 
    ELSE `Ad Campaign` 
END
WHERE `Ad Campaign` IN ('Campaign 1', 'Campaign 2', 'Campaign 3');

#Updating Platform Names

UPDATE finaloutput 
SET Platform = CASE 
    WHEN Platform = 'Platform A' THEN 'Google Ads' 
    WHEN Platform = 'Platform B' THEN 'Facebook Ads' 
    WHEN Platform = 'Platform C' THEN 'YouTube Ads' 
    WHEN Platform = 'Platform D' THEN 'Instagram Ads' 
    ELSE Platform 
END
WHERE Platform IN ('Platform A', 'Platform B', 'Platform C', 'Platform D');

select * from finaloutput;

#Discretization (binning) involves converting continuous values into discrete categories like Low, Medium, and High.

ALTER TABLE finaloutput ADD COLUMN target_category VARCHAR(10);

UPDATE finaloutput 
SET target_category = 
    CASE 
        WHEN CAST(REPLACE(`Target_Achieved (%)`, '%', '') AS DECIMAL(10,2)) < 10 THEN 'Low'
        WHEN CAST(REPLACE(`Target_Achieved (%)`, '%', '') AS DECIMAL(10,2)) BETWEEN 11 AND 22 THEN 'Medium'
        ELSE 'High'
    END;

select * from finaloutput;
#SET GLOBAL local_infile = 1;

#SELECT * 
#INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output1.csv'
#FIELDS TERMINATED BY ',' 
#ENCLOSED BY '"' 
#LINES TERMINATED BY '\n'
#FROM finaloutput;


