# 🔐 Ejercicio 7: Detector de Riesgos o Anomalías en Logs

## 🎯 **Objetivo**
Desarrollar un sistema inteligente que monitoree logs del sistema en tiempo real, utilizando IA para identificar automáticamente patrones anómalos, posibles errores críticos y comportamientos de riesgo, generando alertas proactivas para equipos de operations.

## 📝 **Descripción Detallada**
Crear una plataforma de análisis de logs que procese grandes volúmenes de datos de aplicaciones, servidores y servicios, aplique técnicas de IA para detectar anomalías, clasifique niveles de riesgo y genere reportes automáticos con recomendaciones de acción para equipos técnicos.

## 🛠️ **Tecnologías Requeridas**
- **Docker** - Contenedorización del sistema de monitoreo
- **n8n** - Orquestación del pipeline de análisis de logs
- **GitHub Models** - IA para detección de patrones y anomalías
- **Almacenamiento** - Base de datos para logs históricos y alertas
- **Alertas** - Sistema de notificaciones en tiempo real

## ⚙️ **Funcionalidades Esperadas**

### **Core (Obligatorias)**
- [ ] **Ingesta de logs** en múltiples formatos (syslog, JSON, plain text)
- [ ] **Detección de anomalías** usando patrones históricos e IA
- [ ] **Clasificación de riesgos** (Crítico, Alto, Medio, Bajo)
- [ ] **Sistema de alertas** automáticas para incidentes críticos

### **Avanzadas (Opcionales)**
- [ ] **Análisis de correlación** entre múltiples fuentes de logs
- [ ] **Predicción de fallos** basada en patrones tempranos
- [ ] **Dashboard en tiempo real** con métricas y visualizaciones
- [ ] **Integración con herramientas** de monitoring (PagerDuty, Slack)

## 📊 **Casos de Uso Ejemplo**

### **Caso 1: Detección de Intrusión de Seguridad**
```bash
# Logs de entrada (Web Server)
2024-11-11 14:23:45 [INFO] 192.168.1.100 GET /login - 200 - 0.234s
2024-11-11 14:23:47 [WARN] 192.168.1.100 POST /login - 401 - 0.156s
2024-11-11 14:23:48 [WARN] 192.168.1.100 POST /login - 401 - 0.134s
2024-11-11 14:23:49 [WARN] 192.168.1.100 POST /login - 401 - 0.145s
2024-11-11 14:23:50 [WARN] 192.168.1.100 POST /login - 401 - 0.167s
2024-11-11 14:23:51 [WARN] 192.168.1.100 POST /login - 401 - 0.143s
2024-11-11 14:23:52 [ERROR] 192.168.1.100 - Account locked due to multiple failed attempts
```

```json
// Análisis IA - Output
{
  "alert_id": "SEC-2024-001",
  "timestamp": "2024-11-11T14:23:52Z",
  "risk_level": "CRÍTICO",
  "category": "Seguridad",
  "anomaly_type": "Brute Force Attack",
  
  "analysis": {
    "pattern_detected": "Multiple failed login attempts from single IP",
    "frequency": "5 attempts in 7 seconds",
    "affected_resource": "/login endpoint",
    "source_ip": "192.168.1.100",
    "confidence": 0.96
  },
  
  "context": {
    "baseline_failed_logins": "0.2 per hour",
    "current_rate": "42.8 per hour",
    "anomaly_score": 9.2,
    "historical_pattern": "Never seen this pattern from this IP"
  },
  
  "recommendations": [
    "Immediately block IP 192.168.1.100",
    "Review all login attempts from this IP in last 24h",
    "Check if legitimate user account is affected",
    "Consider implementing CAPTCHA after 3 failed attempts"
  ],
  
  "automated_actions": [
    "IP temporarily blocked for 1 hour",
    "Security team notified via Slack",
    "Incident ticket created: SEC-2024-001"
  ]
}
```

