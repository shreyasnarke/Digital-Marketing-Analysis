use digital_marketing;
SHOW DATABASES;
show tables;
select * from output;

#Convert to Decimal
#>>>>>>1
#UPDATE output 
#SET 
#    `Display ads` = ROUND(`Display ads`, 2),
#    `Non-skippable ads` = ROUND(`Non-skippable ads`, 2),
#    `Bumper ads` = ROUND(`Bumper ads`, 2),
#	`Clicks` = ROUND(`Clicks`, 2)
#WHERE 
#    `Display ads` IS NOT NULL 
#    OR `Non-skippable ads` IS NOT NULL 
#    OR `Bumper ads` IS NOT NULL
#    OR `Clicks` IS NOT NULL;

#>>>>>>2
UPDATE output 
SET 
    `Avg Pages Visited` = ROUND(`Avg Pages Visited`, 2),
    `AVG Time on Site (mins)` = ROUND(`AVG Time on Site (mins)`, 2),
    `Impressions` = ROUND(`Impressions`, 2),
    `Clicks` = ROUND(`Clicks`, 2),
    `Conversions` = ROUND(`Conversions`, 2),
    `Quantity Sold` = ROUND(`Quantity Sold`, 2),
    `Unit Cost Price` = ROUND(`Unit Cost Price`, 2),
    `Unit Sale Price` = ROUND(`Unit Sale Price`, 2),
    `Final Cost Price` = ROUND(`Final Cost Price`, 2),
    `Final Sale Price` = ROUND(`Final Sale Price`, 2),
    `CPI` = ROUND(`CPI`, 2),
    `CPC` = ROUND(`CPC`, 2),
    `Revenue` = ROUND(`Revenue`, 2),
    `Profit` = ROUND(`Profit`, 2),
    `Ad Spend` = ROUND(`Ad Spend`, 2),
    `ROAS(Return on Ad Spend)` = ROUND(`ROAS(Return on Ad Spend)`, 2),
    `Budget Allocation` = ROUND(`Budget Allocation`, 2),
    `Budget_Utilization` = ROUND(`Budget_Utilization`, 2),
    `Sales Target` = ROUND(`Sales Target`, 2),
    `Target_Achieved (%)` = ROUND(`Target_Achieved (%)`, 2)
WHERE 1;

#>>>>>>>>>3
#Dynamic Query to Round All Numeric Columns

#SELECT CONCAT('UPDATE output SET ', 
#              GROUP_CONCAT(CONCAT('`', column_name, '` = ROUND(`', column_name, '`, 2)') SEPARATOR ', '), 
#              ' WHERE 1;') 
#INTO @sql_query
#FROM INFORMATION_SCHEMA.COLUMNS 
#WHERE TABLE_NAME = 'output' 
#AND DATA_TYPE IN ('decimal', 'double', 'float', 'numeric');

#PREPARE stmt FROM @sql_query;
#EXECUTE stmt;
#DEALLOCATE PREPARE stmt;
#select * from output;

UPDATE output 
SET 
    `Display ads` = FLOOR(`Display ads`),  -- Removes decimals
    `Clicks` = FLOOR(`Clicks`),            -- Removes decimals
    `Quantity Sold` = FLOOR(`Quantity Sold`),
    `Target_Achieved (%)` = FLOOR(`Target_Achieved (%)`),
    `Budget Allocation` = FLOOR(`Budget Allocation`),
    `Budget_Utilization` = FLOOR(`Budget_Utilization`)
WHERE 1;

select * from output;

#Updating Campaign Names

UPDATE output 
SET `Ad Campaign` = CASE 
    WHEN `Ad Campaign` = 'Campaign 1' THEN 'Black Friday Sale' 
    WHEN `Ad Campaign` = 'Campaign 2' THEN 'Spring Collection Launch' 
    WHEN `Ad Campaign` = 'Campaign 3' THEN 'New App Promotion' 
    ELSE `Ad Campaign` 
END
WHERE `Ad Campaign` IN ('Campaign 1', 'Campaign 2', 'Campaign 3');

#Updating Platform Names

UPDATE output 
SET Platform = CASE 
    WHEN Platform = 'Platform A' THEN 'Google Ads' 
    WHEN Platform = 'Platform B' THEN 'Facebook Ads' 
    WHEN Platform = 'Platform C' THEN 'YouTube Ads' 
    WHEN Platform = 'Platform D' THEN 'Instagram Ads' 
    ELSE Platform 
END
WHERE Platform IN ('Platform A', 'Platform B', 'Platform C', 'Platform D');

select * from output;

#Update ROAS to Percentage Format

ALTER TABLE output MODIFY COLUMN `ROAS(Return on Ad Spend)` VARCHAR(50);

UPDATE output 
SET `ROAS(Return on Ad Spend)` = CONCAT(ROUND(`ROAS(Return on Ad Spend)` * 100, 2), '%');

select * from output;

#Update "Target Achieved (%)" to Proper Percentage Format

#ALTER TABLE output MODIFY COLUMN `Target_Achieved (%)` VARCHAR(50);
#UPDATE output 
#SET `Target_Achieved (%)` = CONCAT(ROUND(`Target_Achieved (%)`, 2), '%');

#select * from output;

#Discretization (binning) involves converting continuous values into discrete categories like Low, Medium, and High.

ALTER TABLE output ADD COLUMN target_category VARCHAR(10);

UPDATE output 
SET target_category = 
    CASE 
        WHEN CAST(REPLACE(`Target_Achieved (%)`, '%', '') AS DECIMAL(10,2)) < 0.05 THEN 'Low'
        WHEN CAST(REPLACE(`Target_Achieved (%)`, '%', '') AS DECIMAL(10,2)) BETWEEN 0.05 AND 0.3 THEN 'Medium'
        ELSE 'High'
    END;

select * from output;

UPDATE output 
SET 
    `Budget Allocation` = ROUND(`Budget Allocation`, 0),
    `Budget_Utilization` = ROUND(`Budget_Utilization`, 0);

select * from output;

SET GLOBAL local_infile = 1;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/output1.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
FROM output;

