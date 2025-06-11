CREATE OR REPLACE VIEW itemsview1 AS
 SELECT items.* , categories.* FROM items
  INNER JOIN categories on items.items_cat = categories.categories_id;



CREATE OR REPLACE VIEW myfavorite AS 
SELECT favorite.*, items.* , users.users_id FROM favorite
INNER JOIN users ON users.users_id = favorite.favorite_usersid
INNER JOIN items ON items.items_id = favorite.favorite_itemsid

create or replace view cartview as 
SELECT SUM(items.items_price - items.items_price * items.items_discount/100) AS
 itemsprice, COUNT(cart_itemsid) AS
 countitems , cart.*, items.* FROM cart 
 INNER JOIN items ON items.items_id = cart.cart_itemsid 
 WHERE cart_orders = 0
 GROUP BY cart.cart_itemsid, cart.cart_userid ,cart.cart_orders


 CREATE or REPLACE VIEW ordersview as 
SELECT orders.*, address.*FROM orders
LEFT JOIN address ON address.address_id = orders.orders_address 


create or replace view ordersdetailsview as 
SELECT SUM(items.items_price - items.items_price * items.items_discount/100) AS
 itemsprice, COUNT(cart_itemsid) AS
 countitems , cart.*, items.* FROM cart 
 INNER JOIN items ON items.items_id = cart.cart_itemsid 
 WHERE cart_orders != 0
 GROUP BY cart.cart_itemsid, cart.cart_userid