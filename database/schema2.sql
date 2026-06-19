-- ============================================================
--  UNIVERSITY LIBRARY MANAGEMENT SYSTEM
--  Physical Model (SQL Script)
-- ============================================================

-- ============================================================
--  1. TABLE CREATION
-- ============================================================

CREATE TABLE country (
    country_id   INTEGER     PRIMARY KEY,
    country_name VARCHAR(60),
    country_code CHAR(2)
);

CREATE TABLE state (
    state_id     INTEGER     PRIMARY KEY,
    state_name   VARCHAR(40),
    state_code   CHAR(2),
    country_id   INTEGER     NOT NULL
);

CREATE TABLE city (
    city_id      INTEGER      PRIMARY KEY,
    city_name    VARCHAR(100),
    state_id     INTEGER      NOT NULL
);

CREATE TABLE publisher (
    publisher_id     INTEGER      PRIMARY KEY,
    publisher_name   VARCHAR(100),
    corporate_tax_id CHAR(14)     UNIQUE,
    email            VARCHAR(100),
    phone            VARCHAR(15),
    city_id          INTEGER      NOT NULL
);

CREATE TABLE subject_area (
    subject_id   INTEGER      PRIMARY KEY,
    subject_name VARCHAR(50),
    description  VARCHAR(255)
);

CREATE TABLE book (
    book_id          INTEGER      PRIMARY KEY,
    isbn             VARCHAR(20)  UNIQUE,
    title            VARCHAR(150),
    publication_year SMALLINT,
    edition          SMALLINT,
    publisher_id     INTEGER      NOT NULL,
    subject_id       INTEGER      NOT NULL
);

CREATE TABLE book_copy (
    copy_id          INTEGER     PRIMARY KEY,
    accession_number VARCHAR(20) UNIQUE,
    status           VARCHAR(20),
    acquisition_date DATE,
    book_id          INTEGER     NOT NULL
);

CREATE TABLE author (
    author_id   INTEGER      PRIMARY KEY,
    author_name VARCHAR(100),
    nationality VARCHAR(50),
    birth_date  DATE,
    lattes_url  VARCHAR(255)
);

CREATE TABLE user_type (
    user_type_id       INTEGER     PRIMARY KEY,
    description        VARCHAR(30),
    max_loan_days      SMALLINT,
    max_loans_allowed  SMALLINT
);

CREATE TABLE user (
    user_id           INTEGER      PRIMARY KEY,
    full_name         VARCHAR(100),
    national_id       CHAR(11),
    email             VARCHAR(100),
    phone             VARCHAR(15),
    registration_date DATE,
    user_type_id      INTEGER      NOT NULL,
    city_id           INTEGER      NOT NULL,
    UNIQUE (email, national_id)
);

CREATE TABLE enrollment (
    enrollment_id     INTEGER      PRIMARY KEY,
    enrollment_number VARCHAR(20)  UNIQUE,
    course            VARCHAR(80),
    department        VARCHAR(80),
    is_active         BOOLEAN,
    user_id           INTEGER      NOT NULL
);

CREATE TABLE loan (
    loan_id     INTEGER     PRIMARY KEY,
    loan_date   DATE,
    due_date    DATE,
    return_date DATE,
    status      VARCHAR(15),
    user_id     INTEGER     NOT NULL,
    copy_id     INTEGER     NOT NULL
);

CREATE TABLE fine (
    fine_id       INTEGER       PRIMARY KEY,
    daily_rate    DECIMAL(4,2),
    days_overdue  SMALLINT,
    total_amount  DECIMAL(10,2),
    is_paid       BOOLEAN,
    payment_date  DATE,
    loan_id       INTEGER       NOT NULL UNIQUE
);

-- Associative table for the M:N relationship between author and book
CREATE TABLE written_by (
    author_id    INTEGER  NOT NULL,
    book_id      INTEGER  NOT NULL,
    author_order SMALLINT,
    PRIMARY KEY (author_id, book_id)
);


-- ============================================================
--  2. FOREIGN KEY CONSTRAINTS (ALTER TABLE)
-- ============================================================

-- state → country
ALTER TABLE state ADD CONSTRAINT FK_state_country
    FOREIGN KEY (country_id)
    REFERENCES country (country_id)
    ON DELETE RESTRICT;

