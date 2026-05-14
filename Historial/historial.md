# Historial del Proyecto Stargazer Axiom

> Este archivo es un registro cronológico de todo lo que se ha hecho en el proyecto.
> El agente DEBE agregar una entrada cada vez que complete una acción importante.
> Formato de entrada: `## [YYYY-MM-DD] — Título de lo hecho`

---

## Estado General del Proyecto

| Hito | Estado | Fecha |
|------|--------|-------|
| Acceso a Outlier | ✅ Completado | — |
| Assessment (evaluación de ingreso) | ✅ Aprobado | — |
| Onboarding Stargazer Axiom | ✅ Aprobado | — |
| Primera tarea asignada | 🔄 En progreso | 2026-05-12 |

---

## [2026-05-12] — Configuración inicial del entorno de trabajo

**Qué se hizo:**
- Pedro fue reasignado de Real Coder a **Stargazer Axiom** ($27/hr)
- Se leyó y analizó el skill principal `readme-Stargazer.md`
- Se descargaron los archivos oficiales de Outlier:
  - `Stargazer_Eval.zip` → descomprimido en `Stargazer_Eval/`
  - `validation_script.zip` → descomprimido en `validation_script/`
- Se organizaron todas las carpetas en el repo `skills-Stargazer-Axiom`
- Se hizo git push al repo SSH (`git@github.com:pedrocabezaremoto/skills-Stargazer-Axiom.git`)
- Se estudió el flujo completo de una tarea (8 pasos)
- Se estudió `0_Master_Eval.md` — los 8 criterios de evaluación
- Se estudió `HOW_TO_USE.md` — cómo usar el validation script
- Se creó `agent.md` como punto de entrada para futuros agentes
- Se creó esta estructura de `Historial/` y `Progreso-Actual/`

**Resultado:** Entorno configurado, archivos organizados, listo para empezar primera tarea.

**Notas importantes del equipo (canal Stargazer Axiom):**
- `run_script.sh` SOLO aplica patches y corre tests — parsear resultados dentro de él está prohibido
- Config files de testing deben ir inline en los tests f2p/p2p cuando sea posible
- Si se necesitan dependencias nuevas (Jest, Karma), van en `Base.dockerfile` siempre que no revelen el `gold_patch`
- Para tareas de migración con nuevas dependencias npm → usar el truco `pretest` en `test_patch.patch`

---

## [2026-05-13] — Auditoría y corrección de referencias vs. guías oficiales

**Qué se hizo:**
- Se compararon las guías oficiales de Outlier (PDF en español e inglés) contra todos los archivos en `references/` y `Stargazer_Eval/Docs/`
- Se identificaron dos bugs críticos introducidos por la traducción al español:
  1. **JSON keys en español** en `references/04_docker_scripts.md`: `fase_1`, `fase_2`, `resultado_general`, `nombre`, `estado`, `FALLIDO/APROBADO/ÉXITO` — el sistema espera inglés
  2. **`criteria_category` en español** en `references/05_to_08_remaining_steps.md`: `"corrección"` — el evaluador espera `"correctness"`
- Se corrigieron ambos archivos:
  - `04_docker_scripts.md` → JSON con keys en inglés: `phase_1`, `phase_2`, `overall_result`, `name`, `status`, `FAILED/PASSED/SUCCESS`
  - `05_to_08_remaining_steps.md` → `criteria_category` en inglés y lista de valores válidos corregida (`correctness`, `independence`, `readability`, `efficiency`, `visual_aesthetics`)
- Se identificó también que el Paso 8 (Stargazer_Eval) no tenía documentación completa en `05_to_08_remaining_steps.md` — ya está cubierto en ese archivo pero pendiente de ampliar con el flujo detallado

**Resultado:** Referencias corregidas y alineadas con la guía oficial en inglés. Usar estos archivos como referencia para generar rubric.json y test_results.json es ahora seguro.

---

## [2026-05-13] — Reviewer Grading Rubric agregada al proyecto (Guía 4)

