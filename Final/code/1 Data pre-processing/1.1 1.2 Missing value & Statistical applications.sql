/* create and use database */
CREATE DATABASE LibrarySystem;
USE LibrarySystem;

/* info */
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r10946013', '資料科學', 1, '劉謦瑄');

SELECT DATABASE();
SELECT * FROM self;




/* create table */
CREATE TABLE Publishing_Orgarnization (
    PublisherID int NOT NULL,
    Name varchar(40),
    URL varchar(40) DEFAULT 'None',
    disjoint_org varchar(40) NOT NULL CHECK (disjoint_org="Person" OR disjoint_org="Publiser"),
    PRIMARY KEY (PublisherID)
);

CREATE TABLE Borrower (
    ID int NOT NULL,
    Name_firstname varchar(40),
    Name_lastname varchar(40),
    Address_city varchar(40) DEFAULT '台北',
    Address_street varchar(40),
    Address_number varchar(40) CHECK (Address_number>'0'),
    PhoneNumber varchar(40),
    Overlapping_type varchar(40) CHECK (Overlapping_type="student" OR Overlapping_type="teacher" OR Overlapping_type="member" OR Overlapping_type="other"),
    PRIMARY KEY (ID)
);

CREATE TABLE Library_Item (
    ID int NOT NULL,
    Title varchar(40),
    Avalibale int DEFAULT 0 CHECK (Avalibale=0 OR Avalibale=1),
    PRIMARY KEY (ID),

    
    Fk_PublishingOrg_Id int DEFAULT 0,
    FOREIGN KEY (Fk_PublishingOrg_Id) REFERENCES Publishing_Orgarnization(PublisherID),
    
    Fk_Borrower_Id int DEFAULT 0,
    FOREIGN KEY (Fk_Borrower_Id) REFERENCES Borrower(ID)
);


CREATE TABLE Author (
    Author_ID int NOT NULL,
    Name varchar(40) DEFAULT 'Author_Name',
    Address ENUM('北部', '中部', '南部') NOT NULL,
    PRIMARY KEY (Author_ID)
);

CREATE TABLE Editor (
    Editor_ID_ int NOT NULL,
    Name varchar(40) DEFAULT 'Editor_Name',
    Address ENUM('北部', '中部', '南部') NOT NULL,
    mentor_id int,
    PRIMARY KEY (Editor_ID_),
    FOREIGN KEY (mentor_id) REFERENCES Editor(Editor_ID_)
);

CREATE TABLE Book (
    ISBN int NOT NULL DEFAULT 0,
    Price int CHECK(Price>0),
    type ENUM('一般圖書', '兒童圖書', '成人書籍') NOT NULL,
    Author_ID int NOT NULL,
    Editor_ID int,
    fk_Libraryitem_id int NOT NULL,
    PRIMARY KEY (ISBN),
    
    FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID),
    FOREIGN KEY (Editor_ID) REFERENCES Editor(Editor_ID_),
    FOREIGN KEY (fk_Libraryitem_id) REFERENCES Library_Item(ID),
    UNIQUE (fk_Libraryitem_id)
);

CREATE TABLE Magazine (
	Dates varchar(40) DEFAULT "1900-1-1",
	type varchar(40) DEFAULT "general",
	Price int CHECK (Price>=0),
	fk_Libraryitem_id int NOT NULL,
	FOREIGN KEY (fk_Libraryitem_id) REFERENCES Library_Item(ID),
    UNIQUE (fk_Libraryitem_id)
); 

CREATE TABLE Journal (
    Volume int DEFAULT 1,
    type varchar(40) DEFAULT "general",
    Price int CHECK (Price>=0),
    fk_Libraryitem_id int NOT NULL,
    FOREIGN KEY (fk_Libraryitem_id) REFERENCES Library_Item(ID),
    UNIQUE (fk_Libraryitem_id)
); 

CREATE TABLE Borrower_PhoneNumber_multi (
    ID int NOT NULL,
    PhoneNumber_multi varchar(40),
    Phone_type varchar(40),
    FOREIGN KEY (ID) REFERENCES Borrower(ID)
);

