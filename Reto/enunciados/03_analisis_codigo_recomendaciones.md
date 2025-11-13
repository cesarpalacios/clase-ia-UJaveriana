# 🔍 Ejercicio 3: Sistema de Análisis de Código y Recomendaciones

## 🎯 **Objetivo**
Construir un sistema automatizado que analice código fuente y genere recomendaciones inteligentes de mejora, ayudando a desarrolladores a escribir código más limpio, eficiente y mantenible.

## 📝 **Descripción Detallada**
Desarrollar una plataforma que reciba código a través de repositorios GitHub o formularios web, lo analice usando IA para identificar problemas, patrones anti-pattern, oportunidades de optimización y mejores prácticas, generando reportes detallados con sugerencias concretas.

## 🛠️ **Tecnologías Requeridas**
- **Docker** - Contenedorización del análisis
- **n8n** - Orquestación del flujo de análisis
- **GitHub Models** - Análisis inteligente de código con IA
- **GitHub API** - Integración con repositorios para PRs automáticos

## ⚙️ **Funcionalidades Esperadas**

### **Core (Obligatorias)**
- [ ] **Ingesta de código** via upload directo o GitHub webhook
- [ ] **Análisis estático** básico (sintaxis, estructura, complejidad)
- [ ] **Generación de recomendaciones** usando IA
- [ ] **Reporte detallado** con sugerencias específicas

### **Avanzadas (Opcionales)**
- [ ] **Pull Request automático** con mejoras sugeridas
- [ ] **Análisis de seguridad** para vulnerabilidades comunes
- [ ] **Métricas de calidad** y trending de mejoras
- [ ] **Soporte multi-lenguaje** (Python, JavaScript, Java, etc.)

## 📊 **Casos de Uso Ejemplo**

### **Caso 1: Optimización de Performance**
```python
# Código Original
def buscar_usuario(users, target_id):
    for user in users:
        if user['id'] == target_id:
            return user
    return None

# Análisis IA:
# ❌ Complejidad O(n) innecesaria
# ❌ Sin manejo de casos edge
# ❌ Estructura de datos subóptima

# Recomendación:
def buscar_usuario(users_dict, target_id):
    """
    Búsqueda optimizada O(1) usando diccionario
    """
    if not isinstance(target_id, (int, str)):
        raise ValueError("ID debe ser int o string")
    
    return users_dict.get(target_id)

# ✅ Cambiar lista por diccionario para O(1)
# ✅ Agregar validación de tipos
# ✅ Documentación clara
```

### **Caso 2: Mejoras de Legibilidad**
```javascript
// Código Original
function p(d) {
  let r = [];
  for (let i = 0; i < d.length; i++) {
    if (d[i].a && d[i].s > 100) {
      r.push({n: d[i].n, v: d[i].v * 1.2});
    }
  }
  return r;
}

// Análisis IA:
// ❌ Nombres de variables no descriptivos
// ❌ Lógica business hardcodeada
// ❌ Sin documentación ni tipos

// Recomendación:
/**
 * Procesa productos activos aplicando descuento premium
 * @param {Array} products - Lista de productos
 * @returns {Array} Productos procesados con descuento aplicado
 */
function processPremiumProducts(products) {
  const PREMIUM_MULTIPLIER = 1.2;
  const MIN_STOCK_THRESHOLD = 100;
  
  return products
    .filter(product => product.active && product.stock > MIN_STOCK_THRESHOLD)
    .map(product => ({
      name: product.name,
      value: product.value * PREMIUM_MULTIPLIER
    }));
}

// ✅ Nombres descriptivos
// ✅ Constantes para magic numbers
// ✅ Programación funcional
// ✅ JSDoc documentation
```

### **Caso 3: Mejoras de Seguridad**
```python
# Código Original
import os
def execute_command(user_input):
    command = f"ls {user_input}"
    result = os.system(command)
    return result

# Análisis IA:
# 🔥 CRÍTICO: Inyección de comandos
# 🔥 ALTO: Sin sanitización de input
# ❌ Sin manejo de errores

# Recomendación:
import subprocess
import shlex
from pathlib import Path

def list_directory(directory_path):
    """
    Lista contenido de directorio de forma segura
    """
    try:
        # Validar que el path sea seguro
        path = Path(directory_path).resolve()
        
        # Verificar que esté dentro de directorio permitido
        if not str(path).startswith('/safe/directory/'):
            raise ValueError("Directorio no permitido")
        
        # Usar subprocess de forma segura
        result = subprocess.run(
            ['ls', str(path)], 
            capture_output=True, 
            text=True, 
            timeout=5
        )
        
        return result.stdout
        
    except Exception as e:
        logging.error(f"Error listando directorio: {e}")
        return "Error: No se pudo listar el directorio"

# ✅ Subprocess seguro sin shell=True
# ✅ Validación estricta de paths
# ✅ Timeout para prevenir hanging
# ✅ Logging de errores
# ✅ Manejo robusto de excepciones
```

## 🏗️ **Arquitectura Sugerida**

```
Code Input → [Static Analysis] → [AI Processing] → [Rule Engine] → [Report Generation] → [GitHub Integration] → [Output]
```

