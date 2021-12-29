SET SERVEROUTPUT ON;
-- ADDITION OF TWO NUMBERS
DECLARE
NUM1 INTEGER:=&n ;
NUM2 INTEGER:=30;
NUM3 INTEGER;
NUM4 REAL;
BEGIN
NUM3:=NUM1+NUM2;
DBMS_OUTPUT.PUT_LINE('VALUE OF NUM3 IS ' || NUM3);
NUM4:=51.00/4.00;
DBMS_OUTPUT.PUT_LINE('VALUE OF NUM4 IS ' || NUM4);

END;
/   

-- TO PRINT NAME FROM TABLES
SET SERVEROUTPUT ON;

DECLARE
NAME VARCHAR2(20);

BEGIN
SELECT FIRST_NAME INTO NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN 1001;
DBMS_OUTPUT.PUT_LINE(NAME);

END;

/

--SCOPE OF VARIABLE
DECLARE
NUM1 INTEGER:=20;
BEGIN
DECLARE
NUM2 INTEGER:=30;
BEGIN
DBMS_OUTPUT.PUT_LINE(NUM1||NUM2);
END;
DECLARE 
NUM3 INTEGER:=40;
BEGIN
DBMS_OUTPUT.PUT_LINE(NUM1||NUM3);
END;
END;
/

--IFELSE

SET SERVEROUTPUT ON;

DECLARE
NUM INTEGER:=100;
BEGIN
IF (NUM=10) THEN
DBMS_OUTPUT.PUT_LINE('NUMBER IS 10');
ELSIF(NUM=20) THEN
DBMS_OUTPUT.PUT_LINE('NUMBER IS 20');
ELSE
DBMS_OUTPUT.PUT_LINE('NUMBER IS NOT THERE');
END IF;
END;
/

SET SERVEROUTPUT ON;

DECLARE
RAINBOW VARCHAR(20):='V';
BEGIN
CASE RAINBOW
WHEN 'V' THEN DBMS_OUTPUT.PUT_LINE('VIOLET');
WHEN 'I' THEN DBMS_OUTPUT.PUT_LINE('INDIGO');
WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('BLUE');
WHEN 'G' THEN DBMS_OUTPUT.PUT_LINE('GREEN');
WHEN 'Y' THEN DBMS_OUTPUT.PUT_LINE('YELLOW');
WHEN 'O' THEN DBMS_OUTPUT.PUT_LINE('ORANGE');
WHEN 'R' THEN DBMS_OUTPUT.PUT_LINE('RED');
END CASE;
END;
/

--LOOPING IN PLSQL

SET SERVEROUTPUT ON;

DECLARE
NUM INTEGER:=1;
BEGIN
LOOP
DBMS_OUTPUT.PUT_LINE(NUM);
IF (NUM =10) THEN
EXIT;
END IF;
NUM:=NUM+1;
END LOOP;
END;
/

SET SERVEROUTPUT ON;
DECLARE
NUM INTEGER:=1;
BEGIN
WHILE (NUM<10)
LOOP
DBMS_OUTPUT.PUT_LINE(NUM);
NUM:=NUM+1;
END LOOP;
END;
/


SET SERVEROUTPUT ON;
DECLARE
NUM INTEGER:=&N;
BEGIN
FOR I IN 1..10 LOOP
NUM:=NUM+I;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(I)||'-'||TO_CHAR(NUM));
END LOOP;
END;
/

SET SERVEROUTPUT ON;
DECLARE
NUM INTEGER:=&N;
BEGIN
FOR I IN REVERSE 1..10 LOOP
NUM:=NUM+I;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(I)||'-'||TO_CHAR(NUM));
END LOOP;
END;
/

SET SERVEROUTPUT ON;
DECLARE
A NUMBER:=&UPPER_BOUND;
BEGIN
FOR I IN 1..A LOOP
DBMS_OUTPUT.PUT_LINE(I);
END LOOP;
END;
/

SELECT * FROM EMPLOYEES;

