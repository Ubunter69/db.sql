CREATE DATABASE hobujaamLukk;
USE hobujaamLukk;


CREATE TABLE toit (
  toit_id INT PRIMARY KEY,
  toit_nimi VARCHAR(30),
  kaal INT,
  kogus INT
);



CREATE TABLE amet (
  amet_id INT PRIMARY KEY,
  amet_nimi VARCHAR(50)
);

CREATE TABLE tall (
  tall_id INT PRIMARY KEY,
  asukoht VARCHAR(30),
  maht INT
);

CREATE TABLE omanik (
  omanik_id INT PRIMARY KEY,
  nimi VARCHAR(100),
  tel INT,
  email VARCHAR(30)
);

CREATE TABLE hobused (
  hobuse_id INT PRIMARY KEY,
  nimi VARCHAR(40),
  toit_idfk INT,
  vanus INT,
  sugu VARCHAR(10),
  omanik_idfk INT,
  tall_idfk INT
);

CREATE TABLE veterenaar (
  vet_id INT PRIMARY KEY,
  nimi VARCHAR(30),
  oskus VARCHAR(100),
  tel INT
);

CREATE TABLE tootaja (
  tootaja_id INT PRIMARY KEY,
  tootaja_nimi VARCHAR(40),
  amet_idfk INT,
  palk INT
);



CREATE TABLE toitumine (
  toitumine_id INT PRIMARY KEY,
  toit_idfk INT,
  hobuse_idfk INT,
  kuupaev DATE,
  tootaja_idfk INT
);

CREATE TABLE vetvisiit (
  visiit_id INT PRIMARY KEY,
  hobuse_idfk INT,
  vet_idfk INT,
  visiit_kuupaev DATE,
  diaagnos VARCHAR(200),
  ravi VARCHAR(100)
);

ALTER TABLE hobused
  ADD CONSTRAINT fk_hobused_toit FOREIGN KEY (toit_idfk) REFERENCES toit(toit_id);

ALTER TABLE hobused
  ADD CONSTRAINT fk_hobused_omanik FOREIGN KEY (omanik_idfk) REFERENCES omanik(omanik_id);

ALTER TABLE hobused
  ADD CONSTRAINT fk_hobused_tall FOREIGN KEY (tall_idfk) REFERENCES tall(tall_id);

ALTER TABLE tootaja
  ADD CONSTRAINT fk_tootaja_amet FOREIGN KEY (amet_idfk) REFERENCES amet(amet_id);

ALTER TABLE toitumine
  ADD CONSTRAINT fk_toitumine_toit FOREIGN KEY (toit_idfk) REFERENCES toit(toit_id);

ALTER TABLE toitumine
  ADD CONSTRAINT fk_toitumine_hobune FOREIGN KEY (hobuse_idfk) REFERENCES hobused(hobuse_id);

ALTER TABLE toitumine
  ADD CONSTRAINT fk_toitumine_tootaja FOREIGN KEY (tootaja_idfk) REFERENCES tootaja(tootaja_id);

-- Таблица vetvisiit
ALTER TABLE vetvisiit
  ADD CONSTRAINT fk_visiit_hobune FOREIGN KEY (hobuse_idfk) REFERENCES hobused(hobuse_id);

ALTER TABLE vetvisiit
  ADD CONSTRAINT fk_visiit_vet FOREIGN KEY (vet_idfk) REFERENCES veterenaar(vet_id);


INSERT INTO toit (toit_id, toit_nimi, kaal, kogus) VALUES
(1, 'Kaerahelbed', 5, 10),
(2, 'Hein', 10, 20),
(3, 'Porgandid', 2, 5);

INSERT INTO amet (amet_id, amet_nimi) VALUES
(1, 'Tallimees'),
(2, 'Treener'),
(3, 'Loomaarst');

INSERT INTO tall (tall_id, asukoht, maht) VALUES
(1, 'Tallinn', 20),
(2, 'Tartu', 15);

INSERT INTO omanik (omanik_id, nimi, tel, email) VALUES
(1, 'Mari Mets', 51234567, 'mari@gmail.com'),
(2, 'Jüri Kask', 53456789, 'jyri@gmail.com');

