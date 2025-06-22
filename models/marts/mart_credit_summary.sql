with credits as (

    select * from {{ ref('stg_tax_credits') }}

),

summary as (

    select
        credit_type,
        fiscal_year,
        sum(amount) as total_claimed
    from credits
    group by 1, 2

)

select * from summary
