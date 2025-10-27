#!/bin/bash

# Script para obtener certificados SSL con Let's Encrypt
# Uso: ./ssl-setup.sh [init|renew|status]

DOMAIN="ip172-18-0-18-d3vc6lgl2o9000bn4hdg-443.direct.labs.play-with-docker.com"
EMAIL="admin@example.com"  # Cambia por tu email

case "$1" in
    init)
        echo "🔐 Configurando SSL con Let's Encrypt..."
        echo "📧 Email: $EMAIL"
        echo "🌐 Dominio: $DOMAIN"
        echo ""
        
        # Crear directorios necesarios
        mkdir -p certbot/conf certbot/www
        
        # Crear certificado dummy para nginx inicial
        echo "📜 Creando certificado temporal..."
        mkdir -p certbot/conf/live/default
        
        # Generar certificado autofirmado temporal
        docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
            --entrypoint="" \
            certbot/certbot \
            sh -c "
                openssl req -x509 -nodes -days 1 \
                    -newkey rsa:2048 \
                    -keyout /etc/letsencrypt/live/default/privkey.pem \
                    -out /etc/letsencrypt/live/default/fullchain.pem \
                    -subj '/CN=localhost'
            "
        
        echo "✅ Certificado temporal creado"
        
        # Iniciar nginx con certificado temporal
        echo "🚀 Iniciando nginx con certificado temporal..."
        docker-compose up -d nginx
        
        # Esperar a que nginx esté listo
        echo "⏳ Esperando a que nginx esté listo..."
        sleep 10
        
        # Verificar que nginx responde en puerto 80
        echo "🔍 Verificando que nginx responde..."
        if ! curl -f http://localhost/.well-known/acme-challenge/test 2>/dev/null; then
            echo "⚠️  Nginx no responde correctamente en puerto 80"
            echo "📋 Verifica los logs: docker-compose logs nginx"
        fi
        
        # Obtener certificado real de Let's Encrypt
        echo "🔐 Obteniendo certificado real de Let's Encrypt..."
        docker-compose run --rm certbot \
            certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" \
            --agree-tos \
            --no-eff-email \
            --staging \
            -d "$DOMAIN"
        
        if [ $? -eq 0 ]; then
            echo "✅ Certificado de staging obtenido exitosamente!"
            echo "🔄 Para obtener certificado de producción, ejecuta:"
            echo "   ./ssl-setup.sh prod"
        else
            echo "❌ Error obteniendo certificado de staging"
            echo "📋 Verifica los logs y la configuración"
        fi
        ;;
        
    prod)
        echo "🔐 Obteniendo certificado de PRODUCCIÓN..."
        echo "⚠️  Este comando solo funciona si el de staging fue exitoso"
        
        docker-compose run --rm certbot \
            certonly \
            --webroot \
            --webroot-path=/var/www/certbot \
            --email "$EMAIL" \
            --agree-tos \
            --no-eff-email \
            --force-renewal \
            -d "$DOMAIN"
        
        if [ $? -eq 0 ]; then
            echo "✅ Certificado de producción obtenido!"
            echo "🔄 Recargando nginx..."
            docker-compose exec nginx nginx -s reload
            echo "🌟 SSL configurado exitosamente!"
            echo "🌐 Accede a: https://$DOMAIN"
        else
            echo "❌ Error obteniendo certificado de producción"
        fi
        ;;
        
    renew)
        echo "🔄 Renovando certificados..."
        docker-compose run --rm certbot renew
        
        if [ $? -eq 0 ]; then
            echo "✅ Certificados renovados"
            echo "🔄 Recargando nginx..."
            docker-compose exec nginx nginx -s reload
        else
            echo "❌ Error renovando certificados"
        fi
        ;;
        
    status)
        echo "📊 Estado de certificados SSL:"
        docker-compose run --rm certbot certificates
        ;;
        
    test)
        echo "🔍 Probando configuración SSL..."
        
        # Verificar que nginx está corriendo
        if ! docker-compose ps nginx | grep -q "Up"; then
            echo "❌ Nginx no está corriendo"
            exit 1
        fi
        
        # Verificar puerto 80
        echo "📡 Probando HTTP (puerto 80)..."
        if curl -f "http://localhost/.well-known/acme-challenge/test" 2>/dev/null; then
            echo "✅ Puerto 80 responde"
        else
            echo "❌ Puerto 80 no responde"
        fi
        
        # Verificar puerto 443 si existen certificados
        if [ -f "certbot/conf/live/default/fullchain.pem" ]; then
            echo "📡 Probando HTTPS (puerto 443)..."
            if curl -k -f "https://localhost/" 2>/dev/null; then
                echo "✅ Puerto 443 responde"
            else
                echo "❌ Puerto 443 no responde"
            fi
        else
            echo "ℹ️  No hay certificados SSL todavía"
        fi
        ;;
        
    clean)
        echo "🧹 Limpiando certificados (¡CUIDADO!)..."
        read -p "¿Estás seguro? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf certbot/
            echo "✅ Certificados eliminados"
        else
            echo "❌ Cancelado"
        fi
        ;;
        
    *)
        echo "🔐 Configuración SSL con Let's Encrypt para n8n"
        echo "Uso: $0 {init|prod|renew|status|test|clean}"
        echo ""
        echo "Comandos:"
        echo "  init    - Configuración inicial (certificado staging)"
        echo "  prod    - Obtener certificado de producción"
        echo "  renew   - Renovar certificados existentes"
        echo "  status  - Ver estado de certificados"
        echo "  test    - Probar configuración actual"
        echo "  clean   - Eliminar todos los certificados"
        echo ""
        echo "⚠️  IMPORTANTE:"
        echo "  - Cambia el EMAIL en este script antes de usar"
        echo "  - Asegúrate de que el DOMAIN sea correcto"
        echo "  - Ejecuta 'init' primero, luego 'prod'"
        echo ""
        echo "📖 Flujo recomendado:"
        echo "  1. ./ssl-setup.sh init"
        echo "  2. ./ssl-setup.sh prod"
        echo "  3. ./n8n-manager.sh restart"
        exit 1
        ;;
esac