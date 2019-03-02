-- MySQL Script generated by MySQL Workbench
-- Sat 02 Mar 2019 12:44:43 PM WET
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema cabinet
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cabinet
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cabinet` ;
USE `cabinet` ;

-- -----------------------------------------------------
-- Table `cabinet`.`Patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Patient` (
  `idPatient` INT NOT NULL AUTO_INCREMENT,
  `nomPatient` VARCHAR(255) NULL,
  `prenomPatient` VARCHAR(255) NULL,
  `telephonePatient` VARCHAR(20) NULL,
  `mailPatient` VARCHAR(255) NULL,
  `dateNaissance` DATE NULL,
  PRIMARY KEY (`idPatient`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cabinet`.`Personnel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Personnel` (
  `idPersonnel` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NULL,
  `prenom` VARCHAR(255) NULL,
  `telephone` VARCHAR(20) NULL,
  `mail` VARCHAR(255) NULL,
  `password` VARCHAR(255) NULL,
  PRIMARY KEY (`idPersonnel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cabinet`.`Docteur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Docteur` (
  `idDocteur` INT NOT NULL AUTO_INCREMENT,
  `specialite` VARCHAR(255) NULL,
  `Personnel_idPersonnel` INT NOT NULL,
  `nomComplet` VARCHAR(255) NULL,
  PRIMARY KEY (`idDocteur`),
  CONSTRAINT `fk_Docteur_Personnel1`
    FOREIGN KEY (`Personnel_idPersonnel`)
    REFERENCES `cabinet`.`Personnel` (`idPersonnel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Docteur_Personnel1_idx` USING BTREE ON `cabinet`.`Docteur` (`Personnel_idPersonnel`);


-- -----------------------------------------------------
-- Table `cabinet`.`Consultation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Consultation` (
  `idConsultation` INT NOT NULL AUTO_INCREMENT,
  `dateConsultation` DATE NULL,
  `fraisConsultation` VARCHAR(45) NULL,
  `Patient_idPatient` INT NOT NULL,
  `nomDocteur` VARCHAR(255) NOT NULL,
  `note` VARCHAR(255) NULL,
  PRIMARY KEY (`idConsultation`),
  CONSTRAINT `fk_Consultation_Patient1`
    FOREIGN KEY (`Patient_idPatient`)
    REFERENCES `cabinet`.`Patient` (`idPatient`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_Consultation_Patient1_idx` ON `cabinet`.`Consultation` (`Patient_idPatient` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Rdv`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Rdv` (
  `idRdv` INT NOT NULL AUTO_INCREMENT,
  `dateRdv` DATETIME NOT NULL,
  `Patient_idPatient` INT NOT NULL,
  `Docteur_idDocteur` INT NOT NULL,
  `noteRdv` VARCHAR(255) NULL,
  PRIMARY KEY (`idRdv`),
  CONSTRAINT `fk_Rdv_Patient1`
    FOREIGN KEY (`Patient_idPatient`)
    REFERENCES `cabinet`.`Patient` (`idPatient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rdv_Docteur1`
    FOREIGN KEY (`Docteur_idDocteur`)
    REFERENCES `cabinet`.`Docteur` (`idDocteur`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Rdv_Patient1_idx` ON `cabinet`.`Rdv` (`Patient_idPatient` ASC);

CREATE INDEX `fk_Rdv_Docteur1_idx` ON `cabinet`.`Rdv` (`Docteur_idDocteur` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Paiement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Paiement` (
  `idPaiement` INT NOT NULL AUTO_INCREMENT,
  `datePaiement` DATE NULL,
  `modePaiement` VARCHAR(255) NULL,
  `montant` DOUBLE NULL,
  `reste` VARCHAR(45) NULL,
  `Consultation_idConsultation` INT NOT NULL,
  PRIMARY KEY (`idPaiement`),
  CONSTRAINT `fk_Paiement_Consultation1`
    FOREIGN KEY (`Consultation_idConsultation`)
    REFERENCES `cabinet`.`Consultation` (`idConsultation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Paiement_Consultation1_idx` ON `cabinet`.`Paiement` (`Consultation_idConsultation` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Ordonnance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Ordonnance` (
  `idOrdonnance` INT NOT NULL AUTO_INCREMENT,
  `idPatient` INT NOT NULL,
  `note` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idOrdonnance`),
  CONSTRAINT `fk_Ordonnance_Patient1`
    FOREIGN KEY (`idPatient`)
    REFERENCES `cabinet`.`Patient` (`idPatient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Ordonnance_Consultation1_idx` ON `cabinet`.`Ordonnance` (`Consultation_idConsultation` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Acte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Acte` (
  `idActe` INT NOT NULL AUTO_INCREMENT,
  `libelle` VARCHAR(45) NULL,
  `noteActe` VARCHAR(255) NULL,
  `Consultation_idConsultation` INT NOT NULL,
  `dentActe` INT NULL,
  PRIMARY KEY (`idActe`),
  CONSTRAINT `fk_Acte_Consultation1`
    FOREIGN KEY (`Consultation_idConsultation`)
    REFERENCES `cabinet`.`Consultation` (`idConsultation`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Acte_Consultation1_idx` ON `cabinet`.`Acte` (`Consultation_idConsultation` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Ordonnance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Ordonnance` (
  `idOrdonnance` INT NOT NULL AUTO_INCREMENT,
  `idPatient` INT NOT NULL,
  `note` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idOrdonnance`),
  CONSTRAINT `fk_Ordonnance_Patient1`
    FOREIGN KEY (`idPatient`)
    REFERENCES `cabinet`.`Patient` (`idPatient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Ordonnance_Patient1_idx` ON `cabinet`.`Ordonnance` (`idPatient` ASC);


-- -----------------------------------------------------
-- Table `cabinet`.`Antecedant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cabinet`.`Antecedant` (
  `idAntecedant` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(255) NOT NULL,
  `note` VARCHAR(255) NULL,
  `Patient_idPatient` INT NOT NULL,
  PRIMARY KEY (`idAntecedant`),
  CONSTRAINT `fk_Antecedant_Patient1`
    FOREIGN KEY (`Patient_idPatient`)
    REFERENCES `cabinet`.`Patient` (`idPatient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Antecedant_Patient1_idx` ON `cabinet`.`Antecedant` (`Patient_idPatient` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `cabinet`.`Patient`
-- -----------------------------------------------------
START TRANSACTION;
USE `cabinet`;
INSERT INTO `cabinet`.`Patient` (`idPatient`, `nomPatient`, `prenomPatient`, `telephonePatient`, `mailPatient`, `dateNaissance`) VALUES (DEFAULT, 'Girl', 'On fire', '7788', 'gffd@dgs.fr', '1991/01/15');
INSERT INTO `cabinet`.`Patient` (`idPatient`, `nomPatient`, `prenomPatient`, `telephonePatient`, `mailPatient`, `dateNaissance`) VALUES (DEFAULT, 'Owowoo', 'Nowo Nowo', '2445', 'fsd2@dfdfs.sd', '1984/08/05');
INSERT INTO `cabinet`.`Patient` (`idPatient`, `nomPatient`, `prenomPatient`, `telephonePatient`, `mailPatient`, `dateNaissance`) VALUES (DEFAULT, 'Massa', 'Yakoopie', '2234', 'df@dsfss.sd', '2002/01/24');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cabinet`.`Personnel`
-- -----------------------------------------------------
START TRANSACTION;
USE `cabinet`;
INSERT INTO `cabinet`.`Personnel` (`idPersonnel`, `nom`, `prenom`, `telephone`, `mail`, `password`) VALUES (DEFAULT, 'tikti', 'taka', '12345', 'tiki@mail.de', '1234');
INSERT INTO `cabinet`.`Personnel` (`idPersonnel`, `nom`, `prenom`, `telephone`, `mail`, `password`) VALUES (DEFAULT, 'Alicia', 'Keys', '68764', 'ali@mail.us', '1234');
INSERT INTO `cabinet`.`Personnel` (`idPersonnel`, `nom`, `prenom`, `telephone`, `mail`, `password`) VALUES (DEFAULT, 'Le Matien', 'Corner', '389', 'lopem@fdn.fr', '1234');
INSERT INTO `cabinet`.`Personnel` (`idPersonnel`, `nom`, `prenom`, `telephone`, `mail`, `password`) VALUES (DEFAULT, 'Dr', 'House', '112233', 'doctor@house.de', '1234');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cabinet`.`Docteur`
-- -----------------------------------------------------
START TRANSACTION;
USE `cabinet`;
INSERT INTO `cabinet`.`Docteur` (`idDocteur`, `specialite`, `Personnel_idPersonnel`, `nomComplet`) VALUES (DEFAULT, 'Chirurgie', 1, '');
INSERT INTO `cabinet`.`Docteur` (`idDocteur`, `specialite`, `Personnel_idPersonnel`, `nomComplet`) VALUES (DEFAULT, 'PLasturgie dentaire', 2, NULL);
INSERT INTO `cabinet`.`Docteur` (`idDocteur`, `specialite`, `Personnel_idPersonnel`, `nomComplet`) VALUES (DEFAULT, 'Fluoridite Cervicale', 3, NULL);

COMMIT;