create table reserved_by_mn (
    Borrower_id_ int not null,
    Library_Item_id_ int not null,
    Waiting_number int not null,
    CONSTRAINT reserve_borrower_id foreign key (Borrower_id_) references Borrower(ID),
    CONSTRAINT reserve_libraryitem_id foreign key (Library_Item_id_) references Library_Item(ID),
    CONSTRAINT reserve_unique UNIQUE (Borrower_id_, Library_Item_id_)
);

create table edits_mn (
    Book_id_mn int not null,
    Editor_id_mn int not null,
    editors_number int DEFAULT 1,
    CONSTRAINT edit_book_id foreign key (Book_id_mn) references Book(ISBN),
    CONSTRAINT edit_editor_id foreign key (Editor_id_mn) references Editor(Editor_ID_),
    CONSTRAINT edit_unique UNIQUE (Book_id_mn, Editor_id_mn)
);






/* insert */
INSERT INTO Publishing_Orgarnization
VALUES 
(1, '文化出版社', 'https://wenhua.com.tw', "Person"),
(2, '台大出版社', 'https://taida.edu.tw', "Person"),
(3, '國家出版社', 'https://national.com.tw', "Publiser");

INSERT INTO Borrower
VALUES 
(1,"劉","謦瑄","台北","中正路","370","0912345678","student"),
(2,"王","小明","台北","愛國西路","204","0987654321","teacher"),
(3,"李","大為","台南","中正路","20","29291234","member");

INSERT INTO Library_Item
VALUES 
(1, '好看的書', 1,1,Null),
(2, '更好看的書', 0,2,1),
(3, '最好看的書', 0,3,1),
(4, '好好看的書', 0,2,2),
(5, '第一本雜誌', 1,2,Null),
(6, '第二本雜誌', 0,1,2),
(7, '第三本雜誌', 1,3,Null),
(8, 'Journal第一集', 0,1,1),
(9, 'Journal第二集', 0,2,3),
(10, 'Journal第三集', 1,1,Null);

INSERT INTO Author
VALUES 
(1, '李白', "北部"),
(2, '杜甫', "中部"),
(3, '曹植', "中部"),
(4, '曹丕', "南部");

INSERT INTO Editor
VALUES
(1, "神編輯", "北部", Null),
(2, "厲害編輯", "北部", 1),
(3, "傳奇編輯", "南部", 2),
(4, "猛編輯", "中部", 1);

INSERT INTO Book
VALUES
(1234567890, 1000, '一般圖書', 1, 1, 1),
(1356782901, 400, '成人書籍', 2, 2, 2),
(1107893846, 400, '兒童圖書', 3, 4, 3),
(1034128394, NULL, '一般圖書', 4, 3, 4);

INSERT INTO Magazine
VALUES
("1999-06-06","general",399,5),
("2000-04-26","general",299,6),
("2021-05-31","general",450,7);

INSERT INTO Journal
VALUES
(1,"general",399,8),
(2,"general",299,9),
(3,"general",450,10);

INSERT INTO Borrower_PhoneNumber_multi
VALUES
(1, "29213809","Home"),
(3, "0989345231","CellPhone"),
(1, "0934782999","CellPhone");

INSERT INTO reserved_by_mn
VALUES
(2,1,1),
(3,1,2),
(2,4,1);

INSERT INTO edits_mn
VALUES
(1234567890,1,1),
(1356782901,2,1),
(1107893846,4,1),
(1034128394,3,1);











######## Part - FINAL REPORT ########




## ORIGINAL
Select * from Book;


DELIMITER $$
Create procedure SUM_Price(OUT total INT)
begin
    select sum(Price) INTO total from Book;
end $$
DELIMITER ;

call SUM_Price(@sum_);
SELECT @sum_;


## FIND AVG
DELIMITER $$
Create procedure Count_Price(OUT total INT)
begin
    select COUNT(*) INTO total from Book WHERE Price IS NOT NULL;
end $$
DELIMITER ;

call Count_Price(@total_);
SELECT @total_;


SET @avg = @sum_/@total_;
select @avg;



## 更新NULL為指定資訊
DELIMITER $$
Create Procedure Update_info (IN avg_price INT)
    BEGIN
    UPDATE LibrarySystem.BOOK
    SET Book.Price = avg_price 
    WHERE Book.Price IS NULL;
