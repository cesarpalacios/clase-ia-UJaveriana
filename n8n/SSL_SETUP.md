# 🔐 Configuración SSL con Let's Encrypt para n8n

## ¿Por qué SSL?

- ✅ **Gmail requiere HTTPS** para OAuth2 en producción
- ✅ **Seguridad**: Datos encriptados en tránsito
- ✅ **Confianza**: Certificado válido del navegador
- ✅ **APIs modernas**: Muchos servicios requieren HTTPS

## 📋 Arquitectura con SSL

```
Internet → Docker Labs → Nginx (HTTP:80 + HTTPS:443) → n8n (5678) → PostgreSQL
                        ↓
                   Let's Encrypt (Certbot)
```

## 🚀 Configuración Rápida

### 1. Configuración inicial
```bash
# Iniciar servicios básicos
./n8n-manager.sh start

# Configurar SSL (certificado de prueba)
./n8n-manager.sh ssl-init
```

### 2. Certificado de producción
```bash
# Obtener certificado real
./n8n-manager.sh ssl-prod

# Reiniciar para aplicar cambios
./n8n-manager.sh restart
```

### 3. Verificar funcionamiento
```bash
# Ver estado SSL
./n8n-manager.sh ssl-status

# Ver estado general
./n8n-manager.sh status
```

## 🔧 Configuración Manual Detallada

### Paso 1: Preparar entorno
```bash
# Asegurar permisos
./n8n-manager.sh fix-permissions

# Crear directorios SSL
mkdir -p certbot/conf certbot/www
```

### Paso 2: Certificado temporal
```bash
# Crear certificado autofirmado para inicio
./ssl-setup.sh init
```

### Paso 3: Certificado Let's Encrypt
```bash
# Certificado de staging (prueba)
./ssl-setup.sh init

# Certificado de producción (real)
./ssl-setup.sh prod
```

## 📊 URLs Actualizadas

Con SSL configurado:

- **n8n HTTPS**: `https://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-443.direct.labs.play-with-docker.com`
- **n8n HTTP**: `http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com` (redirige a HTTPS)
- **OAuth2 Callback**: `https://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-443.direct.labs.play-with-docker.com/rest/oauth2-credential/callback`

## 🔍 Verificación y Troubleshooting

### Verificar servicios
```bash
# Estado general
docker-compose ps

# Logs específicos
docker-compose logs nginx
docker-compose logs certbot
```

### Probar conectividad
```bash
# Probar HTTP (debe redirigir a HTTPS)
curl -I http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com

# Probar HTTPS
curl -I https://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-443.direct.labs.play-with-docker.com
```

### Ver certificados
```bash
# Estado de certificados
./ssl-setup.sh status

# Probar configuración
./ssl-setup.sh test
```

## 🔄 Renovación Automática

### Script de renovación
```bash
# Renovar certificados (ejecutar cada 60 días)
./ssl-setup.sh renew
```

### Cron job (opcional)
```bash
# Agregar a crontab para renovación automática
0 12 * * 0 /path/to/ssl-setup.sh renew
```

## ⚠️ Problemas Comunes

### 1. "Certificate not found"
```bash
# Solución: Recrear certificado temporal
./ssl-setup.sh clean
./ssl-setup.sh init
```

### 2. "Challenge failed"
```bash
# Verificar que puerto 80 esté accesible
curl http://localhost/.well-known/acme-challenge/test

# Verificar nginx
docker-compose logs nginx
```

### 3. "SSL handshake failed"
```bash
# Verificar certificados
./ssl-setup.sh status

# Recargar nginx
docker-compose exec nginx nginx -s reload
```

### 4. Redirección infinita
```bash
# Verificar configuración de n8n
# Asegurar que N8N_PROTOCOL=https
docker-compose logs n8n
```

## 📁 Estructura de Archivos

```
n8n/
├── docker-compose.yml          # Configuración de servicios
├── nginx.conf                  # Configuración nginx con SSL
├── ssl-setup.sh               # Script de gestión SSL
├── n8n-manager.sh             # Script principal
├── certbot/
│   ├── conf/                  # Certificados Let's Encrypt
│   └── www/                   # Archivos ACME challenge
├── n8n_data/                  # Datos de n8n
├── postgres_data/             # Datos de PostgreSQL
└── nginx_logs/                # Logs de nginx
```

## 🔒 Configuración de Seguridad

El nginx incluye:
- **TLS 1.2/1.3**: Protocolos modernos
- **HSTS**: Forzar HTTPS
- **Security Headers**: Protección XSS, clickjacking
- **Perfect Forward Secrecy**: Cifrado moderno

## 📧 Para Gmail OAuth2

1. **Google Cloud Console**: Crear proyecto OAuth2
2. **URLs autorizadas**: Usar HTTPS callback URL
3. **Credenciales**: Configurar en n8n con HTTPS
4. **Test**: Verificar redirección OAuth2

¡Tu n8n ahora tendrá SSL válido y será compatible con Gmail y otros servicios que requieren HTTPS!