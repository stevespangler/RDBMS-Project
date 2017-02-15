ALTER TABLE `complaints`.`responses` 
DROP PRIMARY KEY;
alter table responses add column `ResponseID` int(10) unsigned primary key auto_increment;

ALTER TABLE `complaints`.`states` 
CHANGE COLUMN `Pop25over` `StatePop25over` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `GraduateDeg` `StateGraduateDeg` DECIMAL(3,1) NULL DEFAULT NULL ,
CHANGE COLUMN `HSorHigher` `StateHSorHigher` DECIMAL(3,1) NULL DEFAULT NULL ,
CHANGE COLUMN `BachelorsorHigher` `StateBachelorsorHigher` DECIMAL(3,1) NULL DEFAULT NULL ,
CHANGE COLUMN `MedianEarnings` `StateMedianEarnings` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2010` `StatePop2010` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2011` `StatePop2011` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2012` `StatePop2012` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2013` `StatePop2013` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2014` `StatePop2014` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2015` `StatePop2015` INT(11) NULL DEFAULT NULL ;

ALTER TABLE `complaints`.`zips` 
CHANGE COLUMN `Pop2010` `ZipPop2010` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2011` `ZipPop2011` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2012` `ZipPop2012` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2013` `ZipPop2013` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop2014` `ZipPop2014` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `Pop25over` `ZipPop25over` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `GraduateDeg` `ZipGraduateDeg` DECIMAL(4,1) NULL DEFAULT NULL ,
CHANGE COLUMN `HSorHigher` `ZipHSorHigher` DECIMAL(4,1) NULL DEFAULT NULL ,
CHANGE COLUMN `BachelorsorHigher` `ZipBachelorsorHigher` DECIMAL(4,1) NULL DEFAULT NULL ,
CHANGE COLUMN `MedianEarnings` `ZipMedianEarnings` INT(11) NULL DEFAULT NULL ;

ALTER TABLE `complaints`.`states` 
CHANGE COLUMN `State` `StateAbb` VARCHAR(2) NOT NULL ;

ALTER TABLE `complaints`.`consumer` 
CHANGE COLUMN `State` `StateAbb` VARCHAR(2) NULL DEFAULT NULL ;

ALTER TABLE `complaints`.`zips` 
ADD COLUMN `Zip3` VARCHAR(3) NULL AFTER `ZipMedianEarnings`;
UPDATE zips SET Zip3 = left(ZipCode,3);

ALTER TABLE `complaints`.`consumer` 
ADD COLUMN `Zip3` VARCHAR(3) NULL;
UPDATE consumer SET Zip3 = left(ZipCode,3);


ALTER TABLE `complaints`.`complaints` 
CHANGE COLUMN `ProductID` `ProductID` VARCHAR(2) NULL DEFAULT NULL ;
ALTER TABLE `complaints`.`products` 
CHANGE COLUMN `ProductID` `ProductID` INT(2) NOT NULL ;