END $$
DELIMITER ;

CALL Update_info(@avg);
Select * from Book;
DROP PROCEDURE IF EXISTS Update_info;

UPDATE Book 
SET Book.Price = NULL
WHERE ISBN = '1034128394';





## 找最大值
DELIMITER $$ 
Create procedure Max_num(OUT output INT)
begin
    SELECT MAX(Price) INTO output FROM Book;
    -- AS current; 
end $$
DELIMITER ;

call Max_num(@max_num);
SELECT @max_num;


## 更新NULL為指定資訊
DELIMITER $$
Create Procedure Update_info (IN avg_price INT)
    BEGIN
    UPDATE LibrarySystem.BOOK
    SET Book.Price = avg_price 
    WHERE Book.Price IS NULL;
END $$
DELIMITER ;

CALL Update_info(@max_num);
Select * from Book;
DROP PROCEDURE IF EXISTS Update_info;


UPDATE Book 
SET Book.Price = NULL
WHERE ISBN = '1034128394';



## FIND 出現次數最多的值
DELIMITER $$ 
Create procedure MaxCount_num(OUT output INT)
begin
    SELECT Price INTO output FROM 
        (SELECT DISTINCT Price , count( * ) AS count FROM Book  
        GROUP BY Price  ORDER BY count DESC  LIMIT 1) 
    AS current; ### 注意要加這個才可以
end $$
DELIMITER ;

call MaxCount_num(@maxcount_num);
SELECT @maxcount_num;

## 更新NULL為指定資訊
DELIMITER $$
Create Procedure Update_info (IN avg_price INT)
    BEGIN
    UPDATE LibrarySystem.BOOK
    SET Book.Price = avg_price 
    WHERE Book.Price IS NULL;
END $$
DELIMITER ;

CALL Update_info(@maxcount_num);
Select * from Book;
DROP PROCEDURE IF EXISTS Update_info;


UPDATE Book 
SET Book.Price = NULL
WHERE ISBN = '1034128394';



## 找最大值最小值
DELIMITER $$ 
Create procedure MaxMin_num(OUT output_max INT, OUT output_min INT)
begin
    SELECT MAX(Price) INTO output_max FROM Book;
    SELECT MIN(Price) INTO output_min FROM Book; 
end $$
DELIMITER ;

call MaxMin_num(@max_num, @min_num);
SELECT @max_num;
SELECT @min_num;



-- 產生大於或等於 column最小值 且小於或等於 column最大值 的整數亂數
DELIMITER $$ 
Create procedure Random_num(IN max_num INT, IN min_num INT,OUT output INT)
begin
    SELECT FLOOR(RAND() * (max_num - min_num + 1) + min_num) INTO output;
end $$
DELIMITER ;

call Random_num(@max_num, @min_num, @rand_num);
SELECT @rand_num;


## 更新NULL為指定資訊
DELIMITER $$
Create Procedure Update_info (IN avg_price INT)
    BEGIN
    UPDATE LibrarySystem.BOOK
    SET Book.Price = avg_price 
    WHERE Book.Price IS NULL;
END $$
DELIMITER ;

CALL Update_info(@rand_num);
Select * from Book;
DROP PROCEDURE IF EXISTS Update_info;






-- ## 寫出四分位數

/* create table */
CREATE TABLE BOOK_ITEM (
    Category varchar(40),
    Book_ID varchar(40),
    AssessedValue INT
);

INSERT INTO BOOK_ITEM
VALUES
("漫畫","1",441),
("漫畫","2",447),
("漫畫","3",230),
("漫畫","4",496),
("漫畫","5",300),
("漫畫","6",525),
("童書","7",295),
("童書","8",379),
("童書","9",289),
("童書","10",331),
("童書","11",313),
("童書","12",220);



/* https://namepluto.com/%E8%A7%A3%E6%B1%BA-mysql-error-code-1055-group-by-%E5%A0%B1%E9%8C%AF/ */
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


SELECT Category, Book_ID, AssessedValue,
    -- Bucket the assessed value for each property into quartiles based on its community
    NTILE(4) OVER (ORDER BY AssessedValue) AS Quartile
FROM BOOK_ITEM;

