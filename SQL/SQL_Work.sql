--==============================
--====CIS310 ASSIGNMENT 6=======
--==============================

--1. List the owner number, last name, and first name of every property owner.
SELECT OWNER_NUM, LAST_NAME, FIRST_NAME
	FROM OWNER;
--2. List the complete PROPERTY table (all rows and all columns).
SELECT *
	FROM PROPERTY;
--3. List the last name and first name of every owner who lives in Seattle.
SELECT LAST_NAME, FIRST_NAME
	FROM OWNER
		WHERE CITY LIKE '%Seattle%';
--4. List the last name and first name of every owner who does not live in Seattle.
SELECT LAST_NAME, FIRST_NAME
	FROM OWNER
		WHERE CITY NOT LIKE '%Seattle%';
--5. List the property ID and office number for every property whose square footage 
--is equal to or less than 1,400 square feet.
SELECT PROPERTY_ID, OFFICE_NUM
	FROM PROPERTY
		WHERE SQR_FT <= 1400;
--6. List the office number and address for every property with three bedrooms.
SELECT OFFICE_NUM, ADDRESS
	FROM PROPERTY
		WHERE BDRMS = 3;
--7. List the property ID for every property with two bedrooms that is managed by StayWell-Georgetown
--USE THE GIVEN NAME (*hint subquery). 
SELECT PROPERTY_ID
	FROM PROPERTY
		WHERE OFFICE_NUM = (SELECT OFFICE_NUM FROM OFFICE WHERE OFFICE_NAME LIKE '%StayWell-Georgetown%');
--8. List the property ID for every property with a monthly rent that is between $1,350 and $1,750 
--MUST USE PROPER OPERATOR FOR FULL CREDIT.
SELECT PROPERTY_ID
	FROM PROPERTY
		WHERE MONTHLY_RENT BETWEEN 1350 AND 1750;
--9. Labor is billed at the rate of $35 per hour. 
--List the property ID, category number, estimated hours, and estimated labor cost for every service request. 
--Sort the results by the estimated cost from highes to lowest.
--To obtain the estimated labor cost, multiply the estimated hours by 35. 
--Use the column name ESTIMATED_COST for the estimated labor cost.
SELECT PROPERTY_ID, CATEGORY_NUMBER, EST_HOURS, (EST_HOURS * 35) AS ESTIMATED_COST
	FROM SERVICE_REQUEST
		ORDER BY ESTIMATED_COST DESC;
--10. List the owner number and last name for all owners who live in Nevada (NV), Oregon (OR), or Idaho (ID)
--USE THE APPROPRIATE OPERATOR FOR FULL CREDIT.
SELECT OWNER_NUM, LAST_NAME
	FROM OWNER
		WHERE STATE LIKE '%NV%' OR STATE LIKE '%OR%' OR STATE LIKE '%ID%';
--11. List the owner number, property ID, square footage, and monthly rent for all properties. 
--Sort the results by monthly rent within the square footage.
SELECT OWNER_NUM, PROPERTY_ID, SQR_FT, MONTHLY_RENT
	FROM PROPERTY
		ORDER BY SQR_FT DESC, MONTHLY_RENT ASC; --Orders by most amount of square feet, then least amount of monthly rent
--12. How many three-bedroom properties are managed by each office?
SELECT OFFICE_NUM, COUNT(BDRMS) AS THREE_BDRM_COUNT
	FROM PROPERTY
		GROUP BY OFFICE_NUM, BDRMS
			HAVING BDRMS = 3;
--Office 1 has two properties with three bedrooms
--Office 2 has three properties with three bedrooms











--==============================
--====CIS310 ASSIGNMENT 7=======
--==============================

--1.	For every property, list the management office number, property address, monthly rent, 
--owner number, owner�s first name, and owner�s last name.
SELECT PROPERTY.OFFICE_NUM, PROPERTY.ADDRESS, PROPERTY.MONTHLY_RENT, OWNER.OWNER_NUM, OWNER.FIRST_NAME, OWNER.LAST_NAME
	FROM PROPERTY
		INNER JOIN OWNER ON PROPERTY.OWNER_NUM=OWNER.OWNER_NUM;


--2.	For every open or service scheduled service requests, list the property ID, description, and status. 
SELECT SERVICE_REQUEST.PROPERTY_ID, SERVICE_CATEGORY.CATEGORY_DESCRIPTION, SERVICE_REQUEST.STATUS
	FROM SERVICE_REQUEST
		INNER JOIN SERVICE_CATEGORY ON SERVICE_REQUEST.CATEGORY_NUMBER=SERVICE_CATEGORY.CATEGORY_NUM
			WHERE STATUS LIKE '%Open%' OR STATUS LIKE 'Scheduled';