-- city → state
ALTER TABLE city ADD CONSTRAINT FK_city_state
    FOREIGN KEY (state_id)
    REFERENCES state (state_id)
    ON DELETE RESTRICT;

-- publisher → city
ALTER TABLE publisher ADD CONSTRAINT FK_publisher_city
    FOREIGN KEY (city_id)
    REFERENCES city (city_id)
    ON DELETE RESTRICT;

-- book → publisher
ALTER TABLE book ADD CONSTRAINT FK_book_publisher
    FOREIGN KEY (publisher_id)
    REFERENCES publisher (publisher_id)
    ON DELETE RESTRICT;

-- book → subject_area
ALTER TABLE book ADD CONSTRAINT FK_book_subject_area
    FOREIGN KEY (subject_id)
    REFERENCES subject_area (subject_id)
    ON DELETE RESTRICT;

-- book_copy → book
ALTER TABLE book_copy ADD CONSTRAINT FK_book_copy_book
    FOREIGN KEY (book_id)
    REFERENCES book (book_id)
    ON DELETE RESTRICT;

-- user → user_type
ALTER TABLE user ADD CONSTRAINT FK_user_user_type
    FOREIGN KEY (user_type_id)
    REFERENCES user_type (user_type_id)
    ON DELETE RESTRICT;

-- user → city
ALTER TABLE user ADD CONSTRAINT FK_user_city
    FOREIGN KEY (city_id)
    REFERENCES city (city_id)
    ON DELETE RESTRICT;

-- enrollment → user
ALTER TABLE enrollment ADD CONSTRAINT FK_enrollment_user
    FOREIGN KEY (user_id)
    REFERENCES user (user_id)
    ON DELETE RESTRICT;

-- loan → user
ALTER TABLE loan ADD CONSTRAINT FK_loan_user
    FOREIGN KEY (user_id)
    REFERENCES user (user_id)
    ON DELETE CASCADE;

-- loan → book_copy
ALTER TABLE loan ADD CONSTRAINT FK_loan_book_copy
    FOREIGN KEY (copy_id)
    REFERENCES book_copy (copy_id)
    ON DELETE RESTRICT;

-- fine → loan
ALTER TABLE fine ADD CONSTRAINT FK_fine_loan
    FOREIGN KEY (loan_id)
    REFERENCES loan (loan_id)
    ON DELETE CASCADE;

-- written_by → author
ALTER TABLE written_by ADD CONSTRAINT FK_written_by_author
    FOREIGN KEY (author_id)
    REFERENCES author (author_id)
    ON DELETE RESTRICT;

-- written_by → book
ALTER TABLE written_by ADD CONSTRAINT FK_written_by_book
    FOREIGN KEY (book_id)
    REFERENCES book (book_id)
    ON DELETE RESTRICT;


-- ============================================================
--  3. DATA INSERTION (SEED DATA)
-- ============================================================

INSERT INTO country VALUES (1, 'Brazil', 'BR');
INSERT INTO country VALUES (2, 'Portugal', 'PT');

INSERT INTO state VALUES (1, 'São Paulo',      'SP', 1);
INSERT INTO state VALUES (2, 'Rio de Janeiro', 'RJ', 1);
INSERT INTO state VALUES (3, 'Minas Gerais',   'MG', 1);
INSERT INTO state VALUES (4, 'Lisbon',         'LX', 2);

INSERT INTO city VALUES (1, 'São Paulo',       1);
INSERT INTO city VALUES (2, 'Campinas',        1);
INSERT INTO city VALUES (3, 'Rio de Janeiro',  2);
INSERT INTO city VALUES (4, 'Belo Horizonte',  3);
INSERT INTO city VALUES (5, 'Lisbon',          4);

INSERT INTO publisher VALUES (1, 'Editora Atlas',       '12345678000190', 'contato@atlas.com.br',    '(11)3333-1111', 1);
INSERT INTO publisher VALUES (2, 'Pearson Education',   '98765432000100', 'br@pearson.com',           '(11)4444-2222', 1);
INSERT INTO publisher VALUES (3, 'O''Reilly Brasil',    '11122233000155', 'contato@oreilly.com.br',  '(21)5555-3333', 3);
INSERT INTO publisher VALUES (4, 'Elsevier',            '44455566000177', 'brasil@elsevier.com',     '(21)6666-4444', 3);

