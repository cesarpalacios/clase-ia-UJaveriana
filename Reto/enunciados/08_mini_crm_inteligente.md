# 🏢 Ejercicio 8: Mini CRM Inteligente

## 🎯 **Objetivo**
Desarrollar un sistema CRM inteligente que automatice la gestión de clientes y prospectos, utilizando IA para generar perfiles automáticos, análisis de comportamiento, próximos pasos sugeridos y estrategias de engagement personalizadas.

## 📝 **Descripción Detallada**
Crear una plataforma CRM que reciba información de clientes a través de formularios, webhooks o integraciones, y utilice IA para enriquecer automáticamente los perfiles con insights, segmentación inteligente, predicción de intenciones de compra y recomendaciones de acciones específicas para el equipo de ventas.

## 🛠️ **Tecnologías Requeridas**
- **Docker** - Contenedorización del sistema CRM
- **n8n** - Orquestación de workflows de automatización
- **GitHub Models** - IA para análisis de clientes y generación de insights
- **Base de datos** - Almacenamiento de perfiles y interacciones
- **Dashboard** - Interfaz para visualización y gestión

## ⚙️ **Funcionalidades Esperadas**

### **Core (Obligatorias)**
- [ ] **Registro de clientes** via formulario o webhook
- [ ] **Generación automática** de perfiles enriquecidos con IA
- [ ] **Segmentación inteligente** basada en características y comportamiento
- [ ] **Sugerencias de próximos pasos** personalizadas para cada cliente

### **Avanzadas (Opcionales)**
- [ ] **Predicción de intención** de compra con scoring automático
- [ ] **Automatización de seguimiento** con emails y tareas programadas
- [ ] **Análisis de sentimiento** de interacciones
- [ ] **Dashboard ejecutivo** con métricas de pipeline y conversión

## 📊 **Casos de Uso Ejemplo**

### **Caso 1: Lead de Software B2B**
```json
// Input - Formulario de contacto
{
  "name": "María García",
  "email": "maria.garcia@techcorp.com",
  "company": "TechCorp Solutions",
  "phone": "+57 300 123 4567",
  "message": "Necesitamos una solución para automatizar nuestros procesos de facturación. Somos una empresa de 50 empleados y manejamos 200+ clientes mensuales.",
  "source": "website_contact_form",
  "timestamp": "2024-11-11T10:30:00Z"
}

// Output - Perfil IA Enriquecido
{
  "contact_id": "CRM-2024-1847",
  "basic_info": {
    "name": "María García",
    "email": "maria.garcia@techcorp.com", 
    "company": "TechCorp Solutions",
    "phone": "+57 300 123 4567",
    "created_at": "2024-11-11T10:30:00Z"
  },
  
  "ai_insights": {
    "company_analysis": {
      "industry": "Tecnología/Software",
      "estimated_size": "Mediana (50 empleados)",
      "revenue_estimate": "$2M - $5M anual",
      "growth_stage": "Crecimiento estable",
      "tech_maturity": "Intermedio-Avanzado",
      "decision_timeline": "3-6 meses típico para esta vertical"
    },
    
    "pain_points_detected": [
      "Automatización de procesos manuales",
      "Gestión de volumen creciente de clientes", 
      "Eficiencia operacional",
      "Escalabilidad de sistemas"
    ],
    
    "buying_signals": [
      {
        "signal": "Menciona número específico de clientes (200+)",
        "strength": "Alto",
        "reasoning": "Indica problema real y cuantificado"
      },
      {
        "signal": "Búsqueda activa de solución de automatización",
        "strength": "Alto", 
        "reasoning": "Necesidad específica y urgente"
      },
      {
        "signal": "Empresa en crecimiento (50 empleados)",
        "strength": "Medio",
        "reasoning": "Presupuesto probable para invertir en tecnología"
      }
    ]
  },
  
  "segmentation": {
    "primary_segment": "Mid-Market B2B Tech",
    "secondary_segments": ["Growing Companies", "Automation Seekers"],
    "lead_score": 85,
    "priority": "Alta",
    "fit_score": "A" // Product-market fit
  },
  
  "recommended_actions": [
    {
      "action": "Llamada de calificación inmediata",
      "priority": 1,
      "timeline": "Dentro de 2 horas",
      "reasoning": "Alto lead score + buying signals fuertes",
      "talking_points": [
        "Explorar proceso actual de facturación",
        "Cuantificar tiempo/costo de proceso manual",
        "Entender timeline de implementación",
        "Identificar stakeholders en decisión"
      ]
    },
    {
      "action": "Enviar caso de estudio relevante",
      "priority": 2, 
      "timeline": "Dentro de 4 horas",
      "content_suggestion": "Caso de éxito: Empresa de software de 60 empleados redujo tiempo de facturación en 75%",
      "reasoning": "Profile similar, demostrar ROI tangible"
    },
    {
      "action": "Programar demo personalizada",
      "priority": 3,
      "timeline": "Dentro de 1 semana",
      "demo_focus": ["Automatización de facturación", "Integración con sistemas existentes", "Escalabilidad"],
      "reasoning": "Necesidad específica requiere demostración práctica"
    }
  ],
  
  "engagement_strategy": {
    "persona_type": "Technical Decision Maker",
    "communication_style": "Directo, orientado a datos, enfoque en ROI",
    "content_preferences": ["Case studies", "Technical demos", "Implementation guides"],
    "follow_up_cadence": "Agresiva (cada 3-5 días)",
    "expected_sales_cycle": "3-4 meses"
  }
}
```

