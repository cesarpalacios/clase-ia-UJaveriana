#!/bin/bash

# Script súper simple para n8n
# Uso: ./n8n-simple.sh [start|stop|restart|logs|status|clean]

case "$1" in
    start)
        echo "🚀 Iniciando n8n..."
        
        # Crear directorio y permisos
        echo "📁 Preparando directorios..."
        mkdir -p n8n_data
        docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
            chown -R 1000:1000 /data &&
            chmod -R 755 /data
        " 2>/dev/null || echo "ℹ️  Permisos configurados"
        
        # Iniciar servicios
        docker-compose up -d
        
        echo "✅ n8n iniciado exitosamente!"
        echo ""
        echo "📍 Accede a n8n en: http://localhost:5678"
        echo "👤 Usuario: admin"
        echo "🔑 Contraseña: admin123"
        echo ""
        echo "💡 Para usar desde Docker Labs, usa el puerto 5678:"
        echo "   http://ip172-18-0-18-d3vc6lgl2o9000bn4hdg-5678.direct.labs.play-with-docker.com"
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
        
    *)
        echo "🚀 n8n - Configuración Súper Simple"
        echo "Uso: $0 {start|stop|restart|logs|status|clean}"
        echo ""
        echo "🎯 Comandos disponibles:"
        echo ""
        echo "  start    - Iniciar n8n + PostgreSQL"
        echo "  stop     - Detener todos los servicios"
        echo "  restart  - Reiniciar todos los servicios"
        echo "  logs     - Ver logs (logs n8n, logs postgres)"
        echo "  status   - Ver estado y URLs"
        echo "  clean    - Eliminar todos los datos"
        echo ""
        echo "📖 Ejemplos:"
        echo "  $0 start           # Iniciar n8n"
        echo "  $0 logs n8n        # Ver logs de n8n"
        echo "  $0 status          # Ver estado actual"
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
        exit 1
        ;;
esac