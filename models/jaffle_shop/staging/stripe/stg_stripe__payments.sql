SELECT id
      ,orderid as order_id
      ,PAYMENTMETHOD
      ,status
      ,amount 
FROM {{ source('jaffle_shop', 'stripe_payments') }}