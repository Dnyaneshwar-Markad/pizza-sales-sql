-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category, SUM(order_details.quantity)
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS TIME_of_ORDER, COUNT(order_id)
FROM
    orders
GROUP BY TIME_of_ORDER
ORDER BY TIME_of_ORDER;


-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    orders.date, SUM(order_details.quantity) AS OrderPerDay
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY orders.date;
-- subquery
SELECT 
    ROUND(AVG(OrderPerDay), 2)
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS OrderPerDay
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS Oder_Quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    order_details.quantity * pizzas.price AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id;
-- sub query
SELECT 
    name, SUM(Revenue)
FROM
    (SELECT 
        pizza_types.name,
            order_details.quantity * pizzas.price AS Revenue
    FROM
        pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id) AS Pizza_with_Money
GROUP BY name
ORDER BY SUM(Revenue) DESC
LIMIT 3;