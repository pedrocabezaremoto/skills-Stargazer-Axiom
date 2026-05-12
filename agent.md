# agent.md — Mapa del Proyecto Stargazer Axiom

> Lee este archivo PRIMERO antes de hacer cualquier cosa.
> Luego lee `Progreso-Actual/progreso.md` para saber qué está pasando ahora mismo.

---

## ¿Qué es este proyecto?

Pedro trabaja en **Stargazer Axiom** dentro de la plataforma Outlier ($27/hr).
El trabajo consiste en tomar un repositorio de GitHub real, crear un bug o problema,
escribir tests que detecten ese problema, y construir los archivos Docker y scripts
que permiten evaluarlo automáticamente en dos fases.

Pedro ya aprobó el onboarding. Actualmente está en **fase de producción de tareas**.

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

## Reglas Invariantes (nunca romper)

1. El repo siempre vive en `/app` dentro de Docker
2. `ENTRYPOINT` de Instance.dockerfile siempre es `["/bin/bash"]`
3. `run_script.sh` SOLO aplica patches y corre tests — nada más
4. Los marcadores de fase son literales: `=== PHASE 1 START ===` y `=== PHASE 2 START ===` (en inglés, exactamente así)
5. Los comandos de test llevan `|| true` para no abortar en fallos esperados
6. Los tests f2p usan sufijo `*.f2p.test.*` y los p2p usan `*.p2p.test.*`

---

## INSTRUCCIÓN PARA EL AGENTE — MUY IMPORTANTE

Siempre que termines de hacer algo con Pedro, actualiza estos dos archivos:

- **`Historial/historial.md`** — agrega una entrada con fecha, qué se hizo y resultado
- **`Progreso-Actual/progreso.md`** — actualiza el estado actual de la tarea

Estos archivos son la memoria del proyecto. Si no los mantienes actualizados,
el próximo agente entrará sin contexto y perderá tiempo reconstruyendo el estado.