INSERT INTO subject_area VALUES (1, 'Computer Science', 'Algorithms, data structures, operating systems');
INSERT INTO subject_area VALUES (2, 'Database Systems', 'Modeling, SQL, NoSQL, data administration');
INSERT INTO subject_area VALUES (3, 'Software Engineering','Agile methodologies, design patterns, software quality');
INSERT INTO subject_area VALUES (4, 'Computer Networks', 'Protocols, infrastructure, network security');
INSERT INTO subject_area VALUES (5, 'Discrete Mathematics', 'Logic, combinatorics, graph theory');

INSERT INTO book VALUES (1, '978-85-7522-408-2', 'Database Systems',           2011, 6, 4, 2);
INSERT INTO book VALUES (2, '978-85-7506-198-3', 'Introduction to Programming with Python', 2019, 3, 2, 1);
INSERT INTO book VALUES (3, '978-85-5519-040-1', 'Software Engineering',               2016, 10,1, 3);
INSERT INTO book VALUES (4, '978-85-7522-508-9', 'Computer Networking and the Internet',  2021, 8, 4, 4);
INSERT INTO book VALUES (5, '978-85-7641-451-4', 'Discrete Mathematics for Computing', 2015, 2, 1, 5);

INSERT INTO book_copy VALUES (1, 'T-0001', 'Available',   '2018-03-10', 1);
INSERT INTO book_copy VALUES (2, 'T-0002', 'Available',   '2018-03-10', 1);
INSERT INTO book_copy VALUES (3, 'T-0003', 'Borrowed',    '2019-07-22', 2);
INSERT INTO book_copy VALUES (4, 'T-0004', 'Available',   '2020-01-15', 3);
INSERT INTO book_copy VALUES (5, 'T-0005', 'Maintenance', '2017-11-05', 4);
INSERT INTO book_copy VALUES (6, 'T-0006', 'Available',   '2021-09-30', 5);

INSERT INTO author VALUES (1, 'Ryan Gosling',      'American', '1950-04-12', NULL);
INSERT INTO author VALUES (2, 'Sherlock Holmes',    'American', '1945-08-22', NULL);
INSERT INTO author VALUES (3, 'Neymar',            'Brazilian','1978-06-01', 'http://lattes.cnpq.br/1234');
INSERT INTO author VALUES (4, 'David Tennant',     'British',  '1951-02-28', NULL);
INSERT INTO author VALUES (5, 'Dean Winchester',    'American', '1956-10-18', NULL);
INSERT INTO author VALUES (6, 'Sam Winchester',     'American', '1955-03-07', NULL);

INSERT INTO written_by VALUES (1, 1, 1);
INSERT INTO written_by VALUES (2, 1, 2);
INSERT INTO written_by VALUES (3, 2, 1);
INSERT INTO written_by VALUES (4, 3, 1);
INSERT INTO written_by VALUES (5, 4, 1);
INSERT INTO written_by VALUES (6, 4, 2);

INSERT INTO user_type VALUES (1, 'Undergraduate Student', 15, 3);
INSERT INTO user_type VALUES (2, 'Graduate Student',      30, 5);
INSERT INTO user_type VALUES (3, 'Professor',             60, 10);
INSERT INTO user_type VALUES (4, 'Staff',                 30, 5);

INSERT INTO user VALUES (1, 'James Santos',  '11122233344', 'james@email.br',    '(11)91111-1111', '2022-02-10', 1, 1);
INSERT INTO user VALUES (2, 'Rafael',         '22233344455', 'rafael@email.br',        '(11)92222-2222', '2021-08-15', 1, 2);
INSERT INTO user VALUES (3, 'Camille',        '33344455566', 'camille@email.br',       '(21)93333-3333', '2019-03-01', 3, 3);
INSERT INTO user VALUES (4, 'Mariana Costa',  '44455566677', 'mariana.c@email.br',      '(31)94444-4444', '2023-01-20', 2, 4);
INSERT INTO user VALUES (5, 'João Oliveira',  '55566677788', 'joao.o@email.br',        '(11)95555-5555', '2022-11-05', 1, 1);

