#!/bin/bash

# Script para manejar n8n con ngrok
# Uso: ./n8n-ngrok.sh [start|stop|restart|logs|status|setup|url]

NGROK_TOKEN_FILE=".ngrok_token"

case "$1" in
    setup)
        echo "🔧 Configuración inicial de ngrok..."
        echo ""
        echo "📋 Pasos para configurar ngrok:"
        echo "1. Ve a https://ngrok.com y crea una cuenta gratuita"
        echo "2. Obtén tu token de autenticación"
        echo "3. Ejecuta: ./n8n-ngrok.sh token TU_TOKEN_AQUI"
        echo ""
        echo "🔑 Ventajas de ngrok:"
        echo "   ✅ URL HTTPS automática"
        echo "   ✅ Compatible con Gmail OAuth2"
        echo "   ✅ No requiere configuración de puertos"
        echo "   ✅ Accesible desde cualquier lugar"
        echo "   ✅ Dashboard web en puerto 4040"
        ;;
        
    token)
        if [ -z "$2" ]; then
            echo "❌ Error: Debes proporcionar el token"
            echo "Uso: $0 token TU_TOKEN_NGROK"
            exit 1
        fi
        
        echo "🔑 Configurando token de ngrok..."
        echo "$2" > "$NGROK_TOKEN_FILE"
        
        # Crear archivo .env para docker-compose
        echo "NGROK_AUTHTOKEN=$2" > .env
        
        echo "✅ Token configurado exitosamente"
        echo "📋 Ahora puedes ejecutar: ./n8n-ngrok.sh start"
        ;;
        
    start)
        if [ ! -f "$NGROK_TOKEN_FILE" ]; then
            echo "❌ Token de ngrok no configurado"
            echo "📋 Ejecuta primero: ./n8n-ngrok.sh setup"
            exit 1
        fi
        
        echo "🚀 Iniciando n8n con ngrok..."
        
        # Crear directorios necesarios y arreglar permisos
        echo "📁 Preparando directorios y permisos..."
        mkdir -p n8n_data postgres_data
        
        # Arreglar permisos usando container temporal
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            echo 'Permisos configurados para n8n'
        "
        
        # Verificar que el archivo .env existe
        if [ ! -f ".env" ]; then
            NGROK_TOKEN=$(cat "$NGROK_TOKEN_FILE")
            echo "NGROK_AUTHTOKEN=$NGROK_TOKEN" > .env
        fi
        
        # Iniciar servicios con ngrok
        docker-compose -f docker-compose-ngrok.yml up -d
        
        echo "✅ Servicios iniciados!"
        echo "⏳ Esperando que ngrok esté listo..."
        sleep 10
        
        # Obtener la URL de ngrok
        ./n8n-ngrok.sh url
        ;;
        
    stop)
        echo "🛑 Deteniendo servicios..."
        docker-compose -f docker-compose-ngrok.yml down
        echo "✅ Servicios detenidos!"
        ;;
        
    restart)
        echo "🔄 Reiniciando servicios..."
        docker-compose -f docker-compose-ngrok.yml down
        sleep 3
        docker-compose -f docker-compose-ngrok.yml up -d
        echo "✅ Servicios reiniciados!"
        sleep 10
        ./n8n-ngrok.sh url
        ;;
        
    logs)
        echo "📋 Mostrando logs..."
        if [ -n "$2" ]; then
            docker-compose -f docker-compose-ngrok.yml logs -f "$2"
        else
            docker-compose -f docker-compose-ngrok.yml logs -f
        fi
        ;;
        
    status)
        echo "📊 Estado de los servicios:"
        docker-compose -f docker-compose-ngrok.yml ps
        echo ""
        ./n8n-ngrok.sh url
        ;;
        
    url)
        echo "🌐 Obteniendo URL de ngrok..."
        
        # Verificar que ngrok está corriendo
        if ! docker-compose -f docker-compose-ngrok.yml ps ngrok | grep -q "Up"; then
            echo "❌ Ngrok no está corriendo"
            echo "📋 Ejecuta: ./n8n-ngrok.sh start"
            exit 1
        fi
        
        # Intentar obtener la URL de la API de ngrok
        sleep 5
        NGROK_URL=""
        
        # Método 1: API de ngrok
        for i in {1..10}; do
            NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)
            if [ -n "$NGROK_URL" ]; then
                break
            fi
            echo "⏳ Esperando que ngrok esté listo... ($i/10)"
            sleep 3
        done
        
        if [ -n "$NGROK_URL" ]; then
            echo "✅ URL de ngrok obtenida:"
            echo "📍 n8n: $NGROK_URL"
            echo "📍 Dashboard ngrok: http://localhost:4040"
            echo "👤 Usuario n8n: admin"
            echo "🔑 Contraseña n8n: admin123"
            echo ""
            echo "🔧 Para Gmail OAuth2, usa esta URL de callback:"
            echo "   $NGROK_URL/rest/oauth2-credential/callback"
            echo ""
            echo "💡 Tip: Guarda esta URL para actualizar n8n si es necesario"
            echo "📋 Para actualizar la configuración: ./n8n-ngrok.sh update-url $NGROK_URL"
        else
            echo "❌ No se pudo obtener la URL de ngrok"
            echo "📋 Verifica los logs: ./n8n-ngrok.sh logs ngrok"
            echo "🌐 O accede al dashboard: http://localhost:4040"
        fi
        ;;
        
    update-url)
        if [ -z "$2" ]; then
            echo "❌ Error: Debes proporcionar la URL de ngrok"
            echo "Uso: $0 update-url https://xxxxx.ngrok-free.app"
            exit 1
        fi
        
        NGROK_URL="$2"
        echo "🔄 Actualizando configuración de n8n con URL: $NGROK_URL"
        
        # Actualizar variables de entorno de n8n
        docker-compose -f docker-compose-ngrok.yml exec n8n sh -c "
            export WEBHOOK_URL='$NGROK_URL'
            export N8N_EDITOR_BASE_URL='$NGROK_URL'
        "
        
        echo "✅ URL actualizada. Reinicia n8n para aplicar cambios:"
        echo "   docker-compose -f docker-compose-ngrok.yml restart n8n"
        ;;
        
    dashboard)
        echo "🌐 Abriendo dashboard de ngrok..."
        echo "📍 Dashboard disponible en: http://localhost:4040"
        echo "💡 Desde aquí puedes ver:"
        echo "   - URL pública actual"
        echo "   - Tráfico HTTP en tiempo real"
        echo "   - Estadísticas de uso"
        echo "   - Logs de conexiones"
        ;;
        
    clean)
        echo "🧹 Limpiando configuración ngrok..."
        read -p "¿Estás seguro? Esto eliminará token y datos (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose -f docker-compose-ngrok.yml down -v
            rm -f "$NGROK_TOKEN_FILE" .env
            sudo rm -rf n8n_data postgres_data
            echo "✅ Configuración limpiada"
        else
            echo "❌ Cancelado"
        fi
        ;;
        
    *)
        echo "🚀 n8n con ngrok - Túnel público automático"
        echo "Uso: $0 {setup|token|start|stop|restart|logs|status|url|update-url|dashboard|clean}"
        echo ""
        echo "📋 Configuración inicial:"
        echo "  setup              - Mostrar guía de configuración"
        echo "  token TOKEN        - Configurar token de ngrok"
        echo ""
        echo "🚀 Operaciones básicas:"
        echo "  start              - Iniciar todos los servicios"
        echo "  stop               - Detener todos los servicios"
        echo "  restart            - Reiniciar todos los servicios"
        echo "  status             - Ver estado y URLs"
        echo ""
        echo "🔧 Utilidades:"
        echo "  logs [servicio]    - Ver logs"
        echo "  url                - Obtener URL actual de ngrok"
        echo "  update-url URL     - Actualizar URL en n8n"
        echo "  dashboard          - Info del dashboard ngrok"
        echo "  clean              - Limpiar todo (¡PELIGROSO!)"
        echo ""
        echo "📖 Flujo de configuración:"
        echo "  1. $0 setup"
        echo "  2. $0 token TU_TOKEN_NGROK"
        echo "  3. $0 start"
        echo "  4. $0 url"
        echo ""
        echo "🌟 Ventajas de ngrok:"
        echo "  ✅ HTTPS automático"
        echo "  ✅ Compatible con Gmail OAuth2"
        echo "  ✅ No requiere configuración de puertos"
        echo "  ✅ Dashboard web incluido"
        exit 1
        ;;
esac