### **Caso 2: Detección de Degradación de Performance**
```bash
# Logs de aplicación
2024-11-11 15:45:12 [INFO] Database query executed - query_time: 0.023s
2024-11-11 15:45:15 [INFO] Database query executed - query_time: 0.034s
2024-11-11 15:45:18 [INFO] Database query executed - query_time: 0.156s
2024-11-11 15:45:21 [WARN] Database query executed - query_time: 0.487s
2024-11-11 15:45:24 [WARN] Database query executed - query_time: 0.923s
2024-11-11 15:45:27 [ERROR] Database query timeout - query_time: 30.000s
2024-11-11 15:45:30 [ERROR] Connection pool exhausted - active: 100, max: 100
```

```json
// Análisis IA - Output
{
  "alert_id": "PERF-2024-018",
  "timestamp": "2024-11-11T15:45:30Z",
  "risk_level": "ALTO",
  "category": "Performance",
  "anomaly_type": "Database Performance Degradation",
  
  "analysis": {
    "metric": "Database query response time",
    "baseline_avg": "0.045s",
    "current_avg": "5.237s",
    "degradation_factor": "116x slower",
    "trend": "Exponentially increasing over 18 minutes"
  },
  
  "indicators": [
    "Query times increased from 23ms to 30s",
    "Connection pool reached maximum capacity",
    "Timeout errors starting to occur",
    "Pattern suggests resource contention"
  ],
  
  "impact_assessment": {
    "affected_users": "~500 concurrent users",
    "business_impact": "Critical - API responses failing",
    "estimated_revenue_impact": "$2,400/hour if continues",
    "sla_breach_risk": "HIGH - 99.9% SLA at risk"
  },
  
  "root_cause_analysis": [
    "Possible slow query introduced in recent deployment",
    "Database server resource constraints",
    "Connection leak from application",
    "Increased traffic beyond capacity"
  ],
  
  "immediate_actions": [
    "Scale database read replicas",
    "Kill long-running queries",
    "Restart connection pools",
    "Alert on-call engineer"
  ]
}
```

### **Caso 3: Detección de Fallo Inminente**
```bash
# Logs de sistema (múltiples servicios)
2024-11-11 16:30:12 [WARN] disk_usage - /var/log: 78% full
2024-11-11 16:32:15 [WARN] memory_usage - Available: 1.2GB, Used: 14.8GB/16GB
2024-11-11 16:35:18 [ERROR] service_api - Response time: 2.34s (SLA: <1s)
2024-11-11 16:37:21 [CRITICAL] disk_usage - /var/log: 89% full
2024-11-11 16:38:45 [ERROR] memory_usage - Available: 0.8GB - Critical threshold
2024-11-11 16:40:12 [CRITICAL] service_unavailable - Connection refused
```

```json
// Análisis IA - Output
{
  "alert_id": "SYS-2024-042",
  "timestamp": "2024-11-11T16:40:12Z",
  "risk_level": "CRÍTICO",
  "category": "System Failure",
  "anomaly_type": "Cascading System Failure",
  
  "failure_prediction": {
    "probability_of_complete_outage": 0.87,
    "estimated_time_to_failure": "8-15 minutes",
    "confidence": 0.93,
    "prediction_model": "Resource exhaustion cascade pattern"
  },
  
  "contributing_factors": [
    {
      "factor": "Disk space exhaustion",
      "current": "89% full",
      "critical_threshold": "95%",
      "time_to_critical": "~5 minutes"
    },
    {
      "factor": "Memory pressure",
      "current": "95% utilized",
      "impact": "Application swapping to disk",
      "consequence": "Performance degradation"
    },
    {
      "factor": "Service degradation",
      "current": "Response times 2.3x SLA",
      "trend": "Worsening rapidly",
      "user_impact": "High error rates"
    }
  ],
  
  "cascade_analysis": {
    "sequence": "High disk usage → Memory pressure → Service slowdown → Connection backlog → Complete failure",
    "historical_precedent": "Similar pattern on 2024-09-15 led to 4h outage",
    "intervention_window": "Critical - action needed within 10 minutes"
  },
  
  "emergency_response": [
    "IMMEDIATE: Scale additional server instances",
    "IMMEDIATE: Clean up log files and temporary data", 
    "IMMEDIATE: Restart services to clear memory leaks",
    "IMMEDIATE: Activate disaster recovery procedures"
  ],
  
  "escalation": {
    "level": "L1 - Critical Incident",
    "notifications": ["CTO", "On-call engineer", "DevOps team"],
    "war_room": "Activated - Incident #2024-042"
  }
}
```

