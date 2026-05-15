# Progreso Actual — Tarea en Curso

> Este archivo refleja el estado EN TIEMPO REAL de la tarea que Pedro está trabajando.
> El agente DEBE actualizar este archivo cada vez que un paso cambie de estado.
> Cuando una tarea termine, mover el resumen a `Historial/historial.md` y resetear este archivo.

---

## ✅ ESTADO: TASK02 INICIADA

**TASK02 ASIGNADA EL 2026-05-15. Entorno listo para comenzar.**

**INSTRUCCIÓN CRÍTICA:** Task01 está cancelada — ignorar completamente. Toda la energía en task02.

---

## Tarea Activa (TASK02)

| Campo | Valor |
|-------|-------|
| Repo asignado | ✅ Repo ID 636561929 — TextBehind SaaS |
| Tipo de problema | ✅ Bug injection + resolution |
| Stack tecnológico | ✅ Next.js 15 / React 19 / TypeScript |
| Framework de tests | 🔄 **POR IDENTIFICAR** (npm scripts disponibles) |
| Aplicación | AI image editor — coloca texto detrás de objetos |
| Base de datos | PostgreSQL + Drizzle ORM |
| Auth | Better Auth |
| Fecha de inicio | 2026-05-15 |

---

## Checklist de la Tarea

### Paso 1 — Setup y análisis del repo
- [x] Repo clonado en `task02/App/` ← Ya existe
- [x] Stack identificado: Next.js 15 / React 19 / TypeScript / Tailwind
- [ ] Framework de testing identificado (buscar en scripts o package.json)
- [ ] Comando de tests encontrado
- [ ] Archivos de configuración relevantes identificados (tsconfig, next.config)
- [ ] **PENDIENTE:** Identificar DÓNDE está el bug a inyectar
  - ¿Autenticación? ¿Procesamiento de imágenes? ¿Database? ¿API?

### Paso 2 — Creación del issue
- [ ] Bug específico identificado y documentado
- [ ] Issue message v1 redactado
- [ ] Problema entendible pero NO da la solución
- [ ] Probado con `claude-sonnet-4-6-scale` (modelo 1)
- [ ] Probado con `claude-qwen3-5-27b-scale` (modelo 2)
- [ ] Al menos 1 modelo FALLA (requisito mínimo)
- [ ] Model trace exportado y guardado

### Paso 3 — Gold patch (solución correcta)
- [ ] Solución correcta implementada en código
- [ ] `gold_patch.patch` generado
- [ ] Verificado: aplicar el patch funciona

### Paso 4 — Tests (F2P y P2P)
- [ ] Tests F2P escritos (deben fallar sin el fix)
- [ ] Tests P2P escritos (deben pasar siempre)
- [ ] `test_patch.patch` generado

### Paso 5 — Dockerfiles
- [ ] `base.Dockerfile` creado
- [ ] `instance.Dockerfile` creado
- [ ] Builds exitosos

### Paso 6 — Scripts
- [ ] `run_script.sh` creado
- [ ] `parse_results.sh` creado
- [ ] Manual execution exitosa

### Paso 7 — Validación
- [ ] `validation_script.sh` corrido
- [ ] Todas las secciones PASS

### Paso 8 — Entrega
- [ ] Rubric.json generado
- [ ] Tarea entregada en Outlier

---

## Bloqueos y Problemas Actuales

> Documentar aquí cualquier error o blocker que aparezca durante el trabajo.

_Ninguno por ahora._

---

## Estado del Entorno Local

| Componente | Estado |
|-----------|--------|
| Cursor | ✅ Instalado y configurado con API key de Outlier |
| Docker | ✅ Instalado en este VPS y funcionando |
| Modelos en Cursor | ✅ `gpt-oss-120b-bedrock` y `qwen3-235b-a22b-instruct-2507-scale` activos |
| Override Base URL | ✅ `https://cursor-intelligence-api.outlier.ai/api/v1` configurado |

---

## Conocimiento de Rúbricas Actualizado

**2026-05-14:** Se estudió material del curso sobre mejores prácticas de rúbricas:
- Se agregó sección "Ejemplos reales de rúbricas buenas vs malas" en `references/rubric-guide.md`
- Lección clave: criterios con múltiples condiciones (Ejemplo 2 y 3 del curso) deben dividirse en criterios atómicos separados
- Regla de oro agregada: si el criterio contiene "y/o" uniendo dos comportamientos → dividirlo

---

## Notas del Agente

> Espacio para que el agente deje notas sobre decisiones tomadas o contexto importante.

**2026-05-13:** Las referencias del proyecto fueron auditadas contra las guías oficiales de Outlier.
Se corrigieron dos bugs críticos en los archivos de referencia:
- `references/04_docker_scripts.md` — JSON keys estaban en español, ahora en inglés
- `references/05_to_08_remaining_steps.md` — `criteria_category` estaba en español, ahora en inglés

Los archivos de referencia están ahora alineados con la guía oficial.
Siguiente paso: esperar URL del repo asignado para comenzar Paso 1.
