# Guía de Creación de Rúbricas — Stargazer Axiom

## Principios fundamentales

### Atomicidad

Cada criterio de la rúbrica debe evaluar **exactamente una cosa**, ser completamente independiente de otros criterios y tener un resultado claro de aprobado/reprobado.

#### ¿Qué significa atómico?
- Un criterio NO debe usar "y" para conectar dos verificaciones distintas → **sepáralas**
- El resultado (pass/fail) de un criterio no debe depender de si otro criterio pasa o falla

#### Ejemplos

| ❌ No atómico (evitar) | ✅ Atómico (preferido) |
|----------------------|----------------------|
| "La función valida la entrada y devuelve el formato correcto" | **Criterio A:** "La función valida que la entrada sea una cadena no vacía" <br> **Criterio B:** "La función devuelve un objeto JSON con las claves `status` y `data`" |
| "El endpoint existe, maneja errores y devuelve resultados paginados" | Tres criterios separados: existencia del endpoint, manejo de errores, paginación |

#### ¿Por qué es importante?
Cuando se agrupan criterios, la calificación se vuelve ambigua. Si una respuesta cumple solo la mitad de un criterio combinado, ¿aprueba o reprueba? Los criterios atómicos eliminan esta ambigüedad.

---

### Granularidad (Especificidad)

La consigna y la rúbrica **siempre deben estar alineadas en su nivel de detalle**.

#### La regla fundamental
No puedes referenciar en la rúbrica elementos de código específicos (rutas de archivo, nombres de funciones, endpoints, variables) a menos que esos mismos elementos estén mencionados **explícitamente** en la consigna.

**Ejemplo correcto:**
- Consigna: *"Corrige la función `handleSearch` en `SearchBar.tsx` para que filtre productos por nombre"*
- Rúbrica: *"La función `handleSearch` en `SearchBar.tsx` filtra los productos haciendo coincidir la cadena de consulta con el campo `name`"* ✅

**Ejemplo incorrecto:**
- Consigna: *"Arregla la función de búsqueda"*
- Rúbrica: *"La función `handleSearch` en `SearchBar.tsx` filtra correctamente"* ❌ — la consigna nunca mencionó ese archivo

#### Niveles de granularidad

| Especificidad de la consigna | Criterio de rúbrica correspondiente |
|-----------------------------|--------------------------------------|
| "Arregla la función de búsqueda" | "El campo de búsqueda filtra la lista de productos mostrada en función de la consulta del usuario" (comportamental, sin referencias a código) |
| "Corrige `handleSearch` en `SearchBar.tsx` para filtrar por nombre" | "La función `handleSearch` en `SearchBar.tsx` filtra los productos haciendo coincidir la cadena de consulta con el campo `name`" |

#### Cómo aplicar
1. Decide el nivel de especificidad que necesitas en la consigna
2. Redacta la consigna con ese nivel de detalle
3. Refleja **exactamente** ese mismo nivel en la rúbrica

#### Errores comunes de granularidad
- **Rúbrica demasiado específica:** hace referencia a rutas o funciones que la consigna nunca mencionó → el modelo no puede evaluarse justamente
- **Rúbrica demasiado vaga:** la consigna es detallada pero los criterios son genéricos → desperdicia la especificidad de la consigna
- **Granularidad inconsistente:** algunos criterios referencian rutas exactas y otros son conductuales, sin razón clara → mantén un nivel uniforme

---

### Pesos mínimos requeridos

| Tipo de tarea | Peso mínimo F2P + P2P |
|---------------|----------------------|
| Visual / UI | `f2p_success + p2p_success >= 20%` |
| Lógica / no visual | `f2p_success + p2p_success >= 30%` |

**La rúbrica siempre suma exactamente 100 puntos.**

---

### Criterios MECE

Los criterios deben ser **Mutuamente Excluyentes, Colectivamente Exhaustivos**:
- Sin solapamiento entre criterios
- Todos los requisitos explícitos de la consigna deben estar cubiertos

---

## Tipos de problema y ejemplos de prompts {#tipos-de-problema}

### Inyección de errores (Bug Injection)

El modelo debe *encontrar y corregir* un bug introducido intencionalmente.