## 🏗️ **Arquitectura Sugerida**

```
Log Sources → [Ingestion] → [Parsing] → [AI Analysis] → [Risk Classification] → [Alert Engine] → [Dashboard/Notifications]
```

### **Flujo Detallado:**
1. **Ingestion**: Recopilar logs de múltiples fuentes (aplicaciones, servidores, servicios)
2. **Parsing**: Normalizar diferentes formatos de logs
3. **Baseline Learning**: Establecer patrones normales de comportamiento
4. **Real-time Analysis**: IA analiza logs entrantes contra baselines
5. **Anomaly Detection**: Identificar desviaciones significativas
6. **Risk Scoring**: Clasificar nivel de riesgo y urgencia
7. **Alert Generation**: Generar alertas contextualizadas con recomendaciones
8. **Action Automation**: Ejecutar respuestas automáticas configuradas

## 🎯 **Criterios de Evaluación Específicos**

### **Funcionamiento (40 pts)**
- [ ] Procesa logs en tiempo real sin perder eventos
- [ ] Detecta anomalías relevantes con baja tasa de falsos positivos
- [ ] Clasifica correctamente niveles de riesgo
- [ ] Genera alertas útiles y accionables

### **Integración Técnica (20 pts)**
- [ ] Ingesta robusta de múltiples formatos de logs
- [ ] Pipeline de procesamiento eficiente y escalable
- [ ] IA integrada efectivamente para detección de patrones
- [ ] Sistema de alertas configurable y confiable

### **Calidad (15 pts)**
- [ ] Precisión alta en detección (>85% accuracy)
- [ ] Baja latencia en detección (<30 segundos)
- [ ] Manejo robusto de volúmenes altos de datos
- [ ] Configuración flexible de reglas y umbrales

## 📚 **Entregables Específicos**

### **Código**
- Sistema de ingesta multi-formato de logs
- Engine de detección de anomalías con IA
- Clasificador de riesgos configurable
- Dashboard en tiempo real con visualizaciones

### **Documentación**
- Guía de configuración de fuentes de logs
- Manual de interpretación de alertas
- Playbook de respuesta a incidentes
- Métricas de performance y accuracy

### **Demo**
- Simular logs con anomalías en vivo
- Mostrar detección en tiempo real
- Demostrar diferentes tipos de alertas
- Dashboard con métricas históricas y en vivo

## 💡 **Tips de Implementación**

### **Primeros Pasos**
1. Comienza con logs simulados o de prueba
2. Implementa parser básico para formato común
3. Crea reglas simples de detección
4. Agrega IA gradualmente para patrones complejos

### **Generación de Logs de Prueba**
```python
import json
import random
import datetime
from time import sleep

def generate_normal_logs():
    """Generar logs normales para establecer baseline"""
    while True:
        log_entry = {
            "timestamp": datetime.datetime.now().isoformat(),
            "level": random.choice(["INFO"] * 8 + ["WARN"] * 2),
            "service": random.choice(["web-api", "user-service", "payment-service"]),
            "response_time": round(random.normalvariate(0.150, 0.050), 3),
            "status_code": random.choice([200] * 9 + [404, 500]),
            "ip_address": f"192.168.1.{random.randint(1, 254)}",
            "user_id": f"user_{random.randint(1000, 9999)}"
        }
        print(json.dumps(log_entry))
        sleep(random.uniform(0.1, 2.0))

def generate_anomaly_logs():
    """Generar logs anómalos para testing"""
    # Simular ataque de fuerza bruta
    attacker_ip = "192.168.1.100"
    for i in range(10):
        log_entry = {
            "timestamp": datetime.datetime.now().isoformat(),
            "level": "WARN",
            "service": "web-api",
            "message": "Failed login attempt",
            "ip_address": attacker_ip,
            "endpoint": "/login",
            "status_code": 401
        }
        print(json.dumps(log_entry))
        sleep(0.2)
```

