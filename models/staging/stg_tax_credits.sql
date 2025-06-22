with source as (
    select * from {{ source('willthompson', 'TAX_CREDITS_2023') }}
),

renamed as (

    select
        fiscal_year,
        tax_year,
        recipient_name,
        credit_type,
        amount,
        credit_description
    from source

)

select * from renamed
