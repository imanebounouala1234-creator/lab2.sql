CREATE DATABASE IF NOT EXISTS bibliotheque
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE bibliotheque;
CREATE TABLE IF NOT EXISTS auteur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NULL,
    CONSTRAINT chk_auteur_nom CHECK (LENGTH(nom) > 0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS abonne (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    date_inscription DATE NOT NULL DEFAULT (CURRENT_DATE),
    CHECK (email LIKE '%@%._%')
) ENGINE=InnoDB;
INSERT INTO auteur (nom, prenom, date_naissance)
VALUES ('Dupont', 'Marie', '1975-04-12');
CREATE TABLE IF NOT EXISTS ouvrage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    isbn CHAR(13) NOT NULL UNIQUE,
    disponibilité BOOLEAN NOT NULL DEFAULT TRUE,
    auteur_id INT NOT NULL,
    CONSTRAINT fk_ouvrage_auteur FOREIGN KEY (auteur_id)
        REFERENCES auteur(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_isbn CHECK (isbn REGEXP '^[0-9]{13}$')
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS emprunt (
    ouvrage_id INT NOT NULL,
    abonne_id INT NOT NULL,
    date_debut DATE NOT NULL DEFAULT CURRENT_DATE,
    date_fin DATE NULL,
    PRIMARY KEY (ouvrage_id, abonne_id, date_debut),
    CONSTRAINT fk_emprunt_ouvrage FOREIGN KEY (ouvrage_id)
        REFERENCES ouvrage(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_emprunt_abonne FOREIGN KEY (abonne_id)
        REFERENCES abonne(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_dates CHECK (date_fin IS NULL OR date_fin >= date_debut)
) ENGINE=InnoDB;
ALTER TABLE ouvrage ADD INDEX idx_ouvrage_disponibile (disponibilité);
ALTER TABLE emprunt ADD INDEX idx_emprunt_date_fin (date_fin);
-- إدخال كاتب
INSERT INTO auteur (nom, prenom, date_naissance)
VALUES ('El Alami', 'Youssef', '1982-11-20');

-- إدخال مشترك
INSERT INTO abonne (nom, prenom, email)
VALUES ('Benali', 'Sarra', 'sarra.benali@example.ma');

-- إدخال كتاب مرتبط بالكاتب رقم 1
INSERT INTO ouvrage (titre, isbn, disponibilité, auteur_id)
VALUES ('L\'Enfant de Sable', '9782020239128', TRUE, 1);

-- إدخال إعارة للكتاب رقم 1 والمشترك رقم 1
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
VALUES (1, 1, CURRENT_DATE);
  -- Insertion d'un auteur
INSERT INTO auteur (nom, prenom, date_naissance)
VALUES ('El Alami', 'Youssef', '1982-11-20');

-- Insertion d'un abonné
INSERT INTO abonne (nom, prenom, email)
VALUES ('Benali', 'Sarra', 'sarra.benali@example.ma');

-- Insertion d'un ouvrage
INSERT INTO ouvrage (titre, isbn, disponibilité, auteur_id)
VALUES ('L\'Enfant de Sable', '9782020239128', TRUE, 1);

-- Insertion d'un emprunt
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut)
VALUES (1, 1, CURRENT_DATE);
-- Test 1: Email dupliqué (Doit échouer)
INSERT INTO abonne (nom, prenom, email)
VALUES ('Idrissi', 'Omar', 'sarra.benali@example.ma');
-- Test 2: Date incohérente (Doit être bloqué par la contrainte CHECK)
INSERT INTO emprunt (ouvrage_id, abonne_id, date_debut, date_fin)
VALUES (1, 1, '2026-05-10', '2026-05-01');
DELIMITER $$

CREATE TRIGGER trg_emprunt_insert BEFORE INSERT ON emprunt
FOR EACH ROW
BEGIN
    -- Vérifier que l'ouvrage est disponible
    IF (SELECT disponibilité FROM ouvrage WHERE id = NEW.ouvrage_id) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'L\'ouvrage n\'est pas disponible.';
    END IF;

    -- Marquer l'ouvrage comme indisponible
    UPDATE ouvrage SET disponibilité = FALSE WHERE id = NEW.ouvrage_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_emprunt_update AFTER UPDATE ON emprunt
FOR EACH ROW
BEGIN
    IF NEW.date_fin IS NOT NULL THEN
        UPDATE ouvrage SET disponibilité = TRUE WHERE id = NEW.ouvrage_id;
    END IF;
END$$

DELIMITER ;
-- Création de la table Categorie
CREATE TABLE IF NOT EXISTS categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Création de la table d'association (ouvrage_categorie)
CREATE TABLE IF NOT EXISTS ouvrage_categorie (
    ouvrage_id INT NOT NULL,
    categorie_id INT NOT NULL,
    PRIMARY KEY (ouvrage_id, categorie_id),
    CONSTRAINT fk_oc_ouvrage FOREIGN KEY (ouvrage_id)
        REFERENCES ouvrage(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_oc_categorie FOREIGN KEY (categorie_id)
        REFERENCES categorie(id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE OR REPLACE VIEW v_emprunts_actifs AS
SELECT 
    e.ouvrage_id,
    o.titre AS titre_ouvrage,
    e.abonne_id,
    CONCAT(a.nom, ' ', a.prenom) AS nom_abonne,
    e.date_debut
FROM emprunt e
JOIN ouvrage o ON e.ouvrage_id = o.id
JOIN abonne a ON e.abonne_id = a.id
WHERE e.date_fin IS NULL;