### **Algoritmo de Detección de Anomalías**
```python
class AnomalyDetector:
    def __init__(self):
        self.baselines = {}
        self.thresholds = {
            'response_time': {'warning': 2.0, 'critical': 5.0},
            'error_rate': {'warning': 0.05, 'critical': 0.15},
            'failed_logins': {'warning': 5, 'critical': 10}
        }
    
    def update_baseline(self, metric, value):
        if metric not in self.baselines:
            self.baselines[metric] = []
        
        self.baselines[metric].append(value)
        # Mantener ventana deslizante de 1000 valores
        self.baselines[metric] = self.baselines[metric][-1000:]
    
    def detect_anomaly(self, log_entry):
        anomalies = []
        
        # Detectar picos en tiempo de respuesta
        if 'response_time' in log_entry:
            rt = log_entry['response_time']
            baseline_avg = np.mean(self.baselines.get('response_time', [rt]))
            
            if rt > baseline_avg * 10:  # 10x más lento que promedio
                anomalies.append({
                    'type': 'response_time_spike',
                    'severity': 'critical' if rt > baseline_avg * 50 else 'warning',
                    'value': rt,
                    'baseline': baseline_avg,
                    'factor': rt / baseline_avg
                })
        
        # Detectar patrones de seguridad
        if self.detect_brute_force(log_entry):
            anomalies.append({
                'type': 'security_brute_force',
                'severity': 'critical',
                'details': 'Multiple failed login attempts detected'
            })
        
        return anomalies
    
    def detect_brute_force(self, log_entry):
        # Implementar lógica de detección de fuerza bruta
        # Verificar múltiples fallos desde misma IP en ventana de tiempo
        pass
```

## 🔗 **Recursos Útiles**

- **Log Parsing**: https://docs.python.org/3/library/re.html
- **Time Series Analysis**: https://pandas.pydata.org/
- **Anomaly Detection**: https://scikit-learn.org/stable/modules/outlier_detection.html
- **Real-time Dashboards**: https://plotly.com/dash/

## 🏆 **Criterios de Excelencia**

Para obtener la máxima puntuación, considera implementar:
- **Machine Learning Advanced**: Modelos no supervisados (Isolation Forest, LSTM autoencoders)
- **Multi-source Correlation**: Correlacionar eventos entre diferentes servicios
- **Predictive Analytics**: Predecir fallos antes de que ocurran
- **Auto-remediation**: Acciones automáticas de corrección
- **Integration Ecosystem**: Conectar con herramientas existentes (ELK, Prometheus, Grafana)
- **Compliance Reporting**: Reportes automáticos para auditorías

## 📊 **Tipos de Anomalías a Detectar**

### **Seguridad**
- Intentos de acceso no autorizados
- Patrones de ataques (DDoS, SQL injection)
- Accesos desde ubicaciones inusuales
- Escalación de privilegios

### **Performance**
- Degradación de tiempos de respuesta
- Aumentos en tasas de error
- Problemas de conectividad
- Cuellos de botella de recursos

### **Sistema**
- Fallos de servicios
- Agotamiento de recursos (CPU, memoria, disco)
- Problemas de red
- Errores de configuración

### **Business Logic**
- Patrones de uso anómalos
- Transacciones fraudulentas
- Comportamiento atípico de usuarios
- Violaciones de reglas de negocio

---

**Nivel de Dificultad**: ⭐⭐⭐⭐ (Avanzado)  
**Tiempo Estimado**: 35-40 horas  
**Ideal para**: Estudiantes interesados en seguridad, monitoring y análisis de datos en tiempo real