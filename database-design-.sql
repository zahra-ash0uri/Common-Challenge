-- SECTION 1:	DDL COMMANDS

create table customer
(
    id		int auto_increment primary key,
    name		varchar(64) not null,
    phone		varchar(16) unique not null,
    postal_code		varchar(32) null,
    city		varchar(16) null
);

create table product
(
    id		int auto_increment primary key,
    name		varchar(32) not null,
    category		varchar(32) null,
    buy_price		float null,	
    quantity_in_stock		int null
);

create table order_details
(
    order_id		int not null,
    product_id		int not null,
    quantity_ordered		int not null,
    unit_price		float not null,
    primary key (order_id, product_id),
    constraint order_details_orders_id_fk
    foreign key (order_id) references orders(id) on update cascade,
    constraint order_details_product_id_fk
    foreign key (product_id) references product (id)
);

create table orders
(
    id		int auto_increment primary key,
    customer_id		int null,
    order_time		date not null,
    status		varchar(16) null,
    constraint orders_customers_id_fk
    foreign key (customer_id) references customers (id) on update cascade
);

create table sale
(
	id		int auto_increment primary key,
    order_id		int not null,
    time_created		timestamp null,
    total_price		float not null,
    recived		float null,
    remainder float null,
    net_profit		float null,
    status		varchar(256) null,
    constraint sale_orders_id_fk
    foreign key (order_id) references orders(id) on update cascade
);



-- SECTION 2:	DML COMMANDS

insert into customer(name, phone) values
(
	'zahra', '09123324234'
);
insert into customer(name, phone) values
(
	'sara', '09354343321'
);
insert into customer(name, phone) values
(
	'ali', '09364343321'
);


insert into product(name, category, buy_price, quantity_in_stock) values
(
	'minion mug', 'mug-livan-decor', '5200', '11' 
);
insert into product(name, category, buy_price, quantity_in_stock) values
(
	'gooshkoob barghi', 'kitchen-cook', '52000', '4'
);
insert into product(name, category, buy_price, quantity_in_stock) values
(
	'daftar yaddasht', 'lavazem-tahrir', '2100', '10'
);
insert into product(name, category, buy_price, quantity_in_stock) values
(
	'goldoon', 'lavazem-manzel', '6000', '14'
);
insert into product(name, category, buy_price, quantity_in_stock) values
(
	'ketabe koodak', 'ketab', '9000', '20'
);


insert into orders(customer_id, order_time) values
(
	 '2', '2019-1-12'
);
insert into orders(customer_id, order_time) values
(
	 '1', '2018-2-12'
);
insert into orders(customer_id, order_time) values
(
	 '3', '2018-3-12'
);


insert into order_details values
(
	'1', '1', '1', '8000'
);
insert into order_details values
(
	'1', '3', '1', '9000'
);
insert into order_details values
(
	'2', '1', '1', '8000'
);
insert into order_details values
(
	'3', '4', '1', '15000'
);
insert into order_details values
(
	'3', '5', '2', '11000'
);


insert into sale(order_id, total_price)
select order_id,
sum(quantity_ordered * unit_price) as total_price
from order_details
group by order_id;



-- SECTION 3 / CASE in column list

create table sales_statistics
(
	Year		int unique not null,
    January		int null,
    February		int null,
    March		int null,
    April		int null,
    May		int null,
    June		int null,
    July		int null,
    August		int null,
    September		int null,
    October		int null,
    November		int null,
    December		int null 		
);

insert into sales_statistics(Year, January, February, March, April, MAy, June, July, August, September, October, November, December)
select date_format(order_time, '%Y') as Year,
case date_format(order_time, '%M')
	when 'January'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as January,
case date_format(order_time, '%M')
	when 'February'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
	else 0
end as February,
case date_format(order_time, '%M')
	when 'March'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as March,
case date_format(order_time, '%M')
	when 'April'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as April,
case date_format(order_time, '%M')
	when 'May'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as May,
case date_format(order_time, '%M')
	 when 'June'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as June,
case date_format(order_time, '%M')
	when 'July'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as July,
case date_format(order_time, '%M')
	when 'August'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as August,
case date_format(order_time, '%M')
	when 'September'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as September,
case date_format(order_time, '%M')
	when 'October'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as October,
case date_format(order_time, '%M')
	when 'November'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
    else 0
end as November,
case date_format(order_time, '%M')
	when 'December'	then	(select sum(quantity_ordered) from order_details where order_details.order_id=orders.id group by order_id)
	else 0
end as December
from orders, order_details
group by Year;



-- SECTION 4		I know that's not the correct one!

(select date_format(order_time, '%M') as month
from orders
join order_details on orders.id = order_details.order_id
group by month
order by sum(order_details.quantity_ordered) desc
limit 2 )
union
(select name
from product
join order_details on product.id = order_details.product_id
join orders on	order_details.order_id = orders.id
group by product_id
order by sum(order_details.quantity_ordered) desc
limit 2);

 