**Ejemplos de issue messages:**
- "Cuando hago clic en el botón Cambiar diseño, no pasa nada. Debería cambiar de diseño inmediatamente."
- "Antes, la barra de búsqueda filtraba los resultados, pero ahora no hace nada cuando escribo."
- "Tras enviar el formulario de registro, la página se recarga, pero mi cuenta no se crea."
- "El interruptor de tema no se mantiene en modo oscuro cuando actualizo la página."
- "El total del carrito aparece como $0 incluso después de agregar artículos. Por favor, solucionen esto."

---

### Solicitud de nueva función (New Feature)

El modelo debe *implementar* una funcionalidad que no existe.

**Ejemplos:**
- "Añadir un interruptor de Modo Oscuro para que los usuarios puedan alternar entre temas claros y oscuros, y recuerde su preferencia."
- "Añadir un botón en la página del informe que permita a los usuarios descargar los datos como un archivo CSV."
- "Implementar paginación en la lista de productos para que se cargue más rápido y sea más fácil de navegar."
- "Crea una página de perfil de usuario donde las personas puedan ver y editar su información."
- "Añadir un botón para desplazarse hacia arriba que aparezca cuando los usuarios se desplacen hacia abajo en la página."

---

### Migración (Migration)

El modelo debe *migrar* tecnología, biblioteca o patrón a una versión/alternativa diferente.

**Ejemplos:**
- "Actualiza el proyecto a React Router v6 y actualiza todas las rutas en consecuencia."
- "Convierte todos los componentes de clase en componentes funcionales usando React Hooks."
- "Reemplaza los métodos de ciclo de vida obsoletos como `componentWillMount` por `useEffect`."
- "Actualice Axios a la versión 1.6 y refactoriza las llamadas a la API para que coincidan con la nueva sintaxis."
- "Migra la configuración de compilación de Webpack 4 a Vite 5 para un desarrollo más rápido."
- "Reemplazar Moment.js por Day.js para reducir el tamaño del paquete manteniendo la misma fecha, formatos, análisis sintáctico y comportamiento de zona horaria."

**⚠️ Nota para migración:** Si la tarea requiere nuevas dependencias de npm, debes usar el patrón `beforeAll` en `test_patch`. Ver `references/patch-workflow.md#dependencias`.

---

### Optimización del rendimiento (Performance)

El modelo debe *mejorar* el rendimiento sin cambiar la funcionalidad.

**Ejemplos:**
- "Optimizar el panel de control para que cargue más de 1000 filas en menos de un segundo."
- "Habilitar la carga diferida para las imágenes en la galería para mejorar el rendimiento de la página."
- "Almacenar en caché las respuestas de la API para acelerar la carga de datos y reducir las solicitudes al servidor."
- "Añade una función de retardo al campo de búsqueda para evitar llamadas excesivas a la API."
- "Refactorizar la lógica de procesamiento de datos para eliminar los bucles anidados."

---

### Mantenimiento (Maintenance)

El modelo debe *actualizar o mejorar* la calidad del código sin añadir funcionalidades.

**Ejemplos:**
- "Actualice todas las dependencias obsoletas a sus últimas versiones estables."
- "Añade la configuración de ESLint y Prettier para que el estilo del código se mantenga coherente."
- "Mejorar el registro de errores en las rutas de la API para facilitar la depuración."

---

### Mejora de pruebas (Test Improvement)

El modelo debe *añadir o mejorar* pruebas existentes.

**Ejemplos:**
- "Añadir pruebas unitarias para los módulos de autenticación y gestión de sesiones."
- "Añade informes de cobertura de pruebas al proyecto para realizar un seguimiento de los archivos y funciones que no se han probado."

**⚠️ Importante:** Si el tipo de problema es "Test Improvement", el issue message debe referirse a pruebas, NO a bugs. Error común: tipo = "Mejora de pruebas" pero el mensaje dice *"Corrige el error de exportación donde ignoreColumn es ignorado"* → eso es un bug injection, no mejora de pruebas.

---

## Objetividad en los criterios

Cada criterio debe describirse como algo **observable y que se pueda aprobar o reprobar**. Evitar palabras vagas:

| ❌ Vago (evitar) | ✅ Objetivo (usar) |
|-----------------|-------------------|
| "La respuesta debe tener un buen formato" | "La función retorna un objeto JSON con las claves `id`, `name` y `status`" |
| "El código debe ser óptimo" | "La función procesa 1000 registros en menos de 500ms" |
| "La implementación es apropiada" | "El componente muestra un mensaje de error cuando el campo está vacío" |

