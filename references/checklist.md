# Checklist Rápida de Revisión — Stargazer Axiom

Usa esta lista durante la revisión para no omitir ningún punto crítico.
Marca cada casilla a medida que la verificas.

---

## Escaneo Inicial — ¿Devolver o Continuar?

- [ ] La tarea NO es spam ni fue generada por LLM
- [ ] El mensaje del problema SÍ corresponde al tipo de tarea
- [ ] Los archivos Docker, parches y scripts SÍ están presentes
- [ ] Al menos uno de los modelos SÍ falla en proporcionar la solución correcta

> Si alguna casilla queda **sin marcar** → Devolver la tarea al participante

---

## Paso 1 — Mensaje del Problema

- [ ] El mensaje está alineado con el tipo de problema
- [ ] Es descriptivo, inequívoco y factible
- [ ] **NO** contiene la solución completa

---

## Paso 2 — Estructura de Archivos

### Archivos presentes:
- [ ] `base.Dockerfile`
- [ ] `instance.Dockerfile`
- [ ] `gold_patch.patch`
- [ ] `test_patch.patch`
- [ ] `basetoinstance.patch`
- [ ] `run_script.sh`
- [ ] `parse_results.sh`
- [ ] `test_results.json`

### Estructura de directorios (Tarea 02):
- [ ] La estructura coincide con el esquema requerido

---

## Paso 3 — Fallo del Modelo

- [ ] Al menos un modelo falló con una solución inválida (no por error de API/conexión)

---

## Paso 4 — Entorno Docker

### base.Dockerfile:
- [ ] Sigue la plantilla (solo modifica líneas permitidas)
- [ ] La imagen base es correcta (`FROM <imagen>:<etiqueta>`)
- [ ] `<repo_url>` correcto en `git clone`
- [ ] Dependencias del sistema instaladas correctamente
- [ ] Dependencias del proyecto instaladas correctamente

### instance.Dockerfile:
- [ ] Sigue la plantilla sin modificaciones prohibidas

### Ambos Dockerfiles:
- [ ] Ninguno copia archivos locales ni ejecuta scripts
- [ ] Ambos compilan sin errores

---

## Paso 5 — Pruebas y test_patch

### Pruebas F2P:
- [ ] Cobertura de TODOS los requisitos explícitos
- [ ] **FALLAN** en Fase 1 (antes de gold_patch)
- [ ] **PASAN** en Fase 2 (después de gold_patch)
- [ ] Mensaje de fallo es claro e informativo
- [ ] Las pruebas son deterministas
- [ ] No dependen de detalles del gold_patch

### Pruebas P2P:
- [ ] Cubren funcionalidad existente relacionada con los cambios
- [ ] **PASAN** en Fase 1
- [ ] **PASAN** en Fase 2
- [ ] Sin efectos secundarios ni regresiones
- [ ] Validan comportamiento real (no solo existencia)

---

## Paso 6 — Calidad de Parches

### gold_patch.patch:
- [ ] Solo contiene cambios de la solución (sin archivos de prueba)
- [ ] Se aplica: `git apply --ignore-whitespace gold_patch.patch`
- [ ] Cumple todos los requisitos del enunciado

### test_patch.patch:
- [ ] Solo contiene archivos de prueba
- [ ] No modifica pruebas existentes
- [ ] No modifica código de app, dependencias ni configuración
- [ ] Se aplica: `git apply --ignore-whitespace test_patch.patch`

### basetoinstance.patch:
- [ ] **Si NO es inyección de errores**: está vacío ✓
- [ ] **Si ES inyección de errores**: contiene la diferencia correcta del defecto ✓

---

## Paso 7 — Calidad de Scripts

### run_script.sh:
- [ ] Orden correcto: `test_patch` → pruebas → `gold_patch` → pruebas
- [ ] No instala dependencias directamente (salvo que el gold_patch lo requiera)
- [ ] El script finaliza correctamente
- [ ] NO llama internamente a `parse_results.sh`

### parse_results.sh:
- [ ] Analiza correctamente la salida en formato JSON
- [ ] Valida: Fase 1 (F2P falla, P2P pasa) y Fase 2 (ambas pasan)
- [ ] Determina claramente ÉXITO / FRACASO
- [ ] Guarda en `test_results.json`

---

## Paso 8 — Script de Validación

- [ ] `validation_script.sh` ejecutado sin errores
- [ ] Todas las secciones pasaron

---

## Paso 9 — Rúbrica

### Contenido:
- [ ] Criterios exhaustivos (todos los requisitos explícitos del enunciado)
- [ ] Dimensiones relevantes para el tipo de problema cubiertas
- [ ] Criterios son MECE (mutuamente excluyentes y colectivamente exhaustivos)

### Pesos:
- [ ] Suma total = **100**
- [ ] F2P + P2P ≥ 20% (visual) o ≥ 30% (no visual/lógica compleja)

### Calidad de criterios:
- [ ] Cada criterio es **Atómico** (un solo requisito)
- [ ] Cada criterio es **Específico** (detalle suficiente para calificar objetivamente)
- [ ] Cada criterio es **Autosuficiente** (evaluable sin consultar consigna ni recursos externos)
- [ ] El nivel de granularidad coincide con la consigna

### Formato:
- [ ] Todos los criterios siguen el formato correcto (id, peso, requisito, categoría)
- [ ] No hay dos criterios con el mismo identificador (título)

---

## Calificación Final

| Aspecto | Evaluación |
|---------|-----------|
| Mensaje del problema | ✅ OK / ⚠️ Con correcciones / ❌ Rechazado |
| Estructura de archivos | ✅ OK / ⚠️ Con correcciones / ❌ Rechazado |
| Fallo del modelo | ✅ Válido / ❌ Inválido |
| Dockerfiles | ✅ OK / ⚠️ Con correcciones / ❌ Error |
| Pruebas F2P | ✅ Correctas / ⚠️ Con problemas / ❌ Fallan |
| Pruebas P2P | ✅ Correctas / ⚠️ Con problemas / ❌ Fallan |
| Parches | ✅ OK / ⚠️ Con correcciones / ❌ Error |
| Scripts | ✅ OK / ⚠️ Con correcciones / ❌ Error |
| Rúbrica | ✅ Completa / ⚠️ Parcial / ❌ Reescribir |

**Calificación asignada:** ___/5

**Justificación:**
```
[Escribir breve justificación de la calificación]
```

**Feedback para el participante:**
```
✅ Fortalezas:
-

🔧 Áreas de mejora:
-

📝 Nota general:
```
