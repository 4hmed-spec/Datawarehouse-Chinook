# Datawarehouse-Chinook
Projet d'alimentation d'un Data Warehouse avec Oracle Data Integrator (ODI) et Oracle XE
# 🎵 Projet Business Intelligence : Chinook Data Warehouse
![Oracle](https://img.shields.io/badge/Oracle-Database_XE-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![ODI](https://img.shields.io/badge/ETL-Oracle_Data_Integrator_11g-orange?style=for-the-badge)
![Python](https://img.shields.io/badge/Python-Scripting-blue?style=for-the-badge&logo=python&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)


Ce projet a été réalisé dans le cadre de la SAE 3.02. L'objectif est de concevoir et d'alimenter un Data Warehouse (Entrepôt de données) à partir d'une base de données opérationnelle de vente de musique (Chinook).

**Auteurs :** Ahmed Terir & Zakaria Charef
**Encadrant :** M. Leveler

## 🏗️ Architecture

Le projet suit une architecture décisionnelle classique :
`Source (Chinook)` ➔ `DSA (Staging)` ➔ `ODS (Operational Data Store)` ➔ `DWH (Data Warehouse - Étoile)`

## 🛠️ Technologies utilisées
* **SGBD :** Oracle Database XE
* **ETL :** Oracle Data Integrator (ODI) 11g
* **Langages :** SQL, PL/SQL, Python (pour le nettoyage des scripts)

## 📂 Contenu du dépôt

* **`/SQL`** : Scripts de création des tables (DSA, ODS, DWH), séquences et requêtes de validation.
* **`/ODI`** : Export XML intelligent du projet ODI (Mappings, Packages, Topologie).
* **`/Python`** : Script d'automatisation pour la correction des données sources.
* **`/Docs`** : Rapport technique complet et dictionnaire des données.

## 🚀 Comment déployer

1.  Exécuter les scripts SQL du dossier `/SQL` pour créer les schémas et séquences.
2.  Lancer le Package principal `PKG_GLOBAL_LOAD` pour alimenter le DWH.

---
*Projet réalisé à l'IUT de Roubaix site de Lille - 2025/2026*
