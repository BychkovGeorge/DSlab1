--2A==================================================================
select
    c.customerid,
    c.salesperson,
    sd.productid,
    sum(sd.orderQty*sd.unitprice*(1-sd.unitpricediscount)) as income
from
    saleslt.customer c
join
    saleslt.salesorderheader s on s.customerid = c.customerid
join
    saleslt.salesorderdetail sd on sd.salesorderid = s.salesorderid
group by
    CUBE(c.customerid, c.salesperson, sd.productid)
ORDER BY
    c.salesperson;
--2A==================================================================


--2B==================================================================
select
    sod.productid,
    c.customerid,
    ca.addressid,
    soh.shiptoaddressid,
    soh.billtoaddressid,
    sum(sod.orderQty*sod.unitprice*(1-sod.unitpricediscount)) as income
from
    saleslt.customer c
join
    saleslt.customeraddress ca on c.customerid = ca.customerid
join
    saleslt.salesorderheader soh on c.customerid = soh.customerid
join
    saleslt.salesorderdetail sod on soh.salesorderid = sod.salesorderid
group by
    CUBE(sod.productid, c.customerid, ca.addressid, soh.shiptoaddressid, soh.billtoaddressid)
order by
    income desc;
--2B==================================================================



--2C==================================================================
select
    a.countryregion,
    a.stateprovince,
    a.city,
    sum(sod.orderQty*sod.unitprice*(1-sod.unitpricediscount)) as income,
    sum(sod.unitpricediscount) as total_discount
from
    saleslt.customer c
join
    saleslt.customeraddress ca on c.customerid = ca.customerid
join
    saleslt.address a on a.addressid = ca.addressid
join
    saleslt.salesorderheader soh on c.customerid = soh.customerid
join
    saleslt.salesorderdetail sod on soh.salesorderid = sod.salesorderid
group by
    rollup(
    a.countryregion,
    a.stateprovince,
    a.city
    )
order by
    a.countryregion;
--2C==================================================================



--2D==================================================================
select
    pc.parentproductcategoryid,
    pc.productcategoryid,
    p.productid,
    sum(sod.orderQty*sod.unitprice*(1-sod.unitpricediscount)) as income,
    sum(sod.unitpricediscount) as total_discount
from
    saleslt.product p
join
    saleslt.productcategory pc on pc.productcategoryid = p.productcategoryid
join
    saleslt.salesorderdetail sod on sod.productid = p.productid
group by
    rollup(
    pc.parentproductcategoryid,
    pc.productcategoryid,
    p.productid
    );
--2D==================================================================



--2E==================================================================
select
    sod.productid,
    c.customerid,
    c.salesperson,
    a.countryregion,
    a.stateprovince,
    a.city,
    sum(sod.orderqty)
from
    saleslt.customer c
join
    saleslt.customeraddress ca on c.customerid = ca.customerid
join
    saleslt.address a on a.addressid = ca.addressid
join
    saleslt.salesorderheader soh on c.customerid = soh.customerid
join
    saleslt.salesorderdetail sod on soh.salesorderid = sod.salesorderid
group by
    rollup(
    sod.productid,
    c.customerid,
    c.salesperson,
    a.countryregion,
    a.stateprovince,
    a.city
    );
--2E==================================================================