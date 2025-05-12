SELECT * FROM items;
SELECT * FROM sales;
SELECT 
    s.sale_id,
    i.item_name,
    s.quantity_sold,
    s.sale_date,
    s.total_amount
FROM sales s
JOIN items i ON s.item_id = i.item_id;