SET SERVEROUTPUT ON;
DECLARE
TYPE EMP_TABLE_TYPE IS TABLE OF EMPLOYEES %ROW TYPE INDEX BY BINARY_INTEGER;
MY_EMP EMP_TABLE_TYPE;
V_COUNT NUMBER:=1007;
BEGIN
FOR I IN 1000..V_COUNT LOOP
      SELECT * INTO my_emp(i) FROM employees
      WHERE employee_id = i;
  END LOOP;
  FOR i IN my_emp.FIRST .. my_emp.LAST
  LOOP
     DBMS_OUTPUT.PUT_LINE ( my_emp(i).last_name);
  END LOOP;
END;
/

SET SERVEROUTPUT ON;

DECLARE
   TYPE emp_table_type is table of
             employees%ROWTYPE INDEX BY BINARY_INTEGER;
   my_emp_table emp_table_type;
   V_START  EMPLOYEES.EMPLOYEE_ID%TYPE := 1001;
   v_count   EMPLOYEES.EMPLOYEE_ID%TYPE:= 1003;
BEGIN
  FOR i IN 1001..v_count
   LOOP
   SELECT * INTO my_emp_table(i) FROM employees
   WHERE employee_id = i;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FIRST NAME'||'  '||'LAST NAME');
  FOR i IN my_emp_table.FIRST .. my_emp_table.LAST
  LOOP
     DBMS_OUTPUT.PUT_LINE ( my_emp_table(i).first_name||'           '||my_emp_table(i).last_name);
  END LOOP;
  
  EXCEPTION
  WHEN NO_DATA_FOUND THEN 
  DBMS_OUTPUT.PUT_LINE('NO DATA FOUND FOR THE GIVEN EMPLOYEE ID');
END;
/
DECLARE
I iNTEGER;
BEGIN

SELECT ORDER_ID INTO I 
FROM ORDERS 
WHERE SALESMAN_ID = 1002;
EXCEPTION
WHEN TOO_MANY_ROWS THEN 
DBMS_OUTPUT.PUT_LINE('TOO MANY MATCHES FOR THE SALESMAN ID');

END;
/
SELECT * FROM ORDERS;

CREATE OR REPLACE PACKAGE BODY sales AS 

procedure insertCustomers
(
name IN customers.name%type,
address in customers.address%type,
website in customers.website%type,
credit_limt in customers.credit_limit%type,
status out varchar2,
error out varchar2
)  
is    
begin    
insert into customers(name ,address,website,credit_limit ) values( name,address,website,credit_limt );    
dbms_output.put_line('Customers record inserted successfully');

if sql%rowcount>0 then 
status:='Values Inserted';
end if;
commit;

EXCEPTION when others then 
status:='Value not Inserted';
error:=sqlcode||' '||sqlerrm;


 
end;
/


CREATE OR REPLACE PACKAGE sales AS 
   --add product
   PROCEDURE add_products( 
   p_name products.product_name%type, 
   p_desc  products.description%type, 
   p_cost products.standard_cost%type,  
   p_price  products.list_price%type, 
   p_catagory products.category_id%type,p_status out varchar2,p_error out varchar2);
   -- Removes a product
   PROCEDURE remove_product(p_id   products.product_id%type,p_status out varchar2,p_error out varchar2);
   end;
   /
   
CREATE OR REPLACE PACKAGE BODY sales AS 
    PROCEDURE add_products( 
   p_name products.product_name%type, 
   p_desc  products.description%type, 
   p_cost products.standard_cost%type,  
  p_price  products.list_price%type, 
   p_catagory products.category_id%type,p_status out varchar2,p_error out varchar2)
   IS 
   BEGIN 
      INSERT INTO products (product_name,description,standard_cost,list_price,category_id) 
         VALUES( p_name, p_desc, p_cost, p_price,p_catagory);
         if sql%rowcount>0
         then p_status:='product inserted';
         end if;
         commit;
         EXCEPTION 
         when others then
         p_status:='product not inserted';
         p_error:=sqlcode||sqlerrm;
   END add_products; 
   
   PROCEDURE remove_product(p_id   products.product_id%type,p_status out varchar2,p_error out varchar2) IS 
   BEGIN 
      DELETE FROM products
      WHERE product_id = p_id; 
      if sql%rowcount>0
      then p_status:='deleted';
      end if;
      if sql%rowcount=0
      then p_status:='no data deleted';
      end if;
      commit;
         EXCEPTION 
         when others then
         p_status:='no data found';
         p_error:=sqlcode||sqlerrm;
         
   END remove_product;
   end;
   /