SELECT
    Category,
    -- Get the minimum value for the community 
    MIN(AssessedValue) Minimum,
    -- Get the 1st quartile boundary for the community, which is the highest value in the 1st quartile
    MAX(CASE WHEN Quartile = 1 THEN AssessedValue END) 1Quartile,
    -- Get the median for the community, which is the highest value in the 2nd quartile
    MAX(CASE WHEN Quartile = 2 THEN AssessedValue END) Median,
    -- Get the 3rd quartile boundary for the community, which is the highest value in the 3rd quartile
    MAX(CASE WHEN Quartile = 3 THEN AssessedValue END) 3Quartile,
    -- Get the maximum value for the community
    MAX(AssessedValue) Maximum,
    -- Get a count of the total properties in the community 
    COUNT(Quartile) AS Count
FROM (
    SELECT
        Category, Book_ID, AssessedValue,
        -- Bucket the assessed value for each property into quartiles based on its community
        NTILE(4) OVER (ORDER BY AssessedValue) AS Quartile
    FROM
        BOOK_ITEM
) Vals
GROUP BY
    Category
ORDER BY
    Category;






## 百分位數Percentile
DELIMITER $$ 
Create procedure Percentile1(IN percent FLOAT,OUT output FLOAT)
begin
    SELECT (COUNT(*)-1)*(1-percent) AS cnt FROM BOOK_ITEM INTO output;
end $$
DELIMITER ;

SET @percent = 0.95;
call Percentile1(@percent, @out);
SELECT @out;


DELIMITER $$ 
Create procedure Percentile2(IN n INT,OUT output INT)
begin
    SELECT AssessedValue FROM BOOK_ITEM ORDER BY AssessedValue DESC LIMIT n,1 INTO output;
end $$
DELIMITER ;

call Percentile2(@out,@ans);
SELECT @ans;





-- 刪除相同資料（https://www.796t.com/content/1543919114.html）

-- Part 1. 刪除全部欄位相同的資料
# 先自行新增幾個重複項
INSERT INTO BOOK_ITEM
VALUES
("漫畫","1",441), ## 整列重複
("童書","7",295), ## 整列重複
("雜誌","13",600); ## 新增類別項

SELECT * FROM BOOK_ITEM;

## 刪除全部欄位相同的資料 (不能直接刪除 因為刪除與查詢若同步 mysql會出錯)
DELIMITER $$ 
Create procedure DELETE_ALL_SAME()
begin
    CREATE TABLE TEMP_BOOK_ITEM AS (SELECT DISTINCT * FROM BOOK_ITEM);
    DELETE FROM BOOK_ITEM;
    INSERT INTO BOOK_ITEM (SELECT * FROM TEMP_BOOK_ITEM);
    DROP TABLE TEMP_BOOK_ITEM;
    SELECT * FROM BOOK_ITEM;
end $$
DELIMITER ;

call DELETE_ALL_SAME();







-- Part 2. 刪除特定欄位資料相同之資料
# 先自行新增幾個重複項
INSERT INTO BOOK_ITEM
VALUES
("漫畫","1",441), ## 整列重複
("童書","7",295), ## 整列重複
("雜誌","13",600); ## 新增類別項
SELECT * FROM BOOK_ITEM;

## 查詢某欄位相同的資料
CREATE TABLE TEMP_BOOK_ITEM2 AS (SELECT * FROM BOOK_ITEM
GROUP BY Book_ID
HAVING COUNT(Book_ID)>1);
SELECT COUNT(*) from TEMP_BOOK_ITEM2;
SELECT * FROM TEMP_BOOK_ITEM2;


## 刪除特定欄位相同的資料 (不能直接刪除 因為刪除與查詢若同步 mysql會出錯)
DELETE FROM BOOK_ITEM WHERE Book_ID IN
(
    SELECT * FROM (SELECT Book_ID FROM BOOK_ITEM
    GROUP BY Book_ID
    HAVING COUNT(Book_ID) > 1) NN
);

INSERT INTO BOOK_ITEM (SELECT * FROM TEMP_BOOK_ITEM2);

DROP TABLE TEMP_BOOK_ITEM2;
SELECT * FROM BOOK_ITEM;









/* drop database */
DROP DATABASE LibrarySystem;
