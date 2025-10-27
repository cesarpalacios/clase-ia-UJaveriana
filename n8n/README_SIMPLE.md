# 🚀 n8n - Setup Súper Simple

## ⚡ Inicio Rápido

```bash
# Opción 1: Local básico
./n8n.sh start
# Acceso: http://localhost:5678

# Opción 2: Docker Labs  
./n8n.sh nginx
# Acceso: http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com

# Opción 3: Túnel público (para Gmail)
echo 'NGROK_AUTHTOKEN=tu_token' > .env  # Token de ngrok.com
./n8n.sh ngrok
# Acceso: https://xxxxx.ngrok-free.app
```

## 🎯 ¿Cuál Usar?

| Uso | Comando | URL | Ideal para |
|---|---|---|---|
| **Desarrollo local** | `./n8n.sh start` | `localhost:5678` | Testing básico |
| **Docker Labs** | `./n8n.sh nginx` | URL de Docker Labs | Desarrollo en la nube |
| **Público/Gmail** | `./n8n.sh ngrok` | `*.ngrok-free.app` | OAuth2, webhooks |

## 📋 Comandos

```bash
./n8n.sh start    # Modo básico
./n8n.sh nginx    # Docker Labs
./n8n.sh ngrok    # Túnel público
./n8n.sh stop     # Detener
./n8n.sh url      # Ver URLs
./n8n.sh logs     # Ver logs
```

## 🔧 Credenciales

- **Usuario**: `admin`
- **Contraseña**: `admin123`

## 🌟 Un Solo Archivo

- ✅ **docker-compose.yml**: Todo en uno con profiles
- ✅ **n8n.sh**: Script súper simple
- ✅ **3 modos**: Local, Docker Labs, Público
- ✅ **Configuración automática**: Sin archivos extra

¡Solo ejecuta `./n8n.sh` y elige tu modo!