--ADD PRODUCT
DECLARE 
   p_status varchar2(20);
   p_error varchar2(300);
BEGIN
  sales.add_products('Cookies', 'Snacks', 40, 43, 104,p_status,p_error);
  DBMS_OUTPUT.PUT_LINE(p_status||' '||p_error);
  end;
  /
--DELETE PRODUCT
SET SERVEROUTPUT ON
DECLARE 
     pro_id products.product_id%type:=&enter_id;
     p_status varchar2(200);
     p_error varchar2(500);
      
BEGIN
   sales.remove_product(pro_id,p_status,p_error);
   dbms_output.put_line(p_status||' '||p_error);
end remove_product;
/




--27-12-2021



SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE sales AS
PROCEDURE add_product_details(
--add product
pro_name products.product_name%TYPE,
pro_desc products.DESCRIPTION%TYPE,
pro_standcost products.standard_cost%TYPE,
pro_listprice products.list_price%TYPE,
pro_categoryid products.category_id%TYPE,
prod_status OUT VARCHAR2,prod_error OUT VARCHAR2);
--Remove product
PROCEDURE remove_product(pro_id products.product_id%TYPE,prod_status OUT VARCHAR2,prod_error OUT VARCHAR2);
--add employee
 PROCEDURE add_employees(
  emp_fname employees.first_name%TYPE,
  emp_lname employees.last_name%TYPE,
  emp_email employees.email%TYPE,
  emp_phone employees.phone%TYPE,
  emp_hire employees.hire_date%TYPE,
  emp_mid employees.manager_id%TYPE,
  emp_jtitle employees.job_title%TYPE,e_status OUT VARCHAR2,e_error OUT VARCHAR2);
--remove employees
 PROCEDURE remove_employees(emp_id employees.employee_id%TYPE,e_status OUT VARCHAR2,e_error OUT VARCHAR2);
--ADD CUSTOMERS
 PROCEDURE add_customers(
   cus_name customers.cname%TYPE,
   cus_address customers.address%TYPE,
   cus_website customers.website%TYPE,
   cus_credit customers.credit_limit%TYPE,c_status OUT VARCHAR2,c_error OUT VARCHAR2);
--remove customer
  PROCEDURE remove_customers(cus_id customers.cutomer_id%TYPE,c_status OUT VARCHAR2,c_error OUT VARCHAR2);
--ADD ORDERS
 PROCEDURE add_orders(
 ord_cus_id orders.customer_id%TYPE,
 ord_status orders.status%TYPE,
 ord_sales_id orders.salesman_id%TYPE,
 ord_date orders.order_date%TYPE,o_status OUT VARCHAR2,o_error OUT VARCHAR2);
--REMOVE ORDERS
PROCEDURE cancel_orders(ord_id orders.order_id%TYPE,o_status OUT VARCHAR2,o_error OUT VARCHAR2);
--ADD ORDER ITEMS
PROCEDURE add_order_items(
orditm_ord_id order_items.order_id%TYPE,
orditm_prod_id order_items.product_id%TYPE,
orditm_qnty order_items.quantity%TYPE,
orditm_unitprice order_items.unit_price%TYPE,oitm_status OUT VARCHAR2,oitm_error OUT VARCHAR2);
--REMOVE ORDER_ITEMS
PROCEDURE remove_order_items(orditm_order_id order_items.order_id%TYPE,oitm_status OUT VARCHAR2,oitm_error OUT VARCHAR2);

--ADD PRODUCT_CATEGORIES
PROCEDURE ADD_CATEGORIES(
   CAT_NAME IN product_categories.category_name%TYPE,
   c_status OUT VARCHAR2,c_error OUT VARCHAR2);
--REMOVE PRODUCT CATEGORIES
PROCEDURE REMOVE_CATEGORIES(CAT_ID IN product_categories.category_id%TYPE,PCSTATUS OUT VARCHAR2,PCERROR OUT VARCHAR2);

