CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  username VARCHAR(200) NOT NULL,
  email VARCHAR(200) NOT NULL,
  password_digest VARCHAR(400) NOT NULL
);

CREATE TABLE breweries (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  address VARCHAR(400) NOT NULL,
  bar_address VARCHAR(400),
  website VARCHAR(200),
  logo VARCHAR(400) NOT NULL,
  avg_rating INTEGER
);

CREATE TABLE beers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  style VARCHAR(400) NOT NULL,
  abv VARCHAR(100) NOT NULL,
  ibu VARCHAR(200),
  image VARCHAR(400) NOT NULL,
  avg_rating INTEGER,
  brewery_id INTEGER NOT NULL,
  FOREIGN KEY (brewery_id) REFERENCES breweries (id) on delete restrict
);

CREATE TABLE brewery_reviews (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  brewery_id INTEGER NOT NULL,
  FOREIGN KEY (brewery_id) REFERENCES breweries (id),
  body VARCHAR(1000) NOT NULL,
  rating VARCHAR(100) NOT NULL
);

CREATE TABLE beer_reviews (
  id SERIAL4 PRIMARY KEY,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  beer_id INTEGER NOT NULL,
  FOREIGN KEY (beer_id) REFERENCES beers (id),
  body VARCHAR(1000) NOT NULL,
  rating VARCHAR(100) NOT NULL
);

-- not sql active record
Beer.create(name: 'Jukebox Hero', style: 'IPA', abv: '7%', ibu: 'N/A', image: 'http://hashigozake.co.nz/images/jukebox%20badge.png', brewery_id: 1)

Brewery.create(name: 'Mountain Goat', address: '80 North St, Richmond VIC 3121', bar_address: 'same', website: 'https://www.goatbeer.com.au/', logo: 'http://craftypint.s3-ap-southeast-2.amazonaws.com/files/assets/eaacab6e/Mountain_Goat_logo.jpg')

Beer.create(name: 'Summer Ale', style: 'Summer Ale', abv: '4.7%', ibu: '20', image: 'https://www.goatbeer.com.au/wp-content/uploads/2017/03/product-summer-ale-2.png', brewery_id: 2)

Beer.create(name: 'Fancy Pants', style: 'Amber Ale', abv: '5.2%', ibu: '30', image: 'https://www.goatbeer.com.au/wp-content/uploads/2017/03/xproduct-fancy-pants-1.png.pagespeed.ic.zpp3V9Usyz.webp', brewery_id: 2)