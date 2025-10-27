#!/bin/bash

# Script unificado para n8n - Súper simple
# Uso: ./n8n.sh [start|nginx|ngrok|stop|url|logs|help]

# Configuración
DOCKER_LABS_URL="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com"

# Función para preparar permisos
prepare_permissions() {
    echo "📁 Preparando directorios..."
    mkdir -p n8n_data
    docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
        chown -R 1000:1000 /data &&
        chmod -R 755 /data
    " 2>/dev/null || echo "⚠️  Permisos configurados manualmente"
}

case "$1" in
    start)
        echo "🚀 Iniciando n8n (modo básico - solo puerto 5678)"
        prepare_permissions
        
        # Solo n8n básico sin proxy
        docker-compose up -d postgres n8n-init n8n
        
        echo "✅ n8n iniciado!"
        echo "📍 Acceso directo: http://localhost:5678"
        echo "👤 Usuario: admin | 🔑 Contraseña: admin123"
        echo ""
        echo "💡 Opciones avanzadas:"
        echo "   ./n8n.sh nginx  - Usar con nginx proxy"
        echo "   ./n8n.sh ngrok  - Usar con túnel público"
        ;;
        
    nginx)
        echo "🚀 Iniciando n8n con nginx proxy (Docker Labs)"
        prepare_permissions
        
        # Configurar variables para nginx
        export WEBHOOK_URL="http://$DOCKER_LABS_URL"
        export N8N_EDITOR_BASE_URL="http://$DOCKER_LABS_URL"
        export N8N_PROTOCOL="http"
        export N8N_SECURE_COOKIE="false"
        
        # Iniciar con nginx
        docker-compose --profile nginx up -d
        
        echo "✅ n8n con nginx iniciado!"
        echo "📍 URL pública: http://$DOCKER_LABS_URL"
        echo "👤 Usuario: admin | 🔑 Contraseña: admin123"
        echo "🔧 Gmail OAuth2: http://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        ;;
        
    ngrok)
        echo "🚀 Iniciando n8n con ngrok (túnel público)"
        
        # Verificar token de ngrok
        if [ ! -f ".env" ] || ! grep -q "NGROK_AUTHTOKEN" .env; then
            echo "❌ Token de ngrok no configurado"
            echo ""
            echo "📋 Configuración rápida:"
            echo "1. Ve a https://ngrok.com y obtén tu token gratuito"
            echo "2. Ejecuta: echo 'NGROK_AUTHTOKEN=tu_token' > .env"
            echo "3. Ejecuta: ./n8n.sh ngrok"
            exit 1
        fi
        
        prepare_permissions
        
        # Configurar variables para ngrok (se actualizarán después)
        export WEBHOOK_URL="https://placeholder.ngrok-free.app"
        export N8N_EDITOR_BASE_URL="https://placeholder.ngrok-free.app"
        export N8N_PROTOCOL="https"
        export N8N_SECURE_COOKIE="true"
        
        # Iniciar con ngrok
        docker-compose --profile ngrok up -d
        
        echo "✅ n8n con ngrok iniciado!"
        echo "⏳ Esperando URL de ngrok..."
        sleep 10
        
        # Obtener URL de ngrok
        ./n8n.sh url
        ;;
        
    stop)
        echo "🛑 Deteniendo n8n..."
        docker-compose --profile nginx --profile ngrok down
        echo "✅ n8n detenido!"
        ;;
        
    url)
        echo "🌐 Obteniendo URLs..."
        
        # Verificar qué servicios están corriendo
        if docker-compose ps nginx 2>/dev/null | grep -q "Up"; then
            echo "📍 Nginx: http://$DOCKER_LABS_URL"
            echo "🔧 OAuth2: http://$DOCKER_LABS_URL/rest/oauth2-credential/callback"
        fi
        
        if docker-compose ps ngrok 2>/dev/null | grep -q "Up"; then
            echo "📍 Dashboard ngrok: http://localhost:4040"
            
            # Intentar obtener URL de ngrok
            for i in {1..5}; do
                NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok-free\.app' | head -1)
                if [ -n "$NGROK_URL" ]; then
                    echo "📍 Ngrok público: $NGROK_URL"
                    echo "🔧 OAuth2: $NGROK_URL/rest/oauth2-credential/callback"
                    break
                fi
                echo "⏳ Esperando ngrok... ($i/5)"
                sleep 2
            done
            
            if [ -z "$NGROK_URL" ]; then
                echo "❌ No se pudo obtener URL de ngrok automáticamente"
                echo "🌐 Verifica en: http://localhost:4040"
            fi
        fi
        
        if docker-compose ps n8n 2>/dev/null | grep -q "Up"; then
            if ! docker-compose ps nginx 2>/dev/null | grep -q "Up" && ! docker-compose ps ngrok 2>/dev/null | grep -q "Up"; then
                echo "📍 Directo: http://localhost:5678"
            fi
        fi
        
        echo "👤 Usuario: admin | 🔑 Contraseña: admin123"
        ;;
        
    logs)
        if [ -n "$2" ]; then
            docker-compose logs -f "$2"
        else
            echo "📋 Logs disponibles:"
            docker-compose ps --format "table {{.Service}}\t{{.Status}}"
            echo ""
            echo "Ver logs específicos: ./n8n.sh logs [n8n|nginx|ngrok|postgres]"
            echo "Ver todos: docker-compose logs -f"
        fi
        ;;
        
    status)
        echo "📊 Estado de servicios:"
        docker-compose ps
        echo ""
        ./n8n.sh url
        ;;
        
    clean)
        echo "🧹 Limpiando datos (¡CUIDADO!)"
        read -p "¿Eliminar todos los datos? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose --profile nginx --profile ngrok down -v
            sudo rm -rf n8n_data
            echo "✅ Datos eliminados"
        else
            echo "❌ Cancelado"
        fi
        ;;
        
    help|*)
        echo "🚀 n8n - Script Simplificado"
        echo "Uso: $0 {start|nginx|ngrok|stop|url|logs|status|clean|help}"
        echo ""
        echo "🎯 Modos de uso:"
        echo ""
        echo "🏠 Básico (puerto 5678):"
        echo "   $0 start     - Solo n8n en localhost:5678"
        echo ""
        echo "🌐 Docker Labs (nginx proxy):"
        echo "   $0 nginx     - n8n + nginx para Docker Labs"
        echo "   URL: http://$DOCKER_LABS_URL"
        echo ""
        echo "🚀 Público (ngrok tunnel):"
        echo "   $0 ngrok     - n8n + túnel público HTTPS"
        echo "   Requiere: Token de ngrok.com (gratis)"
        echo "   URL: https://xxxxx.ngrok-free.app"
        echo ""
        echo "🔧 Utilidades:"
        echo "   $0 stop      - Detener todo"
        echo "   $0 url       - Ver URLs actuales"
        echo "   $0 logs      - Ver logs"
        echo "   $0 status    - Estado completo"
        echo "   $0 clean     - Limpiar datos"
        echo ""
        echo "📖 Ejemplos rápidos:"
        echo ""
        echo "# Desarrollo local simple"
        echo "$0 start"
        echo ""
        echo "# Docker Labs"
        echo "$0 nginx"
        echo ""
        echo "# Túnel público (requiere token)"
        echo "echo 'NGROK_AUTHTOKEN=tu_token' > .env"
        echo "$0 ngrok"
        echo ""
        echo "🎯 ¿Cuál elegir?"
        echo "• start → Desarrollo local básico"
        echo "• nginx → Docker Labs o servidor local"
        echo "• ngrok → Gmail OAuth2, webhooks, acceso externo"
        echo ""
        echo "👤 Credenciales: admin / admin123"
        exit 1
        ;;
esac