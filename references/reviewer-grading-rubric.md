# Reviewer Grading Rubric — Stargazer Axiom

> Esta es la tabla que Outlier usa para calificar la calidad de una tarea.
> Como attempter, conocerla te dice exactamente qué revisan y qué es FAIL vs. PASS.

---

## Calificaciones de Tarea (1 – 5)

| Calificación | Descripción |
|---|---|
| **1 – Inaceptable** | Sin señales de esfuerzo, debe rehacerse completamente. Spam, generado por LLM, o esfuerzo mínimo. |
| **2 – Problemas mayores** | Muestra esfuerzo pero debe rehacerse en gran parte. Prompt confuso o demasiado simple, gold patch con falla grave, rúbrica necesita reescribirse completamente. |
| **3 – Algunos problemas** | Problemas moderados que necesitaban corrección pero era mayormente válida. Pequeñas ediciones al prompt, correcciones menores al patch, reescritura moderada de la rúbrica. |
| **4 – Problemas menores** | Pocos problemas, solo ediciones menores para llegar a perfecto. Corregir errores tipográficos, reescribir un par de criterios, pequeños errores. |
| **5 – Perfecto** | Siguió todas las guías, no requirió ediciones. |

---

## Guía para dar Feedback

El feedback debe ser:
- **Específico** — nombra partes concretas de la tarea donde hiciste cambios
- **Conciso** — organizado y enfocado
- **Accionable** — explica cómo el contribuidor puede corregir los problemas en tareas futuras
- **Alentador** — respetuoso, menciona tanto fortalezas como debilidades

---

## Tabla de Dimensiones — Reviewer Grading Rubric

### Dimensión: Prompt

| Sub-dimensión | FAIL (1-2) | Non-Fail (3-4) | PASS (5) |
|---|---|---|---|
| **Claridad y Especificidad** | No es claro lo que se pide, extremadamente difícil de seguir, o demasiado vago. Faltan detalles críticos. | Mayormente claro; puede haber interpretaciones razonables, pero llevarán a la misma respuesta. | Claro, específico y libre de ambigüedad. |
| **Relevancia de Dominio** | El prompt no cumple con el tipo de issue. | Débilmente conectado o interpretable como relacionado. | Claramente encaja en el tipo de issue. |
| **Fallo Válido del Modelo** | No se proporcionó traza de fallo. El prompt no hace que al menos un modelo falle. El fallo del modelo se basa en una interpretación ambigua (el modelo eligió una interpretación válida). | N/A | El fallo del modelo es pronunciado y se basa en una solicitud clara en el prompt. |
| **Alineación Prompt-Rúbrica** | Referencias a archivos/funciones/clases/APIs específicos en la rúbrica que no se mencionan en el prompt. Discordancia de granularidad: la rúbrica es significativamente más específica que el prompt. | La rúbrica y el prompt están mayormente alineados con discrepancias menores. Algunos criterios requieren inferencia razonable del prompt. | El prompt y la rúbrica están alineados en especificidad y granularidad, y todos los criterios son evaluables objetivamente. |

> **NOTA (Alineación):** Los requisitos del prompt deben reflejarse en la rúbrica, pero no necesitan usar exactamente los mismos nombres de archivo, siempre que se refieran claramente al mismo elemento.
>
> **NOTA (Fallo del modelo):** Si el prompt se modifica para coincidir con la especificidad de la rúbrica, la traza no necesita actualizarse.
>
> **REGLA CLAVE:** Es preferible actualizar el prompt para que sea tan específico como la rúbrica, en lugar de hacer los criterios menos específicos para coincidir con el prompt.

---

### Dimensión: Criterios de Rúbrica

| Sub-dimensión | FAIL (1-2) | Non-Fail (3-4) | PASS (5) |
|---|---|---|---|
| **Objetividad / Especificidad** | Al menos un criterio para un requisito explícito específico es subjetivo, demasiado vago, demasiado amplio o no medible (ej. "el código debe tener buen formato"). | N/A | Todos los criterios son objetivos y vinculados a factores cuantitativamente medibles, o cualitativos descritos sin ambigüedad. |
| **Cobertura** | Falta al menos un criterio que verifica un requisito explícito del prompt o una expectativa implícita crítica. | Falta criterio para expectativa implícita no crítica. Falta al menos 1 dimensión que debería haberse cubierto (ej. componente visual pero no se cubrió Visual Aesthetics). | La rúbrica cubre exhaustiva y colectivamente todos los requisitos explícitos e implícitos. |
| **Precisión** | Al menos un criterio verifica algo que contradice lo requerido. Al menos un criterio tiene error factual. Al menos un criterio no es un requisito y no mejora la respuesta. | Al menos un criterio tiene la categoría incorrecta (no marcar si la seleccionada aplica aunque otra encaje mejor). | Todos los criterios representan con precisión los requisitos explícitos e implícitos. |
| **Atomicidad** | Al menos un criterio agrupa dos o más restricciones no relacionadas sin un enfoque claro. Al menos 1 criterio incluye múltiples restricciones solo parcialmente relacionadas. | A lo sumo 3 criterios incluyen múltiples restricciones parcialmente relacionadas (interpretables como una instrucción coherente). | Todos los criterios son razonablemente atómicos. |
| **Autosuficiencia** | Al menos un criterio no puede evaluarse sin acceder al prompt, texto de referencia o información externa. | Al menos un criterio no puede evaluarse sin acceder a otros criterios de la rúbrica (pero con la rúbrica completa es suficiente). | Ningún criterio requiere leer el prompt u otra referencia externa para evaluarse. |
| **Pesos** | Los pesos no suman 100. Los criterios bajo Correctness no suman al menos 10 (sin contar f2p/p2p). F2P + P2P combinados < 20%. | F2P + P2P combinados ≥ 20% pero < 30% para componentes no visuales o lógica compleja. | Los pesos suman 100. Cada dimensión presente suma al menos 10. Tests = ≥20% (visual) o ≥30% (no visual/lógica). |
| **Formato** | Al menos 1 criterio no sigue el formato correcto. Dos criterios comparten el mismo id (título). | N/A | Todos los criterios siguen el formato correcto. |

