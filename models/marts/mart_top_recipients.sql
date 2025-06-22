with credits as (
    select * from {{ ref('stg_tax_credits') }}
),

top_recipients as (
    select
        recipient_name,
        sum(amount::float) as total_claimed
    from credits
    group by recipient_name
    order by total_claimed desc
    limit 10
)

select * from top_recipients
