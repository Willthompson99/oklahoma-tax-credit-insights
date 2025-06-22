with source as (
    select * 
    from {{ source('willthompson', 'TAX_CREDITS_2023') }}
),

cleaned as (
    select *
    from source
    where amount is not null and regexp_like(amount, '^[0-9,.]+$')
),

renamed as (
    select
        fiscal_year,
        tax_year,
        recipient_name,
        credit_type,
        try_cast(replace(amount, ',', '') as float) as amount,
        credit_description
    from cleaned
)

select * from renamed
