# Configuración de n8n con Docker Labs y Nginx Proxy

## Arquitectura

```
Internet → Docker Labs → Nginx (Puerto 80) → n8n (Puerto 5678) → PostgreSQL
```

## Ventajas del Nginx Proxy

- ✅ **Puerto estándar**: Usa puerto 80 (más fácil acceso)
- ✅ **Mejor rendimiento**: Nginx maneja conexiones estáticas
- ✅ **WebSocket support**: Funciona mejor con n8n
- ✅ **Logs separados**: Mejor debugging
- ✅ **Cache**: Archivos estáticos se cachean
- ✅ **Flexibilidad**: Fácil agregar SSL, rate limiting, etc.

## Archivos de configuración

1. **docker-compose.yml**: Orquestación de servicios
2. **nginx.conf**: Configuración del proxy reverso
3. **n8n-manager.sh**: Script de manejo simplificado

## URL actualizada para Docker Labs

Tu nueva URL será:
```
http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com
```

## Uso rápido

### Iniciar todo:
```bash
./n8n-manager.sh start
```

### Ver estado:
```bash
./n8n-manager.sh status
```

### Ver logs:
```bash
./n8n-manager.sh logs
./n8n-manager.sh logs nginx
./n8n-manager.sh logs n8n
```

### Detener:
```bash
./n8n-manager.sh stop
```

### 4. Configuración para Gmail

#### Crear credenciales OAuth2 en Google Cloud Console:
1. Ve a [Google Cloud Console](https://console.cloud.google.com)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la Gmail API
4. Ve a "Credenciales" > "Crear credenciales" > "ID de cliente OAuth 2.0"
5. Configura las URLs de redirección:
   - `https://tu-url-docker-labs.com/rest/oauth2-credential/callback`

#### En n8n:
1. Ve a Configuración > Credenciales
2. Crea una nueva credencial de Gmail OAuth2
3. Ingresa tu Client ID y Client Secret de Google
4. Autoriza la aplicación

### 5. Comandos para ejecutar

```bash
# Construir y ejecutar
docker-compose up -d

# Ver logs
docker-compose logs -f n8n

# Detener
docker-compose down
```

### 6. Acceso a n8n
- URL: Tu URL de Docker Labs (puerto 5678)
- Usuario: admin
- Contraseña: admin123

## Notas importantes

1. **Seguridad**: Cambia las credenciales por defecto en producción
2. **SSL**: Docker Labs ya proporciona HTTPS automáticamente
3. **Persistencia**: Los datos se guardan en volúmenes Docker
4. **Limitaciones**: Docker Labs tiene tiempo de vida limitado (4 horas aprox.)

## Solución de problemas

### Si n8n no se conecta a Gmail:
1. Verifica que la URL en WEBHOOK_URL sea correcta y accesible
2. Asegúrate de que las credenciales OAuth2 estén configuradas correctamente
3. Verifica que las URLs de redirección en Google Cloud Console coincidan

### Si no puedes acceder a n8n:
1. Verifica que el puerto 5678 esté expuesto correctamente
2. Usa la URL completa de Docker Labs
3. Espera unos minutos para que los servicios inicien completamente