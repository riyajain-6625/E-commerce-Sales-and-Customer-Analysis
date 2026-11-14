-- 1. Identify the grain and PK/FK relationships.

describe customers;
describe order_item;
describe  orders;
describe payments;
-- 3. Calculate monthly volume and revenue.

SELECT
    MONTH(o.order_date) AS month,
    SUM(o.total_amount) AS total_amount,
    SUM(oi.total_sales) AS total_sales
FROM orders o
JOIN (
    SELECT
        order_id,
        SUM(unit_price * quantity) AS total_sales
    FROM order_items
    GROUP BY order_id
) oi
ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date);

-- 4. Calculate the main average/value KPI.
SELECT c.customer_id, c.name, avg(o.total_amount) as avg_aov
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY o.total_amount, c.customer_id;
-- 5. Rank top customers/products
SELECT c.customer_id, c.name,max(o.total_amount) as highest_amount 
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY  c.customer_id, o.total_amount
order by max(o.total_amount) desc limit 1;

select product_name,sum(cost_price*quantity) as sales
from products p
join order_items oi
on p.product_id=oi.product_id
group by cost_price*quantity,product_name
order by sales desc limit 1
;

-- 6. Analyze category/segment performance.
select category,max(cost_price*quantity) as sales
from products p
join order_items oi
group by cost_price*quantity,category
order by sales desc limit 1;

-- 7. Calculate cancellation/failure rate.

SELECT 
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM payments) AS failed_percentage
FROM payments
WHERE payment_status = 'Failed';
-- 8. Find repeat customers/users.
select customer_id from orders
group by customer_id
having  count(customer_id)>1