INSERT INTO hobused (hobuse_id, nimi, toit_idfk, vanus, sugu, omanik_idfk, tall_idfk) VALUES
(1, 'Mustang', 1, 5, 'mees', 1, 1),
(2, 'Torm', 2, 7, 'naine', 2, 2);

INSERT INTO veterenaar (vet_id, nimi, oskus, tel) VALUES
(1, 'Dr. Kivi', 'Hobuste sisemised haigused', 50123456),
(2, 'Dr. Tamm', 'Ortopeedia', 50987654);

INSERT INTO tootaja (tootaja_id, tootaja_nimi, amet_idfk, palk) VALUES
(1, 'Peeter Saar', 1, 1200),
(2, 'Liis Lill', 2, 1500);

INSERT INTO toitumine (toitumine_id, toit_idfk, hobuse_idfk, kuupaev, tootaja_idfk) VALUES
(1, 1, 1, '2024-05-01', 1),
(2, 2, 2, '2024-05-02', 2);

INSERT INTO vetvisiit (visiit_id, hobuse_idfk, vet_idfk, visiit_kuupaev, diaagnos, ravi) VALUES
(1, 1, 1, '2024-05-03', 'Kõhulahtisus', 'Ravimid'),
(2, 2, 2, '2024-05-04', 'Kabi valu', 'Puhkus ja määrded');


CREATE VIEW vaade_toitumine_info AS
SELECT
    h.nimi AS hobune_nimi,
    t.toit_nimi,
    ttm.kuupaev,
    tr.tootaja_nimi
FROM toitumine ttm
INNER JOIN hobused h ON ttm.hobuse_idfk = h.hobuse_id
INNER JOIN toit t ON ttm.toit_idfk = t.toit_id
INNER JOIN tootaja tr ON ttm.tootaja_idfk = tr.tootaja_id;

SELECT * FROM vaade_toitumine_info
ORDER BY kuupaev DESC;

CREATE VIEW vaade_vetvisiidid AS
SELECT
    h.nimi AS hobune_nimi,
    v.visiit_kuupaev,
    vt.nimi AS veterinaar_nimi,
    v.diaagnos,
    v.ravi
FROM vetvisiit v
INNER JOIN hobused h ON v.hobuse_idfk = h.hobuse_id
INNER JOIN veterenaar vt ON v.vet_idfk = vt.vet_id
WHERE v.visiit_kuupaev >= '2024-05-01';

select * from vaade_vetvisiidid
order by visiit_kuupaev DESC;


CREATE VIEW vaade_hobuste_arv_omaniku_jaoks AS
SELECT
    o.nimi AS omanik_nimi,
    COUNT(h.hobuse_id) AS hobuste_arv
FROM omanik o
INNER JOIN hobused h ON o.omanik_id = h.omanik_idfk
GROUP BY o.nimi;

select * from vaade_hobuste_arv_omaniku_jaoks
ORDER BY hobuste_arv DESC;
--------------------------------------------Tabel logi ja triggerid-------------------------------------------------
CREATE TABLE logi (
logiID INT IDENTITY(1,1) PRIMARY KEY,
kuupaev DATE,
toiming VARCHAR(30),
andmed VARCHAR(100),
kasutaja VARCHAR(50)
);
DROP TABLE logi;
-------------------------------------------Triger lisamine------------------------------------------------------------
CREATE TRIGGER toitumineLisamine
ON toitumine
FOR INSERT
AS
INSERT INTO logi (kuupaev, toiming, andmed, kasutaja)
SELECT 
GETDATE(),
'Toitumise kirje lisatud:',
CONCAT('Hobune: ', h.nimi, ', Toit: ', t.toit_nimi, ', Kuupäev: ', i.kuupaev),
SYSTEM_USER
FROM inserted i
JOIN hobused h ON i.hobuse_idfk = h.hobuse_id
JOIN toit t ON i.toit_idfk = t.toit_id;