END sales;  
/
CREATE OR REPLACE PACKAGE BODY sales AS
PROCEDURE add_product_details(
pro_name products.product_name%TYPE,
pro_desc products.DESCRIPTION%TYPE,
pro_standcost products.standard_cost%TYPE,
pro_listprice products.list_price%TYPE,
pro_categoryid products.category_id%TYPE,
prod_status OUT VARCHAR2,prod_error OUT VARCHAR2)
IS
BEGIN
  INSERT INTO products (product_name,DESCRIPTION,standard_cost,list_price,category_id)
  VALUES(pro_name,pro_desc,pro_standcost,pro_listprice,pro_categoryid);
  IF SQL%rowcount>0
  THEN prod_status:='PRODUCT INSERTED';
  END IF;
  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
  prod_status:='NO DATA INSERTED';
  prod_error:=SQLCODE||sqlerrm;
END add_product_details;

PROCEDURE remove_product(pro_id products.product_id%TYPE,prod_status OUT VARCHAR2,prod_error OUT VARCHAR2) IS
BEGIN
   DELETE FROM products WHERE product_id=pro_id;
    IF SQL%found
  THEN prod_status:='DATA DELETED';
  END IF;
  COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
  prod_status:='NO DATA DELETED';
  prod_error:=SQLCODE||sqlerrm;
END remove_product;

 PROCEDURE add_employees(
  emp_fname employees.first_name%TYPE,
  emp_lname employees.last_name%TYPE,
  emp_email employees.email%TYPE,
  emp_phone employees.phone%TYPE,
  emp_hire employees.hire_date%TYPE,
  emp_mid employees.manager_id%TYPE,
  emp_jtitle employees.job_title%TYPE,e_status OUT VARCHAR2,e_error OUT VARCHAR2)IS
  BEGIN
  INSERT INTO employees(first_name,last_name,email,phone,hire_date,manager_id,job_title)
     VALUES(emp_fname,emp_lname,emp_email,emp_phone,emp_hire,emp_mid,emp_jtitle);
     IF SQL%rowcount>0
         THEN e_status:='employee inserted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
         e_status:='employee data not inserted';
         e_error:=SQLCODE||sqlerrm;
  END add_employees;
 
 PROCEDURE remove_employees(emp_id employees.employee_id%TYPE,e_status OUT VARCHAR2,e_error OUT VARCHAR2)IS
  BEGIN
      DELETE FROM employees WHERE employee_id=emp_id;
        IF SQL%rowcount>0
         THEN  e_status:='delteded';
         END IF;
        IF SQL%rowcount=0
         THEN  e_status:='not deleted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN no_data_found THEN
         dbms_output.put_line('product id does not found');
         WHEN OTHERS THEN
         e_status:='not deleted';
         e_error:=SQLCODE||sqlerrm;
 END remove_employees;
 
 PROCEDURE add_customers(
   cus_name customers.cname%TYPE,
   cus_address customers.address%TYPE,
   cus_website customers.website%TYPE,
   cus_credit customers.credit_limit%TYPE,c_status OUT VARCHAR2,c_error OUT VARCHAR2)IS
   BEGIN
   INSERT INTO customers(cname,address,website,credit_limit)
   VALUES(cus_name,cus_address,cus_website,cus_credit);
   IF SQL%rowcount>0
         THEN c_status:='data inserted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
         c_status:='data not inserted';
         c_error:=SQLCODE||sqlerrm;
   END add_customers;

  PROCEDURE remove_customers(cus_id customers.cutomer_id%TYPE,c_status OUT VARCHAR2,c_error OUT VARCHAR2)IS
   BEGIN
   DELETE FROM customers WHERE cutomer_id=cus_id;
   IF SQL%rowcount>0
         THEN c_status:='deleted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN no_data_found THEN
         dbms_output.put_line('customer id does not found');
         WHEN OTHERS THEN
         c_status:='not found';
         c_error:=SQLCODE||sqlerrm;
   END remove_customers;
   
PROCEDURE add_orders(
 ord_cus_id orders.customer_id%TYPE,
 ord_status orders.status%TYPE,
 ord_sales_id orders.salesman_id%TYPE,
 ord_date orders.order_date%TYPE,o_status OUT VARCHAR2,o_error OUT VARCHAR2)IS
  BEGIN
 INSERT INTO orders(customer_id ,status ,salesman_id ,order_date)
 VALUES(ord_cus_id,ord_status,ord_sales_id,ord_date);
 IF SQL%rowcount>0
         THEN o_status:='data inserted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
         o_status:='not inserted';
         o_error:=SQLCODE||sqlerrm;
 END add_orders;
 
