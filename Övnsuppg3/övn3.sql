-- 1. Av 77 produkter, hur stor andel har gått till London?
SELECT 
    orders.Id, 
    CustomerId, 
    ShipCity,
    p.productname,
    COUNT(*) AS Antal,
    count(distinct(company.order_details.ProductId)),
    count(distinct(company.order_details.ProductID)) / 77.0 AS Andel,
    count(distinct(company.order_details.ProductID)) / cast((select count(*) from company.products)as float) as Andel
FROM company.order_details od
JOIN company.orders o ON od.OrderId = o.Id
JOIN company.products p ON od.ProductId = p.Id
where o.shipcity = 'London'

SELECT 
    COUNT(DISTINCT p.ID) * 100.0 / COUNT(DISTINCT ProductID) AS PercentageDeliveredToLondon
FROM company.orders o
JOIN company.order_details od ON o.ID = od.OrderID
JOIN company.products p ON od.ProductID = p.ID
WHERE o.ShipCity = 'London';

select
	--od.OrderId,
	--od.ProductId
	count(distinct(od.ProductId)) as NbrProd,
	count(distinct(od.ProductId)) / 77.0 as Ratio,
	count(distinct(od.ProductId)) / cast((select count(*) from company.products) as float) as Ratio
from
	company.order_details od
	inner join company.orders o on od.OrderId = o.Id
where
	o.ShipCity = 'London';

SELECT * FROM company.products;
SELECT * FROM company.orders;
SELECT * FROM company.order_details;
SELECT * FROM company.employees;
SELECT * FROM company.customers;
SELECT * FROM company.suppliers;