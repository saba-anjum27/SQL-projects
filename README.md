#SQL-Projects
Getting Started

For these projects, you will need to have access to a SQL database. You can use any SQL database management system (DBMS) such as MySQL, PostgreSQL, or SQLite. For these projects, we have used MySQL Workbench to run the SQL queries. The projects here are designed to use SQL queries to find the various insights from given data across various verticals like Service and Banking. The goal was to clearly understand the structure of each table and the relationships among them using the ER diagrams and write complex join queries to get the relevant datasets. Thereafter to get insights on the data using various queries like sorting queries, aggregation queries, ranking queries, window functions etc.

##PROJECTS
###Sales and delivery Domain
🎓 Composite data of a business organization, confined to the ‘sales and delivery’ domain was given for the period of the last decade. From the given data retrieve solutions for the given scenarios like:

top 3 customers?
customer whose order took the maximum time to get delivered.
total sales made by each product from the data (using Windows function)
total profit made from each product from the data (using windows function)
total number of unique customers in January and how many of them came back every month over the entire year in 2011
###Restaurant Industry
🎓 Overview of Restaurant Dataset ● Chefmozaccepts (Location Wise availability of Payment Modes) ● Chefmozcuisine (Location Wise availability of Cuisine) ● Chefmozhours4(Working Hours of Restaurant) ● Chefmozparking (Parking availability at restaurants at different places) ● Geoplaces2(Location Wise Summary of dress code, country, state, etc.) ● Rating_final (User wise rating to the restaurants in diff locations) ● Usercuisine (User had which Cuisine) ● User payment (User used which payment mode) ● Userprofile (Users personal details like a smoker, drink level, interest, religion, etc.)

###Triggers
Basic understanding of Triggers. How to create them and how they are used.

Problem Statement:
Let’s say you are studying SQL for two weeks. In your institute, there is an employee who has been maintaining the student’s details and Student Details Backup tables. He / She is deleting the records from the Student details after the students completed the course and keeping the backup in the student details backup table by inserting the records every time. You are noticing this daily and now you want to help him/her by not inserting the records for backup purpose when he/she delete the records.write a trigger that should be capable enough to insert the student details in the backup table whenever the employee deletes records from the student details table.

Note: The query should insert the rows in the backup table before deleting the records from student details.
