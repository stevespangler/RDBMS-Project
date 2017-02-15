CREATE TABLE products(ProductName VARCHAR(40),
					  ProductID INT(2),
					  PRIMARY KEY (ProductID)); 
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/product.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE subproducts(SubProductName VARCHAR(40),
						 SubProductID VARCHAR(5),
						 PRIMARY KEY (SubProductID)); 
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/subproduct.csv'
INTO TABLE subproducts
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE company(CompanyName VARCHAR(60) PRIMARY KEY,
						comphone VARCHAR(16),
                        comstreet VARCHAR(50),
                        comcity VARCHAR(40),
                        comstate VARCHAR(2),
                        comzip VARCHAR(5));
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/company.csv'
INTO TABLE company
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(CompanyName,comphone,comstreet,comcity,comstate,@comzip)
SET comzip = nullif(@comzip,00000);

CREATE TABLE States(StateName VARCHAR(20),
					StateAbb VARCHAR(2) PRIMARY KEY,
					StateArea DECIMAL(9,2),
					StatePop25over INT,
                    StateGraduateDeg DECIMAL (3,1),
                    StateHSorHigher DECIMAL(3,1),
                    StateBachelorsorHigher DECIMAL (3,1),
                    StateMedianEarnings INT,
                    StatePop2010 INT,
                    StatePop2011 INT,
					StatePop2012 INT,
                    StatePop2013 INT,
                    StatePop2014 INT,
                    StatePop2015 INT);
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/states.csv'
INTO TABLE states
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
                    
CREATE TABLE zips(ZipCode VARCHAR(5) PRIMARY KEY,
				  ZipArea DECIMAL(7,3),
                  ZipPop2010 INT,
                  ZipPop2011 INT,
                  ZipPop2012 INT,
                  ZipPop2013 INT,
                  ZipPop2014 INT,
                  ZipPop25over INT,
                  ZipGraduateDeg DECIMAL (4,1),
                  ZipHSorHigher DECIMAL (4,1),
                  ZipBachelorsorHigher DECIMAL (4,1),
                  ZipMedianEarnings INT);
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/zips.csv'
INTO TABLE zips
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;                  

CREATE TABLE consumer(StateAbb VARCHAR(2) REFERENCES states,
                      ZipCode VARCHAR(5) REFERENCES zips,
                      ConsumerID VARCHAR(6) PRIMARY KEY);
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/consumers.csv'
INTO TABLE consumer
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

CREATE TABLE complaints(Rec_Date DATE,
						ProductID VARCHAR(5) REFERENCES products,
                        SubProductID VARCHAR(5) REFERENCES subproducts,
                        Issue VARCHAR(60),
                        Subissue VARCHAR(60),
                        CompanyName VARCHAR(60) REFERENCES company,
                        How_submitted VARCHAR(15),
                        Sent_to_company DATE,
                        ComplaintID VARCHAR(7) PRIMARY KEY,
                        ConsumerID VARCHAR(6) REFERENCES consumer
                        ResponseID INT(7) UNSIGNED PRIMARY KEY AUTO_INCREMENT);
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/complaints.csv'
INTO TABLE complaints
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@Rec_Date, ProductID, SubProductID, Issue, Subissue, CompanyName, How_submitted, @Sent_to_company, ComplaintID, ConsumerID)
SET Rec_Date = str_to_date(@Rec_Date,'%c/%e/%Y'),
Sent_to_company = str_to_date(@Sent_to_company,'%c/%e/%Y'); 				
                        
CREATE TABLE responses(CompanyName VARCHAR(60) REFERENCES company,
					   PublicResponse VARCHAR(130),
                       Response_to_consumer VARCHAR(40),
                       Timely VARCHAR(3),
                       ConsumerDisputed VARCHAR(4),
                       ComplaintID VARCHAR(7) REFERENCES complaints);
LOAD DATA LOCAL INFILE 'C:/Users/Steven Spangler/OneDrive - Georgia State University/CIS 8040/Project/finaltables/responses.csv'
INTO TABLE responses
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE `complaints`.`zips` 
ADD COLUMN `Zip3` VARCHAR(3) NULL AFTER `ZipMedianEarnings`;
UPDATE zips SET Zip3 = left(ZipCode,3);

ALTER TABLE `complaints`.`consumer` 
ADD COLUMN `Zip3` VARCHAR(3) NULL;
UPDATE consumer SET Zip3 = left(ZipCode,3);