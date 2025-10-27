# 🚀 n8n - Configuración Súper Simple

## ⚡ Inicio en 30 Segundos

```bash
./n8n-simple.sh start
```

**¡Eso es todo!** 🎉

## 🌐 Acceso

- **Local**: http://localhost:5678
- **Docker Labs**: http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-5678.direct.labs.play-with-docker.com

## 🔑 Credenciales

- **Usuario**: `admin`
- **Contraseña**: `admin123`

## 📋 Comandos

```bash
./n8n-simple.sh start    # Iniciar
./n8n-simple.sh stop     # Detener  
./n8n-simple.sh restart  # Reiniciar
./n8n-simple.sh status   # Ver estado
./n8n-simple.sh logs     # Ver logs
./n8n-simple.sh clean    # Limpiar datos
```

## 🎯 ¿Qué Incluye?

- ✅ **n8n**: Automatización visual
- ✅ **PostgreSQL**: Base de datos
- ✅ **Puerto 5678**: Acceso directo
- ✅ **Sin proxies**: Máxima simplicidad
- ✅ **Permisos automáticos**: Sin configuración manual

## 📁 Archivos

- `docker-compose.yml` - Configuración de servicios
- `n8n-simple.sh` - Script de manejo
- `n8n_data/` - Datos de n8n (se crea automáticamente)

## 💡 Para Gmail OAuth2

Si necesitas conectar Gmail:
1. En Google Cloud Console, usa: `http://localhost:5678/rest/oauth2-credential/callback`
2. Para Docker Labs, usa el puerto 5678 en tu URL

**¡Solo ejecuta `./n8n-simple.sh start` y listo! 🚀**