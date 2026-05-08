# Errores Comunes y Checklist de Revisión — Stargazer Axiom

## Errores comunes al crear tareas

### 1. Issue Message — Falta de alineación con el tipo de problema

| Error | Ejemplo | Solución |
|-------|---------|----------|
| El mensaje del problema no coincide con el tipo de problema especificado | Tipo = "Mejora de pruebas" pero el mensaje dice: *"Corrige el error de exportación donde se ignora `ignoreColumn: '[2,3]'` y se exportan las columnas incorrectas"* | Antes de redactar la consigna, asegúrate de que tu objetivo principal se alinee directamente con el tipo de problema dado |

---

### 2. Fallo del modelo — Rastro inválido

| Error | Causa | Solución |
|-------|-------|---------|
| La conversación del agente se interrumpe repentinamente y se considera un fallo del modelo | Problemas con la API key o la conexión — el log muestra *"Error: la conexión falló"* — pero el colaborador lo etiqueta como fallo del modelo | Regenera la conversación con el agente; esto NO es un fallo válido del modelo |

---

### 3. Cargando archivos — Nombres incorrectos

| Error | Ejemplo | Solución |
|-------|---------|---------|
| El colaborador sube archivos con nombres incorrectos | Se sube `run_tests.sh` en lugar de `run_script.sh` | Asegúrate de que los nombres de los archivos sean **exactamente** como aparecen en la lista. No ignores los validadores de código |

---

### 4. Dockerfile — Modificaciones prohibidas

| Error | Ejemplo | Solución |
|-------|---------|---------|
| El archivo Dockerfile no sigue la plantilla de las directrices | El colaborador sube un `base.Dockerfile` con `CMD` al final en lugar de `ENTRYPOINT ["/bin/bash"]` | Usa la plantilla del Dockerfile y modifica **únicamente** las secciones permitidas |

---

### 5. Dockerfile — No compilable

| Error | Causa | Solución |
|-------|-------|---------|
| El Dockerfile no se compila ni se ejecuta | Errores de compilación relacionados con paquetes dañados o comandos incorrectos al ejecutar `docker build` o `docker run` | Depura la compilación desde el Dockerfile y asegúrate de que se complete correctamente antes de subir la tarea |

---

### 6. solution.patch — Solución incorrecta

| Error | Ejemplo | Solución |
|-------|---------|---------|
| El `solution.patch` no resuelve el problema o introduce nuevos errores | Se pide corregir una función que falla con entrada vacía, pero el código no maneja ese caso | El parche debe resolver completamente el problema sin romper funcionalidad existente. F2P y P2P deben mostrar resultados positivos |

---

### 7. Rúbricas — Cobertura insuficiente

| Error | Ejemplo | Solución |
|-------|---------|---------|
| El criterio describe un comportamiento de forma demasiado genérica sin incluir todos los requisitos explícitos | La consigna requiere pruebas para `hexToRgbA`, `colorLuminance`, `lighten` y `darken`, pero la rúbrica solo tiene criterios para las dos primeras | Todos los requisitos explícitos de la consigna deben estar presentes en la rúbrica |

---

### 8. Rúbricas — Pesos de F2P/P2P insuficientes

| Error | Ejemplo | Solución |
|-------|---------|---------|
| El peso combinado de F2P y P2P está por debajo del umbral mínimo | Total = 100 pts, `f2p_success` = 5 y `p2p_success` = 5 (F2P + P2P = 10%, por debajo del mínimo requerido del 20%) | Asigna ponderaciones de manera que `f2p_success + p2p_success >= 20%` (visual) o `>= 30%` (lógica no visual) |

---

### 9. Rúbricas — Criterios subjetivos

| Error | Ejemplo | Solución |
|-------|---------|---------|
| Criterios que no se pueden medir objetivamente | *"La respuesta debe tener un buen formato"* / *"El código debe ser óptimo"* | Cada criterio debe ser observable y describible como algo que se puede aprobar o reprobar con condiciones medibles |

---

### 10. Parches de prueba — Cobertura insuficiente

| Error | Ejemplo | Solución |
|-------|---------|---------|
| Las pruebas F2P no cubren todos los requisitos explícitos; las P2P no cubren todas las funcionalidades relacionadas | La consigna requiere pruebas para cuentas y servicios de carrito, pero las pruebas F2P solo verifican los métodos de cuenta | Identifica cada requisito explícito e implementa al menos una prueba F2P para cada uno; identifica toda funcionalidad afectada e implementa pruebas P2P |

---

### 11. Parches de prueba — Pruebas irrelevantes

| Error | Ejemplo | Solución |
|-------|---------|---------|
| Pruebas F2P/P2P que no corresponden al área del problema | La consigna pide un cambio de color en la barra de navegación, pero las pruebas F2P se centran en botones de navegación y las P2P en servicios del carrito | Las F2P deben ser relevantes para el problema; las P2P deben cubrir el área o módulo correcto relacionado con el problema |

---

### 12. Parches de prueba — Pruebas no válidas (estáticas)

