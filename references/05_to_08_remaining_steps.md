# Paso 5: Script de Validación

## Propósito

Verifica que todos los entregables se ajusten a la estructura del proyecto, que los Dockerfiles compilen y ejecuten correctamente, que los scripts funcionen y que los resultados de las pruebas se generen y validen correctamente.

## Procedimiento

```bash
# 1. Descarga validation_script.zip y colócalo en el directorio raíz del proyecto
# 2. Descomprime
unzip validation_script.zip

# 3. Sigue las instrucciones en HOW_TO_USE.md
```

## Lo que hace el script automáticamente

1. **Validar la estructura del proyecto** — todos los archivos y directorios necesarios
2. **Crear imágenes Docker** — base e instancia desde tus Dockerfiles
3. **Ejecutar el contenedor de instancia** — corriendo `run_script.sh` y `parse_results.sh`
4. **Analizar y validar resultados** contra el contrato de dos fases:
   - Fase 1 (estado defectuoso): F2P deben FALLAR, P2P deben PASAR
   - Fase 2 (estado corregido): TODO debe PASAR

## Resultado

El script genera `analysis_results.json` y un resumen en la terminal.

- **ÉXITO** — ✅ puedes continuar
- **FALLO** — ❌ el resumen indica qué paso falló y por qué

> ⚠️ Pega el último `analysis_results.json` en la tarea.

---

# Paso 6: Añadir Etiquetas

Para facilitar la categorización de la tarea en la plataforma Outlier, debes agregar etiquetas relevantes que describan el stack, framework y tipo de problema.

## Etiquetas disponibles

Las siguientes etiquetas están disponibles en la plataforma Outlier:

```
JavaScript    TypeScript    Angular       Node
Redux         Babel         Webpack       Jest
localStorage  API           CSS           Frontend
Backend       Other         Web Frameworks
NextJS        React.js      Vue.js        JQuery
Svelte        Bootstrap
```

## Cómo agregar etiquetas

1. **Ubicación:** En el formulario de entrega de tarea en la plataforma Outlier
2. **Selecciona múltiples:** Puedes marcar 1 o más etiquetas que describan tu tarea
3. **Requisito mínimo:** Al menos 1 etiqueta debe estar seleccionada
4. **Alineación con tu issue:** Las etiquetas deben reflejar las tecnologías usadas en el repo y el tipo de problema

### Ejemplo de alineación

| Repo | Tecnologías | Etiquetas recomendadas |
|------|-----------|------------------------|
| Angular 19 app | Angular, TypeScript, Karma | `TypeScript`, `Angular`, `Frontend` |
| Next.js 15 app | Next.js, React, TypeScript | `TypeScript`, `NextJS`, `React.js`, `Frontend` |
| Node.js API | Node, Express, Jest | `Node`, `Backend`, `Jest` |
| Vue.js SPA | Vue, CSS, localStorage | `Vue.js`, `Frontend`, `CSS` |

## Si tu etiqueta no aparece en la lista

1. Selecciona **"Other"** como una de tus etiquetas
2. Escribe el nombre personalizado en el campo de texto que aparezca
3. Envía la tarea — el revisor la categorizará correctamente

## Checklist del Paso 6

- [ ] Identificadas las tecnologías principales del repo
- [ ] Seleccionadas al menos 1 etiqueta relevante
- [ ] Si agregaste etiquetas personalizadas, escrito el nombre en "Other"
- [ ] Las etiquetas reflejan tanto el stack como el tipo de problema (bug, feature, optimization, etc.)

---

# Paso 7: Creación de la Rúbrica

## Qué es una Rúbrica

Un conjunto de criterios para evaluar **objetiva y detalladamente** la calidad de una respuesta al prompt. Los criterios deben cubrir todas las características de una buena respuesta **sin ser tan restrictivos** que excluyan otras soluciones válidas.

## Reglas Generales

- Puedes escribir **tantos criterios como necesites**
- Cada criterio debe coincidir con una (o más) partes del prompt
- Puede haber cero, uno o varios criterios por dimensión de calidad
- Asigna ponderaciones según importancia
- **La suma de todos los pesos debe ser 100**

## Principios de los Criterios

| Principio | Descripción |
|-----------|-------------|
| **Autónomo** | Evaluable sin información externa |
| **Atómico** | Prueba un aspecto distinto por criterio |
| **Sin ambigüedad** | Vinculado a factores medibles |
| **Específico** | Referencia a código, UI, datos o rutas de archivo concretos |
| **Relevante** | Vinculado a un requisito explícito del prompt |
| **Granularidad consistente** | Todos los criterios al mismo nivel de detalle |

