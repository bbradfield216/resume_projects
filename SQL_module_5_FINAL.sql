/******************************/
/***** SQL Module 5 FINAL *****/
/******************************/

-- USE wide-world-sales-data.db


/***** Problem 1 *****/
/*
 
Write queries that count the number of records in each of the following tables: sales_customers, sales_customer_categories, 
sales_invoice_lines, sales_invoices, sales_orders. Label each of the columns as "table_name_count" (i.e. order_count for the sales_orders table).

*/

-- Q: Which table has the most records? Which table has the fewest records?

SELECT COUNT(*) AS cutomers_count
FROM sales_customers sc; --663
SELECT COUNT(*) AS customer_categories_count
FROM sales_customer_categories scc; --8
SELECT COUNT(*) AS invoice_lines_count
FROM sales_invoice_lines sil; --228,265
SELECT COUNT(*) AS invoices_count
FROM sales_invoices si; --70,510
SELECT COUNT(*) AS orders_count
FROM sales_orders so; --73,595


/***** Problem 2 *****/
/*

Write a query that selects all records from the sales_customer_categories table.

*/

-- Q: What is the Category Name for CategoryID 6?
SELECT *
FROM sales_customer_categories scc
WHERE CustomerCategoryID = 6;


/***** Problem 3 *****/
/*

Write a query that pulls all records from the sales_customers table.

*/

-- Q: What is the lowest CustomerID that gives a CreditLimit which is not NULL?
SELECT *
FROM sales_customers sc
WHERE CreditLimit IS NOT NULL
ORDER BY CustomerID ASC;


/***** Problem 4 *****/
/*

Write a query that shows CustomerID, CustomerName, CreditLimit, PhoneNumber, and DeliveryPostalCode from the sales_customers table. Only include
 records that have a credit limit. Note: the default amount of rows returned in DBeaver is 200.

*/
SELECT COUNT(CustomerID), CustomerName, CreditLimit, PhoneNumber, DeliveryPostalCode 
FROM sales_customers sc
WHERE CreditLimit IS NOT NULL;

/***** Problem 5 *****/
/*

Extend the previous query to only include records where the credit limit is between 3000 and 5000. Sort the records by credit limit from high to low.

*/

-- Q: What is the highest credit limit offered within these constraints?
SELECT CustomerID, CustomerName, CreditLimit, PhoneNumber, DeliveryPostalCode 
FROM sales_customers sc
WHERE CreditLimit BETWEEN 3000 AND 5000
ORDER BY CreditLimit DESC;


/***** Problem 6 *****/
/*
 
Write one query which calculates the Min, Max and Average of CreditLimit from the sales_customers table filtering out the null values. And a second
 query which calculates the Min, Max and Average of CreditLimit from the sales_customers table including the null values. Compare the aggregate results
  of each query.

*/

-- Q: True or False. Filtering out the NULL values from a column changes the average value because these values are included when calculating
 the average.

 SELECT Min(CreditLimit), Max(CreditLimit), AVG(CreditLimit)
 FROM sales_customers sc
 WHERE CreditLimit IS NOT NULL;

 SELECT Min(CreditLimit), Max(CreditLimit), AVG(CreditLimit)
 FROM sales_customers sc;


/***** Problem 7 *****/
/*

Write a query that pulls all records from the sales_orders table. Sort records by CustomerID.

 */

SELECT OrderDate 
FROM sales_orders so
WHERE so.CustomerID = 1
ORDER BY OrderDate DESC;

SELECT COUNT(so.CustomerID)
FROM sales_orders so
WHERE so.CustomerID = 1
ORDER BY CustomerID ASC;

/***** Problem 8 *****/
/*

Write a query that pulls the OrderID, CustomerID, OrderDate, and ExpectedDeliveryDate from the sales_orders table. Add a column to the display
 that calculates the number of days that the company anticipates taking from when the order was made until it is expected to be delivered. Label
  this column days_to_deliver. Sort the data by days_to_deliver high to low. Use the JULIANDAY function.

*/

-- Q: What is the maximum estimate on the number of days it will take for an order to deliver?
SELECT OrderID, CustomerID, OrderDate, ExpectedDeliveryDate,  JULIANDAY(ExpectedDeliveryDate) - JULIANDAY(OrderDate) AS days_to_deliver
FROM sales_orders so
ORDER BY days_to_deliver DESC;


/***** Problem 9 *****/
/*

Write a query that shows how many orders each customer makes using the sales_order table with an aggregate and group by clause. Sort the results
 by the number of orders from low to high.

*/
SELECT COUNT(DISTINCT OrderID)
FROM sales_orders so
WHERE CustomerID = 1;

