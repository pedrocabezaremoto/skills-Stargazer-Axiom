# agent.md — Mapa del Proyecto Stargazer Axiom

> Lee este archivo PRIMERO antes de hacer cualquier cosa.
> Luego lee `Progreso-Actual/progreso.md` para saber qué está pasando ahora mismo.

---

## ¿Qué es este proyecto?

**Stargazer Axiom** es un proyecto de creación de datos dentro de Outlier ($27/hr).

**Objetivo:** Construir una base de datos de problemas de coding desafiantes asociados a repositorios reales de GitHub.
Esta base se usa para evaluar y mejorar la capacidad de agentes de IA para implementar cambios en codebases reales.

**El flujo de trabajo:** Tomar un repositorio real → Crear un problema (bug, feature, migración, optimización, etc.) → 
Escribir tests que lo validen → Crear la Golden Solution (solución correcta) → Empaquetar todo en Docker, scripts y patches 
reproducibles → Verificar con herramientas automáticas → Entregar a Outlier para revisión y evaluación.

**Estado:** Pedro ya aprobó el onboarding. Actualmente en **fase de producción de tareas**.

---

## Estado del Proyecto

| Fase | Estado |
|------|--------|
| Onboarding | ✅ Aprobado |
| Configuración del entorno | ✅ Completo |
| Primera tarea asignada | 🔄 En progreso |

Ver detalles en `Progreso-Actual/progreso.md` y `Historial/historial.md`.

---

## Mapa de Carpetas

```
skills-Stargazer-Axiom/
│
├── agent.md                    ← ESTÁS AQUÍ — lee primero
│
├── readme-Stargazer.md         ← skill: asistente constructor de tareas
├── readme-reviewer.md          ← skill: asistente revisor de tareas
│
├── Progreso-Actual/
│   └── progreso.md             ← estado actual de la tarea en curso (léelo siempre)
│
├── Historial/
│   └── historial.md            ← registro cronológico de todo lo hecho
│
├── references/                 ← guías técnicas paso a paso
│   ├── 01_setup_and_analysis.md
│   ├── 02_problem_creation.md
│   ├── 03_testing.md
│   ├── 04_docker_scripts.md
│   ├── 05_to_08_remaining_steps.md
│   ├── checklist.md
│   ├── common-errors.md
│   ├── dockerfile-templates.md
│   ├── env-setup.md
│   ├── patch-workflow.md
│   ├── rating-guidelines.md
│   ├── rubric-criteria.md
│   ├── rubric-guide.md
│   ├── script-templates.md
│   ├── checklist.md            ← checklist de revisión (leer antes de entregar)
│   └── reviewer-grading-rubric.md ← ⚠️ LEER ANTES DE ENTREGAR — tabla exacta de FAIL/PASS del revisor
│
├── Stargazer_Eval/             ← evaluador oficial de Outlier
│   ├── Eval/                   ← 8 criterios de evaluación (0_Master a 8_Coverage)
│   ├── Guide/                  ← cómo correr el eval + tricks
│   ├── Templates/              ← plantillas Base y Instance Dockerfile
│   ├── Docs/QC_Spec_Doc.md     ← especificación de calidad oficial
│   └── Tasks/Task_to_evaluate/ ← poner aquí la tarea para evaluar
│
├── validation_script/          ← script para validar antes de entregar
│   ├── HOW_TO_USE.md
│   ├── validation_script.sh    ← usar en Linux/VPS
│   └── validation_script.ps1   ← usar en Windows
│
└── Onboarding/                 ← material del onboarding (referencia)
```

---

## 📋 Cómo está organizado este proyecto (Para agentes)

Este proyecto está **altamente modularizado** y diseñado para agentes como tú:

### Arquitectura

| Capa | Propósito | Archivos |
|------|-----------|----------|
| **Entry** | Entiender qué es el proyecto y dónde estamos | `agent.md` (estás aquí), `Progreso-Actual/progreso.md` |
| **Step-by-Step** | Guías técnicas para cada uno de los 8 pasos | `references/01_setup_and_analysis.md` a `references/05_to_08_remaining_steps.md` |
| **Temáticas** | Profundidad en temas específicos | `references/rubric-guide.md`, `references/patch-workflow.md`, `references/dockerfile-templates.md` |
| **Validación** | Verificar antes de entregar | `validation_script/`, `Stargazer_Eval/` |
| **Aprendizaje** | Material de onboarding | `Onboarding/IntroCourse-Stargazer.md`, `Onboarding/ErroresComunes-Stargazer.md` |

### Flujo típico de lectura para un agente nuevo

1. **Primero:** Lees `agent.md` (este archivo) — entiendes qué es el proyecto
2. **Segundo:** Lees `Progreso-Actual/progreso.md` — sabes qué tarea está en curso y en qué paso
3. **Tercero:** Vas a `references/0X_*.md` según el paso actual
4. **Si necesitas:** Profundizas en archivos temáticos (`rubric-guide.md`, `patch-workflow.md`, etc.)
5. **Antes de entregar:** Lees `references/reviewer-grading-rubric.md` y ejecutas validación + eval

### Fortalezas de esta estructura

