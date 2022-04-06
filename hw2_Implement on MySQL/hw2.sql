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
(1356782901, 100, '成人書籍', 2, 2, 2),
(1107893846, 400, '兒童圖書', 3, 4, 3),
(1034128394, 200, '一般圖書', 4, 3, 4);

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


/* create two views (Each view should be based on two tables.)*/
CREATE VIEW BooksInfo AS (
  SELECT Editor.Name , Book.Editor_ID, Book.ISBN
  FROM Editor
  LEFT JOIN Book
  ON Book.Editor_ID=Editor.Editor_ID_
);

CREATE VIEW BorrowerItem_info AS (
  SELECT Borrower.Name_firstname , Borrower.Name_lastname, Library_Item.Title
  FROM Borrower
  LEFT JOIN Library_Item
  ON Library_Item.Fk_Borrower_Id=Borrower.ID
);


/* select from all tables and views */
SELECT * FROM Publishing_Orgarnization;
SELECT * FROM Borrower;
SELECT * FROM Library_Item;
SELECT * FROM Author;
SELECT * FROM Editor;
SELECT * FROM Book;
SELECT * FROM Magazine;
SELECT * FROM Journal;
SELECT * FROM Borrower_PhoneNumber_multi;
SELECT * FROM reserved_by_mn;
SELECT * FROM edits_mn;
SELECT * FROM BooksInfo;
SELECT * FROM BorrowerItem_info;


/* drop database */
DROP DATABASE LibrarySystem;