### **Caso 2: Lead de E-commerce B2C**
```json
// Input - Lead de campaña digital
{
  "name": "Carlos Mendoza",
  "email": "carlos.mendoza@gmail.com",
  "phone": "+57 310 987 6543",
  "source": "facebook_ads_campaign",
  "utm_campaign": "black_friday_2024",
  "behavior_data": {
    "pages_visited": ["/pricing", "/features", "/testimonials"],
    "time_on_site": "8 minutes 23 seconds",
    "downloads": ["feature_comparison.pdf"],
    "form_fills": 1
  },
  "demographics": {
    "age_range": "35-44",
    "location": "Bogotá, Colombia",
    "interests": ["entrepreneurship", "small_business", "e-commerce"]
  }
}

// Output - Perfil IA Enriquecido
{
  "contact_id": "CRM-2024-1848",
  "ai_insights": {
    "customer_profile": {
      "persona": "Small Business Owner / Entrepreneur",
      "business_stage": "Early-stage o planning",
      "tech_comfort": "Intermediate",
      "budget_sensitivity": "Alto - busca value por money",
      "decision_style": "Research-heavy, compara opciones"
    },
    
    "behavioral_analysis": {
      "engagement_level": "Alto interés",
      "purchase_intent": "Media-Alta (75%)",
      "research_phase": "Evaluación activa de opciones",
      "urgency_level": "Media - timeline Black Friday indica urgencia moderada"
    },
    
    "conversion_probability": {
      "score": 72,
      "factors": [
        "+20 pts: Descargó material comparativo",
        "+15 pts: Tiempo alto en sitio (8+ min)",
        "+10 pts: Visitó pricing (alta intención)",
        "+12 pts: Fuente: Facebook Ads (segmentada)",
        "-5 pts: No ha visitado página de checkout"
      ]
    }
  },
  
  "segmentation": {
    "primary_segment": "SMB Entrepreneurs",
    "lifecycle_stage": "Marketing Qualified Lead",
    "lead_score": 72,
    "campaign_attribution": "facebook_ads_black_friday"
  },
  
  "recommended_actions": [
    {
      "action": "Secuencia de email nurturing automática",
      "priority": 1,
      "timeline": "Inmediato",
      "email_sequence": [
        "Day 0: Welcome + success stories de SMBs",
        "Day 2: Feature deep-dive relevant to e-commerce",
        "Day 5: Limited-time Black Friday offer",
        "Day 8: Social proof + testimonials",
        "Day 12: Last chance offer"
      ]
    },
    {
      "action": "Retargeting personalizado",
      "priority": 2,
      "timeline": "Dentro de 1 hora",
      "ad_content": "Dynamic ads mostrando features que visitó",
      "budget_allocation": "$15/day x 7 días"
    },
    {
      "action": "Llamada de follow-up suave",
      "priority": 3,
      "timeline": "Día 7 si no responde a emails",
      "approach": "Consultiva, no agresiva",
      "script": "Ayudar a resolver dudas específicas sobre implementación"
    }
  ],
  
  "personalization": {
    "messaging_tone": "Amigable, educativo, no presionante",
    "content_focus": ["Ease of use", "Quick setup", "Cost-effectiveness"],
    "offer_strategy": "Discount-driven con urgency limitada",
    "success_metrics_to_highlight": ["Time to value", "ROI en primeros 3 meses"]
  }
}
```