SELECT CustomerID, COUNT(OrderDate) AS number_of_orders_made
FROM sales_orders so
GROUP BY CustomerID
ORDER BY number_of_orders_made DESC;


/***** Problem 10 *****/
/*

Write a query that summarizes the records from the sales_invoices table.

*/

-- Q: How many total dry items were ordered using all the invoices?
SELECT *
FROM sales_invoices si;

SELECT SUM(TotalDryItems)
FROM sales_invoices si;

SELECT COUNT(TotalDryItems)
FROM sales_invoices si;


/***** Problem 11 *****/
/*

Write a query that pulls InvoiceID, OrderID, CustomerID, InvoiceDate, TotalDryItems, and TotalChillerItems from the sales_invoices table. Only
 pull records that have more than 3 dry items and include at least one chilled items.

*/
SELECT InvoiceID, OrderID, CustomerID, InvoiceDate, TotalDryItems, TotalChillerItems 
FROM sales_invoices si
WHERE TotalDryItems > 3 AND TotalChillerItems >=1;

/***** Problem 12 *****/
/*

Write a query that calculates the average unit price across all items in the sales_invoice_lines table.

*/

-- Q: What is the average unit price across all items?

SELECT AVG(UnitPrice)
FROM sales_invoice_lines sil; --45.5917

/***** Problem 13 *****/
/*

Write a query that shows the total order amount for each InvoiceID in the sales_invoice_lines table. The Extended Price accounts for the unit
 price and multiplied by the Quantity, so use Extended Price. Each InvoiceID can appear more than one time so you will need to aggregate the
  InvoiceIDs. Sort the data by the total invoice amount.

*/

-- Q: What is the InvoiceID for the most expensive order?
SELECT InvoiceID, SUM(ExtendedPrice) AS total_invoice_amount
FROM sales_invoice_lines sil
GROUP BY InvoiceID
ORDER BY total_invoice_amount DESC;


/***** Problem 14 *****/
/*

Write a query that calculates the average quantity sold for each StockItemID using the sales_invoice_lines table. Display the StockItemID and the
 average quantity and sort the results by StockItemIdD.

*/

-- Q: What is the average amount of product sold for StockItemID 224?
SELECT StockItemID, AVG(Quantity)
FROM sales_invoice_lines sil
WHERE StockItemID = 224
GROUP BY StockItemID;


/***** Problem 15 *****/
/*

Write a query which joins all the sales tables and counts the total number of rows that overlap in all the tables. Note: if you get over a million
 records, the joins are not done properly and there is a possibility that a many to many join was created. Join the tables in the
  following order: CustomerCategories -> Customers -> Orders -> Invoices -> InvoiceLines.  

*/

-- Q: How many records have data in every table? 
SELECT *
FROM sales_orders so;
SELECT *
FROM sales_customers sc;


SELECT COUNT(*)
FROM sales_customer_categories scc 
JOIN sales_customers sc ON scc.CustomerCategoryID = sc.CustomerCategoryID
JOIN sales_orders so ON sc.CustomerID = so.CustomerID
JOIN sales_invoices si ON si.OrderID = so.OrderID
JOIN sales_invoice_lines sil ON si.InvoiceID = sil.InvoiceID;



/***** Problem 16 *****/
/*

Write a query that shows how much is spent on all orders for each customer category. Use the query that joins all the tables. Sort the data
 by most dollars spent.

*/

-- Q: How much is spent in each category?

SELECT *
FROM sales_customer_categories scc;
SELECT *
FROM sales_customers sc;
SELECT *
FROM sales_orders so;
SELECT *
FROM sales_invoices si;
SELECT *
FROM sales_invoice_lines sil;

SELECT scc.CustomerCategoryName, scc.CustomerCategoryID, SUM(sil.ExtendedPrice) AS dollars_spent
FROM sales_customer_categories scc 
JOIN sales_customers sc ON scc.CustomerCategoryID = sc.CustomerCategoryID
JOIN sales_orders so ON sc.CustomerID = so.CustomerID
JOIN sales_invoices si ON si.OrderID = so.OrderID
JOIN sales_invoice_lines sil ON si.InvoiceID = sil.InvoiceID
GROUP BY scc.CustomerCategoryID
ORDER BY dollars_spent DESC;


/***** Problem 17 *****/
/*

Write a query that joins the sales_customers, sales_orders, sales_invoices and sales_invoice_lines. The results should include all data in all tables
 that overlap. Display the CustomerID, CustomerName, OrderID and OrderDate. Additionally, create an aggregate column of the total ExtendedPrice
  and group by OrderID. Filter out the data to see all the orders for the customer named "Malorie Bousquet". 

*/
SELECT sc.CustomerID, sc.CustomerName, so.OrderID, so.OrderDate, SUM(ExtendedPrice) AS total_price
FROM sales_customers sc 
JOIN sales_orders so ON so.CustomerID = sc.CustomerID 
JOIN sales_invoices si ON si.OrderID = so.OrderID 
JOIN sales_invoice_lines sil ON sil.InvoiceID = si.InvoiceID
WHERE sc.CustomerName = "Malorie Bousquet"
GROUP BY so.OrderID
ORDER BY total_price DESC;


