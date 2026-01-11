------------------------
-- ETAPE 1 : SEQUENCES (Générateurs de TK)
---------------------------------------------------------
CREATE SEQUENCE SEQ_TK_DATE  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TK_CUST  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TK_TRACK START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TK_EMP   START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TK_ART   START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_TK_FACT  START WITH 1 INCREMENT BY 1;

---------------------------------------------------------
-- ETAPE 2 : DIMENSION DATE
---------------------------------------------------------
CREATE TABLE DIM_DATE (
    TK_DATE          NUMBER PRIMARY KEY, 
    DATE_REELLE      DATE,               
    ANNEE            NUMBER(4),          
    TRIMESTRE        NUMBER(1),          
    MOIS_NOM         VARCHAR2(20),       
    JOUR_NOM         VARCHAR2(20),       
    SEMAINE_ANNEE    NUMBER(2)           
);

---------------------------------------------------------
-- ETAPE 3 : DIMENSIONS METIER (Avec noms d'origine)
---------------------------------------------------------

-- Dimension CUSTOMER
CREATE TABLE DIM_CUSTOMER (
    TK_CUSTOMER      NUMBER PRIMARY KEY, -- Seule Clé Primaire
    CUSTOMERID       NUMBER,             -- Nom d'origine (Plus de PK !)
    FULL_NAME        VARCHAR2(255),
    CITY             VARCHAR2(100),
    COUNTRY          VARCHAR2(100),
    EMAIL            VARCHAR2(255),
    COMPANY          VARCHAR2(255),
    INTEGRATION_DATE TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Dimension ARTIST
CREATE TABLE DIM_ARTIST (
    TK_ARTIST        NUMBER PRIMARY KEY,
    ARTISTID         NUMBER,             -- Nom d'origine
    NAME             VARCHAR2(255),
    NATIONALITE      VARCHAR2(100), -- (A remplir si dispo, ou laisser vide)
    GENRE_PRINCIPAL  VARCHAR2(100), 
    STATUT           VARCHAR2(50), 
    INTEGRATION_DATE TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Dimension EMPLOYEE
CREATE TABLE DIM_EMPLOYEE (
    TK_EMPLOYEE      NUMBER PRIMARY KEY,
    EMPLOYEEID       NUMBER,             -- Nom d'origine
    LAST_NAME        VARCHAR2(100),
    FIRST_NAME       VARCHAR2(100),
    TITLE            VARCHAR2(100),
    BIRTHDATE        DATE,
    HIREDATE         DATE,
    INTEGRATION_DATE TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Dimension TRACK (Piste)
CREATE TABLE DIM_TRACK (
    TK_TRACK         NUMBER PRIMARY KEY,
    TRACKID          NUMBER,             -- Nom d'origine
    NAME             VARCHAR2(255),
    COMPOSER         VARCHAR2(255),
    UNITPRICE        NUMBER(10,2),
    ALBUM_TITLE      VARCHAR2(255),      
    GENRE_NAME       VARCHAR2(100),      
    MEDIATYPE_NAME   VARCHAR2(100),      
    INTEGRATION_DATE TIMESTAMP DEFAULT SYSTIMESTAMP
);

---------------------------------------------------------
-- ETAPE 4 : TABLE DE FAITS (FACT_SALES)
---------------------------------------------------------
CREATE TABLE FACT_SALES (
    TK_SALES         NUMBER PRIMARY KEY,
    
    -- Clés étrangères vers les TK des dimensions
    FK_DATE          NUMBER,
    FK_CUSTOMER      NUMBER,
    FK_TRACK         NUMBER,
    FK_EMPLOYEE      NUMBER,
    
    -- Infos d'origine (Optionnel, pour tracer)
    INVOICEID        NUMBER,
    INVOICELINEID    NUMBER,
    
    -- Mesures
    QUANTITY         NUMBER,
    UNITPRICE        NUMBER(10,2),
    TOTAL_AMOUNT     NUMBER(10,2),
    INTEGRATION_DATE TIMESTAMP DEFAULT SYSTIMESTAMP,

    -- Liens techniques
    CONSTRAINT FK_SALES_DATE FOREIGN KEY (FK_DATE) REFERENCES DIM_DATE(TK_DATE),
    CONSTRAINT FK_SALES_CUST FOREIGN KEY (FK_CUSTOMER) REFERENCES DIM_CUSTOMER(TK_CUSTOMER),
    CONSTRAINT FK_SALES_TRK  FOREIGN KEY (FK_TRACK) REFERENCES DIM_TRACK(TK_TRACK),
    CONSTRAINT FK_SALES_EMP  FOREIGN KEY (FK_EMPLOYEE) REFERENCES DIM_EMPLOYEE(TK_EMPLOYEE)
);

---------------------------------------------------------
-- ETAPE 5 : Remplissage Date (Indispensable)
---------------------------------------------------------
DECLARE
    v_start_date DATE := TO_DATE('01/01/2009', 'DD/MM/YYYY');
    v_end_date   DATE := TO_DATE('31/12/2030', 'DD/MM/YYYY');
    v_curr_date  DATE;
BEGIN
    v_curr_date := v_start_date;
    WHILE v_curr_date <= v_end_date LOOP
        INSERT INTO DIM_DATE (
            TK_DATE, DATE_REELLE, ANNEE, TRIMESTRE, MOIS_NOM, JOUR_NOM, SEMAINE_ANNEE
        ) VALUES (
            SEQ_TK_DATE.NEXTVAL,
            v_curr_date,
            TO_NUMBER(TO_CHAR(v_curr_date, 'YYYY')),
            TO_NUMBER(TO_CHAR(v_curr_date, 'Q')),
            TO_CHAR(v_curr_date, 'Month', 'NLS_DATE_LANGUAGE=FRENCH'),
            TO_CHAR(v_curr_date, 'Day', 'NLS_DATE_LANGUAGE=FRENCH'),
            TO_NUMBER(TO_CHAR(v_curr_date, 'IW'))
        );
        v_curr_date := v_curr_date + 1;
    END LOOP;
    COMMIT;
END;
/