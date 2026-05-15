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

### Paso 2: ✅ COMPLETADO
**Crear Issue Messages para Confundir Modelos**

#### Prompt Ganador: `issue_message_1.md` — Sección 1.3
- Modelo que falló: QWEN 3.5 27B
- Prompt copiado a: `task02/issue_message.txt`
- Trace guardado en: `historial/2026-05-15_model_trace_failure.md`
- Análisis en: `prompts_modelos/analysis_prompt1_3_failure.md`

---

## 📋 Issue Messages

| Mensaje | Status | Descripción | Prueba |
|---------|--------|-------------|--------|
| prompt 1.0 | ❌ Arregló bug | Baseline claro con posthog.ts | QWEN 3.5 27B |
| prompt 1.1 | 🧪 Sin probar | Sin nombre de archivo | - |
| prompt 1.2 | 🧪 Sin probar | Solo síntoma frontend | - |
| prompt 1.3 | ✅ GANADOR | Misdirection sorting/fechas | QWEN 3.5 27B |

---

## 🎯 Próximos Pasos

### Paso 3: ⏳ EN PROGRESO
**Validación con validation_script.sh**

1. **Limpiar Docker cache y re-correr:**
   ```bash
   cd /root/skills-Stargazer-Axiom/validation_script
   docker system prune -f
   ./validation_script.sh --local /root/skills-Stargazer-Axiom/task02 --task-id task02
   ```

2. **Si el script pasa:**
   - Tomar el output JSON en `logs/task02/`
   - Subir a la plataforma Outlier

3. **Si el script falla:**
   - Revisar logs en `validation_script/logs/task02/`
   - Corregir lo que falle y re-correr

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