PROCEDURE cancel_orders(ord_id orders.order_id%TYPE,o_status OUT VARCHAR2,o_error OUT VARCHAR2)IS
 BEGIN
 UPDATE orders SET status='cancelled' WHERE order_id=ord_id;
 IF SQL%rowcount>0
         THEN o_status:='ORDER CANCELED';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
         o_status:='not CANCELED';
         o_error:=SQLCODE||sqlerrm;
 END cancel_orders;

PROCEDURE add_order_items(
orditm_ord_id order_items.order_id%TYPE,
orditm_prod_id order_items.product_id%TYPE,
orditm_qnty order_items.quantity%TYPE,
orditm_unitprice order_items.unit_price%TYPE,oitm_status OUT VARCHAR2,oitm_error OUT VARCHAR2)IS
BEGIN
 INSERT INTO order_items(order_id ,product_id ,quantity ,unit_price)
 VALUES(orditm_ord_id,orditm_prod_id,orditm_qnty,orditm_unitprice);
 IF SQL%rowcount>0
         THEN oitm_status:='inserted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
        oitm_status:='not inserted';
        oitm_error:=SQLCODE||sqlerrm;
 END add_order_items;

PROCEDURE remove_order_items(orditm_order_id order_items.order_id%TYPE,oitm_status OUT VARCHAR2,oitm_error OUT VARCHAR2)IS
BEGIN
   DELETE FROM order_items WHERE ITEM_ID=orditm_order_id;
   IF SQL%rowcount>0
         THEN oitm_status:='order items removed';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
        oitm_status:='not removed';
        oitm_error:=SQLCODE||sqlerrm;
   END remove_order_items;
   
   --ADD CATEGORIES

PROCEDURE ADD_CATEGORIES(
   CAT_NAME IN product_categories.category_name%TYPE,
   c_status OUT VARCHAR2,c_error OUT VARCHAR2)IS
   BEGIN
   INSERT INTO PRODUCT_CATEGORIES(CATEGORY_NAME)
   VALUES(CAT_NAME);
   IF SQL%rowcount>0
         THEN c_status:='data inserted';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
         c_status:='data not inserted';
         c_error:=SQLCODE||sqlerrm;
   END ADD_CATEGORIES;

--DELETE CATEGORIES

PROCEDURE REMOVE_CATEGORIES(CAT_ID PRODUCT_CATEGORIES.CATEGORY_ID%TYPE,PCSTATUS OUT VARCHAR2,PCERROR OUT VARCHAR2)IS
BEGIN
   DELETE FROM PRODUCT_CATEGORIES WHERE CATEGORY_ID=CAT_ID;
   IF SQL%rowcount>0
         THEN pcstatus:='order items removed';
         END IF;
         IF SQL%ROWCOUNT=0 THEN
         pcstatus:='not removed';
         END IF;
         COMMIT;
         EXCEPTION
         WHEN OTHERS THEN
        pcstatus:='not removed';
        pcerror:=SQLCODE||sqlerrm;
   END REMOVE_CATEGORIES;


END sales;
/
SELECT* FROM products;
SELECT * FROM employees;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
/
SET SERVEROUTPUT ON;
DECLARE
 prov_status VARCHAR2(100);
 prov_error VARCHAR(100);
 product_id products.product_id%TYPE:='&enter_the_id';
 BEGIN
  sales.remove_product(product_id,prov_status,prov_error);
  dbms_output.put_line(prov_status||''||prov_error);
END;
/


SET SERVEROUTPUT ON;
DECLARE
result1 VARCHAR2(50);
ERROR VARCHAR2(50);
BEGIN
sales.add_customers('sachin','KARUR','WWW.KARURBALA.COM',45000,result1,ERROR);
CUSTPACKAGE.CUSTDELETE(1416);
dbms_output.put_line(result1);
--EXCEPTION WHEN OTHERS THEN
--DBMS_OUTPUT.PUT_LINE('Error in inserting the value');
result1:='RESULT1';