**Regla de los dos revisores:** si dos revisores diferentes no podrían calificar el criterio de la misma manera sin necesidad de interpretación, el criterio es demasiado subjetivo.

---

## Ejemplos reales de rúbricas buenas vs malas (del curso)

**Contexto del issue:** El toggle Mensual/Anual de la página de precios no actualiza precios ni etiquetas al cambiar a Anual. El botón se resalta correctamente, pero cada tarjeta mantiene su precio mensual y el texto "month" nunca cambia.

### ✅ Ejemplo 1 — Criterios BUENOS (atómicos, verificables)

Estos tres criterios son independientes, uno evalúa una sola cosa, y cualquier revisor puede verificarlos sin interpretar nada:

- "When 'Yearly' is selected, the Consult card shows $500."
- "The pricing card components receive the price through props rather than embedding hardcoded values."
- "The active toggle button has the orange highlight applied, and the inactive button does not."

**Por qué son buenos:**
- Cada uno prueba UNA sola cosa
- El resultado es claro: pasa o no pasa
- No necesitan interpretación

---

### ❌ Ejemplo 2 — Criterio MALO (demasiado complejo, múltiples condiciones)

> "A quote whose departureDate falls on Friday after 18:00 UTC, anywhere on Saturday, or anywhere on Sunday carries a +8% weekend surcharge on top of the seat subtotal, relative to an otherwise identical weekday daytime departure; a Friday departure before 18:00 UTC does NOT trigger the weekend surcharge."

**Por qué es malo:**
- Tiene 4 condiciones distintas combinadas en un solo criterio
- Si el modelo cumple 3 de las 4 condiciones, ¿pasa o falla? No está claro
- Debería dividirse en criterios separados: Friday after 18:00, Saturday, Sunday, Friday before 18:00

---

### ❌ Ejemplo 3 — Criterio MALO (matemática específica que mezcla dos comportamientos)

> "When a quote is BOTH a night departure (22:00-05:00 UTC) and a weekend departure, the two surcharges stack additively, yielding +20% on top of the seat subtotal (not the +21.something% that compounding would produce)"

**Por qué es malo:**
- Combina dos condiciones (noche + fin de semana) en un solo criterio
- Incluye una aclaración matemática específica que hace el criterio difícil de evaluar
- Mezcla "qué debe pasar" con "qué no debe pasar" en un solo punto

**Cómo dividirlo correctamente:**
- Criterio A: "When night departure (22:00-05:00 UTC) applies, a +12% surcharge is added to the seat subtotal."
- Criterio B: "When weekend departure applies, a +8% surcharge is added to the seat subtotal."
- Criterio C: "When both surcharges apply simultaneously, they stack additively (total +20%), not multiplicatively."

---

## Regla de oro para verificar atomicidad

Antes de confirmar un criterio, hazte esta pregunta:

> **"¿Puedo evaluar este criterio sin evaluar ninguna otra condición al mismo tiempo?"**

Si la respuesta es NO → dividelo.
Si contiene la palabra "y" o "o" uniendo dos comportamientos → dividelo.
Si necesita math o múltiples casos → dividelo.

---

## Generación del Archivo rubric.json

### Contexto

Una vez que termines la tarea en la plataforma Stargazer, la rúbrica que creaste está disponible en la interfaz de la plataforma. Necesitas **extraer esa rúbrica**, procesarla con una herramienta, y generar el archivo `rubric.json` que se entrega junto con la tarea.

### Paso 1 — Extraer el Texto de la Rúbrica desde la Plataforma

1. **Finaliza la tarea** en la plataforma Stargazer
2. Ve al panel izquierdo de la tarea
3. Haz clic en el **icono de pin** del paso "**Define criteria**"
4. **Expande TODOS los criterios** — asegúrate de que cada uno esté completamente visible
5. **Selecciona todo el texto** de la rúbrica (Ctrl+A o Cmd+A)
6. **Cópialo** (Ctrl+C o Cmd+C)

### Paso 2 — Formato Exacto Esperado

El texto que copies debe respetar estrictamente este formato (es el que la herramienta de parsing espera):

```
f2p_success
Weight: 16
Weight
16
Requirement
All tests in tests/build.f2p.test.js pass after applying the gold patch

Category
correctness

p2p_success
Weight: 16
Weight
16
Requirement
All tests in tests/build.p2p.test.js pass in both Phase 1 and Phase 2

Category
correctness

[... otros criterios ...]
```