--3.	For every service request for furniture replacement, list the property ID, 
--management office number, address, estimated hours, spent hours, owner number, 
--and owner�s last name.
SELECT SR.PROPERTY_ID, P.OFFICE_NUM, P.ADDRESS, SR.EST_HOURS, 
		SR.SPENT_HOURS, P.OWNER_NUM, O.LAST_NAME, SR.DESCRIPTION
			FROM PROPERTY P
				INNER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID=SR.PROPERTY_ID
				INNER JOIN OWNER O ON P.OWNER_NUM=O.OWNER_NUM
				INNER JOIN SERVICE_CATEGORY SC ON SR.CATEGORY_NUMBER=SC.CATEGORY_NUM
					WHERE CATEGORY_DESCRIPTION LIKE '%replacement%';


--4.	List the first and last names of all owners who own a two-bedroom property. 
--Use the IN operator in your query.
SELECT OWNER.FIRST_NAME,OWNER.LAST_NAME
	FROM OWNER
		WHERE OWNER_NUM IN (SELECT OWNER_NUM FROM PROPERTY WHERE BDRMS = 2);


--5.	Repeat Exercise 4, but this time use the EXISTS operator in your query.
SELECT FIRST_NAME, LAST_NAME
	FROM OWNER O
		WHERE EXISTS (SELECT * 
						FROM PROPERTY P
							WHERE P.OWNER_NUM=O.OWNER_NUM AND BDRMS = 2);


--6.	List the property IDs of any pair of properties that have the same number of bedrooms. 
--For example, one pair would be property ID 2 and property ID 6, 
--because they both have four bedrooms. The first property ID listed should be the major sort key 
--and the second property ID should be the minor sort key.
SELECT A.PROPERTY_ID, B.PROPERTY_ID, B.BDRMS
	FROM PROPERTY A INNER JOIN PROPERTY B ON A.BDRMS=B.BDRMS
		WHERE A.PROPERTY_ID < B.PROPERTY_ID
			ORDER BY A.PROPERTY_ID, B.PROPERTY_ID;


--7.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State or own two-bedroom properties.
SELECT P.OFFICE_NUM, P.ADDRESS, P.MONTHLY_RENT
	FROM PROPERTY P
		INNER JOIN OWNER ON P.OWNER_NUM=OWNER.OWNER_NUM
			WHERE OWNER.STATE='WA' OR P.BDRMS=2;


--8.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State and own a two-bedroom property.
SELECT P.OFFICE_NUM, P.ADDRESS, P.MONTHLY_RENT
	FROM PROPERTY P
		INNER JOIN OWNER ON P.OWNER_NUM=OWNER.OWNER_NUM
			WHERE OWNER.STATE='WA' AND P.BDRMS=2;


--9.	List the office number, address, and monthly rent for properties 
--whose owners live in Washington State but do not own two-bedroom properties.
SELECT P.OFFICE_NUM, P.ADDRESS, P.MONTHLY_RENT
	FROM PROPERTY P
		INNER JOIN OWNER ON P.OWNER_NUM=OWNER.OWNER_NUM
			WHERE OWNER.STATE='WA' AND P.BDRMS=2;


--10.	Find the service ID and property ID for each service request 
--whose estimated hours is greater than the number of estimated hours on every service request 
--on which the category number is 5.
--MUST USE ANY/ALL OPERATOR
SELECT SERVICE_ID, PROPERTY_ID
	FROM SERVICE_REQUEST
		WHERE EST_HOURS > ALL (SELECT EST_HOURS
									FROM SERVICE_REQUEST
										WHERE CATEGORY_NUMBER='5');

--11.	List the address, square footage, owner number, service ID, number of estimated hours, 
--and number of spent hours for each service request on which the category number is 4.
SELECT P.ADDRESS, P.SQR_FT, P.OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS
	FROM SERVICE_REQUEST SR
		INNER JOIN PROPERTY P ON SR.PROPERTY_ID=P.PROPERTY_ID
			WHERE CATEGORY_NUMBER = ALL (SELECT CATEGORY_NUMBER FROM SERVICE_REQUEST WHERE CATEGORY_NUMBER='4');

--12.	Repeat Exercise 11, but this time be sure each property is included 
--regardless of whether the property currently has any service requests for category 4.
SELECT P.ADDRESS, P.SQR_FT, P.OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS, SR.CATEGORY_NUMBER
	FROM PROPERTY P
		LEFT OUTER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID=SR.PROPERTY_ID;











--==============================
--====CIS310 ASSIGNMENT 8=======
--==============================


--==============================Part 1: Table Creation& Modification======================================
--1.Create a LARGE_PROPERTY table with the structure shown below, no primary keys are defined in this table.
/*
===Column Name == | ==Data Type===
|   OFFICE_NUM    |  DECIMAL(2)
|   ADDRESS       |  CHAR(25)
|   BDRMS         |  DECIMAL(2)
|   FLOORS        |  DECIMAL(2)
|   MONTHLY_RENT  |  DECIMAL(6,2)
|   OWNER_NUM     |  CHAR(5)
*/

