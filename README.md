# Clase IA - Universidad Javeriana

Este repositorio contiene los materiales y configuraciones utilizados en las clases de Inteligencia Artificial de la Universidad Javeriana.

## 📋 Contenido

- **n8n**: Configuración de Docker Compose para n8n (plataforma de automatización de flujos de trabajo)

## 🚀 n8n - Plataforma de Automatización

n8n es una herramienta de automatización de flujos de trabajo que permite conectar diferentes servicios y APIs de manera visual.

### 🛠️ Configuración

El proyecto incluye una configuración completa de Docker Compose con:
- **n8n**: Plataforma principal de automatización
- **PostgreSQL**: Base de datos para almacenar configuraciones y datos

### 📦 Requisitos Previos

- Docker
- Docker Compose

### 🚀 Instalación y Ejecución

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/cesarpalacios/clase-ia-UJaveriana.git
   cd "Clase IA"
   ```

2. **Navegar al directorio de n8n:**
   ```bash
   cd n8n
   ```

3. **Ejecutar con Docker Compose:**
   ```bash
   docker-compose up -d
   ```

4. **Acceder a n8n:**
   - URL: http://localhost:5678
   - Usuario: `admin`
   - Contraseña: `admin123`

### 📊 Servicios Incluidos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| n8n | 5678 | Interfaz web de n8n |
| PostgreSQL | 5432 | Base de datos (solo interno) |

### 🔧 Configuración Personalizada

La configuración incluye:
- **Autenticación básica** activada para seguridad
- **Zona horaria** configurada para América/Bogotá
- **Volúmenes persistentes** para datos de n8n y PostgreSQL
- **Variables de entorno** preconfiguradas

### 📁 Estructura de Directorios

```
n8n/
├── docker-compose.yml    # Configuración de servicios
├── n8n_data/            # Datos persistentes de n8n (creado automáticamente)
└── postgres_data/       # Datos de PostgreSQL (creado automáticamente)
```

### 🔄 Comandos Útiles

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes (¡cuidado: elimina todos los datos!)
docker-compose down -v
```

### 🛡️ Seguridad

> **⚠️ Importante**: Las credenciales por defecto están incluidas para propósitos educativos. En un entorno de producción, asegúrate de cambiar:
> - Contraseñas de PostgreSQL
> - Credenciales de autenticación de n8n
> - Configurar HTTPS apropiado

### 📚 Recursos Adicionales

- [Documentación oficial de n8n](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🤝 Contribuciones

Este es un proyecto educativo de la Universidad Javeriana. Las contribuciones son bienvenidas a través de pull requests.

## 📧 Contacto

Para preguntas relacionadas con el curso, contactar al instructor a través de los canales oficiales de la Universidad Javeriana.

## 📄 Licencia

Este proyecto es para uso educativo en el contexto del curso de Inteligencia Artificial de la Universidad Javeriana.

---

**Universidad Pontificia Javeriana** | Curso de Inteligencia Artificial