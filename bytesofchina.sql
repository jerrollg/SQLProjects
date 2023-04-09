CREATE TABLE restaurant(
  id integer PRIMARY KEY,
  name varchar(20),
  description varchar(100),
  rating decimal,
  telephone char(10),
  hours varchar(100)
);
INSERT INTO restaurant VALUES (
  1,
  'China Bytes',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

CREATE TABLE address(
  id integer PRIMARY KEY,
  restaurant_id integer REFERENCES restaurant(id) UNIQUE,
  street_number varchar(10),
  street_name varchar (20),
  city varchar(20),
  state varchar(50),
  google_map_link varchar(50));
INSERT INTO address VALUES (
  1,
  1,
  '2020',
  'Busy St',
  'Chinatown',
  'MA',
  'http://bit.ly/ChinaBytes'
);

CREATE TABLE category(
  id char(2) PRIMARY KEY,
  name varchar(20),
  description varchar(200)
);
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

CREATE TABLE dish(
  id integer PRIMARY KEY,
  name varchar(50),
  description varchar(200),
  hot_and_spicy boolean
);
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

CREATE TABLE review(
  id integer PRIMARY KEY,
  restaurant_id integer REFERENCES restaurant(id),
  rating decimal,
  description varchar(100),
  date date
);
INSERT INTO review VALUES (
  1,
  1,
  5.0,
  'Would love to host another birthday party at China Byte!',
  '05-22-2020'
);
INSERT INTO review VALUES (
  2,
  1,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020'
);
INSERT INTO review VALUES (
  3,
  1,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020'
);
INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);
INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

CREATE TABLE categories_dishes (
  category_id char(2) REFERENCES category(id),
  dish_id integer REFERENCES dish(id),
  price money,
  PRIMARY KEY(category_id, dish_id)
);
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);

SELECT name, street_number, street_name, telephone
FROM restaurant, address;

SELECT id, MAX(rating) AS best_rating
FROM review
GROUP BY id
ORDER BY rating DESC;

SELECT 
  dish.name AS dish_name,
  categories_dishes.price AS price,
  category.name AS category
FROM dish
LEFT JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
INNER JOIN category
  ON categories_dishes.category_id = category.id
ORDER BY 1;

SELECT 
  category.name AS category,
  dish.name AS dish_name,
  categories_dishes.price AS price
FROM category
LEFT JOIN categories_dishes
  ON category.id = categories_dishes.category_id
INNER JOIN dish
  ON categories_dishes.dish_id = dish.id
ORDER BY 1;

SELECT 
  dish.name AS spicy_dish_name,
  category.name AS category,
  categories_dishes.price AS price
FROM dish
LEFT JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
INNER JOIN category
  ON categories_dishes.category_id = category.id
WHERE hot_and_spicy = 'Yes';

SELECT 
  dish_id,
  COUNT(dish_id)
FROM categories_dishes
GROUP BY dish_id
HAVING COUNT(dish_id) > 1;

SELECT
  dish.name AS dish_name,
  COUNT(dish_id) AS dish_count
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
GROUP BY dish.name
HAVING COUNT(dish_id) > 1;

SELECT 
  rating,
  description
FROM review
WHERE rating = (
  SELECT MAX(rating)
  FROM review);