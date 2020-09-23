--1A==================================================================
    select
    rank() over (order by count(customerid) desc) as rank,
    salesperson,
    count(customerid) as count_of_customers
from
    saleslt.customer
group by
    salesperson
order by
    rank asc;
--1A==================================================================



--1B==================================================================
select
    dense_rank() over(order by count(sod.orderqty) desc) as rank,
    c.salesperson,
    count(sod.orderqty) as total_sales
from
    saleslt.customer c
join
    saleslt.salesorderheader soh on c.customerid = soh.customerid
join
    saleslt.salesorderdetail sod on sod.salesorderid = soh.salesorderid
group by
    c.salesperson
order by
  total_sales desc;
--1B==================================================================



--1C==================================================================
select
    dense_rank() over(order by sum(sod.orderqty*(sod.unitprice-sod.unitpricediscount)) desc) as rank,
    c.salesperson,
    sum(sod.orderqty*sod.unitprice*(1-sod.unitpricediscount)) as income
from
    saleslt.customer c
join
    saleslt.salesorderheader soh on c.customerid = soh.customerid
join
    saleslt.salesorderdetail sod on soh.salesorderid = sod.salesorderid
group by
    c.salesperson
order by
    income desc;
--1C==================================================================



--2A==================================================================
select
    percent_rank() over(partition by a.countryregion order by count(c.customerid) asc) as rank,
    a.countryregion,
    a.stateprovince,
    count(c.customerid) as count_of_customers
from
    saleslt.customer c
join
    saleslt.customeraddress ca on ca.customerid = c.customerid
join
    saleslt.address a on a.addressid = ca.addressid
group by
    a.countryregion, a.stateprovince
order by
    a.countryregion, rank, a.stateprovince;
--2A==================================================================



--2B==================================================================
select
    dense_rank() over(order by count(c.customerid) asc) as rank,
    a.countryregion,
    a.stateprovince,
    count(c.customerid) as count_of_customers
from
    saleslt.customer c
left join
    saleslt.customeraddress ca on ca.customerid = c.customerid
left join
    saleslt.address a on a.addressid = ca.addressid
group by
    a.countryregion, a.stateprovince
order by
    rank, a.countryregion, a.stateprovince;
--2B==================================================================



--2C==================================================================
select
    rank() over(order by count(c.customerid) desc) as rank,
    a.countryregion,
    a.stateprovince,
    a.city,
    count(c.customerid) as count_of_customers,
    lag(count(c.customerid), 1, 23) over(order by  count(c.customerid) desc)-count(c.customerid) as customers_difference
from
    saleslt.customer c
join
    saleslt.customeraddress ca on c.customerid = ca.customerid
join
    saleslt.address a on a.addressid = ca.addressid
group by
    a.countryregion,
    a.stateprovince,
    a.city
order by
    rank,
    a.countryregion,
    a.stateprovince,
    a.city;
--2C==================================================================