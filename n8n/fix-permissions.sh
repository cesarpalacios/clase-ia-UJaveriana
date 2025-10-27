#!/bin/bash

echo "🔧 Solucionando permisos para n8n..."

# Crear directorios si no existen
mkdir -p n8n_data nginx_logs postgres_data

# En Docker Labs, necesitamos asegurar permisos correctos
echo "📁 Configurando permisos de directorios..."

# Opción 1: Usar docker run para arreglar permisos
echo "🐳 Usando contenedor temporal para arreglar permisos..."
docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
    chown -R 1000:1000 /data &&
    chmod -R 755 /data &&
    echo 'Permisos de n8n_data configurados'
"

# Verificar que los directorios existen
if [ -d "n8n_data" ]; then
    echo "✅ Directorio n8n_data creado"
else
    echo "❌ Error creando directorio n8n_data"
fi

if [ -d "nginx_logs" ]; then
    echo "✅ Directorio nginx_logs creado"
else
    echo "❌ Error creando directorio nginx_logs"
fi

if [ -d "postgres_data" ]; then
    echo "✅ Directorio postgres_data creado"
else
    echo "❌ Error creando directorio postgres_data"
fi

echo ""
echo "🚀 Ahora puedes ejecutar:"
echo "   docker-compose up -d"
echo ""
echo "📍 O usar el script manager:"
echo "   ./n8n-manager.sh start"