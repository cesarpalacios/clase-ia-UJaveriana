#!/bin/bash

# Script para manejar n8n con nginx proxy
# Uso: ./n8n-manager.sh [start|stop|restart|logs|status]

DOCKER_LABS_URL="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-443.direct.labs.play-with-docker.com"
DOCKER_LABS_URL_HTTP="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com"

case "$1" in
    start)
        echo "🚀 Iniciando n8n con nginx proxy..."
        
        # Crear directorios necesarios y arreglar permisos
        echo "📁 Preparando directorios y permisos..."
        mkdir -p nginx_logs postgres_data n8n_data
        
        # Arreglar permisos usando container temporal
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            echo 'Permisos configurados para n8n'
        "
        
        # Iniciar servicios
        docker-compose up -d
        
        echo "✅ Servicios iniciados!"
        echo "📍 n8n disponible en: https://$DOCKER_LABS_URL"
        echo "� Alternativo (HTTP): http://$DOCKER_LABS_URL_HTTP"
        echo "�👤 Usuario: admin"
        echo "🔑 Contraseña: admin123"
        echo ""
        echo "🔧 Para configurar Gmail OAuth2, usa esta URL de callback:"
        echo "   https://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        echo ""
        echo "🔐 Para configurar SSL, ejecuta:"
        echo "   ./ssl-setup.sh init"
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
        echo "   n8n HTTPS: https://$DOCKER_LABS_URL"
        echo "   n8n HTTP: http://$DOCKER_LABS_URL_HTTP"
        echo "   Callback OAuth2: https://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        ;;
        
    ssl-init)
        echo "🔐 Configurando SSL automáticamente..."
        ./ssl-setup.sh init
        ;;
        
    ssl-prod)
        echo "🔐 Obteniendo certificado de producción..."
        ./ssl-setup.sh prod
        ;;
        
    ssl-status)
        echo "📊 Estado SSL..."
        ./ssl-setup.sh status
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
        echo "🛠️  Script de manejo de n8n con nginx y SSL"
        echo "Uso: $0 {start|stop|restart|logs|status|nginx-reload|backup|fix-permissions|clean|ssl-init|ssl-prod|ssl-status}"
        echo ""
        echo "Comandos básicos:"
        echo "  start            - Iniciar todos los servicios"
        echo "  stop             - Detener todos los servicios"
        echo "  restart          - Reiniciar todos los servicios"
        echo "  logs [srv]       - Ver logs (opcional: especificar servicio)"
        echo "  status           - Ver estado de servicios y URLs"
        echo ""
        echo "Comandos de mantenimiento:"
        echo "  nginx-reload     - Recargar configuración de nginx"
        echo "  backup           - Crear backup de datos"
        echo "  fix-permissions  - Arreglar permisos de n8n"
        echo "  clean            - Limpiar todos los datos (¡PELIGROSO!)"
        echo ""
        echo "Comandos SSL:"
        echo "  ssl-init         - Configurar SSL inicial (staging)"
        echo "  ssl-prod         - Obtener certificado de producción"
        echo "  ssl-status       - Ver estado de certificados SSL"
        echo ""
        echo "📋 Flujo completo recomendado:"
        echo "  1. $0 start"
        echo "  2. $0 ssl-init"
        echo "  3. $0 ssl-prod"
        echo "  4. $0 restart"
        echo ""
        echo "Ejemplos:"
        echo "  $0 start"
        echo "  $0 ssl-init"
        echo "  $0 logs nginx"
        exit 1
        ;;
esac