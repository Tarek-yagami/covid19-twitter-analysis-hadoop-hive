#!/bin/bash

echo "=== Analyse des tweets COVID-19 avec Hadoop ==="
echo "Dataset: gpreda/covid19-tweets"
echo "Date: $(date)"
echo "======================================================"

# Variables
DATASET_NAME="covid19_tweets"
OUTPUT_DIR="/user/$USER/output"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Fonction de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Vérifier si Hadoop est démarré
log "1. Vérification du cluster Hadoop..."
if ! jps | grep -q "NameNode"; then
    log "   Démarrage d'Hadoop..."
    start-dfs.sh
    start-yarn.sh
    sleep 15
    log "   Hadoop démarré."
else
    log "   Hadoop est déjà en cours d'exécution."
fi

# Vérifier l'état HDFS
log "2. Vérification de l'état HDFS..."
hdfs dfsadmin -report | head -10

# Supprimer les anciens résultats s'ils existent
log "3. Nettoyage des anciens résultats..."
hdfs dfs -rm -r $OUTPUT_DIR/covid_analysis_* 2>/dev/null || true

# Exécuter MapReduce
log "4. Exécution du job MapReduce..."
MAPREDUCE_OUTPUT="$OUTPUT_DIR/covid_analysis_mapreduce_$TIMESTAMP"
if hadoop jar ~/covid_analysis.jar CovidTweetAnalysis /user/$USER/data/covid_tweets/$DATASET_NAME.csv $MAPREDUCE_OUTPUT; then
    log "   MapReduce terminé avec succès."
    log "   Résultats MapReduce:"
    hdfs dfs -cat $MAPREDUCE_OUTPUT/part-r-00000
    # Sauvegarder localement
    hdfs dfs -get $MAPREDUCE_OUTPUT/part-r-00000 ~/mapreduce_results_$TIMESTAMP.txt
else
    log "   Erreur lors de l'exécution MapReduce."
fi

# Exécuter les requêtes Hive
log "5. Exécution des requêtes Hive..."
HIVE_OUTPUT="hive_results_$TIMESTAMP.txt"
if hive -f covid_analysis_queries.sql > ~/$HIVE_OUTPUT 2>&1; then
    log "   Requêtes Hive terminées avec succès."
    log "   Résultats sauvegardés dans ~/$HIVE_OUTPUT"
else
    log "   Erreur lors de l'exécution des requêtes Hive."
    log "   Vérifiez le fichier ~/$HIVE_OUTPUT pour les détails."
fi

# Générer un rapport de synthèse
log "6. Génération du rapport de synthèse..."
REPORT_FILE="covid_analysis_report_$TIMESTAMP.txt"
cat > ~/$REPORT_FILE << EOF
=== RAPPORT D'ANALYSE TWEETS COVID-19 ===
Date d'analyse: $(date)
Dataset: gpreda/covid19-tweets
Cluster Hadoop: Mode pseudo-distribué

RÉSULTATS MAPREDUCE:
$(cat ~/mapreduce_results_$TIMESTAMP.txt 2>/dev/null || echo "Fichier non trouvé")

RÉSULTATS HIVE:
Voir le fichier: ~/$HIVE_OUTPUT

FICHIERS GÉNÉRÉS:
- Résultats MapReduce: ~/mapreduce_results_$TIMESTAMP.txt
- Résultats Hive: ~/$HIVE_OUTPUT
- Rapport complet: ~/$REPORT_FILE

INTERFACES WEB:
- NameNode: http://localhost:9870
- ResourceManager: http://localhost:8088
EOF

log "7. Analyse terminée !"
log "   Rapport disponible dans : ~/$REPORT_FILE"