CREATE TABLE LARGE_PROPERTY
(
	OFFICE_NUM DECIMAL(2),
	ADDRESS CHAR(25),
	BDRMS DECIMAL(2),
	FLOORS DECIMAL(2),
	MONTHLY_RENT DECIMAL(6, 2),
	OWNER_NUM CHAR(5)
);

--2.Insert into the LARGE_PROPERTY table the office number, address, bedrooms, baths, 
--monthly rent, and owner number for those properties whose square footage is greater than 1,500 square feet.
INSERT INTO LARGE_PROPERTY
	SELECT OFFICE_NUM, ADDRESS, BDRMS, FLOORS, MONTHLY_RENT, OWNER_NUM
		FROM PROPERTY
			WHERE SQR_FT > 1500;

--3.StayWell has increased the monthly rent of each large property by $150. 
--Update the monthly rents in the LARGE_PROPERTY table accordingly.
UPDATE LARGE_PROPERTY
	SET MONTHLY_RENT = MONTHLY_RENT+150;

--4.After increasing the monthly rent of each large property by $150 (Exercise 3), 
--StayWell decides to decrease the monthly rent of any property 
--whose monthly fee is more than $1750 by one percent. 
--Update the monthly rents in the LARGE_PROPERTY table accordingly.
UPDATE LARGE_PROPERTY
	SET MONTHLY_RENT = MONTHLY_RENT - (MONTHLY_RENT*.01)
		WHERE MONTHLY_RENT > 1750;

--5.Insert a row into the LARGE_PROPERTY table for a new property. The office number is 1, 
--the address is 2643 Lugsi Dr, the number of bedrooms is 3, the number of floors is 2, 
--the monthly rent is $775, and the owner number is MA111.
INSERT INTO LARGE_PROPERTY (OFFICE_NUM, ADDRESS, BDRMS, FLOORS, MONTHLY_RENT, OWNER_NUM)
	VALUES ('1', '2643 Lugsi Dr', '3', '2', 775, 'MA111');

--6.Delete all properties in the LARGE_PROPERTY table for which the owner number is BI109.
DELETE FROM LARGE_PROPERTY
	WHERE OWNER_NUM = 'BI109';

--7.The property in managed by Columbia City with the address 105 North Illinois Rd is 
--in the process of being remodeled and the number of bedrooms is unknown. 
--Change the bedrooms value in the LARGE_PROPERTY table to null.
UPDATE LARGE_PROPERTY
	SET BDRMS = NULL
		WHERE ADDRESS LIKE '%105 North Illinois Rd%';

--8. Delete the LARGE_PROPERTY table from the database.
DROP TABLE LARGE_PROPERTY;





--==============================Part 2: Views, Procedures and Triggers======================================
-- 9. Create a Stored Procedure DISP_OWNER_YOURFIRSTNAMELASTNAME (E.G. DISP_OWNER_JIAOWANG).
--This SP takes a single parameter/variable named I_PROPERTY_ID to store user input value of a PROPERTY_ID. 
--It should output OFFICE_NUM, ADDRESS, OWNER_NUM and OWNER_NAME (concatenated FirstName LastName in proper format) 
--from the PROPERTY and OWNER tables for the given PROPERTY_ID
CREATE PROCEDURE DISP_OWNER_LUKELEVEQUE @I_PROPERTY_ID CHAR (1) = NULL
AS
	BEGIN
		SELECT P.OFFICE_NUM, P.ADDRESS, P.OWNER_NUM, CONCAT(O.FIRST_NAME, ' ', O.LAST_NAME) AS OWNER_NAME
			FROM PROPERTY P
				INNER JOIN OWNER O ON P.OWNER_NUM=O.OWNER_NUM
					WHERE PROPERTY_ID = @I_PROPERTY_ID
	END;

EXEC DISP_OWNER_LUKELEVEQUE '1';

-- 10. Create a Stored Procedure UPDATE_OWNER_YOURFIRSTNAMELASTNAME (E.G. UPDATE_OWNER_JIAOWANG).
--This Stored Procedure takes 2 parameters/variables:  
--I_OWNER_NUM to store user input value of a OWNER_NUM, and I_LAST_NAME to store user input value of a new LAST_NAME. 
--This stored procedure should update/change the last name to the given value, for the given owner num.	
CREATE PROCEDURE UPDATE_OWNER_LUKELEVEQUE @I_OWNER_NUM CHAR(5) = NULL, @I_LAST_NAME VARCHAR(20) = NULL
AS
	BEGIN
		UPDATE OWNER
			SET LAST_NAME = @I_LAST_NAME
				WHERE OWNER_NUM = @I_OWNER_NUM
	END;

SELECT * FROM OWNER;
EXEC UPDATE_OWNER_LUKELEVEQUE 'AK102', 'Aksoy';