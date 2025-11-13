# 📊 Ejercicio 4: Clasificador de Contenido o Comentarios

## 🎯 **Objetivo**
Desarrollar un sistema inteligente que analice y clasifique automáticamente contenido o comentarios de usuarios, permitiendo filtrado, moderación y análisis de sentimiento en tiempo real.

## 📝 **Descripción Detallada**
Crear una plataforma automatizada que reciba contenido textual (comentarios de clientes, reviews, posts en redes sociales, mensajes de soporte) y los clasifique en múltiples dimensiones: sentimiento, urgencia, spam/no spam, categorías temáticas, con un dashboard visual para análisis y toma de decisiones.

## 🛠️ **Tecnologías Requeridas**
- **Docker** - Contenedorización del sistema de análisis
- **n8n** - Orquestación del flujo de clasificación
- **GitHub Models** - IA para análisis de texto y clasificación
- **Base de datos** - Almacenamiento de contenido y clasificaciones
- **Dashboard** - Visualización de métricas y resultados

## ⚙️ **Funcionalidades Esperadas**

### **Core (Obligatorias)**
- [ ] **Ingesta de contenido** via API, webhook o formulario web
- [ ] **Clasificación multi-dimensional** (sentimiento, spam, urgencia)
- [ ] **Dashboard básico** con métricas y visualizaciones
- [ ] **API de consulta** para obtener clasificaciones

### **Avanzadas (Opcionales)**
- [ ] **Moderación automática** con acciones configurables
- [ ] **Alertas en tiempo real** para contenido crítico
- [ ] **Análisis de tendencias** y patrones temporales
- [ ] **ML personalizado** con reentrenamiento automático

## 📊 **Casos de Uso Ejemplo**

### **Caso 1: Comentarios de E-commerce**
```json
// Input
{
  "content": "¡Excelente producto! Llegó rapidísimo y la calidad es increíble. Definitivamente volvería a comprar. El empaque también perfecto.",
  "source": "review_producto_123",
  "timestamp": "2024-11-11T10:30:00Z"
}

// Output - Clasificación
{
  "sentiment": {
    "classification": "positivo",
    "confidence": 0.95,
    "score": 4.8
  },
  "urgency": {
    "level": "baja",
    "requires_response": false
  },
  "spam_detection": {
    "is_spam": false,
    "confidence": 0.97
  },
  "categories": [
    "calidad_producto",
    "envio_rapido",
    "empaque"
  ],
  "action_required": "none",
  "priority": 1
}
```

### **Caso 2: Comentario de Soporte Crítico**
```json
// Input
{
  "content": "URGENTE: El sistema está caído desde hace 3 horas y tenemos clientes furiosos. Necesitamos solución YA o perdemos contratos importantes!!!",
  "source": "ticket_soporte",
  "user_id": "cliente_vip_456"
}

// Output - Clasificación
{
  "sentiment": {
    "classification": "negativo",
    "confidence": 0.92,
    "score": 1.2
  },
  "urgency": {
    "level": "crítica",
    "requires_response": true,
    "max_response_time": "15_minutes"
  },
  "spam_detection": {
    "is_spam": false,
    "confidence": 0.99
  },
  "categories": [
    "sistema_caído",
    "cliente_vip",
    "urgencia_comercial"
  ],
  "action_required": "escalate_to_senior",
  "priority": 10,
  "alerts": ["sms_to_manager", "slack_critical_channel"]
}
```

### **Caso 3: Spam Detection**
```json
// Input
{
  "content": "¡¡¡OFERTA INCREÍBLE!!! Gana $5000 diarios desde casa. Haz clic aquí: bit.ly/gana-dinero-facil. Solo por hoy 50% descuento. No te pierdas esta oportunidad única.",
  "source": "contact_form"
}

// Output - Clasificación
{
  "sentiment": {
    "classification": "neutral",
    "confidence": 0.6,
    "score": 3.0
  },
  "urgency": {
    "level": "ninguna",
    "requires_response": false
  },
  "spam_detection": {
    "is_spam": true,
    "confidence": 0.98,
    "spam_indicators": [
      "excessive_punctuation",
      "money_promises",
      "urgency_keywords",
      "suspicious_link",
      "all_caps_usage"
    ]
  },
  "action_required": "block_and_delete",
  "priority": 0
}
```

## 🏗️ **Arquitectura Sugerida**

```
Content Input → [Text Preprocessing] → [AI Classification] → [Rule Engine] → [Action Engine] → [Database Storage] → [Dashboard/Alerts]
```

### **Flujo Detallado:**
1. **Input**: Recibir contenido via API, webhook, formulario
2. **Preprocessing**: Limpiar texto, detectar idioma, normalizar
3. **Classification**: IA analiza y clasifica en múltiples dimensiones
4. **Rule Engine**: Aplicar reglas de negocio específicas
5. **Actions**: Ejecutar acciones automáticas según clasificación
6. **Storage**: Guardar contenido y metadata de clasificación
7. **Visualization**: Dashboard en tiempo real con métricas

## 🎯 **Criterios de Evaluación Específicos**