> **NOTA (Atomicidad):** Todos los criterios f2p y p2p deben estar contenidos dentro de `f2p_success` y `p2p_success` respectivamente.

---

### Dimensión: Solución / Gold Patch

| Sub-dimensión | FAIL (1-2) | Non-Fail (3-4) | PASS (5) |
|---|---|---|---|
| **Corrección** | La solución no corrige el issue. Introduce nuevos bugs. Incompleta o solo cubre parte de los requisitos. | La solución aborda el issue principal pero tiene gaps menores o edge cases no manejados. Funciona pero podría ser más robusta. | La solución aborda completamente el issue. Todos los requisitos, sin bugs nuevos. |
| **Calidad del Gold Patch** | Contiene o modifica archivos de test. El código rompe funcionalidad existente al aplicarlo. El patch falla al aplicarse al código de instancia. | N/A | Solo contiene código de solución (sin archivos de test). No rompe funcionalidad existente. El patch se aplica limpiamente (warnings son ok). |

---

### Dimensión: Tests

| Sub-dimensión | FAIL (1-2) | Non-Fail (3-4) | PASS (5) |
|---|---|---|---|
| **Calidad del Test Patch** | Contiene archivos no-test (código de app, dependencias, configs como package.json). Modifica tests existentes. El patch falla al aplicarse. | N/A | Solo contiene archivos de test. Es un diff Git válido y se aplica limpiamente. |
| **Cobertura F2P** | Los tests F2P no cubren requisitos explícitos del prompt o hay gaps importantes. 3 o más tests son irrelevantes al issue. | Tests son redundantes pero la funcionalidad requerida está cubierta. A lo sumo 2 tests son irrelevantes. | Los tests F2P son relevantes al issue y cubren TODOS los requisitos sin ser redundantes. |
| **Comportamiento F2P** | Al menos 1 test F2P PASA en Fase 1 (debería fallar antes del fix). Al menos 1 test F2P FALLA en Fase 2 (debería pasar después del fix). | N/A | Tests F2P FALLAN en Fase 1 (antes del fix). Tests F2P PASAN en Fase 2 (después del fix). |
| **Cobertura P2P** | 3 o más tests P2P son irrelevantes al área cambiada. Sin cobertura de regresión para funcionalidad relacionada. | Tests son simples pero relevantes al área cambiada. A lo sumo 2 tests son irrelevantes. | Los tests P2P cubren apropiadamente la funcionalidad existente alrededor del cambio. |
| **Comportamiento P2P** | Al menos 1 test P2P falla en cualquiera de las fases. | N/A | Tests P2P PASAN en Fase 1. Tests P2P PASAN en Fase 2. |
| **Independencia de Tests** | Los tests F2P referencian o dependen de los P2P (o viceversa). Las suites no son autónomas. | N/A | Las suites F2P y P2P son completamente independientes. Cada suite es autónoma y ejecutable independientemente. |

> **NOTA (Cobertura F2P para Testing Enhancement):** Los tests F2P deben verificar que los archivos de test existen con la estructura correcta, convenciones de nombrado, y ejecutabilidad básica.

---

### Dimensión: Docker & Scripts

| Sub-dimensión | FAIL (1-2) | Non-Fail (3-4) | PASS (5) |
|---|---|---|---|
| **Base Dockerfile** | Falla al compilar por dependencias faltantes. Imagen base incorrecta. No sigue la plantilla o modifica secciones prohibidas (DO NOT MODIFY). | N/A | Compila sin errores. Todas las dependencias se instalan. Entorno correctamente configurado. |
| **Instance Dockerfile** | Falla al compilar. No sigue la plantilla o modifica secciones prohibidas. | N/A | Compila sin errores. Scripts tienen permisos ejecutables. El flujo completo de tests corre automáticamente. |
| **Calidad de basetoinstance.patch** | Tarea NO es bug injection pero el patch es no-vacío. Tarea ES bug injection pero el patch está vacío o contiene código no relacionado al bug. | N/A | Bug injection: patch no-vacío y completamente relevante al bug. No bug injection: patch vacío. |
| **Calidad de Scripts** | Orden incorrecto de patches en run_script.sh. Alguno de los patches falla al aplicarse. Script termina con errores. parse_results.sh no parsea correctamente. parse_results.sh termina con errores. | run_script.sh instala dependencias cuando el gold_patch NO incluye cambios a dependencias. Llama a parse_results.sh desde dentro. | Scripts tienen ejecución limpia con output legible. run_script.sh aplica patches en el orden correcto. parse_results.sh parsea los resultados correctamente. |

> **NOTA (Base Dockerfile):** El entorno base debe ser igual al repo de GitHub. La única excepción es si hay un bug en el repo que impida compilar el Docker — en ese caso, el entorno base será el código corregido sin el bug.
>
> **NOTA (Instance Dockerfile):** El entorno de instancia será igual al entorno base para todos los tipos de issue excepto bug injection.

---

### Dimensión: Archivos Subidos

| Sub-dimensión | FAIL | PASS |
|---|---|---|
| **Archivos Presentes** | Falta cualquiera de: `base.Dockerfile`, `instance.Dockerfile`, `gold_patch.patch`, `test_patch.patch`, `basetoinstance.patch`, `run_script.sh`, `parse_results.sh`, `test_results.json` | Todos los archivos han sido subidos. |