| Error | Ejemplo | Solución |
|-------|---------|---------|
| Prueba estática que reemplaza una prueba de comportamiento | Las pruebas F2P solo usan `grep` para verificar la existencia de una función en lugar de llamarla y verificar su comportamiento | Todas las pruebas deben ser conductuales; no uses `grep` ni búsqueda de contenido codificado. Prueba el **comportamiento**, no la implementación |

---

### 13. Script de análisis — Sin archivo de salida

| Error | Ejemplo | Solución |
|-------|---------|---------|
| `parse_results.sh` solo genera salida a stdout pero nunca escribe a `test_results.json` | El script finaliza con `echo "$RESULTS"` sin redirigir al archivo | El script debe generar salida tanto a stdout como a `/app/test_results.json` usando `tee` |

```bash
# ✅ Correcto
echo "$RESULTS" | tee /app/test_results.json

# ❌ Incorrecto
echo "$RESULTS"
```

---

### 14. Parches con artefactos antiguos

| Error | Ejemplo | Solución |
|-------|---------|---------|
| Los parches contienen prefijos `/base` o `/instance` obsoletos | `gold_patch` modifica `base/Front End/components/Button.js` en lugar de `Front End/components/Button.js` | El directorio de trabajo unificado es `/app`. Evita incluir referencias a `/base` o `/instance`. Regenera el parche con la nueva estructura |

---

## Checklist de Revisión Rápida

Usa esta lista antes de enviar tu tarea.

### Estructura de carpetas
- [ ] Carpeta `/App` con el commit base (código funcional)
- [ ] Carpeta `/dockerfiles` con `base.Dockerfile` e `instance.Dockerfile`
- [ ] Carpeta `/scripts` con `run_script.sh` (ejecutable) y `parse_results.sh` (ejecutable)
- [ ] Carpeta `/patches` con `gold_patch.patch`, `test_patch.patch`, `basetoinstance.patch`
- [ ] Archivo `test_results.json`

### Requisitos del issue
- [ ] El mensaje del problema cumple los requisitos del tipo de problema
- [ ] El mensaje es claro e inequívoco
- [ ] El problema **no** revela la solución
- [ ] El problema proporciona suficiente contexto

### Validación de Docker
- [ ] El `base.Dockerfile` compila correctamente
- [ ] El `instance.Dockerfile` compila correctamente
- [ ] La instancia de Docker se ejecuta y muestra claramente los resultados de la prueba

### Validación de parches
- [ ] El gold patch se aplica limpiamente sin conflictos
- [ ] El gold patch resuelve completamente el problema
- [ ] Gold patch solo modifica los archivos necesarios
- [ ] Gold patch no añade dependencias innecesarias
- [ ] El test patch se aplica correctamente sin conflictos
- [ ] El test patch incluye pruebas F2P y P2P
- [ ] El test patch solo agrega pruebas, NO modifica archivos existentes
- [ ] Los parches usan rutas de archivo correctas (sin `/base` ni `/instance`)

### Requisitos de prueba
- [ ] Las pruebas F2P **fallan** antes de aplicar el gold patch
- [ ] Las pruebas F2P **pasan** después de aplicar el gold patch
- [ ] Las pruebas P2P pasan tanto antes como después del gold patch
- [ ] Las pruebas F2P validan realmente la corrección/función
- [ ] Las pruebas P2P cubren la funcionalidad relacionada/existente
- [ ] Las pruebas tienen afirmaciones claras
- [ ] El test patch NO modifica pruebas existentes

### Criterios de la rúbrica
- [ ] La rúbrica suma exactamente **100 puntos**
- [ ] La rúbrica contiene solo categorías relevantes
- [ ] Los criterios son MECE (Mutuamente Excluyentes, Colectivamente Exhaustivos)
- [ ] Cada criterio es específico y medible
- [ ] Los criterios son atómicos (no apilados)
- [ ] Los criterios son autónomos (independientes entre sí)
- [ ] La distribución del peso refleja la importancia relativa
- [ ] La rúbrica abarca **todos** los requisitos explícitos de la consigna

### Validación de scripts
- [ ] El script ejecuta ambas fases de prueba
- [ ] El script de ejecución aplica los parches correctamente
- [ ] El script de análisis identifica los resultados de Fase 1 y Fase 2
- [ ] El script de análisis genera un resumen JSON en el formato requerido
- [ ] Los scripts tienen manejo de errores adecuado
- [ ] Los scripts **no** tienen resultados codificados (hardcoded)

### Calidad del código
- [ ] No hay código de depuración en los parches
- [ ] El código sigue las convenciones del proyecto
- [ ] Manejo adecuado de errores en la solución
- [ ] No hay valores codificados que deban ser configurables

### Detección LLM
- [ ] No hay comentarios que indiquen el uso de LLM
- [ ] No hay comentarios de marcador de posición (placeholder)
- [ ] No se usan emojis en las pruebas ni en los scripts de ejecución o análisis

### Validación final
- [ ] Flujo de trabajo completo probado manualmente
- [ ] Resultado satisfactorio del script de validación de Stargazer
- [ ] El problema plantea un desafío adecuado
- [ ] El problema tiene solución
- [ ] Todas las rutas de archivo son correctas
