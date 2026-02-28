
CLASS WORK

/*

Ըստ ցուցադրվող արդյունքի ամսվա դեպքում տեսնում ենք վաճառքի ծավալներում 
լավագույն 3 ամիսները, որոնք նույն քառորտի մեջ չեն գտնվում, իսկ քառորդային բաժանման դեպքում
լավագույն քառորդի 3 ամիսներն են, որոնք ամփոփում են լավագույն քառորդը։

SELECT
	DATE_TRUNC('month', order_date_date) AS month,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY  DATE_TRUNC('month', order_date_date)
ORDER BY total_revenue DESC
LIMIT 3;


SELECT
	DATE_TRUNC('quarter', order_date_date) AS quarter,
	SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY  DATE_TRUNC('quarter', order_date_date)
ORDER BY total_revenue DESC
LIMIT 1;


SELECT
	CURRENT_DATE - order_date_date AS days_since_order
FROM sales_analysis
WHERE CURRENT_DATE - order_date_date < 60;


































