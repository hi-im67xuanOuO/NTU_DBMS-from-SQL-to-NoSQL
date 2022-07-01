/* create and use database */
CREATE DATABASE Test;
USE Test;

CREATE TABLE t (
    keyword varchar(40) NOT NULL,
    color varchar(40) NOT NULL
);

INSERT INTO t
VALUES 
('foo','red'),
('bar','yellow'),
('baz','blue'),
('bazbaz','green');

/* select from all tables and views */
SELECT DATABASE();
SELECT * FROM t;
SELECT keyword,
COALESCE(keyword='foo') as red,
COALESCE(keyword='baz') as blue,
COALESCE(keyword='bazbaz') as green,
COALESCE(keyword='bar')as yellow
FROM t;
/* drop database */
DROP DATABASE Test;