# Progreso Actual — Tarea en Curso

> Este archivo refleja el estado EN TIEMPO REAL de la tarea que Pedro está trabajando.
> El agente DEBE actualizar este archivo cada vez que un paso cambie de estado.
> Cuando una tarea termine, mover el resumen a `Historial/historial.md` y resetear este archivo.

---

## Tarea Activa

| Campo | Valor |
|-------|-------|
| Repo asignado | ⏳ Pendiente — Pedro debe proporcionar la URL |
| Tipo de problema | ⏳ Por identificar |
| Stack tecnológico | ⏳ Por identificar |
| Framework de tests | ⏳ Por identificar |
| Fecha de inicio | 2026-05-12 |

---

## Checklist de la Tarea

### Paso 1 — Setup y análisis del repo
- [ ] Repo clonado en directorio de trabajo
- [ ] Stack tecnológico identificado
- [ ] Framework de testing identificado
- [ ] Comando de tests identificado (`npm test` / `pytest` / etc.)
- [ ] Archivos de configuración relevantes identificados
- [ ] Tipo de problema definido

### Paso 2 — Creación del problema
- [ ] `issue_message.txt` redactado
- [ ] Dificultad del problema evaluada (fácil / medio / difícil)
- [ ] Probado con Sonnet 4.6 — al menos uno falla
- [ ] Probado con Qwen 3.5 27b — confirmado fallo
- [ ] Log de errores del modelo guardado
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

## Notas del Agente

> Espacio para que el agente deje notas sobre decisiones tomadas o contexto importante.

_Esperando URL del repo asignado para comenzar Paso 1._
