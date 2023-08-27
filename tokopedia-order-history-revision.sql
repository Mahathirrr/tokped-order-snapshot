CREATE DATABASE tokopedia_order_history2;

USE tokopedia_order_history2;

SHOW TABLES;

# Cari untuk penampilan data nama, apakah perlu untuk explisit secara table atau melalui join

CREATE TABLE product (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_lower VARCHAR(100) NOT NULL,
    weight INT NOT NULL,
    price BIGINT NOT NULL
)ENGINE = InnoDB;

DESC product;

CREATE TABLE orders (
    id VARCHAR(10) PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    shipping_cost BIGINT NOT NULL,
    service_charge BIGINT NOT NULL,
    buyer_id VARCHAR(10),
    address_id VARCHAR(10),
    payment_method_id VARCHAR(10),
    logistic_id VARCHAR(10),
    total_weight          INT          NOT NULL,
    total_product_amount  BIGINT       NOT NULL,
    total_shipping_cost   BIGINT       NOT NULL,
    total_shopping_amount BIGINT       NOT NULL,
    total_amount          BIGINT       NOT NULL,
    seller_id VARCHAR(10),
    seller_name VARCHAR(100) NOT NULL,
    buyer_name VARCHAR(100) NOT NULL,
    address_name VARCHAR(100) NOT NULL,
    adress_address VARCHAR(255) NOT NULL,
    address_province VARCHAR(100) NOT NULL,
    address_city VARCHAR(100) NOT NULL,
    address_country VARCHAR(100) NOT NULL,
    address_postcode VARCHAR(10) NOT NULL,
    payment_method_name VARCHAR(100) NOT NULL ,
    logistic_name VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

DESC orders;

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_buyer
        FOREIGN KEY (buyer_id) REFERENCES buyer(id),
    ADD CONSTRAINT fk_orders_address
        FOREIGN KEY (address_id) REFERENCES address(id),
    ADD CONSTRAINT fk_orders_payment_method
        FOREIGN KEY (payment_method_id) REFERENCES payment_method(id),
    ADD CONSTRAINT fk_orders_seller
        FOREIGN KEY (seller_id) REFERENCES seller(id),
    ADD CONSTRAINT fk_orders_logistic
        FOREIGN KEY (logistic_id) REFERENCES logistic(id);

DESC orders;

CREATE TABLE order_detail (
    product_id VARCHAR(10) PRIMARY KEY,
    orders_id VARCHAR(10) PRIMARY KEY,
    product_quantity INT NOT NULL,
    total_product_amount BIGINT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_weight INT NOT NULL,
    product_price BIGINT NOT NULL
)ENGINE = InnnoDB;

ALTER TABLE order_detail
    ADD CONSTRAINT fk_order_detail_product
        FOREIGN KEY (product_id) REFERENCES product(id),
    ADD CONSTRAINT fk_order_detail_orders
        FOREIGN KEY (orders_id) REFERENCES orders(id);

desc order_detail;

CREATE TABLE buyer (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE seller (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE address (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    post_code VARCHAR(10) NOT NULL,
    city VARCHAR(100) NOT NULL ,
    province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    buyer_id VARCHAR(10)
)ENGINE = InnoDB;

ALTER TABLE address
    ADD CONSTRAINT fk_address_buyer
        FOREIGN KEY (buyer_id) REFERENCES buyer(id);

DESC address;

CREATE TABLE payment_method (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

DESC payment_method;

CREATE TABLE logistic (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

# Membuat table summary
# Table disimpan di database
CREATE TABLE summary_sales (
    seller_id VARCHAR(10) PRIMARY KEY,
    month DATE NOT NULL DEFAULT CONCAT(YEAR(NOW()), '-', MONTH(NOW()), '-01'),
    total_income BIGINT NOT NULL
)ENGINE = InnoDB;

ALTER TABLE summary_sales
    ADD CONSTRAINT fk_summary_sales_seller
        FOREIGN KEY (seller_id) REFERENCES seller(id);

# Table view summary
CREATE VIEW summary_income_view AS
SELECT seller_id, DATE_FORMAT(month, '%Y-%m') AS month, SUM(total_income) AS sales_total
FROM summary_sales
GROUP BY seller_id, DATE_FORMAT(month, '%Y-%m');

