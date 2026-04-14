-- Création de la base de données
CREATE DATABASE IF NOT EXISTS gestion_loyers;
USE gestion_loyers;

-- =========================
-- Table users
-- =========================
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- Table locataires
-- =========================
CREATE TABLE locataires (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    telephone VARCHAR(20),
    adresse TEXT,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- Table biens
-- =========================
CREATE TABLE biens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    nom_bien VARCHAR(150) NOT NULL,
    adresse TEXT,
    type ENUM('maison', 'appartement', 'studio') DEFAULT 'appartement',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =========================
-- Table contrats
-- =========================
CREATE TABLE contrats (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    locataire_id BIGINT NOT NULL,
    bien_id BIGINT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NULL,
    montant_loyer DECIMAL(10,2) NOT NULL,
    jour_limite_paiement INT NOT NULL, -- ex: 5 (5 du mois)
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (locataire_id) REFERENCES locataires(id) ON DELETE CASCADE,
    FOREIGN KEY (bien_id) REFERENCES biens(id) ON DELETE CASCADE
);

-- =========================
-- Table paiements
-- =========================
CREATE TABLE paiements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    contrat_id BIGINT NOT NULL,
    mois VARCHAR(7) NOT NULL, -- format YYYY-MM
    montant DECIMAL(10,2) NOT NULL,
    date_paiement DATE NULL,
    statut ENUM('paye', 'en_retard', 'impaye') DEFAULT 'impaye',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE (contrat_id, mois),

    FOREIGN KEY (contrat_id) REFERENCES contrats(id) ON DELETE CASCADE
);

-- =========================
-- Table notifications
-- =========================
CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    locataire_id BIGINT NOT NULL,
    contrat_id BIGINT NOT NULL,
    message TEXT NOT NULL,
    date_envoi TIMESTAMP NULL,
    statut ENUM('envoye', 'en_attente') DEFAULT 'en_attente',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (locataire_id) REFERENCES locataires(id) ON DELETE CASCADE,
    FOREIGN KEY (contrat_id) REFERENCES contrats(id) ON DELETE CASCADE
);

-- =========================
-- Index utiles
-- =========================
CREATE INDEX idx_paiements_mois ON paiements(mois);
CREATE INDEX idx_contrats_locataire ON contrats(locataire_id);
CREATE INDEX idx_notifications_statut ON notifications(statut);