**Estructura de cada criterio:**
- **Nombre del criterio** (ej: `f2p_success`)
- **Línea 1:** `Weight: {número}`
- **Línea 2:** `Weight`
- **Línea 3:** `{número}` (mismo que arriba)
- **Línea 4:** `Requirement`
- **Línea 5+:** Descripción del requisito (puede ser múltiples líneas)
- **Línea N:** `Category`
- **Línea N+1:** Categoría (ej: `correctness`)
- **Línea vacía** entre criterios

### Paso 3 — Usar la Herramienta de Parsing

1. Abre la **herramienta generadora de rúbricas** en la plataforma Stargazer (ubicación: panel de validación/herramientas)
2. Haz clic en el **input box**
3. **Pega el texto** que copiaste
4. Haz clic en el botón **"Parse Rubric"**
5. La herramienta procesa el texto y genera automáticamente la estructura `rubric.json`

### Paso 4 — Descargar o Copiar el Archivo

Después de hacer clic en "Parse Rubric", tienes dos opciones:

**Opción A — Descargar directamente:**
- Haz clic en **"Download rubric.json"**
- El archivo se descarga a tu carpeta de descargas
- Cópialo a la carpeta raíz de tu tarea

**Opción B — Copiar manualmente:**
- En el recuadro **RESULT**, haz clic en **"Raw JSON"**
- Copia todo el JSON
- Crea un nuevo archivo `rubric.json` en la carpeta raíz
- Pega el contenido
- Guarda el archivo

### Paso 5 — Validación

Verifica que el archivo `rubric.json` generado:

```bash
# 1. Es válido JSON
jq . rubric.json

# 2. La suma de pesos es exactamente 100
jq '[.criteria[].weight] | add' rubric.json
# Debe devolver: 100

# 3. Tiene los campos requeridos
jq '.criteria[0]' rubric.json
# Debe tener: name, weight, requirement, category
```

### Errores Comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| Error de parsing | El formato del texto copiado no coincide | Verificar que estén incluidos `Weight`, `Weight {número}`, `Requirement`, `Category` |
| Suma de pesos ≠ 100 | Entrada manual de pesos incorrecto | Verificar en la plataforma que cada peso sea exacto |
| Criterios faltantes | No expandiste todos en la plataforma | Volver a copiar asegurando que TODOS estén visibles |
| Archivo vacío | El botón "Download" descargó un archivo sin contenido | Usar "Raw JSON" y copiar manualmente |
| JSON inválido | El parser generó estructura corrupta | Intentar de nuevo; si persiste, reportar a QM |

### Estructura Final Esperada

El `rubric.json` debe tener esta estructura:

```json
{
  "criteria": [
    {
      "name": "f2p_success",
      "weight": 16,
      "requirement": "All tests in tests/build.f2p.test.js pass after applying the gold patch",
      "category": "correctness"
    },
    {
      "name": "p2p_success",
      "weight": 16,
      "requirement": "All tests in tests/build.p2p.test.js pass in both Phase 1 and Phase 2",
      "category": "correctness"
    },
    ...
  ]
}
```

**Validación de criterios:**
- ✅ Todos los criterios tienen `name`, `weight`, `requirement`, `category`
- ✅ La suma de todos los `weight` es exactamente `100`
- ✅ `f2p_success` + `p2p_success` ≥ `20%` (visual) o ≥ `30%` (lógica)
- ✅ Los nombres de criterios son únicos
- ✅ Las categorías son reconocidas (`correctness`, `feature_completeness`, etc.)

---

## Checklist de Creación de Rúbrica

- [ ] Atomicidad: cada criterio evalúa exactamente UNA cosa
- [ ] Granularidad: rúbrica y prompt tienen el mismo nivel de especificidad
- [ ] Pesos: suma exacta de 100
- [ ] F2P + P2P: mínimo 20% (visual) o 30% (lógica)
- [ ] Criterios MECE: sin solapamiento, cobertura completa
- [ ] Objetividad: sin palabras vagas ("bueno", "óptimo", etc.)
- [ ] Formato: `rubric.json` generado y validado
- [ ] Estructura: todos los criterios tienen `name`, `weight`, `requirement`, `category`
