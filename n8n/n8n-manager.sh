#!/bin/bash

# Script para manejar n8n con nginx proxy
# Uso: ./n8n-manager.sh [start|stop|restart|logs|status]

DOCKER_LABS_URL="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com"

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
        echo "📍 n8n disponible en: http://$DOCKER_LABS_URL"
        echo "👤 Usuario: admin"
        echo "🔑 Contraseña: admin123"
        echo ""
        echo "🔧 Para configurar Gmail OAuth2, usa esta URL de callback:"
        echo "   http://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
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
        echo "🛠️  Script de manejo de n8n con nginx"
        echo "Uso: $0 {start|stop|restart|logs|status|nginx-reload|backup|fix-permissions|clean}"
        echo ""
        echo "Comandos disponibles:"
        echo "  start            - Iniciar todos los servicios"
        echo "  stop             - Detener todos los servicios"
        echo "  restart          - Reiniciar todos los servicios"
        echo "  logs [srv]       - Ver logs (opcional: especificar servicio)"
        echo "  status           - Ver estado de servicios y URLs"
        echo "  nginx-reload     - Recargar configuración de nginx"
        echo "  backup           - Crear backup de datos"
        echo "  fix-permissions  - Arreglar permisos de n8n"
        echo "  clean            - Limpiar todos los datos (¡PELIGROSO!)"
        echo ""
        echo "Ejemplos:"
        echo "  $0 start"
        echo "  $0 fix-permissions"
        echo "  $0 logs nginx"
        echo "  $0 logs n8n"
        exit 1
        ;;
esac