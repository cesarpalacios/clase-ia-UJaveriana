# 🔧 Solución al Error de Permisos de n8n

## El Problema
```
Error: EACCES: permission denied, open '/home/node/.n8n/config'
```

Este error ocurre porque:
1. El contenedor de n8n corre con usuario `node` (UID 1000)
2. El directorio montado no tiene los permisos correctos
3. n8n no puede escribir archivos de configuración

## ✅ Soluciones Implementadas

### 1. Script Automático (Recomendado)
```bash
./n8n-manager.sh fix-permissions
```

### 2. Script Manual
```bash
./fix-permissions.sh
```

### 3. Comando Docker Directo
```bash
docker run --rm -v "$(pwd)/n8n_data:/data" busybox sh -c "
    chown -R 1000:1000 /data &&
    chmod -R 755 /data
"
```

### 4. En Docker Labs (Si los scripts no funcionan)
```bash
# Detener servicios
docker-compose down

# Limpiar directorio
rm -rf n8n_data

# Crear directorio con permisos correctos
mkdir -p n8n_data
chmod 755 n8n_data

# Usar docker para asegurar permisos internos
docker run --rm -v "$(pwd)/n8n_data:/data" busybox chown -R 1000:1000 /data

# Iniciar servicios
docker-compose up -d
```

## 🔍 Verificación

Para verificar que los permisos están correctos:

```bash
# Ver permisos del directorio
ls -la n8n_data/

# Ver logs de n8n
docker-compose logs n8n

# Debe mostrar algo como:
# "n8n ready on 0.0.0.0, port 5678"
# Sin errores de EACCES
```

## 🚀 Inicio Limpio

Si sigues teniendo problemas:

```bash
# Parar todo
docker-compose down

# Limpiar completamente
./n8n-manager.sh clean

# Arreglar permisos
./n8n-manager.sh fix-permissions

# Iniciar
./n8n-manager.sh start
```

## 📝 Cambios Realizados

1. **docker-compose.yml**: 
   - Agregado `user: "1000:1000"` al servicio n8n
   - Creado servicio `n8n-init` para preparar permisos

2. **n8n-manager.sh**: 
   - Comando `fix-permissions` agregado
   - Auto-corrección de permisos en `start`

3. **fix-permissions.sh**: 
   - Script dedicado solo a permisos

## ⚠️ Notas Importantes

- En Docker Labs, el usuario del contenedor debe coincidir con los permisos del volumen
- UID 1000 es el estándar para el usuario `node` en el contenedor n8n
- Los permisos se deben configurar ANTES de iniciar n8n
- Si cambias de instancia de Docker Labs, repite el proceso de permisos