**Qué se hizo:**
- Se cotejó la Guía 4 oficial ("Reviewer Guidelines") contra los archivos del proyecto
- Se identificó que la **Reviewer Grading Rubric** (tabla completa de dimensiones de evaluación) estaba completamente ausente del proyecto
- Se creó `references/reviewer-grading-rubric.md` con las dimensiones completas: Prompt (Claridad, Dominio, Fallo del modelo, Alineación), Criterios de Rúbrica (Objetividad, Cobertura, Precisión, Atomicidad, Autosuficiencia, Pesos, Formato), Solución/Gold Patch, Tests, Docker & Scripts, Archivos Subidos
- Se actualizó `checklist.md` para agregar las descripciones detalladas de calificaciones 1-5 y la Guía de Feedback (Específico, Conciso, Accionable, Alentador)

**Resultado:** El proyecto ahora tiene cobertura completa de las 4 guías oficiales de Outlier.

---

## [2026-05-13] — Corrección de templates Dockerfile y Scripts (Guía 3)

**Qué se hizo:**
- Se cotejó la Guía 3 oficial ("Stargazer Axiom Templates") contra `references/04_docker_scripts.md`
- Se identificaron y corrigieron 5 bugs críticos:
  1. **Instance.dockerfile usaba `COPY`** → debe ser `--mount=type=bind` (el patch NO se copia permanentemente)
  2. **Instance.dockerfile usaba `git reset --hard HEAD`** → debe ser `git checkout $LATEST_COMMIT`
  3. **Instance.dockerfile usaba `-s` para verificar patch** → debe ser `grep -q '^diff'`
  4. **Instance.dockerfile usaba `--ignore-whitespace`** → debe ser `--whitespace=fix`
  5. **run_script.sh no tenía `RAW_OUTPUT_FILE` ni markers de fase** → parse_results.sh no podía parsear nada
- Se agregó el template completo de `parse_results.sh` que estaba completamente ausente del proyecto
- Se corrigió el template de `base.Dockerfile` para que coincida con la plantilla oficial (estructura con secciones comentadas, `git reset --hard $LATEST_COMMIT` después del clone)

**Resultado:** Templates ahora alineados con la Guía 3 oficial. Sin estos cambios, instance.dockerfile build y el parsing de resultados fallaban.

---

## [2026-05-14] — Entorno confirmado listo + conocimiento de rúbricas ampliado

**Qué se hizo:**
- Pedro confirmó que **Cursor ya está configurado** con la API key de Outlier, modelos `gpt-oss-120b-bedrock` y `qwen3-235b-a22b-instruct-2507-scale` activos, y Override Base URL configurado
- Pedro confirmó que **Docker ya está instalado y funcionando** en este VPS — no necesita instalación adicional
- Se leyó y analizó el **Manual Stargazer Axiom v1.0** (PDF completo, 20 páginas) — cubre configuración, extracción de model trace, generación de .patch, rubric.json, dependencias npm, consejos de rúbricas, prompts por tipo de issue, los 14 errores comunes y checklist final
- Se estudió material visual del curso sobre rúbricas con 3 ejemplos concretos (toggle de precios mensual/anual)
- Se actualizó `references/rubric-guide.md` con nueva sección de ejemplos reales: criterios buenos (atómicos, un solo comportamiento) vs criterios malos (múltiples condiciones mezcladas)
- Se actualizó `Progreso-Actual/progreso.md` con estado del entorno y notas de rúbricas

**Estado del entorno al 2026-05-14:**
- ✅ Cursor configurado con API Outlier
- ✅ Docker instalado en VPS
- ✅ Entorno listo para empezar primera tarea productiva
- ⏳ Pendiente: URL del repo asignado por Outlier

**Resultado:** Pedro está listo para comenzar. Solo falta recibir el repo asignado de la plataforma.

---

<!-- Agregar nuevas entradas ARRIBA de esta línea, debajo del último ## -->
