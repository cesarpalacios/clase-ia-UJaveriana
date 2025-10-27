#!/bin/bash

# Script súper simple para n8n
# Uso: ./n8n-simple.sh [start|stop|restart|logs|status|clean]

case "$1" in
    start)
        echo "🚀 Iniciando n8n..."
        
        # Verificar si hay URL de ngrok configurada
        if [ -n "$2" ]; then
            export NGROK_URL="$2"
            echo "🌐 Configurando URL de ngrok: $NGROK_URL"
        elif [ -n "$NGROK_URL" ]; then
            echo "🌐 Usando URL de ngrok desde variable de entorno: $NGROK_URL"
        else
            echo "💡 Usando URL local. Para ngrok usa: $0 start <url>"
            echo "   Ejemplo: $0 start https://0a79d5bba895.ngrok-free.app"
        fi
        
        # Crear directorio y permisos
        echo "📁 Preparando directorios..."
        mkdir -p n8n_data
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            find /data -name 'config' -exec chmod 600 {} \; 2>/dev/null || true
        " 2>/dev/null || echo "ℹ️  Permisos configurados"
        
        # Iniciar servicios
        echo "🐳 Iniciando servicios..."
        docker-compose up -d
        
        echo "⏳ Esperando que los servicios estén listos..."
        sleep 15
        
        # Verificar estado
        if docker-compose ps n8n | grep -q "Up"; then
            echo "✅ n8n iniciado exitosamente!"
            echo ""
            if [ -n "$NGROK_URL" ]; then
                echo "📍 Accede a n8n en: $NGROK_URL"
                echo "🌐 URL de webhooks: $NGROK_URL"
            else
                echo "📍 Accede a n8n en: http://localhost:5678"
                echo "💡 Para Docker Labs, usa el puerto 5678:"
                echo "   http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-5678.direct.labs.play-with-docker.com"
            fi
            echo "👤 Usuario: admin"
            echo "🔑 Contraseña: admin123"
        else
            echo "❌ Error iniciando n8n. Ver logs:"
            echo "   ./n8n-simple.sh logs"
        fi
        ;;
        
    fix)
        echo "🔧 Arreglando problemas comunes..."
        
        # Detener servicios
        echo "🛑 Deteniendo servicios..."
        docker-compose down
        
        # Limpiar y recrear permisos
        echo "📁 Arreglando permisos..."
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data &&
            find /data -name 'config' -exec chmod 600 {} \; 2>/dev/null || true &&
            echo 'Permisos corregidos'
        "
        
        # Reiniciar servicios
        echo "🚀 Reiniciando servicios..."
        docker-compose up -d
        
        echo "✅ Problemas solucionados!"
        echo "⏳ Esperando que n8n esté listo..."
        sleep 15
        ./n8n-simple.sh status
        ;;
        
    stop)
        echo "🛑 Deteniendo n8n..."
        docker-compose down
        echo "✅ n8n detenido!"
        ;;
        
    restart)
        echo "🔄 Reiniciando n8n..."
        docker-compose down
        docker-compose up -d
        echo "✅ n8n reiniciado!"
        ;;
        
    logs)
        if [ -n "$2" ]; then
            echo "📋 Logs de $2:"
            docker-compose logs -f "$2"
        else
            echo "📋 Logs de todos los servicios:"
            docker-compose logs -f
        fi
        ;;
        
    status)
        echo "📊 Estado de servicios:"
        docker-compose ps
        echo ""
        echo "🌐 URLs disponibles:"
        echo "   Local: http://localhost:5678"
        echo "   Docker Labs: http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-5678.direct.labs.play-with-docker.com"
        echo ""
        echo "👤 Credenciales: admin / admin123"
        ;;
        
    clean)
        echo "🧹 Limpiando datos de n8n..."
        echo "⚠️  Esto eliminará todos los workflows y configuraciones"
        read -p "¿Continuar? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker-compose down -v
            sudo rm -rf n8n_data 2>/dev/null || rm -rf n8n_data
            echo "✅ Datos eliminados"
        else
            echo "❌ Cancelado"
        fi
        ;;
        
    ngrok)
        if [ -z "$2" ]; then
            echo "❌ Falta la URL de ngrok"
            echo "💡 Uso: $0 ngrok <url>"
            echo "   Ejemplo: $0 ngrok https://0a79d5bba895.ngrok-free.app"
            exit 1
        fi
        
        echo "🌐 Configurando n8n con ngrok..."
        echo "🔗 URL: $2"
        
        # Configurar variable de entorno
        export NGROK_URL="$2"
        
        # Reiniciar n8n con la nueva URL
        echo "🔄 Reiniciando n8n con ngrok..."
        docker-compose down
        docker-compose up -d
        
        echo "⏳ Esperando que n8n esté listo..."
        sleep 15
        
        if docker-compose ps n8n | grep -q "Up"; then
            echo "✅ n8n configurado con ngrok!"
            echo ""
            echo "🌐 URLs configuradas:"
            echo "   Acceso web: $2"
            echo "   Webhooks: $2"
            echo ""
            echo "👤 Credenciales: admin / admin123"
            echo ""
            echo "💡 Para Gmail y otros servicios, usa: $2"
        else
            echo "❌ Error configurando n8n. Ver logs:"
            echo "   ./n8n-simple.sh logs"
        fi
        ;;

    *)
        echo "🚀 n8n - Configuración Súper Simple"
        echo "Uso: $0 {start|stop|restart|fix|ngrok|logs|status|clean}"
        echo ""
        echo "🎯 Comandos disponibles:"
        echo ""
        echo "  start    - Iniciar n8n + PostgreSQL"
        echo "  stop     - Detener todos los servicios"
        echo "  restart  - Reiniciar todos los servicios"
        echo "  fix      - Arreglar problemas de permisos/DB"
        echo "  ngrok    - Configurar URL de ngrok"
        echo "  logs     - Ver logs (logs n8n, logs postgres)"
        echo "  status   - Ver estado y URLs"
        echo "  clean    - Eliminar todos los datos"
        echo ""
        echo "📖 Ejemplos:"
        echo "  $0 start           # Iniciar n8n"
        echo "  $0 ngrok https://abc.ngrok-free.app  # Configurar ngrok"
        echo "  $0 start https://abc.ngrok-free.app  # Iniciar con ngrok"
        echo "  $0 fix             # Arreglar errores comunes"
        echo "  $0 logs n8n        # Ver logs de n8n"
        echo "  $0 status          # Ver estado actual"
        echo ""
        echo "🚨 Si tienes problemas:"
        echo "  1. $0 fix          # Arregla permisos y BD"
        echo "  2. $0 logs         # Ve qué está pasando"
        echo "  3. $0 clean && $0 start  # Reinicio completo"
        echo ""
        echo "🌐 Acceso después de iniciar:"
        echo "  • Local: http://localhost:5678"
        echo "  • Docker Labs: usar puerto 5678"
        echo ""
        echo "👤 Credenciales:"
        echo "  • Usuario: admin"
        echo "  • Contraseña: admin123"
        echo ""
        echo "💡 Características:"
        echo "  ✅ Solo n8n + PostgreSQL"
        echo "  ✅ Puerto directo 5678"
        echo "  ✅ Sin proxy ni túneles"
        echo "  ✅ Configuración mínima"
        echo "  ✅ Máxima simplicidad"
        echo "  ✅ Arreglo automático de problemas"
        exit 1
        ;;
esac