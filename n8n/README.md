# 🚀 n8n - Configuración Súper Simple

## ⚡ Inicio en 30 Segundos

```bash
./n8n-simple.sh start
```

**¡Eso es todo!** 🎉

## 🌐 Con ngrok para Gmail/APIs externas

```bash
# Configurar ngrok URL
./n8n-simple.sh ngrok https://0a79d5bba895.ngrok-free.app

# O iniciar directamente con ngrok
./n8n-simple.sh start https://0a79d5bba895.ngrok-free.app

# O usar variable de entorno
export NGROK_URL=https://0a79d5bba895.ngrok-free.app
./n8n-simple.sh start
```

## 🌐 Acceso

- **Local**: http://localhost:5678
- **Docker Labs**: http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-5678.direct.labs.play-with-docker.com
- **Con ngrok**: Tu URL personalizada de ngrok

## 🔑 Credenciales

- **Usuario**: `admin`
- **Contraseña**: `admin123`

## 📋 Comandos

```bash
./n8n-simple.sh start                           # Iniciar
./n8n-simple.sh start https://abc.ngrok-free.app # Iniciar con ngrok
./n8n-simple.sh ngrok https://abc.ngrok-free.app # Configurar ngrok
./n8n-simple.sh stop                            # Detener  
./n8n-simple.sh restart                         # Reiniciar
./n8n-simple.sh status                          # Ver estado
./n8n-simple.sh logs                            # Ver logs
./n8n-simple.sh clean                           # Limpiar datos
```

## 🎯 ¿Qué Incluye?

- ✅ **n8n**: Automatización visual
- ✅ **PostgreSQL**: Base de datos
- ✅ **Puerto 5678**: Acceso directo
- ✅ **ngrok**: Soporte para URLs externas
- ✅ **Sin proxies**: Máxima simplicidad
- ✅ **Permisos automáticos**: Sin configuración manual

## 📁 Archivos

- `docker-compose.yml` - Configuración de servicios
- `n8n-simple.sh` - Script de manejo
- `.env.example` - Ejemplo de configuración ngrok
- `n8n_data/` - Datos de n8n (se crea automáticamente)

## 💡 Para Gmail OAuth2

### Con ngrok (Recomendado):
1. Obtén tu URL de ngrok: `https://abc.ngrok-free.app`
2. En Google Cloud Console, usa: `https://abc.ngrok-free.app/rest/oauth2-credential/callback`
3. Configura n8n: `./n8n-simple.sh ngrok https://abc.ngrok-free.app`

### Solo local/Docker Labs:
1. En Google Cloud Console, usa: `http://localhost:5678/rest/oauth2-credential/callback`
2. Para Docker Labs, usa el puerto 5678 en tu URL

**¡Solo ejecuta `./n8n-simple.sh start` y listo! 🚀**