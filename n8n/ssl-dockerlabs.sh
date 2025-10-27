#!/bin/bash

# Script mejorado para SSL en Docker Labs
# Uso: ./ssl-dockerlabs.sh [init|test|obtain|status]

DOMAIN="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-80.direct.labs.play-with-docker.com"
EMAIL="admin@example.com"  # Cambia por tu email

echo "🔧 Configuración SSL para Docker Labs"
echo "📧 Email: $EMAIL"
echo "🌐 Dominio: $DOMAIN"
echo ""

case "$1" in
    init)
        echo "🚀 Configuración inicial para SSL..."
        
        # Parar servicios si están corriendo
        docker-compose down 2>/dev/null || true
        
        # Crear directorios
        mkdir -p certbot/conf certbot/www nginx_logs
        
        # Usar configuración nginx simple para HTTP
        echo "📝 Configurando nginx para HTTP solamente..."
        cp nginx-http-only.conf nginx.conf
        
        # Actualizar docker-compose para solo HTTP inicialmente
        echo "🐳 Iniciando servicios en modo HTTP..."
        docker-compose up -d postgres n8n nginx
        
        # Esperar que los servicios estén listos
        echo "⏳ Esperando que los servicios estén listos..."
        sleep 15
        
        echo "✅ Servicios iniciados en modo HTTP"
        echo "🔍 Prueba que funciona: http://$DOMAIN/test"
        echo "📋 Próximo paso: ./ssl-dockerlabs.sh test"
        ;;
        
    test)
        echo "🔍 Probando accesibilidad desde internet..."
        
        # Verificar que nginx responde localmente
        if docker-compose exec nginx nginx -t; then
            echo "✅ Configuración nginx válida"
        else
            echo "❌ Error en configuración nginx"
            exit 1
        fi
        
        # Crear archivo de prueba para ACME
        TEST_FILE="test-$(date +%s)"
        echo "test-content-$(date)" > "certbot/www/$TEST_FILE"
        
        echo "📁 Archivo de prueba creado: $TEST_FILE"
        echo "🌐 Probando acceso desde Docker Labs..."
        echo "   URL: http://$DOMAIN/.well-known/acme-challenge/$TEST_FILE"
        echo ""
        echo "⏳ Esperando 10 segundos para que se propague..."
        sleep 10
        
        # Test con curl desde el contenedor
        if docker-compose exec nginx wget -q -O - "http://localhost/.well-known/acme-challenge/$TEST_FILE" 2>/dev/null; then
            echo "✅ Archivo accesible localmente"
        else
            echo "❌ Archivo NO accesible localmente"
            echo "📋 Verificando configuración..."
            docker-compose exec nginx ls -la /var/www/certbot/
        fi
        
        echo ""
        echo "🔍 Para probar desde internet, visita:"
        echo "   http://$DOMAIN/test"
        echo "   http://$DOMAIN/.well-known/acme-challenge/$TEST_FILE"
        echo ""
        echo "📋 Si ambas URLs funcionan, ejecuta: ./ssl-dockerlabs.sh obtain"
        ;;
        
    obtain)
        echo "🔐 Obteniendo certificado SSL de Let's Encrypt..."
        
        # Verificar que nginx está corriendo
        if ! docker-compose ps nginx | grep -q "Up"; then
            echo "❌ Nginx no está corriendo. Ejecuta: ./ssl-dockerlabs.sh init"
            exit 1
        fi
        
        # Obtener certificado (inicialmente staging para pruebas)
        echo "📜 Obteniendo certificado de staging..."
        docker-compose run --rm certbot \
            certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" \
            --agree-tos \
            --no-eff-email \
            --staging \
            --verbose \
            -d "$DOMAIN"
        
        if [ $? -eq 0 ]; then
            echo "✅ Certificado de staging obtenido!"
            echo "🔄 Cambiando a configuración HTTPS..."
            
            # Restaurar configuración nginx con SSL
            cp nginx.conf.ssl nginx.conf 2>/dev/null || echo "⚠️  nginx.conf.ssl no encontrado, usando configuración actual"
            
            # Recargar nginx
            docker-compose exec nginx nginx -s reload
            
            echo "🌟 Configuración SSL aplicada!"
            echo "📋 Para certificado de producción, ejecuta:"
            echo "   ./ssl-dockerlabs.sh prod"
        else
            echo "❌ Error obteniendo certificado"
            echo "📋 Verifica los logs: docker-compose logs certbot"
        fi
        ;;
        
    prod)
        echo "🔐 Obteniendo certificado de PRODUCCIÓN..."
        
        docker-compose run --rm certbot \
            certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" \
            --agree-tos \
            --no-eff-email \
            --force-renewal \
            --verbose \
            -d "$DOMAIN"
        
        if [ $? -eq 0 ]; then
            echo "✅ Certificado de producción obtenido!"
            docker-compose exec nginx nginx -s reload
            echo "🌟 ¡SSL configurado exitosamente!"
        else
            echo "❌ Error obteniendo certificado de producción"
        fi
        ;;
        
    status)
        echo "📊 Estado actual:"
        echo ""
        echo "🐳 Servicios:"
        docker-compose ps
        echo ""
        echo "📜 Certificados:"
        docker-compose run --rm certbot certificates 2>/dev/null || echo "No hay certificados"
        echo ""
        echo "🌐 URLs de prueba:"
        echo "   Test: http://$DOMAIN/test"
        echo "   ACME: http://$DOMAIN/.well-known/acme-challenge/"
        ;;
        
    logs)
        echo "📋 Logs de nginx:"
        docker-compose logs nginx
        echo ""
        echo "📋 Logs de certbot:"
        docker-compose logs certbot
        ;;
        
    simple)
        echo "🔧 Configuración SSL simple (autofirmado)..."
        
        # Crear certificado autofirmado
        mkdir -p certbot/conf/live/default
        
        docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
            --entrypoint="" \
            certbot/certbot \
            sh -c "
                openssl req -x509 -nodes -days 365 \
                    -newkey rsa:2048 \
                    -keyout /etc/letsencrypt/live/default/privkey.pem \
                    -out /etc/letsencrypt/live/default/fullchain.pem \
                    -subj '/CN=$DOMAIN'
            "
        
        echo "✅ Certificado autofirmado creado"
        echo "📋 Ahora puedes usar HTTPS (con advertencia del navegador)"
        ;;
        
    *)
        echo "🔐 Configuración SSL simplificada para Docker Labs"
        echo "Uso: $0 {init|test|obtain|prod|status|logs|simple}"
        echo ""
        echo "Flujo recomendado:"
        echo "  1. $0 init     - Configuración inicial HTTP"
        echo "  2. $0 test     - Probar accesibilidad"
        echo "  3. $0 obtain   - Obtener certificado SSL"
        echo "  4. $0 prod     - Certificado de producción"
        echo ""
        echo "Comandos adicionales:"
        echo "  status  - Ver estado actual"
        echo "  logs    - Ver logs de nginx y certbot"
        echo "  simple  - Crear certificado autofirmado"
        echo ""
        echo "⚠️  Recuerda cambiar EMAIL en este script"
        exit 1
        ;;
esac