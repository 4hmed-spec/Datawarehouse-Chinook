import sys

def nettoyer_script_sql(fichier_entree, fichier_sortie):
    """
    Transforme un script SQL générique (type MySQL) en script compatible Oracle.
    1. Transforme les INSERT multiples en INSERT uniques.
    2. Gère le caractère spécial '&' (substitution variable) via chr(38).
    """
    print(f"Traitement de {fichier_entree} vers {fichier_sortie}...")
    
    with open(fichier_entree, 'r', encoding='utf-8') as f_in, \
         open(fichier_sortie, 'w', encoding='utf-8') as f_out:
        
        current_prefix = "" # Pour stocker "INSERT INTO Table (...) VALUES"
        
        for line in f_in:
            original_line = line.strip()
            
            # --- CORRECTION 1 : Gestion du caractère '&' (Ampersand) ---
            # Oracle demande une valeur utilisateur quand il voit '&'.
            # On le remplace par une concaténation du code ASCII : '||chr(38)||'
            if '&' in original_line:
                # Ex: 'R&B' devient 'R'||chr(38)||'B'
                original_line = original_line.replace('&', "'||chr(38)||'")

            # --- CORRECTION 2 : Formatage des INSERT ---
            
            # Cas A : Détection de la ligne d'en-tête INSERT
            # Ex: INSERT INTO Genre (GenreId, Name) VALUES
            if original_line.upper().startswith("INSERT INTO") and "VALUES" in original_line.upper():
                # On capture tout ce qu'il y a avant les données pour le réutiliser
                # On enlève le 'VALUES' de la fin pour être propre, on le rajoutera
                parts = original_line.split("VALUES")
                current_prefix = parts[0].strip() + " VALUES"
                continue # On ne l'écrit pas tout de suite, on attend les données

            # Cas B : Ligne de données (Tuple)
            # Ex: (1, 'Rock'),
            elif original_line.startswith("(") and current_prefix:
                # On nettoie la fin de ligne (enlève la virgule ou le point-virgule)
                data_content = original_line.rstrip(",;")
                
                # On reconstruit la ligne complète format Oracle
                # Ex: INSERT INTO Genre (...) VALUES (1, 'Rock');
                new_line = f"{current_prefix} {data_content};\n"
                f_out.write(new_line)

            # Cas C : Autres lignes (CREATE TABLE, COMMIT, etc.)
            else:
                # On réécrit la ligne telle quelle si elle n'est pas vide
                if original_line:
                    f_out.write(original_line + "\n")

    print("Terminé ! Le fichier est prêt.")
