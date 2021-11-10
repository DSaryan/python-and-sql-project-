use superstores;
                          /*     Assignment 2                    
                            --  Superstores Database Exercises --                 
                 /*---Task_2----*/

/* 1. Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen */
select Customer_Name as "Customer Name " , 
 Customer_Segment as "Customer Segment" 
 from cust_dimen;
 
 /* 2. Write a query to find all the details of the customer from the table cust_dimen order by desc. */
  select * from cust_dimen order by  Customer_Name desc;
  
  /* 3. Write a query to get the Order ID, Order date from table orders_dimen where Order Priority’ is high */
   
   select order_id, order_date from orders_dimen where Order_Priority LIKE '%HIGH%';
   
   /* 4. Find the total and the average sales (display total_sales and avg_sales) */
   select sum(SALES) AS total_sale, 
   avg(sales) as avg_sales 
   from market_fact;
   
   /* 5. Write a query to get the maximum and minimum sales from maket_fact table.*/
   select max(sales) as maximum_sales, 
   min(sales) as  minimum_sales 
   from market_fact;
   
   /* 6.Display the number of customers in each region in decreasing order of no_of_customers.
   The result should contain columns Region, no_of_customers. */
   select region, count(customer_name) as no_of_customers
   from cust_dimen 
   group by Region
   order by no_of_customers desc;
   
   /* 7. Find the region having maximum customers (display the region name and max(no_of_customers)*/
select region, count(customer_name) as no_of_customers
   from cust_dimen 
   group by Region
   order by no_of_customers desc  
  limit 1 ;
  
  /* 8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
and the number of tables purchased (display the customer name, no_of_tables purchased) */
   SELECT 
    Customer_Name, COUNT(*) AS num_tables
FROM
    market_fact s,
    cust_dimen c,
    prod_dimen p
WHERE
    s.Cust_id = c.Cust_id
        AND s.Prod_id = p.Prod_id
        AND p.Product_Sub_Category = 'TABLES'
        AND c.Region = 'ATLANTIC'
GROUP BY Customer_Name
ORDER BY num_tables DESC;

/* 9. Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners)*/
SELECT DISTINCT
    Customer_Name
FROM
    cust_dimen
WHERE
    region LIKE '%ONTARIO%'
        AND Customer_Segment LIKE '%SMALL BUSINESS%';
        
        
   /* 10. Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold)*/

SELECT 
    prod_id AS product_id, COUNT(*) AS no_of_products_sold
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products_sold DESC;

/*11. Display product Id and product sub category whose produt category belongs to 
Furniture and Technlogy. The result should contain columns product id, product 
sub category*/

SELECT 
    prod_id, product_sub_category, product_category
FROM
    prod_dimen
WHERE
    product_category IN ('FURNITURE' , 'TECHNOLOGY');

/* 12. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?  */

SELECT 
    p.product_category, SUM(profit) AS profits
FROM
    market_fact AS M
        JOIN
    Prod_dimen AS P ON M.prod_id = P.prod_id
GROUP BY p.product_category
ORDER BY profits DESC;

/* 13. Display the product category, product sub-category and the profit within each subcategory in three columns. */
SELECT 
    p.product_category,
    p.product_sub_category,
    SUM(m.profit) AS profits
FROM
    market_fact m
        INNER JOIN
    prod_dimen p ON m.prod_id = p.prod_id
GROUP BY p.product_category , p.product_sub_category;
 
 /* 14. Display the order date, order quantity and the sales for the order.  */
SELECT 
    o.order_date, M.order_quantity, M.sales
FROM
    market_fact AS M
        JOIN
    orders_dimen AS O ON M.ord_id = O.ord_id;
/* 15. Display the names of the customers whose name contains the  */
-- i) Second letter as ‘R’
SELECT 
    Customer_name
FROM
    cust_dimen
WHERE
    customer_name LIKE '_R%';
 -- ii) Fourth letter as ‘D’
SELECT 
    Customer_name
FROM
    cust_dimen
WHERE
    customer_name LIKE '___D%';

/* 16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000. */
SELECT 
    c.cust_id, SUM(M.sales) AS Sales, c.customer_name, c.region
