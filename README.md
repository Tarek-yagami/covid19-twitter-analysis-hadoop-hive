# Analyse de données COVID-19 sur Twitter avec Hadoop et Hive

Projet réalisé dans le cadre du module **Bases de Données Avancées (BDA)**.  
Le thème du TP est : **"Analyse de données Web avec Hadoop"**.

## 📁 Structure du projet
```covid19-twitter-analysis/
├── mapreduce/ # Code Java MapReduce
├── hive/ # Scripts Hive (.sql)
├── results/ # Résultats des traitements
└── README.md
```

## 📦 Jeu de données

Le jeu de données utilisé provient de Kaggle :  
🔗 [COVID-19 Tweets Dataset on Kaggle](https://www.kaggle.com/datasets/gpreda/covid19-tweets/data)


## ⚙️ Technologies utilisées

- Java + Hadoop MapReduce
- Apache Hive (avec OpenCSVSerde)
- HDFS
- Bash / Shell Linux

## 🔍 Objectif du projet

Ce projet vise à analyser un grand jeu de données de tweets liés au COVID-19 à l’aide d’outils Big Data.  
Les analyses incluent :

- Nombre total de tweets
- Hashtags les plus fréquents
- Mentions de mots-clés importants (vaccine, lockdown, etc.)
- Retweets vs tweets originaux
- Répartition des sources (iPhone, Android…)
- Comptes vérifiés
- Activité mensuelle
- Utilisateurs les plus actifs

## 🚀 Exécution

### MapReduce
```bash
hadoop jar covid-analysis.jar input_path output_path
```

### Hive
```bash
hive -f hive/03_top_hashtags.sql
```

📊 Résultats
Les résultats des traitements sont disponibles dans le dossier results/.

📄 Rapport
Le rapport complet est disponible ici :
📎 rapport_bda_covid19.pdf