### **Caso 3: Cliente Existente - Upsell Opportunity**
```json
// Input - Cliente existente con comportamiento de interés
{
  "customer_id": "CUST-2023-0456", 
  "name": "Ana Rodríguez",
  "company": "Verde Consulting",
  "current_plan": "Professional ($99/mes)",
  "account_age": "14 meses",
  "recent_activity": {
    "feature_usage_spike": "Analytics dashboard +340% last month",
    "support_tickets": [
      "¿Cómo exportar reportes avanzados?",
      "Límites en número de usuarios en plan actual"
    ],
    "login_frequency": "Daily (increased from 3x/week)",
    "new_team_members": 3
  }
}

// Output - Perfil IA Enriquecido
{
  "customer_analysis": {
    "health_score": 85, // Customer muy engaged
    "growth_indicators": [
      "Equipo creció de 5 a 8 personas",
      "Uso de analytics aumentó 340%",
      "Login diario vs 3x/semana anterior", 
      "Preguntando por features avanzadas"
    ],
    
    "upsell_readiness": {
      "score": 92,
      "signals": [
        "Hitting plan limits (usuarios)",
        "Actively using advanced features",
        "Asking about premium capabilities",
        "Strong product adoption"
      ]
    }
  },
  
  "opportunity_analysis": {
    "recommended_plan": "Enterprise ($299/mes)",
    "upgrade_value": "$200/mes additional revenue",
    "probability": "88%",
    "optimal_timing": "Próximos 15 días",
    "risk_factors": ["Price sensitivity unknown", "Decision maker unclear"]
  },
  
  "recommended_actions": [
    {
      "action": "Llamada de Customer Success proactiva",
      "priority": 1,
      "timeline": "Dentro de 24 horas",
      "objective": "Congratular uso + explorar necesidades crecientes",
      "talking_points": [
        "Reconocer crecimiento del equipo",
        "Celebrar aumento en uso de analytics",
        "Explorar pain points con límites actuales",
        "Introducir benefits de Enterprise plan"
      ]
    },
    {
      "action": "Demo personalizada de features Enterprise",
      "priority": 2,
      "timeline": "Semana actual",
      "focus_areas": ["Advanced reporting", "Unlimited users", "Priority support"],
      "value_prop": "Show ROI de advanced analytics para team más grande"
    },
    {
      "action": "Oferta limitada de upgrade",
      "priority": 3,
      "timeline": "Post-demo",
      "offer": "First 3 months a 50% off en upgrade",
      "reasoning": "Reward loyalty + remove price objection"
    }
  ],
  
  "retention_strategy": {
    "current_satisfaction": "Alta (based on usage patterns)",
    "expansion_potential": "$2,400 ARR adicional",
    "churn_risk": "Bajo (2%)",
    "next_review": "90 días post-upgrade"
  }
}
```

## 🏗️ **Arquitectura Sugerida**

```
Lead Input → [Data Enrichment] → [AI Analysis] → [Scoring Engine] → [Segmentation] → [Action Engine] → [CRM Database] → [Dashboard]
```

### **Flujo Detallado:**
1. **Lead Capture**: Formularios, webhooks, integraciones capturan datos básicos
2. **Data Enrichment**: Enriquecer con datos públicos, sociales, de empresa
3. **AI Analysis**: IA analiza perfil y comportamiento para generar insights
4. **Lead Scoring**: Algoritmo calcula probabilidad de conversión
5. **Segmentation**: Clasificar en segmentos para personalización
6. **Action Generation**: IA sugiere próximos pasos específicos
7. **Automation**: Ejecutar acciones automáticas configuradas
8. **Tracking**: Monitorear resultados y ajustar estrategias

## 🎯 **Criterios de Evaluación Específicos**

### **Funcionamiento (40 pts)**
- [ ] Registro de leads funciona correctamente
- [ ] IA genera insights relevantes y útiles
- [ ] Segmentación es lógica y accionable
- [ ] Recomendaciones de acciones son específicas y prácticas

### **Integración Técnica (20 pts)**
- [ ] Base de datos diseñada apropiadamente para CRM
- [ ] Pipeline de enriquecimiento de datos eficiente
- [ ] IA integrada efectivamente para análisis
- [ ] Dashboard funcional con métricas relevantes

### **Calidad (15 pts)**
- [ ] Perfiles generados son completos y precisos
- [ ] Scoring refleja probabilidad real de conversión
- [ ] Acciones sugeridas aumentan tasa de conversión
- [ ] Interfaz usable para equipo de ventas

## 📚 **Entregables Específicos**

### **Código**
- Sistema de registro y gestión de leads
- Engine de enriquecimiento con IA
- Algoritmo de scoring y segmentación
- Dashboard CRM con métricas y acciones

### **Documentación**
- Guía de configuración de lead sources
- Manual de interpretación de scoring
- Playbook de acciones recomendadas
- Métricas de success y KPIs

### **Demo**
- Registrar diferentes tipos de leads en vivo
- Mostrar generación automática de perfiles
- Demostrar scoring y segmentación
- Dashboard con pipeline y métricas

## 💡 **Tips de Implementación**

### **Primeros Pasos**
1. Diseña schema de base de datos para leads/customers
2. Crea formulario básico de captura de leads
3. Implementa enriquecimiento simple con IA
4. Agrega scoring básico y acciones sugeridas

