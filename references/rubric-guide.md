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