ERROR:=SQLCODE||' '||sqlerrm;
dbms_output.put_line(ERROR);


END;
/


-Add product
DECLARE
p_status varchar2 (100);
p_error varchar2(500);
BEGIN
sales.add_product_details('samsung','mobile',2000,3000,10,p_status,p_error);
dbms_output.put_line(p_status||''||p_error);
end add_product;
/
--Delete product
DECLARE 
 pro_id products.product_id%type:=&enter_id;
 pro_status varchar2(200);
 pro_error varchar2(500);
 BEGIN
sales.remove_product(pro_id,pro_status,pro_error);
 dbms_output.put_line(pro_status||''||pro_error);
 end remove_prod;
/
--ADD CUSTOMERS
SET SERVEROUTPUT ON;
DECLARE
RESULT1 VARCHAR2(50);
ERROR VARCHAR2(50);
BEGIN
SALES.ADD_CUSTOMERS('HARI','KARUR','WWW.KARURBALA.COM',45000,RESULT1,ERROR);

DBMS_OUTPUT.PUT_LINE(RESULT1);
--EXCEPTION WHEN OTHERS THEN
--DBMS_OUTPUT.PUT_LINE('Error in inserting the value');
RESULT1:='RESULT1';
ERROR:=SQLCODE||' '||SQLERRM;
DBMS_OUTPUT.PUT_LINE(ERROR);


END;
/
---Delete CUSTOMER
DECLARE 
 CUS_ID CUSTOMERS.CUTOMER_ID%type:=&enter_id;
 STATUS varchar2(200);
 ERROR varchar2(500);
 BEGIN
sales.REMOVE_CUSTOMERS(CUS_ID,STATUS,ERROR);
 dbms_output.put_line(STATUS||''||ERROR);
 end REMOVE_CUSTOMERS;
/


--ADD ORDERS
DECLARE
STATUS VARCHAR2(20);
ERROR1 VARCHAR2(50);
BEGIN
SALES.ADD_ORDERS(1406,'packed',1002,'28-11-2021',STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/


--DELETE ORDERS
DECLARE
ORD_ID ORDERS.ORDER_ID%TYPE:=&ORDER_ID;
STATUS VARCHAR2(50);
ERROR1 VARCHAR2(50);

BEGIN
SALES.cancel_orders(ORD_ID,STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/

--ADD EMPLOYEES
DECLARE
STATUS VARCHAR2(20);
ERROR1 VARCHAR2(50);
BEGIN
SALES.ADD_EMPLOYEES('faruk','m','faruk@gmail.com',9090909898,'28-11-2019',103,'customer support',STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/

--DELETE EMPLOYEES
DECLARE
EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE:=&EMPLOYEE_ID;
STATUS VARCHAR2(50);
ERROR1 VARCHAR2(50);

BEGIN
SALES.REMOVE_EMPLOYEES(EMP_ID,STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/
set serveroutput on;
--ADD ORDER_ITEMS
DECLARE
STATUS VARCHAR2(20);
ERROR1 VARCHAR2(50);
BEGIN
SALES.ADD_ORDER_ITEMS(516,1034,25,50,STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/

--DELETE EMPLOYEES
DECLARE
ITM_ID ORDER_ITEMS.ITEM_ID%TYPE:=&ITEM_ID;
STATUS VARCHAR2(50);
ERROR1 VARCHAR2(50);

BEGIN
SALES.REMOVE_ORDER_ITEMS(ITM_ID,STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/


--ADD PRODUCT_CATEGORIES
DECLARE
STATUS VARCHAR2(20);
ERROR1 VARCHAR2(50);
BEGIN
SALES.ADD_CATEGORIES('PERFUME',STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/


--DELETE PRODUCT CATEGORIES
DECLARE
CAT_ID PRODUCT_CATEGORIES.CATEGORY_ID%TYPE:=&CAT_ID;
STATUS VARCHAR2(50);
ERROR1 VARCHAR2(50);

BEGIN
SALES.REMOVE_CATEGORIES(CAT_ID,STATUS,ERROR1);
DBMS_OUTPUT.PUT_LINE(STATUS||' '||ERROR1);
END;
/