INSERT INTO toitumine (toitumine_id, toit_idfk, hobuse_idfk, kuupaev, tootaja_idfk)
VALUES (3, 3, 1, '2025-10-20', 2);
SELECT * FROM toitumine;
SELECT * FROM logi;
----------------------------------------------------------------Triger kustutamine---------------------------------------------------------------
CREATE TRIGGER toitumineKustutamine
ON toitumine
FOR DELETE
AS
INSERT INTO logi (kuupaev, toiming, andmed, kasutaja)
SELECT 
GETDATE(),
'Toitumise kirje kustutatud:',
CONCAT('Hobune: ', h.nimi, ', Toit: ', t.toit_nimi, ', Kuupäev: ', d.kuupaev),
SYSTEM_USER
FROM deleted d
JOIN hobused h ON d.hobuse_idfk = h.hobuse_id
JOIN toit t ON d.toit_idfk = t.toit_id;
--Kontroll
DELETE FROM toitumine
WHERE toitumine_id = 3;

SELECT * FROM toitumine;
SELECT * FROM logi;
----------------------------------------------------------------triger uuendamine----------------------------------------------------------------------
CREATE TRIGGER toitumineUuendamine
ON toitumine
FOR UPDATE
AS
INSERT INTO logi (kuupaev, toiming, andmed, kasutaja)
SELECT 
GETDATE(),
'Toitumise kirje uuendatud:',
CONCAT('Hobune: ', h.nimi, ', Toit (vana): ', t_old.toit_nimi, ', Toit (uus): ', t_new.toit_nimi, ', Kuupäev (vana): ', i_old.kuupaev, ', Kuupäev (uus): ', i_new.kuupaev),
SYSTEM_USER
FROM inserted i_new
JOIN deleted i_old ON i_new.toitumine_id = i_old.toitumine_id
JOIN hobused h ON i_new.hobuse_idfk = h.hobuse_id
JOIN toit t_new ON i_new.toit_idfk = t_new.toit_id
JOIN toit t_old ON i_old.toit_idfk = t_old.toit_id;


--Kontroll
UPDATE toitumine 
SET kuupaev = '2025-10-21', toit_idfk = 2 
WHERE toitumine_id = 1;
SELECT * FROM toitumine;
SELECT * FROM logi;
GRANT SELECT, INSERT, UPDATE, DELETE ON DATABASE::hobujaam TO HobujaamaDirektor;



drop TRIGGER toitumineLisamine
drop TRIGGER toitumineKustutamine
drop TRIGGER toitumineUuendamine
drop table logi;



INSERT INTO toitumine (toitumine_id, toit_idfk, hobuse_idfk, kuupaev, tootaja_idfk)
VALUES (100, 1, 1, '2025-10-20', 1);


UPDATE toitumine
SET toit_idfk = 2, kuupaev = '2025-10-21'
WHERE toitumine_id = 100;



DELETE FROM toitumine
WHERE toitumine_id = 100;
SELECT * FROM toitumine;
select * from hobused;
select * from toit;
SELECT * FROM logi;



ALTER TABLE logi
ALTER COLUMN andmed VARCHAR(500);


grant select, insert, update, delete on amet to hobujaamaDirektor
grant select, insert, update, delete on hobused to hobujaamaDirektor
grant select, insert, update, delete on omanik to hobujaamaDirektor
grant select, insert, update, delete on tall to hobujaamaDirektor
grant select, insert, update, delete on toit to hobujaamaDirektor
grant select, insert, update, delete on toitumine to hobujaamaDirektor
grant select, insert, update, delete on tootaja to hobujaamaDirektor
grant select, insert, update, delete on veterenaar to hobujaamaDirektor
grant select, insert, update, delete on vetvisiit to hobujaamaDirektor

-------------------------------direktor---------------------
INSERT INTO toitumine (toitumine_id, toit_idfk, hobuse_idfk, kuupaev, tootaja_idfk)
VALUES (100, 1, 1, '2025-10-20', 1);

UPDATE toitumine
SET toit_idfk = 2, kuupaev = '2035-10-21'
WHERE toitumine_id = 2;

DELETE FROM toitumine
WHERE toitumine_id = 100;
select * from toitumine


select * from logi;
































