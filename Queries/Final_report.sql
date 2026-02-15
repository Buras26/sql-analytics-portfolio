ALTER TABLE employees
ADD CONSTRAINT uq_employees_email UNIQUE (email);



ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);



ALTER TABLE sales 
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);



ALTER TABLE sales
ADD COLUMN sales_channel TEXT;



ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));



-- UPDATE sales Փոփոխություն  ենք կատարում վաճառքի բաժնում
-- SET sales_channel = 'online' վաճաառքի սյունակի արժեքը ընտրում ենք օնլայն
-- WHERE transaction_id % 2 = 0; տոկոսը մնացորդով բաժանումն է, 0-ն զույգը, եթե լիներ 1,ապա կենտ, հրահանգը ենթադրում է ընտրել այն տողը, որտեղ գործարքի այդին զույգ է։



CREATE INDEX idx_sales_product_id
ON sales (product_id);


CREATE INDEX idx_sales_customer_id
ON sales (customer_id)


CREATE INDEX idx_product_category
ON products (category);


/* 1․ Օգտագործումվում է Sequential Scan, քանի որ տողերի քանակը քիչ է։
2. PostreSQL-Ը չի օգտագործում ինդեքս, այլ կիրառում է HashAgregate, այս ծավալի համար արդյուանվետ է։
3. Ընտրվել է սա, քանի որ 5000 տողի համար, սա անվճար տարբերակն է։

EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
*/



/* 1. Երբ ցանկանում ենք տվյալ պահին տեսնել բոլոր սյունակները, ապա կարող ենք ընտրել այս տարբերակը։
2. Ընտրելով կոնկրետ սյունակը, հստակ կունենանք այն տվյալները, որոնք անհրաժեշտ են։
Չենք ծանրաբեռնի ցանցը և հստակ կֆիլտրենք ոչ անհրաժեշտ սյունակները։

SELECT *
FROM sales;

SELECT
  transaction_id,
  product_id,
  total_sales
FROM sales;
*/



/* 
1. order by  հրահանգը ավելացնում է լրացուցիչ հաշվարկային ծախս
2. Այս դեպքում ինդեքսները չեն օգնում, քանի որ total revenue չկա սյունակում, որպեսզի նախապես ինդեքսավորենք։


SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales 
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
*/


/*
1. Այո հարցման պլանները նման են, երկու դեպքում էլ օգտագործվել է, HashAggregate և  Seq Scan on products
2. Ունեն նույն գնահատված արժեքը, 3.50 -ից 4.50
3. Տրամաբանորեն երկուսն էլ նույն աշխատանքն են կատարում, առանց ագրեգատ ֆունկցիաների օրինակ sum, count և այլն, այստեղ ունենք մշակման նույն ճանապարհը։

EXPLAIN
SELECT DISTINCT
  category,
  price
FROM products;

EXPLAIN
SELECT
  category,
  price
FROM products
GROUP BY category, price;

*/


/*

․1. check constraint ունենք, այն թույլ չի տալիս սահմանել 0-ից փոքր արժեք  այս դեպքում։
. տվյալի կրկնության արդյունքում, այն է ՝ customer_id, գործարկվել է primery key սահմանափակումը։
2.օգնում է զերծ մնալ մարդկային կամ տեխնիկական սխալներ թույլ տալուց։

UPDATE products
SET price = -5
WHERE product_id = 101;


INSERT INTO customers (customer_id, email, phone_number)
VALUES (999, 'anna@example.com', '091000999');
*/



1․ PRIMARY KEY
UNIQUE
FOREIGN KEY
CHECK
 Այս չորս սահմանափակումները օգնում են պահել, եզակիություն, խուսափել անտրամաբանական հարցումներից և սխալ մուտքագրումներից։
2. Կոմպոզիտային ինդեքսը կարևոր է, կօգնի ֆիլտրել մի քանի սյունակով
3. EXPLAIN ավելացնելով կտեսնենք հարցման պլանը, որտեղ 

seq scan- սա ենթադրում է որ կարդում է ամբողջ սյունակը համապատասխան տողը գտնելու համար
cost - եթե թիվը մեծ է, ուրեմն ծախսվում է շատ ռեսուրսներ, պետք էօգտագործել արդյունավետ ֆիլտրեր։
hashAggregate- եթե առկա է ապա,  մեծ ծավալի դեպքում դանդաղում է
select * - մեծացնում է ցանցային ծանրաբեռնվածությունը և դանդաղեցնում մշակումը, պետք է ընտրել կոնկրետ սյունակներ
sort - ազդանշում է որ կա հաշվարկային լրացուցիչ ծախս, պետք օգտվել limit հրամանից։