## Dimensiones de Calidad

| Dimensión | Pregunta clave | Obligatoria |
|-----------|---------------|------------|
| **Corrección** | ¿El código entrega el requisito funcional completo? (incluye sintaxis y lógica) | ✅ Sí — mín. 10% |
| **Independencia** | ¿Libre de componentes/dependencias innecesarias? | No |
| **Legibilidad/Extensibilidad** | ¿Bien documentado para un futuro colaborador? | No |
| **Eficiencia de ejecución** | ¿Libre de ineficiencias significativas en memoria y latencia? | No |
| **Estética visual** | ¿Los artefactos producidos son visualmente atractivos? | No |

## Requisitos Clave — Pruebas Unitarias

```
✅ OBLIGATORIO:
- Agregar criterios f2p_success y p2p_success en la dimensión "corrección"
- f2p_success + p2p_success ≥ 20% del peso total
  (30-40% para componentes no visuales o con alto componente lógico)
- Si hay varios problemas en el prompt → una f2p_success por problema

❌ PROHIBIDO:
- Referenciar módulos o casos de prueba específicos
```

## Formato del archivo `rubric.json`

```json
[
  {
    "id": "uuid-generado",
    "title": "f2p_success",
    "weight": 20,
    "annotations": {
      "criteria_requirement": "Las pruebas F2P pasan después de aplicar el gold patch, verificando que [descripción del nuevo comportamiento]",
      "criteria_category": "correctness"
    }
  },
  {
    "id": "uuid-generado",
    "title": "p2p_success",
    "weight": 10,
    "annotations": {
      "criteria_requirement": "Las pruebas P2P siguen pasando después de aplicar el gold patch, confirmando que no hay regresiones",
      "criteria_category": "correctness"
    }
  },
  {
    "id": "uuid-generado",
    "title": "nombre_criterio_en_snake_case",
    "weight": 15,
    "annotations": {
      "criteria_requirement": "Descripción clara y objetiva del criterio sin ambigüedad",
      "criteria_category": "correctness"
    }
  }
]
```

### Identificadores válidos de `criteria_category`

```
correctness
independence
readability
efficiency
visual_aesthetics
```

### Validación rápida

```
⚡ Suma de todos los pesos = 100
⚡ corrección tiene ≥1 criterio y ≥10% del peso
⚡ f2p_success presente en "corrección"
⚡ p2p_success presente en "corrección"
⚡ f2p_success + p2p_success ≥ 20% del peso total
⚡ Todos los títulos en formato snake_case
⚡ Sin referencias a módulos o casos de prueba específicos
```

> **Alternativa:** Usa la herramienta de análisis de rúbricas para generar el JSON interactivamente en lugar de escribirlo a mano.

---

# Paso 8: Script de Evaluación Final

## Propósito

Detectar problemas que el script de validación no puede identificar. Verifica la calidad y coherencia de: prompt, pruebas, rúbricas, gold patch, Dockerfiles y nivel de granularidad.

## Procedimiento

```bash
# 1. Descarga Stargazer_Eval.zip
# 2. Descomprime en el directorio raíz de tu tarea
unzip Stargazer_Eval.zip

# 3. Abre la carpeta Guide/ y sigue HOW_TO_RUN_EVAL.md
```

## Tabla de Componentes Evaluados

| Componente | Veredicto | Acción si FALLA |
|------------|-----------|-----------------|
| Prompt | PASS/FAIL | Revisar claridad, especificidad y alineación con rúbrica |
| Tests | PASS/FAIL | Verificar F2P/P2P, nomenclatura, patch limpio |
| Rubrics | PASS/FAIL | Verificar pesos, dimensiones, criterios |
| Alignment | PASS/FAIL | Alinear prompt → rúbrica → gold patch |
| Granularity | PASS/FAIL | Ajustar nivel de detalle |
| Dockerfile | PASS/FAIL | Verificar plantillas y reglas |
| Golden Patch | PASS/FAIL | Verificar que aplica limpiamente y pasa todas las pruebas |

## Flujo de Corrección

1. Revisa el informe consolidado
2. Para cada componente en FAIL, usa la tabla "Cómo solucionarlo"
3. Corrige y vuelve a ejecutar la evaluación maestra
4. Si modificas archivos previamente cargados → vuelve a ejecutar el script de validación y sube los nuevos archivos
5. **Solo envía cuando el veredicto general sea PASS**

> ⚠️ OBLIGATORIO: Una tarea no evaluada con el paquete Stargazer se considera incompleta y puede ser rechazada.