### **Flujo Detallado:**
1. **Input**: Recibir código via GitHub webhook o upload directo
2. **Parsing**: Analizar AST (Abstract Syntax Tree) del código
3. **Static Analysis**: Métricas básicas (complejidad, líneas, funciones)
4. **AI Analysis**: GitHub Models analiza patrones y problemas
5. **Rule Engine**: Aplicar reglas específicas por lenguaje
6. **Report**: Generar reporte con recomendaciones priorizadas
7. **Integration**: Crear PR o issue en GitHub con sugerencias

## 🎯 **Criterios de Evaluación Específicos**

### **Funcionamiento (40 pts)**
- [ ] Analiza correctamente diferentes lenguajes de programación
- [ ] Genera recomendaciones relevantes y útiles
- [ ] Integración GitHub funciona para repos públicos
- [ ] Reportes son claros y accionables

### **Integración Técnica (20 pts)**
- [ ] Pipeline de análisis bien estructurado
- [ ] Parsing correcto de diferentes sintaxis
- [ ] GitHub API integrado apropiadamente
- [ ] Manejo robusto de errores de código

### **Calidad (15 pts)**
- [ ] Recomendaciones priorizadas por impacto
- [ ] Detección de múltiples tipos de problemas
- [ ] Sugerencias incluyen código específico
- [ ] Performance optimizada para archivos grandes

## 📚 **Entregables Específicos**

### **Código**
- Sistema de parsing multi-lenguaje
- Engine de análisis estático
- Integración con GitHub API
- Templates de reportes por tipo de problema

### **Documentación**
- Guía de tipos de análisis soportados
- Ejemplos de recomendaciones por categoría
- Configuración de reglas personalizadas
- Métricas de calidad de código definidas

### **Demo**
- Analizar repositorio público de GitHub
- Mostrar diferentes tipos de recomendaciones
- Crear PR automático con mejoras
- Dashboard con métricas de calidad

## 💡 **Tips de Implementación**

### **Primeros Pasos**
1. Comienza con un lenguaje (Python o JavaScript)
2. Implementa análisis básico de complejidad ciclomática
3. Integra IA para detectar code smells simples
4. Expande gradualmente a más lenguajes y reglas

### **Herramientas Sugeridas**
- **Python**: `ast`, `flake8`, `pylint`, `bandit`
- **JavaScript**: `esprima`, `eslint`, `jshint`
- **Java**: `PMD`, `SpotBugs`, `Checkstyle`
- **Multi-language**: `SonarQube API`, `CodeClimate`

### **Categorías de Análisis**
```yaml
security:
  - SQL injection vulnerabilities
  - XSS potential issues
  - Hardcoded credentials
  - Insecure random generators

performance:
  - Algorithm complexity issues
  - Memory leaks potential
  - Inefficient data structures
  - Database query optimization

maintainability:
  - Code duplication
  - Long parameter lists
  - Complex conditional logic
  - Missing documentation

best_practices:
  - Naming conventions
  - Error handling patterns
  - SOLID principles violations
  - Design pattern opportunities
```

## 🔗 **Recursos Útiles**

- **GitHub API**: https://docs.github.com/en/rest
- **AST Parsing**: https://docs.python.org/3/library/ast.html
- **Code Analysis**: https://github.com/PyCQA/pylint
- **Security Analysis**: https://bandit.readthedocs.io/

## 🏆 **Criterios de Excelencia**

Para obtener la máxima puntuación, considera implementar:
- **ML Custom Models**: Entrenar modelo específico para patrones de tu organización
- **Real-time Analysis**: Análisis en tiempo real mientras se escribe código
- **Team Analytics**: Métricas agregadas para equipos de desarrollo
- **Custom Rules Engine**: Reglas configurables por proyecto/organización
- **IDE Integration**: Plugin para VS Code o JetBrains
- **Continuous Learning**: Sistema que aprende de feedback de desarrolladores

## 📊 **Métricas de Calidad Sugeridas**

### **Métricas Básicas**
- **Complejidad Ciclomática**: < 10 por función
- **Líneas por función**: < 50
- **Parámetros por función**: < 5
- **Profundidad de anidación**: < 4

### **Métricas Avanzadas**
- **Technical Debt**: Tiempo estimado para resolver issues
- **Code Coverage**: % de código cubierto por tests
- **Duplication Ratio**: % de código duplicado
- **Maintainability Index**: Índice compuesto de mantenibilidad

### **Reportes Generados**
```markdown
# 📊 Reporte de Análisis de Código

## 🎯 Resumen Ejecutivo
- **Score General**: 7.8/10
- **Issues Críticos**: 2
- **Issues Mayores**: 8
- **Issues Menores**: 23

## 🔥 Issues Críticos
1. **Vulnerabilidad SQL Injection** en `user_service.py:45`
2. **Credenciales hardcodeadas** en `config.py:12`

## 📈 Métricas de Calidad
- Complejidad promedio: 6.2 (🟡 Aceptable)
- Cobertura de tests: 45% (🔴 Bajo)
- Duplicación de código: 12% (🟡 Moderado)

## 💡 Recomendaciones Prioritarias
1. Implementar sanitización en queries SQL
2. Mover credenciales a variables de entorno
3. Aumentar cobertura de tests al 80%
4. Refactorizar función `process_data()` (CC: 15)
```

---

**Nivel de Dificultad**: ⭐⭐⭐⭐ (Avanzado)  
**Tiempo Estimado**: 35-40 horas  
**Ideal para**: Estudiantes con experiencia en desarrollo y interés en calidad de código