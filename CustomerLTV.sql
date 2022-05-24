-- Question 1: select the active subscibers with the most aggregated spend

SELECT subscription_status,o.order_status, sum(o.order_value) as cumulativeSpend FROM subscriptions s
LEFT JOIN orders o on s.customer_id = o.customer_id
WHERE o.order_status=="paid"
GROUP BY s.customer_id
Having subscription_status=="active"
Order by cumulativeSpend DESC,LIMIT 1

-- Question 2
SELECT order_id, sum(o.order_value) as totalValue, count(order_id) as totalOrders, sum(quantity) as totalQuantity FROM orders o
JOIN order_compositionn c on o.order_id = c.order_id
GROUP BY o.order_id

-- average value per order and average items per order for first order
SELECT avg(totalValue/totalOrders) as avgValuePerOrder, avg(totalQuantity/totalOrders) as avgNumItemsPerOrder
FROM (
	SELECT order_id, sum(o.order_value) as totalValue, count(order_id) as totalOrders, sum(quantity) as totalQuantity, order_status, order_type
    FROM orders o
    JOIN order_compositionn c on o.order_id = c.order_id
    WHERE order_status=="paid"
    GROUP BY o.order_id
    Having order_type=="1")

-- average value per order and average items per order for repeat order
SELECT avg(totalValue/totalOrders) as avgValuePerOrder, avg(totalQuantity/totalOrders) as avgNumItemsPerOrder
FROM (
	SELECT order_id, sum(o.order_value) as totalValue, count(order_id) as totalOrders, sum(quantity) as totalQuantity, order_status, order_type
    FROM orders o
    JOIN order_compositionn c on o.order_id = c.order_id
    WHERE order_status=="paid"
    GROUP BY o.order_id
    Having order_type=="0")

-- Question 3
SELECT avg(cohortTotalValue/cohortTotalOrders) as avgLifeValue
FROM(
    SELECT cohort_month, count(order_id) as cohortTotalOrders, sum(order_value) as cohortTotalValue, order_status from customers c
    JOIN orders o on o.customer_id=c.customer_id
    WHERE order_status =="paid"
    GROUP BY cohort_month)
Order by avgLifeValue DESC
