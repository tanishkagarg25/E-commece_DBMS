--create tables DDL
CREATE TABLE `cart` (
  `Cart_id` varchar(7) NOT NULL PRIMARY KEY
);
CREATE TABLE `cart_item` (
  `Quantity_wished` int(1) NOT NULL,
  `Date_Added` date NOT NULL,
  `Cart_id` varchar(7) NOT NULL,
  `Product_id` varchar(7) NOT NULL,
  `purchased` varchar(3) DEFAULT 'NO'
);
CREATE TABLE `customer` (
  `Customer_id` varchar(6) NOT NULL PRIMARY KEY,
  `c_pass` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Address` varchar(20) NOT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `Phone_number_s` varchar(10) NOT NULL,
  `Cart_id` varchar(7) NOT NULL
);
CREATE TABLE `payment` (
  `payment_id` varchar(7) NOT NULL PRIMARY KEY,
  `payment_date` date NOT NULL,
  `Payment_type` varchar(10) NOT NULL,
  `Customer_id` varchar(6) NOT NULL,
  `Cart_id` varchar(7) NOT NULL,
  `total_amount` decimal(6,0) DEFAULT NULL
);
CREATE TABLE `product` (
  `Product_id` varchar(7) NOT NULL PRIMARY KEY,
  `Type` varchar(7) NOT NULL,
  `Color` varchar(15) NOT NULL,
  `P_Size` varchar(2) NOT NULL,
  `Gender` varchar(1) NOT NULL,
  `Commission` varchar(2) NOT NULL,
  `Cost` varchar(5) NOT NULL,
  `Quantity` varchar(2) NOT NULL,
  `Seller_id` varchar(6) DEFAULT NULL
);
CREATE TABLE `seller` (
  `Seller_id` varchar(6) NOT NULL PRIMARY KEY,
  `s_pass` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Address` varchar(10) NOT NULL
);
CREATE TABLE `seller_phone_num` (
  `Phone_num` int(10) NOT NULL,
  `Seller_id` varchar(6) NOT NULL
);
ALTER TABLE `customer`ADD PRIMARY KEY (`Customer_id`),ADD KEY `Cart_id` (`Cart_id`);
ALTER TABLE `seller_phone_num`ADD PRIMARY KEY (`Phone_num`,`Seller_id`),ADD KEY `Seller_id` (`Seller_id`);

--insert
INSERT INTO `cart` (`Cart_id`) VALUES
('crt1011'),
('crt1012'),
('crt1013'),
('crt1014'),
('crt1015');
INSERT INTO `cart_item` (`Quantity_wished`, `Date_Added`, `Cart_id`, `Product_id`, `purchased`) VALUES
(1, '0000-00-00', 'crt1011', 'pid1001', 'Y'),
(3, '0000-00-00', 'crt1012', 'pid1004', 'NO');
INSERT INTO `customer` (`Customer_id`, `c_pass`, `Name`, `Address`, `pincode`, `Phone_number_s`, `Cart_id`) VALUES
('cid100', 'ABCM1235', 'rajat', 'G-432', '632014', '2147483647', 'crt1011'),
('cid101', 'ABCM1236', 'niketan', 'G-454', '55786', '2147483647', 'crt1012'),
('cid102', 'ABCM1237', 'chinkuu', 'G-456', '65379', '2147483647', 'crt1013'),
('cid103', 'ABCM1238', 'sapnaaa', 'G-459', '32656', '2147483647', 'crt1014');
INSERT INTO `payment` (`payment_id`, `payment_date`, `Payment_type`, `Customer_id`, `Cart_id`, `total_amount`) VALUES
('pmt1001', '0000-00-00', 'online', 'cid100', 'crt1011', NULL),
('pmt1002', '0000-00-00', 'online', 'cid100', 'crt1012', NULL),
('pmt1003', '0000-00-00', 'cash', 'cid102', 'crt1013', NULL),
('pmt1004', '0000-00-00', 'online', 'cid103', 'crt1014', NULL);
INSERT INTO `product` (`Product_id`, `Type`, `Color`, `P_Size`, `Gender`, `Commission`, `Cost`, `Quantity`, `Seller_id`) VALUES
('pid1001', 'jeans', 'red', '32', 'M', '10', '10005', '0', 'sid100'),
('pid1002', 'top', 'red', '30', 'F', '12', '500', '0', 'sid103'),
('pid1003', 'purse', 'purple', '32', 'F', '10', '800', '0', 'sid103'),
('pid1004', 'belt', 'brown', '30', 'M', '11', '300', '0', 'sid106'),
('pid1008', 'wallet', 'brown', '10', 'M', '10', '600.0', '3.', 'sid100');
INSERT INTO `seller` (`Seller_id`, `s_pass`, `Name`, `Address`) VALUES
('sid100', '12345', 'amannnnn', 'delhi  '),
('sid103', '96543', 'nikatan', 'agra'),
('sid106', '98723', 'phangar', 'delhi cmc'),
('sid108', '98745', 'Naman', 'jaipur'),
('sid109', '67523', 'tani', 'bangalore');
INSERT INTO `seller_phone_num` (`Phone_num`, `Seller_id`) VALUES
(906416370, 'sid100'),
(906486537, 'sid103'),
(990016870, 'sid100');

--join
select sum(quantity_wished * cost * commission/100) total_profit from product p join cart_item c on p.product_id=c.product_id where c.purchased="Y";
select sum(quantity_wished * cost) total_payable from product p join cart_item c on p.product_id=c.product_id where c.product_id in (select product_id from cart_item where cart_id in(select Cart_id from customer where customer_id='cid101') and c.purchased="Y");
SELECT product.Product_id,product.Type,seller.Name FROM product INNER JOIN seller ON product.Seller_id=seller.Seller_id;	
select p.product_id,p.type,c.Product_id from product as p left join cart_item as c on p.product_id = c.product_id; 

--aggregate
select sum(quantity_wished) number_of_item,cart_id from Cart_item group by cart_id;
select count(product_id) count_pid,date_added from Cart_item where purchased='Y'  group by(date_added);
select max(cost),type max_cost from product;
select count(Phone_num) no_of_contacts,seller_id from seller_phone_num group by Seller_id;

--set
SELECT * FROM customer WHERE name like "s%" union select * from customer where name like "%a";
SELECT product_id FROM product intersect select product_id from cart_item; 
SELECT product_id FROM product except select product_id from cart_item;
SELECT Customer_id FROM payment intersect select customer_id from customer;

--function
DELIMITER //
CREATE FUNCTION totalProducts(sId varchar(6))
RETURNS int(3)
DETERMINISTIC  
BEGIN  
declare total int default 0;
select count(*) into total
from product
where seller_id=sId;
return total;
end //
DELIMITER;
select seller_id,totalProducts(Seller_id) from product;

--procedure
DELIMITER $$
CREATE procedure prod_details(p_id varchar(10))
BEGIN
declare quan int(2) default 0;
    select quantity into quan from product where product_id=p_id;
END $$
DELIMITER ;
call prod_details('pid1008');

--trigger
DELIMITER //
CREATE TRIGGER quan_check BEFORE INSERT ON `cart_item`
FOR EACH ROW BEGIN
    IF new.quantity_wished = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'QUANTITY CANT BE 0';
    END IF;
    end;

--cursor
c = mydb.cursor();