### **Schema de Base de Datos Sugerido**
```sql
-- Tabla de contactos
CREATE TABLE contacts (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    company VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Tabla de companies
CREATE TABLE companies (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    industry VARCHAR(100),
    size_estimate VARCHAR(50),
    revenue_estimate VARCHAR(100),
    website VARCHAR(255)
);

-- Tabla de interactions
CREATE TABLE interactions (
    id UUID PRIMARY KEY,
    contact_id UUID REFERENCES contacts(id),
    type VARCHAR(50), -- email, call, meeting, form_fill
    content TEXT,
    timestamp TIMESTAMP,
    source VARCHAR(100)
);

-- Tabla de ai_insights
CREATE TABLE ai_insights (
    id UUID PRIMARY KEY,
    contact_id UUID REFERENCES contacts(id),
    lead_score INTEGER,
    segment VARCHAR(100),
    buying_signals JSONB,
    recommended_actions JSONB,
    generated_at TIMESTAMP
);
```

### **Lead Scoring Algorithm**
```python
def calculate_lead_score(contact_data):
    score = 0
    
    # Demographic scoring
    if contact_data.get('company_size') == 'enterprise':
        score += 30
    elif contact_data.get('company_size') == 'mid-market':
        score += 20
    elif contact_data.get('company_size') == 'smb':
        score += 10
    
    # Behavioral scoring
    if contact_data.get('visited_pricing'):
        score += 25
    
    if contact_data.get('downloaded_content'):
        score += 15
    
    if contact_data.get('time_on_site', 0) > 300:  # 5+ minutes
        score += 10
    
    # Intent scoring
    intent_keywords = ['buy', 'purchase', 'pricing', 'demo', 'trial']
    message = contact_data.get('message', '').lower()
    for keyword in intent_keywords:
        if keyword in message:
            score += 15
            break
    
    # Source quality scoring
    source = contact_data.get('source', '')
    if source == 'referral':
        score += 20
    elif source == 'organic_search':
        score += 15
    elif source == 'paid_ads':
        score += 10
    
    return min(score, 100)  # Cap at 100

def generate_recommendations(lead_score, contact_data):
    recommendations = []
    
    if lead_score >= 80:
        recommendations.append({
            'action': 'immediate_call',
            'priority': 1,
            'timeline': '< 2 hours'
        })
    elif lead_score >= 60:
        recommendations.append({
            'action': 'personal_email',
            'priority': 1,
            'timeline': '< 24 hours'
        })
    else:
        recommendations.append({
            'action': 'nurturing_sequence',
            'priority': 2,
            'timeline': 'automated'
        })
    
    return recommendations
```

## 🔗 **Recursos Útiles**

- **CRM Database Design**: https://blog.hubspot.com/service/what-is-crm-database
- **Lead Scoring Best Practices**: https://blog.marketo.com/2016/04/lead-scoring-best-practices.html
- **Customer Segmentation**: https://blog.hubspot.com/service/what-is-customer-segmentation
- **Dashboard Design**: https://plotly.com/dash/

## 🏆 **Criterios de Excelencia**

Para obtener la máxima puntuación, considera implementar:
- **Predictive Analytics**: Modelos de lifetime value y churn prediction
- **Email Automation**: Secuencias automáticas de nurturing personalizadas  
- **Integration Ecosystem**: Conectar con herramientas de marketing (Mailchimp, HubSpot)
- **Advanced Segmentation**: Segmentación dinámica basada en comportamiento
- **Sales Analytics**: Métricas avanzadas de pipeline y forecasting
- **Mobile App**: App móvil para equipo de ventas en campo

## 📊 **Métricas Clave del Dashboard**

### **Pipeline Metrics**
```javascript
{
  "total_leads": 1247,
  "qualified_leads": 341,
  "conversion_rate": 27.3,
  "avg_lead_score": 64,
  "pipeline_value": "$450,000"
}
```

### **Segmentation Breakdown**
```javascript
{
  "enterprise": {"count": 89, "avg_deal_size": "$15,000"},
  "mid_market": {"count": 156, "avg_deal_size": "$5,000"}, 
  "smb": {"count": 203, "avg_deal_size": "$1,200"}
}
```

### **Performance Tracking**
```javascript
{
  "lead_sources": {
    "website": 45.2,
    "referrals": 23.1,
    "paid_ads": 18.7,
    "events": 13.0
  },
  "conversion_by_source": {
    "referrals": 45.3,
    "website": 28.1,
    "events": 21.7,
    "paid_ads": 15.2
  }
}
```

---

**Nivel de Dificultad**: ⭐⭐⭐ (Intermedio)  
**Tiempo Estimado**: 25-30 horas  
**Ideal para**: Estudiantes interesados en sales automation, customer analytics y business intelligence