INSERT INTO enrollment VALUES (1, '2022001', 'Computer Science', 'DCOMP', TRUE,  1);
INSERT INTO enrollment VALUES (2, '2021010', 'Information Systems', 'DSI',  TRUE,  2);
INSERT INTO enrollment VALUES (3, '2023050', 'Master''s in Computing', 'PPGCC',TRUE,  4);
INSERT INTO enrollment VALUES (4, '2022100', 'Software Engineering', 'DCOMP',TRUE,  5);

INSERT INTO loan VALUES (1, '2024-03-01', '2024-03-16', '2024-03-14', 'Returned', 1, 1);
INSERT INTO loan VALUES (2, '2024-03-05', '2024-03-20', NULL,         'Active',   2, 3);
INSERT INTO loan VALUES (3, '2024-02-10', '2024-04-10', '2024-04-20', 'Returned', 3, 4);
INSERT INTO loan VALUES (4, '2024-03-15', '2024-03-30', NULL,         'Overdue',  5, 2);
INSERT INTO loan VALUES (5, '2024-03-20', '2024-05-20', NULL,         'Active',   4, 6);

-- Fine data (Loan 3: 10 days overdue)
INSERT INTO fine VALUES (1, 2.00, 10, 20.00, TRUE,  '2024-04-22', 3);
-- Active fine for non-returned overdue loan (Loan 4)
INSERT INTO fine VALUES (2, 2.00, 5,  10.00, FALSE, NULL,         4);


-- ============================================================
--  4. QUERIES (DATA RETRIEVAL)
-- ============================================================

-- 4.1 All books with their respective authors and publisher
SELECT
    b.title,
    b.isbn,
    b.publication_year,
    b.edition,
    a.author_name,
    wb.author_order,
    p.publisher_name,
    sa.subject_name
FROM book b
JOIN publisher    p  ON b.publisher_id = p.publisher_id
JOIN subject_area sa ON b.subject_id   = sa.subject_id
JOIN written_by   wb ON b.book_id      = wb.book_id
JOIN author       a  ON wb.author_id   = a.author_id
ORDER BY b.title, wb.author_order;

-- 4.2 Active and overdue loans with user and book copy details
SELECT
    u.full_name                             AS user_name,
    ut.description                          AS user_role,
    b.title                                 AS book_title,
    bc.accession_number,
    l.loan_date,
    l.due_date,
    l.status,
    DATEDIFF(CURDATE(), l.due_date)        AS days_overdue
FROM loan l
JOIN user      u  ON l.user_id      = u.user_id
JOIN user_type ut ON u.user_type_id = ut.user_type_id
JOIN book_copy bc ON l.copy_id      = bc.copy_id
JOIN book      b  ON bc.book_id     = b.book_id
WHERE l.status IN ('Active', 'Overdue')
ORDER BY l.due_date;

-- 4.3 Unpaid / Open fines
SELECT
    u.full_name         AS user_name,
    u.email,
    b.title             AS book_title,
    l.loan_date,
    l.due_date,
    f.days_overdue,
    f.daily_rate,
    f.total_amount
FROM fine f
JOIN loan      l  ON f.loan_id = l.loan_id
JOIN user      u  ON l.user_id = u.user_id
JOIN book_copy bc ON l.copy_id = bc.copy_id
JOIN book      b  ON bc.book_id = b.book_id
WHERE f.is_paid = FALSE
ORDER BY f.total_amount DESC;

-- 4.4 Complete loan history per user
SELECT
    u.full_name,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status,
    COALESCE(CAST(f.total_amount AS CHAR), 'No fine') AS fine_amount
FROM user u
JOIN loan      l  ON l.user_id = u.user_id
JOIN book_copy bc ON l.copy_id = bc.copy_id
JOIN book      b  ON bc.book_id = b.book_id
LEFT JOIN fine f  ON f.loan_id = l.loan_id
ORDER BY u.full_name, l.loan_date;

-- 4.5 Most borrowed books
SELECT
    b.title,
    COUNT(l.loan_id) AS total_loans
FROM book b
JOIN book_copy bc ON bc.book_id = b.book_id
JOIN loan      l  ON l.copy_id  = bc.copy_id
GROUP BY b.book_id, b.title
ORDER BY total_loans DESC;
