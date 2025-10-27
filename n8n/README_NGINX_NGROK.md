# 🚀 n8n con Nginx y Ngrok - Guía Completa

## 📋 Dos Opciones Disponibles

### 🏠 Opción 1: Docker Labs + Nginx (HTTP)
- **Ideal para**: Desarrollo en Docker Labs
- **URL**: `http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com`
- **Ventajas**: Simple, sin configuración adicional
- **Limitación**: Solo HTTP, limitado a Docker Labs

### 🌐 Opción 2: Ngrok (HTTPS Túnel Público)
- **Ideal para**: Webhooks, Gmail OAuth2, acceso desde cualquier lugar
- **URL**: `https://xxxxx.ngrok-free.app` (generada automáticamente)
- **Ventajas**: HTTPS automático, acceso público, compatible con Gmail
- **Requisito**: Token gratuito de ngrok.com

## 🚀 Inicio Rápido

### Opción 1: Docker Labs + Nginx
```bash
# Iniciar con nginx (Docker Labs)
./n8n-manager.sh start

# Acceder en:
# http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com
```

### Opción 2: Ngrok
```bash
# 1. Obtener token en https://ngrok.com (gratis)
# 2. Configurar token:
echo 'NGROK_AUTHTOKEN=tu_token_aqui' > .env

# 3. Iniciar con ngrok:
./n8n-manager.sh start-ngrok

# 4. Obtener URL:
./n8n-manager.sh get-ngrok-url
```

## 📊 Comparación de Opciones

| Característica | Docker Labs + Nginx | Ngrok |
|---|---|---|
| **Configuración** | ✅ Inmediata | ⚙️ Requiere token |
| **HTTPS** | ❌ Solo HTTP | ✅ HTTPS automático |
| **Gmail OAuth2** | ⚠️ Limitado | ✅ Totalmente compatible |
| **Webhooks** | ⚠️ Solo en Docker Labs | ✅ Desde cualquier lugar |
| **URL** | 🔒 Fija (Docker Labs) | 🔄 Cambia cada inicio |
| **Dashboard** | ❌ No | ✅ http://localhost:4040 |
| **Acceso externo** | ❌ Solo Docker Labs | ✅ Desde cualquier lugar |

## 🔧 Comandos Disponibles

### Comandos de Inicio
```bash
./n8n-manager.sh start          # nginx + Docker Labs
./n8n-manager.sh start-nginx    # nginx + Docker Labs  
./n8n-manager.sh start-ngrok    # ngrok + túnel público
```

### Comandos Generales
```bash
./n8n-manager.sh stop           # Detener servicios
./n8n-manager.sh restart        # Reiniciar servicios
./n8n-manager.sh status         # Ver estado
./n8n-manager.sh logs           # Ver logs
```

### Comandos Específicos
```bash
./n8n-manager.sh get-ngrok-url  # Obtener URL de ngrok
./n8n-manager.sh nginx-reload   # Recargar nginx
```

## 🎯 Casos de Uso

### Usar Docker Labs + Nginx cuando:
- ✅ Desarrollo y testing básico
- ✅ No necesitas webhooks externos
- ✅ Quieres algo simple y rápido
- ✅ Estás trabajando solo en Docker Labs

### Usar Ngrok cuando:
- ✅ Necesitas conectar con Gmail
- ✅ Quieres recibir webhooks
- ✅ Necesitas acceso desde otros dispositivos
- ✅ Requieres HTTPS
- ✅ Vas a compartir la URL con otros

## 📖 Configuración de Gmail OAuth2

### Con Docker Labs (HTTP)
```
URL de callback: http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com/rest/oauth2-credential/callback
```

### Con Ngrok (HTTPS)
```bash
# 1. Obtener URL actual
./n8n-manager.sh get-ngrok-url

# 2. Usar en Google Cloud Console:
# https://xxxxx.ngrok-free.app/rest/oauth2-credential/callback
```

## 🔄 Cambiar Entre Opciones

```bash
# Cambiar de nginx a ngrok
./n8n-manager.sh stop
./n8n-manager.sh start-ngrok

# Cambiar de ngrok a nginx
./n8n-manager.sh stop
./n8n-manager.sh start-nginx
```

## 🛠️ Troubleshooting

### Ngrok no funciona
```bash
# Verificar token
cat .env

# Ver logs de ngrok
./n8n-manager.sh logs ngrok

# Ver dashboard
# http://localhost:4040
```

### Nginx no funciona
```bash
# Ver logs de nginx
./n8n-manager.sh logs nginx

# Verificar configuración
docker-compose exec nginx nginx -t
```

### Problemas de permisos
```bash
./n8n-manager.sh fix-permissions
```

## 📁 Estructura de Archivos

```
n8n/
├── docker-compose.yml          # Configuración principal (nginx + ngrok)
├── docker-compose-ngrok.yml    # Solo ngrok (alternativo)
├── nginx.conf                  # Configuración nginx
├── n8n-manager.sh             # Script principal
├── n8n-ngrok.sh               # Script dedicado ngrok
├── .env                       # Token de ngrok
├── n8n_data/                  # Datos de n8n
├── postgres_data/             # Datos PostgreSQL
└── nginx_logs/                # Logs nginx
```

## 🎉 Credenciales por Defecto

- **Usuario**: admin
- **Contraseña**: admin123

## 💡 Tips

1. **Para desarrollo**: Usa Docker Labs + nginx
2. **Para producción/webhooks**: Usa ngrok
3. **Token ngrok**: Gratis en https://ngrok.com
4. **URL ngrok**: Cambia cada vez que reinicias
5. **Dashboard ngrok**: Siempre en http://localhost:4040
6. **Backup**: `./n8n-manager.sh backup` antes de cambios importantes

¡Ahora tienes dos opciones flexibles para usar n8n según tus necesidades!