/***** Problem 18 *****/
/*
 
Write a query that returns the customer name and the total amount spent for Malorie Bousquet. Use the joins from the previous query as the base for
 this query.
 
*/

-- Q: How much has Malorie spent on all of her orders combined?
SELECT sc.CustomerName, SUM(ExtendedPrice) AS total_amount_spent
FROM sales_customers sc 
JOIN sales_orders so ON so.CustomerID = sc.CustomerID 
JOIN sales_invoices si ON si.OrderID = so.OrderID 
JOIN sales_invoice_lines sil ON sil.InvoiceID = si.InvoiceID
WHERE sc.CustomerName = "Malorie Bousquet"
GROUP BY sc.CustomerName;

SELECT sc.CustomerID, sc.CustomerName, so.OrderID, so.OrderDate, SUM(ExtendedPrice)
FROM sales_customers sc 
JOIN sales_orders so ON so.CustomerID = sc.CustomerID 
JOIN sales_invoices si ON si.OrderID = so.OrderID 
JOIN sales_invoice_lines sil ON sil.InvoiceID = si.InvoiceID
WHERE sc.CustomerName = "Malorie Bousquet"
GROUP BY so.OrderID;


/***** Problem 19 *****/
/*

Write a query that joins the sales_customers, sales_orders, sales_invoices and sales_invoice_lines. The results should include all data in all
 tables that overlap. Display the CustomerName, and create an aggregate column with the total number of orders for each customer. Filter out
  the data to see all orders "having" more than 130 orders. Order by the highest total orders to the lowest total orders.

*/
SELECT *
FROM sales_orders so;

SELECT sc.CustomerName, COUNT(so.CustomerID) AS total_number_of_orders 
FROM sales_customers sc 
JOIN sales_orders so ON so.CustomerID = sc.CustomerID 
JOIN sales_invoices si ON si.OrderID = so.OrderID 
JOIN sales_invoice_lines sil ON sil.InvoiceID = si.InvoiceID
GROUP BY sc.CustomerName
HAVING total_number_of_orders > 130
ORDER BY total_number_of_orders DESC;


/***** Problem 20 *****/
/*

Write a query using the sales_invoice_lines table that displays the StockItemID, the total items sold using the Quantity column, and the average
 price per unit. Create one additional aggregate column that calculates the total quantity by the average cost per item to obtain total revenue
  for that item. Sort the data by total revenue from highest to lowest.

*/

-- Q: How many stock items were sold for the product with the highest total revenue?

SELECT StockItemID, Quantity, AVG(UnitPrice), Quantity * AVG(UnitPrice) AS total_revenue
FROM sales_invoice_lines sil
GROUP BY StockItemID
ORDER BY total_revenue DESC;

/***** Problem 21 *****/
/*

Using the StockItemID obtained from the product with the highest revenue, write a query that displays the SalespersonPersonID and total quantity
 of this product that they sold. Do this by joining sales_orders, sales_invoices and sales_invoice_lines. Rememeber to group by the
  SalespersonPersonID and filter on the StockItemID. Sort the results by the aggregated variable from most sold to least sold.

 */
SELECT *
FROM sales_orders so;

SELECT *
FROM sales_invoices si;

SELECT *
FROM sales_invoice_lines sil;

SELECT so.SalespersonPersonID, StockItemID, SUM(Quantity) AS total_quantity
FROM sales_orders so
JOIN sales_invoices si ON si.OrderID = so.OrderID 
JOIN sales_invoice_lines sil ON sil.InvoiceID = si.InvoiceID
WHERE StockItemID = 215
GROUP BY so.SalespersonPersonID
ORDER BY total_quantity DESC;



/***** Problem 22 ****/
/*

Write a query that shows the SalespersonPersonID and total revenue as a sum total of the ExtendedPrice column. Sort the results from highest
 to lowest amount. Join the sales_orders, sales_invoices and sales_invoice_lines tables to obtain these results.
 
*/

SELECT so.SalespersonPersonID, SUM(sil.ExtendedPrice) AS total_revenue
FROM sales_orders so
JOIN sales_invoices si ON so.OrderID = si.OrderID 
JOIN sales_invoice_lines sil ON si.InvoiceID = sil.InvoiceID
GROUP BY so.SalespersonPersonID 
ORDER BY total_revenue DESC;


