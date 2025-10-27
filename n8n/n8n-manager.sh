#!/bin/bash

# Script para manejar n8n con nginx o ngrok
# Uso: ./n8n-manager.sh [start|start-nginx|start-ngrok|stop|restart|logs|status]

DOCKER_LABS_URL="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com"

case "$1" in
    start)
        echo "🚀 Iniciando n8n con nginx proxy (Docker Labs)..."
        
        # Crear directorios necesarios y arreglar permisos
        echo "📁 Preparando directorios y permisos..."
        mkdir -p nginx_logs postgres_data n8n_data
        
        # Arreglar permisos usando container temporal
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            echo 'Permisos configurados para n8n'
        "
        
        # Iniciar servicios con nginx
        docker-compose --profile nginx up -d
        
        echo "✅ Servicios iniciados con nginx!"
        echo "📍 n8n disponible en: http://$DOCKER_LABS_URL"
        echo "👤 Usuario: admin"
        echo "🔑 Contraseña: admin123"
        echo ""
        echo "🔧 Para configurar Gmail OAuth2, usa esta URL de callback:"
        echo "   http://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        echo ""
        echo "💡 Para usar ngrok en su lugar, ejecuta: ./n8n-manager.sh start-ngrok"
        ;;
        
    start-nginx)
        echo "🚀 Iniciando n8n con nginx proxy..."
        $0 start
        ;;
        
    start-ngrok)
        echo "🚀 Iniciando n8n con ngrok..."
        
        # Verificar token de ngrok
        if [ ! -f ".env" ] || ! grep -q "NGROK_AUTHTOKEN" .env; then
            echo "❌ Token de ngrok no configurado"
            echo "📋 Pasos para configurar:"
            echo "   1. Ve a https://ngrok.com y obtén tu token"
            echo "   2. Ejecuta: echo 'NGROK_AUTHTOKEN=tu_token' > .env"
            echo "   3. Ejecuta de nuevo: ./n8n-manager.sh start-ngrok"
            exit 1
        fi
        
        # Crear directorios necesarios y arreglar permisos
        echo "📁 Preparando directorios y permisos..."
        mkdir -p postgres_data n8n_data
        
        # Arreglar permisos usando container temporal
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            echo 'Permisos configurados para n8n'
        "
        
        # Iniciar servicios con ngrok
        docker-compose --profile ngrok up -d
        
        echo "✅ Servicios iniciados con ngrok!"
        echo "⏳ Esperando que ngrok esté listo..."
        sleep 10
        
        # Obtener URL de ngrok
        ./n8n-manager.sh get-ngrok-url
        ;;
        
    get-ngrok-url)
        echo "🌐 Obteniendo URL de ngrok..."
        
        for i in {1..10}; do
            NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)
            if [ -n "$NGROK_URL" ]; then
                echo "✅ URL de ngrok:"
                echo "📍 n8n: $NGROK_URL"
                echo "📍 Dashboard ngrok: http://localhost:4040"
                echo "👤 Usuario: admin"
                echo "🔑 Contraseña: admin123"
                echo ""
                echo "🔧 Para Gmail OAuth2, usa esta URL de callback:"
                echo "   $NGROK_URL/rest/oauth2-credential/callback"
                return 0
            fi
            echo "⏳ Esperando ngrok... ($i/10)"
            sleep 3
        done
        
        echo "❌ No se pudo obtener URL de ngrok"
        echo "📋 Verifica el dashboard: http://localhost:4040"
        ;;
        
    stop)
        echo "🛑 Deteniendo servicios..."
        docker-compose down
        echo "✅ Servicios detenidos!"
        ;;
        
    restart)
        echo "🔄 Reiniciando servicios..."
        docker-compose down
        docker-compose up -d
        echo "✅ Servicios reiniciados!"
        ;;
        
    logs)
        echo "📋 Mostrando logs..."
        if [ -n "$2" ]; then
            docker-compose logs -f "$2"
        else
            docker-compose logs -f
        fi
        ;;
        
    status)
        echo "📊 Estado de los servicios:"
        docker-compose ps
        echo ""
        echo "🌐 URLs importantes:"
        echo "   n8n: http://$DOCKER_LABS_URL"
        echo "   Callback OAuth2: http://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        ;;
        
    nginx-reload)
        echo "🔄 Recargando configuración de nginx..."
        docker-compose exec nginx nginx -s reload
        echo "✅ Configuración de nginx recargada!"
        ;;
        
    backup)
        echo "💾 Creando backup..."
        BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        # Backup de datos
        docker-compose exec postgres pg_dump -U '<user>' n8n > "$BACKUP_DIR/n8n_db.sql"
        cp -r n8n_data "$BACKUP_DIR/"
        cp docker-compose.yml "$BACKUP_DIR/"
        cp nginx.conf "$BACKUP_DIR/"
        
        echo "✅ Backup creado en: $BACKUP_DIR"
        ;;
        
    fix-permissions)
        echo "🔧 Arreglando permisos de n8n..."
        
        # Crear directorios si no existen
        mkdir -p n8n_data nginx_logs postgres_data
        
        # Arreglar permisos usando container temporal
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            echo '✅ Permisos configurados correctamente'
        "
        
        echo "🚀 Ahora puedes ejecutar: ./n8n-manager.sh start"
        ;;
        
    clean)
        echo "🧹 Limpiando datos (¡CUIDADO! Esto borrará todo!)..."
        read -p "¿Estás seguro? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose down -v
            sudo rm -rf n8n_data postgres_data nginx_logs
            echo "✅ Datos limpiados"
        else
            echo "❌ Cancelado"
        fi
        ;;
        
    *)
        echo "🛠️  Script de manejo de n8n con nginx o ngrok"
        echo "Uso: $0 {start|start-nginx|start-ngrok|stop|restart|logs|status|get-ngrok-url|nginx-reload|backup|fix-permissions|clean}"
        echo ""
        echo "🚀 Comandos de inicio:"
        echo "  start            - Iniciar con nginx (Docker Labs)"
        echo "  start-nginx      - Iniciar con nginx (igual que start)"
        echo "  start-ngrok      - Iniciar con ngrok (túnel público)"
        echo ""
        echo "📋 Comandos básicos:"
        echo "  stop             - Detener todos los servicios"
        echo "  restart          - Reiniciar todos los servicios"
        echo "  logs [srv]       - Ver logs (opcional: especificar servicio)"
        echo "  status           - Ver estado de servicios y URLs"
        echo ""
        echo "🔧 Comandos específicos:"
        echo "  get-ngrok-url    - Obtener URL actual de ngrok"
        echo "  nginx-reload     - Recargar configuración de nginx"
        echo ""
        echo "🛠️ Comandos de mantenimiento:"
        echo "  backup           - Crear backup de datos"
        echo "  fix-permissions  - Arreglar permisos de n8n"
        echo "  clean            - Limpiar todos los datos (¡PELIGROSO!)"
        echo ""
        echo "� Opciones disponibles:"
        echo ""
        echo "🏠 Docker Labs (nginx):"
        echo "   - URL: http://$DOCKER_LABS_URL"
        echo "   - Comando: $0 start"
        echo "   - Ideal para: Desarrollo en Docker Labs"
        echo ""
        echo "🌐 Ngrok (túnel público):"
        echo "   - URL: https://xxxxx.ngrok-free.app"
        echo "   - Comando: $0 start-ngrok"
        echo "   - Ideal para: Webhooks, Gmail OAuth2, acceso externo"
        echo "   - Requiere: Token gratuito de ngrok.com"
        echo ""
        echo "📋 Flujo ngrok:"
        echo "  1. Obtener token en https://ngrok.com"
        echo "  2. echo 'NGROK_AUTHTOKEN=tu_token' > .env"
        echo "  3. $0 start-ngrok"
        echo ""
        echo "Ejemplos:"
        echo "  $0 start         # nginx + Docker Labs"
        echo "  $0 start-ngrok   # ngrok + túnel público"
        echo "  $0 get-ngrok-url # ver URL de ngrok"
        exit 1
        ;;
esac