FROM
    cust_dimen AS c
        JOIN
    market_fact AS M ON c.cust_id = M.cust_id
GROUP BY c.cust_id
HAVING Sales BETWEEN 1000 AND 5000;

/* 17. Write a SQL query to find the 3rd highest sales.  */
SELECT 
    *
FROM
    market_fact
WHERE
    sales < (SELECT 
            MAX(sales)
        FROM
            market_fact
        WHERE
            sales < (SELECT 
                    MAX(sales)
                FROM
                    market_fact))
ORDER BY sales DESC
LIMIT 1;

/* 18. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the */
-- profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)
--  Note: You can hardcode the name of the least profitable product subcategory
SELECT 
    c.region,
    COUNT(DISTINCT s.ship_id) AS no_of_shipments,
    SUM(m.profit) AS profit_in_each_region
FROM
    market_fact m
        INNER JOIN
    cust_dimen c ON m.cust_id = c.cust_id
        INNER JOIN
    shipping_dimen s ON m.ship_id = s.ship_id
        INNER JOIN
    prod_dimen p ON m.prod_id = p.prod_id
WHERE
    p.product_sub_category IN (SELECT 
            p.product_sub_category
        FROM
            market_fact m
                INNER JOIN
            prod_dimen p ON m.prod_id = p.prod_id
        GROUP BY p.product_sub_category
        HAVING SUM(m.profit) <= ALL (SELECT 
                SUM(m.profit) AS profits
            FROM
                market_fact m
                    INNER JOIN
                prod_dimen p ON m.prod_id = p.prod_id
            GROUP BY p.product_sub_category))
GROUP BY c.region
ORDER BY profit_in_each_region DESC;

        /*Task_1
/*
* Description of the dataset  
1. cust_dimen: having all data of customers 
		  a) Customer_Name (TEXT): Name of the customer
          b) Province (TEXT): Province of the customer
          c) Region (TEXT): Region from where the customer belongs
          d) Customer_Segment (TEXT): Segment from where the customer buy products
          e) Cust_id (TEXT): Unique Customer ID
	
2. market_fact: Details of every order sold ,(i.e delivered,profit,shipping id etc)
	    a) Ord_id (TEXT): unique id of order  
        b) Prod_id (TEXT): unique id of product
        c) Ship_id (TEXT): unique id of shipment
        d) Cust_id (TEXT): unique id of the Customer 
        e) Sales (DOUBLE): Sales from the Item sold
        f) Discount (DOUBLE): Discount on the Item sold
        g) Order_Quantity (INT):  Quantity of the Item ordered
        h) Profit (DOUBLE): Profit gained from the Item sold
        i) Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        j) Product_Base_Margin (DOUBLE): Profit margin on the base of manufacturing cost Item sold
        
3. orders_dimen: Details of every order placed
		
        a) Order_ID (INT): Unque id of the Order 
        b) Order_Date (TEXT): Date of order
        c) Order_Priority (TEXT): Priority of the Order
        d) Ord_id (TEXT): Unique Order ID
	
4. prod_dimen: Details of product category and sub category
		
       a)  Product_Category (TEXT): Category of the product
	   b) Product_Sub_Category (TEXT): Sub Category of the product
	   c) Prod_id (TEXT): Unique Product ID
	
5. shipping_dimen: Details of shipping of orders
		
       a)  Order_ID (INT):  Unique Order ID
	   b)  Ship_Mode (TEXT): Mode of shipping
	   c)  Ship_Date (TEXT): Date of shipping
	   d)  Ship_id (TEXT): Unique Shipment ID
 -------PRIMARY KEY AND FOREIGN KEYS FOR THE DATASET-------
	
1. cust_dimen
		A)Primary Key: Cust_id
        B) Foreign Key: NA
	
2. market_fact
		A) Primary Key: NA
        B) Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
3. orders_dimen
		A) Primary Key: Ord_id
        B) Foreign Key: NA
	
4. prod_dimen
		A) Primary Key: Prod_id, Product_Sub_Category
        B) Foreign Key: NA
	
5. shipping_dimen
		A) Primary Key: Ship_id
        B) Foreign Key: NA           */


   
 
 

