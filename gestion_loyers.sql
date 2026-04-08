-- =========================================
-- BASE DE DONNÉES : gestion_loyers
-- =========================================

CREATE DATABASE IF NOT EXISTS gestion_loyers;
USE gestion_loyers;

-- =========================================
-- TABLE USERS (Laravel compatible)
-- =========================================
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255),
    role ENUM('admin','gestionnaire') DEFAULT 'gestionnaire',
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================================
-- TABLE LOCATAIRES
-- =========================================
CREATE TABLE locataires (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    telephone VARCHAR(20),
    email VARCHAR(255) NULL,
    adresse TEXT NULL,
    piece_identite VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================================
-- TABLE BIENS
-- =========================================
CREATE TABLE biens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255),
    type ENUM('maison','appartement','bureau','boutique'),
    adresse TEXT,
    ville VARCHAR(100),
    loyer DECIMAL(10,2),
    statut ENUM('disponible','occupe') DEFAULT 'disponible',
    description TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- =========================================
-- TABLE CONTRATS
-- =========================================
CREATE TABLE contrats (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    locataire_id BIGINT UNSIGNED,
    bien_id BIGINT UNSIGNED,
    date_debut DATE,
    date_fin DATE NULL,
    loyer_mensuel DECIMAL(10,2),
    caution DECIMAL(10,2) DEFAULT 0,
    statut ENUM('actif','termine','resilie') DEFAULT 'actif',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_contrat_locataire
        FOREIGN KEY (locataire_id) REFERENCES locataires(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_contrat_bien
        FOREIGN KEY (bien_id) REFERENCES biens(id)
        ON DELETE CASCADE
);

-- =========================================
-- TABLE PAIEMENTS
-- =========================================
CREATE TABLE paiements (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    contrat_id BIGINT UNSIGNED,
    montant DECIMAL(10,2),
    date_paiement DATE,
    mois_concerne DATE,
    mode_paiement ENUM('cash','mobile_money','banque'),
    reference VARCHAR(255) NULL,
    statut ENUM('paye','partiel','en_retard') DEFAULT 'paye',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_paiement_contrat
        FOREIGN KEY (contrat_id) REFERENCES contrats(id)
        ON DELETE CASCADE
);

-- =========================================
-- TABLE FACTURES (OPTIONNEL)
-- =========================================
CREATE TABLE factures (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    contrat_id BIGINT UNSIGNED,
    montant_total DECIMAL(10,2),
    mois DATE,
    statut ENUM('paye','impaye') DEFAULT 'impaye',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,

    CONSTRAINT fk_facture_contrat
        FOREIGN KEY (contrat_id) REFERENCES contrats(id)
        ON DELETE CASCADE
);

-- =========================================
-- TABLE NOTIFICATIONS (OPTIONNEL)
-- =========================================
CREATE TABLE notifications (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    locataire_id BIGINT UNSIGNED,
    message TEXT,
    type ENUM('rappel','retard'),
    lu BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NULL,

    CONSTRAINT fk_notification_locataire
        FOREIGN KEY (locataire_id) REFERENCES locataires(id)
        ON DELETE CASCADE
);

-- =========================================
-- INDEX (optimisation)
-- =========================================
CREATE INDEX idx_contrat_locataire ON contrats(locataire_id);
CREATE INDEX idx_contrat_bien ON contrats(bien_id);
CREATE INDEX idx_paiement_contrat ON paiements(contrat_id);

-- =========================================
-- DONNÉES DE TEST (OPTIONNEL)
-- =========================================

INSERT INTO locataires (nom, prenom, telephone) VALUES
('Kabongo', 'Jonathan', '0990000001'),
('Mbuyi', 'Sandrine', '0990000002');

INSERT INTO biens (nom, type, adresse, ville, loyer) VALUES
('Appartement A1', 'appartement', 'Kinshasa Gombe', 'Kinshasa', 500),
('Maison B2', 'maison', 'Kinshasa Limete', 'Kinshasa', 800);

INSERT INTO contrats (locataire_id, bien_id, date_debut, loyer_mensuel)
VALUES
(1, 1, '2026-01-01', 500);

INSERT INTO paiements (contrat_id, montant, date_paiement, mois_concerne, mode_paiement)
VALUES
(1, 500, '2026-01-05', '2026-01-01', 'cash');
