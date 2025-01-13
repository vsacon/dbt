with customers as (

     select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as ( 

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as ( 

    select * from {{ ref('stg_stripe__payments') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

lifetime_value (

    SELECT  orders.customer_id
           ,sum(payments.amount) AS lifetime_value
    FROM orders
    LEFT JOIN payments using(order_id)
    GROUP BY orders.customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) 
        as number_of_orders,
        lifetime_value.lifetime_value

    from customers

    left join customer_orders using (customer_id)
    left join lifetime_value using (customer_id)

)

select * from final