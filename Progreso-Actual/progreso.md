# Progreso Actual — Tarea en Curso

> Este archivo refleja el estado EN TIEMPO REAL de la tarea que Pedro está trabajando.
> El agente DEBE actualizar este archivo cada vez que un paso cambie de estado.
> Cuando una tarea termine, mover el resumen a `Historial/historial.md` y resetear este archivo.

---

## ⚠️ ESTADO: TASK01 CANCELADA

**LA TAREA TASK01 HA SIDO ANULADA Y CANCELADA EL 2026-05-15.**

**INSTRUCCIÓN CRÍTICA:** No leer, no continuar, no modificar task01. Derivar todas las consultas sobre task01 a `Historial/historial.md` → entrada `[2026-05-15] — TASK01 CANCELADA`.

Agentes futuros: **enfocarse completamente en TASK02 en adelante.**

---

## Tarea Activa (CANCELADA)

| Campo | Valor |
|-------|-------|
| Repo asignado | ✅ Repo ID 635272517 — Nuton Learning App |
| Tipo de problema | ✅ Performance Optimization |
| Stack tecnológico | ✅ Angular 19 / TypeScript |
| Framework de tests | ✅ Karma + Jasmine (`npm test`) |
| Archivo objetivo | ✅ `nuton/src/app/services/cart.service.ts` |
| Problema identificado | ✅ CartService — subtotal acumulativo (floating-point drift) |
| Fecha de inicio | 2026-05-14 |

---

## Checklist de la Tarea

### Paso 1 — Setup y análisis del repo
- [x] Repo clonado en directorio de trabajo (`task01/`)
- [x] Stack tecnológico identificado (Angular 19 / TypeScript)
- [x] Framework de testing identificado (Karma + Jasmine)
- [x] Comando de tests identificado (`npm test`)
- [x] Archivos de configuración relevantes identificados
- [x] Tipo de problema definido (Performance Optimization — CartService)

### Paso 2 — Creación del issue
- [x] Issue message v1 redactado (CartService subtotal acumulativo)
- [x] Issue v1 probado con `claude-qwen3-5-27b-scale` → **RESOLVIÓ** (fallo nuestro)
- [x] Issue v2 probado con `claude-qwen3-5-27b-scale` → **RESOLVIÓ** (fallo nuestro)
- [x] Issue v3 redactado — estrategia misdirection (apunta a state mutation, no aritmética)
- [ ] Issue v3 pegado en Cursor con `claude-qwen3-5-27b-scale` — **PENDIENTE**
- [ ] Verificar si el modelo cae en la trampa (state cloning sin arreglar aritmética)
- [ ] Model trace exportado y guardado (Export Transcript → .md)
- [ ] `basetoinstance.patch` generado

### Paso 3 — Gold patch
- [ ] Solución correcta implementada
- [ ] `gold_patch.patch` generado
- [ ] Verificado: `git apply --ignore-whitespace gold_patch.patch` funciona
- [ ] Repo restaurado al estado roto

### Paso 4 — Tests
- [ ] Tests f2p escritos (`*.f2p.test.*`)
- [ ] Tests p2p escritos (`*.p2p.test.*`)
- [ ] Tests son autónomos (sin dependencias externas)
- [ ] `test_patch.patch` generado
- [ ] Verificado: f2p FALLAN en estado roto
- [ ] Verificado: p2p PASAN en estado roto
- [ ] Verificado: todo PASA con gold_patch aplicado

### Paso 5 — Dockerfiles
- [ ] `Base.dockerfile` creado
- [ ] `Instance.dockerfile` creado
- [ ] Build de Base exitoso
- [ ] Build de Instance exitoso

### Paso 6 — Scripts
- [ ] `run_script.sh` creado
- [ ] `parse_results.sh` creado
- [ ] Ejecución manual exitosa

### Paso 7 — Validación
- [ ] `validation_script.sh` corrido
- [ ] Todas las secciones PASS
- [ ] `test_results.json` generado correctamente

### Paso 8 — Entrega
- [ ] Tarea entregada en Outlier
- [ ] Resultado registrado en `Historial/historial.md`

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
