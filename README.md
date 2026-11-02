

<img width="480" height="229" alt="Capture d&#39;écran 2026-11-02 003342" src="https://github.com/user-attachments/assets/0ac84125-ce2a-460d-a042-b7f363a49a55" />
<img width="58" height="21" alt="Capture d&#39;écran 2026-11-02 003353" src="https://github.com/user-attachments/assets/21ae2fe9-73f1-4022-9251-3db7245cab86" />
<img width="815" height="436" alt="Capture d&#39;écran 2026-11-02 003403" src="https://github.com/user-attachments/assets/760d1637-7d6e-4d80-9f06-81fa0eb400f6" />
<img width="669" height="492" alt="Capture d&#39;écran 2026-11-02 003535" src="https://github.com/user-attachments/assets/a9981822-cd49-421f-a4de-4cb4b66728f3" />
<img width="929" height="517" alt="Capture d&#39;écran 2026-11-02 003947" src="https://github.com/user-attachments/assets/5f690dcc-7578-473e-9273-0416fbf61a0b" />
<img width="924" height="508" alt="Capture d&#39;écran 2026-11-02 004255" src="https://github.com/user-attachments/assets/d3760d16-0543-4b3e-ac42-d9c95d7ac726" />
<img width="959" height="517" alt="Capture d&#39;écran 2026-11-02 004549" src="https://github.com/user-attachments/assets/a8a5f720-96b0-4235-81bc-b49b322c0d8e" />
<img width="854" height="515" alt="Capture d&#39;écran 2026-11-02 004650" src="https://github.com/user-attachments/assets/bd05d5a0-c4e4-471e-b184-56bf84f1f1c8" />
# Lab: Gestion d'une Bibliothèque Scolaire (MySQL)

Ce projet contient la modélisation, la création, la sécurisation par contraintes et l'automatisation via des **Triggers** pour la base de données d'une bibliothèque scolaire.

---

## 📁 Structure du Projet

* **`etudiant_backup.sql`** : Script d'exportation complet de la base de données (DDL, DML, Triggers).
* **`README.md`** : Documentation du projet.

---

## 🛠️ Étapes de Réalisation

### 1. Initialisation de la Base de Données
Création de la base `bibliotheque` avec un encodage UTF-8 pour supporter les caractères accentués.

```sql
CREATE DATABASE IF NOT EXISTS bibliotheque
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE bibliotheque;
