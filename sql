/*Tính tỉ lệ số tiền thanh toán từng ngày với
tổng số tiền đã thanh toán của mỗi KH
OUTPUT: Mã KH, tên KH, ngày thanh toán, số tiền thanh toán tại ngày
tổng số tiền đã thanh toán, tỉ lệ */
--SUBQUERIES
select a.customer_id, b.first_name, a.payment_date, a.amount,
(select sum(amount)
from payment x
where x.customer_id = a.customer_id
group by customer_id),
a.amount/(select sum(amount)
from payment x
where x.customer_id = a.customer_id
group by customer_id) as ti_le
from payment as a
join customer as b on a.customer_id = b.customer_id
group by a.customer_id, b.first_name, a.payment_date, a.amount;
--CTE
with twt_total_payment as 
(select customer_id,
sum(amount) as total
from payment 
group by customer_id)
select a.customer_id, b.first_name, a.payment_date, a.amount, c.total,
a.amount/c.total as ti_le
from payment as a
join customer as b on b.customer_id = a.customer_id
join twt_total_payment as c
on c.customer_id = a.customer_id
--WINDOW 
select a.customer_id, b.first_name, a.payment_date, a.amount,
sum(a.amount) over(partition by a.customer_id) as total -- gom nhóm theo mỗi customer_id chứ không cần liệt kê hết ra như group by 
from payment as a
join customer as b on a.customer_id = b.customer_id
--cu phap
select col1, col2, col3,...
agg(col2) over(partition by col1, col2)
from table
/* Viết truy vấn trả về danh sách phim bao gồm
-film_id
-title
-length,
-category,
-thời lượng trung bình của phim trong categroy đó
-sắp xếp kết quả theo film_id */
select a.film_id, a.title, a.length, c.name as category,
round(avg(length) over (partition by c.name),2) as avg_length
from film a
join public.film_category b on a.film_id = b.film_id
join public.category c on c.category_id = b.category_id
/* Viết truy vấn trả về tất cả chi tiết các thanh toán bao gồm số lần thanh toán
được thực hiện bởi khách hàng này và số tiền đó 
Sắp xếp kết quả theo payment_id */
select*,
count(*) over (partition by customer_id,amount) as so_lan
from payment
order by payment_id;
---- 
select payment_date,amount,customer_id,
sum(amount) over(partition by customer_id order by payment_date) as total_amount
from payment
-- sắp xếp dữ liệu từ xa đến gần, cộng các dữ liệu trước đó lũy kế
-- cú pháp
select col1,col2,..
agg(col2) over (partition by col1,col2... order by col3)
from table 
--window function with rank function
--xếp hạng độ dài phim trong từng thể loại
--output: film_id, category, length, xếp hạng độ dài phim trong từng category