✅ **Modularidad:** Cada tema en su archivo — búsqueda rápida  
✅ **Templates listos:** `dockerfile-templates.md`, `script-templates.md` — no reinventar la rueda  
✅ **Automatización:** `validation_script.sh` + `Stargazer_Eval` oficial — verificación garantizada  
✅ **Rastreabilidad en vivo:** `Progreso-Actual/progreso.md` — siempre saber dónde estamos  
✅ **Pedagogía:** `Onboarding/` + `common-errors.md` — aprender de errores comunes  

---

## Flujo de una Tarea (8 pasos)

| Paso | Acción |
|------|--------|
| 1 | Clonar el repo asignado y analizar su estructura |
| 2 | Crear el `issue_message.txt` — el problema que debe resolver la IA |
| 3 | Probar que al menos un modelo de IA falla al resolverlo |
| 4 | Crear el `gold_patch.patch` — la solución correcta |
| 5 | Crear los tests f2p y p2p → generar `test_patch.patch` |
| 6 | Crear `Base.dockerfile` e `Instance.dockerfile` |
| 7 | Crear `run_script.sh` y `parse_results.sh` |
| 8 | Correr `validation_script.sh` y entregar |
| **PRE-ENTREGA** | **Revisar `references/reviewer-grading-rubric.md` — verificar cada dimensión antes de subir** |

---

## 🔴 Reglas Invariantes (NUNCA romper — el validador y evaluador fallarán)

| # | Regla | Por qué importa |
|----|-------|-----------------|
| 1 | El repo vive **siempre** en `/app` dentro de Docker — nunca cambiar | Los scripts y patches están hardcodeados a `/app` |
| 2 | `ENTRYPOINT ["/bin/bash"]` en ambos Dockerfiles — nunca `CMD` | El evaluador asume esta entrada |
| 3 | `run_script.sh` SOLO aplica patches + corre tests — nada más (sin npm install salvo si gold patch lo requiere) | Si instala deps, puede maskear fallos de test reales |
| 4 | Phase markers exactos en inglés: `=== PHASE 1 START ===` y `=== PHASE 2 START ===` | El parser busca estas strings literales |
| 5 | Tests llevantodos `\|\| true` al final — no abortar en fallos esperados | La Fase 1 espera que F2P fallen; si se aborta es error de script |
| 6 | F2P tests: sufijo `*.f2p.test.{js,ts,php,...}` / P2P tests: sufijo `*.p2p.test.*` | El parser clasifica por nombre; nombres incorrectos rompen el resultado |
| 7 | `test_patch.patch` contiene SOLO archivos de test — nada de app code, configs ni package.json | El validador rechaza patches sucios |
| 8 | `gold_patch.patch` contiene SOLO solución — nunca archivos de test | Mismo: rechazo si contamina con tests |
| 9 | `instance.Dockerfile` aplica patch con `--mount=type=bind`, no `COPY` | El validador busca --mount |
| 10 | `parse_results.sh` lee de `$RAW_OUTPUT_FILE`, no de stdout directo | Sin esto, test_results.json no se genera |
| 11 | Suma de pesos rubric = **exactamente 100** / f2p_success + p2p_success ≥ 20% (UI) o ≥ 30% (lógica) | El evaluador rechaza rubrics sin alineación de pesos |

**Si rompes una regla, el validador o evaluador falla. Siempre chequea con `references/common-errors.md`.**

---

## 🚀 ANTES DE EMPEZAR — CHECKLIST PARA EL AGENTE

### Lectura inicial (5 min)

- [ ] Estoy leyendo `agent.md` **ahora** ← aquí estás
- [ ] Iré a leer `Progreso-Actual/progreso.md` después de esto
- [ ] Entiendo que hay 8 pasos y estoy en el paso X

### Navegación rápida durante el trabajo

| Necesito... | Voy a... |
|---|---|
| Saber en qué paso estoy | `Progreso-Actual/progreso.md` |
| Guía completa del paso actual | `references/0X_*.md` (ej: `references/04_docker_scripts.md` para paso 4) |
| Ejemplos de Dockerfile/scripts | `references/dockerfile-templates.md` o `references/script-templates.md` |
| Errores comunes | `references/common-errors.md` |
| Cómo evalúa el revisor | `references/reviewer-grading-rubric.md` |
| Cómo crear rúbrica | `references/rubric-guide.md` |
| **Cómo generar rubric.json** | `references/rubric-guide.md` → Sección "Generación del Archivo rubric.json" |
| **Cómo extraer Model Trace** | `references/env-setup.md` → Sección "Extracción del Rastro del Modelo" |
| **beforeAll + npm install (migrations)** | `references/03_testing.md` → Sección "3.4 Manejo de Dependencias en test_patch" |
| Validar antes de entregar | Ejecutar `validation_script.sh` |
| Evaluar calidad final | Ejecutar `Stargazer_Eval/Guide/HOW_TO_RUN_EVAL.md` |

### Después de cada sesión (CRÍTICO)

Actualiza SIEMPRE estos archivos o el próximo agente perderá contexto:

1. **`Progreso-Actual/progreso.md`** — actualiza el checklist de pasos y "Bloqueos y Problemas Actuales"
2. **`Historial/historial.md`** — agrega una entrada: `[fecha] Paso X: [qué se hizo] → [resultado]`

---

## Regla de Oro para Agentes

> **La documentación de este proyecto es tu mejor amiga.**
> Si algo no está claro, busca en `references/`. Si aún no lo encuentras, chequea `common-errors.md`.
> Si sigues trabado, pregúntale a Pedro — él sabe exactamente cómo desbloquear.
