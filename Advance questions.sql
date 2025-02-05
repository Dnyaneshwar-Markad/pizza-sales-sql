-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, round(sum(pizzas.price*order_details.quantity) / (
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS TotalRevenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
)*100,2) as Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by category;


-- Analyze the cumulative revenue generated over time.
select date, sum(Revenue) over(order by date) from
(select orders.date, round(sum(order_details.quantity*pizzas.price),2) as Revenue
from 
orders join order_details
on orders.order_id= order_details.order_id
join pizzas
on order_details.pizza_id=pizzas.pizza_id
group by date) as Orders_rev;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, Ranking, name, Revenue from
(select category, name, Revenue, rank()over(partition by category order by Revenue desc)  as Ranking
from
(select pizza_types.category,pizza_types.name ,round(sum(order_details.quantity*pizzas.price),2) as Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id= pizzas.pizza_type_id
join order_details
on pizzas.pizza_id= order_details.pizza_id
group by category,name) as Category_Rev) as TopRanked
where Ranking <=3;