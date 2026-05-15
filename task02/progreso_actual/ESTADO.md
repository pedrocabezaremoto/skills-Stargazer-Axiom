# Estado Actual - Task02: Breaking AI Models

**Fecha Última Actualización:** 2026-05-15

---

## 📊 Etapa Actual

### Paso 1: ✅ COMPLETADO
**Identificar el Bug**
- Archivo: `src/server/api/routers/posthog.ts`
- Líneas: 107-113
- Problema: Falta `else` para manejar device types inesperados
- Status: Identificado y documentado

### Paso 2: 🔄 EN PROGRESO
**Crear Issue Messages para Confundir Modelos**

#### Versión Actual: `issue_message_1.md`
- Status: Generado y listo para testing
- Descripción: Baseline profesional - describe síntoma sin ser específico
- Siguiente: Esperar resultado del testing con modelos
- Plan: Si modelo lo arregla → crear `issue_message_2` (más vago)

---

## 📋 Issue Messages

| Mensaje | Status | Descripción | Prueba |
|---------|--------|-------------|--------|
| issue_message_1 | ✅ Listo | Baseline claro | Pendiente |
| issue_message_2 | ⏳ Próximo | Más vago | - |
| issue_message_3 | ⏳ Próximo | Síntomas solo | - |
| issue_message_4+ | ⏳ Futuro | Misdirection | - |

---

## 🎯 Próximos Pasos

1. **Testing mensaje_1 en Cursor**
   - Modelo: Sonnet 4.6 y QWEN 3.5 27B
   - Acción: Pegar en chat y observar si arregla o falla
   - Meta: Encontrar cuál modelo falla

2. **Si modelo lo arregla:**
   - Crear `issue_message_2.md` (más vago)
   - Volver a probar

3. **Cuando un modelo falle:**
   - Exportar chat/trace
   - Documentar en `historial/`
   - Completar Paso 2 ✅

---

## 📁 Estructura

```
task02/
├── prompts_modelos/
│   ├── README.md (estrategias)
│   ├── issue_message_1.md ✅
│   ├── issue_message_2.md (próximo)
│   └── ...
├── progreso_actual/
│   └── ESTADO.md (este archivo)
├── historial/
│   └── testing_results.md
└── App/
    └── app/ (código con bug)
```

---

## 🔔 Notas

- Los prompts están en bilingual format (English + Spanish)
- El objetivo es encontrar qué nivel de vaguedad rompe a los modelos
- No sobrescribir, solo agregar información nueva