### **Funcionamiento (40 pts)**
- [ ] Clasifica correctamente diferentes tipos de contenido
- [ ] Dashboard muestra métricas relevantes en tiempo real
- [ ] API responde con clasificaciones precisas
- [ ] Maneja volumen alto de contenido simultáneo

### **Integración Técnica (20 pts)**
- [ ] Pipeline de procesamiento eficiente
- [ ] Base de datos optimizada para consultas
- [ ] IA integrada correctamente para múltiples categorías
- [ ] Dashboard interactivo y responsive

### **Calidad (15 pts)**
- [ ] Precisión alta en clasificaciones (>85%)
- [ ] Manejo robusto de edge cases y contenido ambiguo
- [ ] Performance optimizada para tiempo real
- [ ] Configuración flexible de reglas y umbrales

## 📚 **Entregables Específicos**

### **Código**
- API de clasificación con endpoints RESTful
- Pipeline de procesamiento de texto
- Dashboard web interactivo
- Scripts de entrenamiento y evaluación

### **Documentación**
- Guía de configuración de categorías
- Manual de interpretación de métricas
- Ejemplos de integración API
- Documentación de precisión por categoría

### **Demo**
- Clasificar en vivo diferentes tipos de contenido
- Dashboard con métricas en tiempo real
- Demostrar configuración de reglas y alertas
- Mostrar casos edge y manejo de errores

## 💡 **Tips de Implementación**

### **Primeros Pasos**
1. Comienza con clasificación binaria simple (positivo/negativo)
2. Implementa preprocesamiento básico de texto
3. Agrega categorías graduales
4. Construye dashboard básico con métricas key

### **Técnicas de NLP Sugeridas**
```python
# Preprocesamiento de texto
import re
import nltk
from textblob import TextBlob

def preprocess_text(text):
    # Limpiar y normalizar
    text = re.sub(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', 
                  '[URL]', text)
    text = re.sub(r'\S+@\S+', '[EMAIL]', text)
    text = re.sub(r'[^\w\s]', '', text)
    
    return text.lower().strip()

def extract_features(text):
    # Características para clasificación
    blob = TextBlob(text)
    
    return {
        'word_count': len(text.split()),
        'sentiment_polarity': blob.sentiment.polarity,
        'sentiment_subjectivity': blob.sentiment.subjectivity,
        'exclamation_count': text.count('!'),
        'caps_ratio': sum(1 for c in text if c.isupper()) / len(text),
        'question_count': text.count('?'),
        'has_urls': '[URL]' in text,
        'has_emails': '[EMAIL]' in text
    }
```

### **Dashboard Sugerido**
```yaml
sections:
  overview:
    - total_processed_today
    - sentiment_distribution_pie
    - urgent_items_counter
    - spam_detection_rate
    
  real_time:
    - live_feed_latest_items
    - sentiment_trend_chart
    - volume_by_hour_chart
    - top_categories_bar
    
  analytics:
    - sentiment_over_time
    - urgency_patterns
    - category_distribution
    - user_behavior_insights
    
  alerts:
    - critical_items_list
    - threshold_violations
    - system_health_status
    - recent_actions_log
```

## 🔗 **Recursos Útiles**

- **Text Processing**: https://textblob.readthedocs.io/
- **Sentiment Analysis**: https://huggingface.co/models?pipeline_tag=text-classification
- **Dashboard**: https://dash.plotly.com/ o https://streamlit.io/
- **Real-time Updates**: WebSockets o Server-Sent Events

## 🏆 **Criterios de Excelencia**

Para obtener la máxima puntuación, considera implementar:
- **Multi-idioma**: Clasificación en español, inglés y otros idiomas
- **Active Learning**: Sistema que mejora con feedback manual
- **A/B Testing**: Comparar diferentes modelos de clasificación
- **Advanced Analytics**: Análisis de cohortes y segmentación
- **API Rate Limiting**: Manejo profesional de límites de uso
- **Webhook Integrations**: Conectar con Slack, Teams, email systems

## 📊 **Métricas Clave del Dashboard**

### **Métricas de Volumen**
```javascript
// Métricas en tiempo real
{
  "today_processed": 15847,
  "hourly_rate": 1247,
  "peak_hour": "14:00-15:00",
  "processing_latency_avg": "150ms"
}
```

### **Distribución de Sentimiento**
```javascript
{
  "sentiment_distribution": {
    "positivo": 45.2,
    "neutral": 38.7,
    "negativo": 16.1
  },
  "trend_vs_yesterday": "+2.3% positivo"
}
```

### **Detección de Spam**
```javascript
{
  "spam_rate": 8.3,
  "blocked_automatically": 1247,
  "manual_review_queue": 23,
  "false_positive_rate": 2.1
}
```

### **Alertas y Acciones**
```javascript
{
  "critical_alerts_today": 12,
  "auto_escalations": 5,
  "avg_response_time": "8.5 minutes",
  "sla_compliance": 94.2
}
```

---

**Nivel de Dificultad**: ⭐⭐⭐ (Intermedio)  
**Tiempo Estimado**: 25-30 horas  
**Ideal para**: Estudiantes interesados en NLP, análisis de sentimiento y dashboards