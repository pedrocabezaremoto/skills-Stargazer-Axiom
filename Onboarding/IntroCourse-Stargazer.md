# Onboarding Stargazer Axiom - Notas del Curso

Este documento contiene la traducción y resumen de los puntos clave del curso de introducción de Stargazer Axiom en Outlier.

---

## TITULO Pagina 1
### Imagen 1
**Stargazer Axiom - Curso de Introducción para Attempters**
Slide de bienvenida al curso de inducción para el rol de "Attempter" (el que realiza la tarea).

### Imagen 2
**¡Bienvenido!**
El propósito de Stargazer Axiom es crear una base de datos de solicitudes de problemas técnicos (issue requests) desafiantes para un repositorio. Esta base de datos se utilizará para evaluar (benchmark) y mejorar la capacidad de los agentes de programación para implementar cambios en un código base.

**Para lograr esto, deberás:**
*   Construir un **proyecto estándar (setup)** alrededor de un repositorio asignado.
*   Crear un **prompt desafiante** solicitando cambios en el código base.
*   Verificar que el **modelo falle** al intentar responder adecuadamente.
*   Escribir tu propia **solución** al problema planteado.
*   Crear **pruebas unitarias (unit tests)** para verificar tu solución.
*   Componer una **rúbrica** que se pueda usar para calificar qué tan exitoso fue el agente.
*   **Subir parches, scripts y archivos Docker** para que tu flujo de trabajo pueda ser reproducido.

---

## TITULO Pagina 2
### Imagen 1
**Flujo de Trabajo (Workflow)**
Aquí se detalla cómo se ve el proceso en la práctica mientras realizas la tarea:

1.  **Configuración y análisis (Setup and analysis):** Clonarás el repositorio asignado y configurarás tu entorno, luego explorarás el código base para entender su estructura y funcionalidad.
2.  **Creación del problema y solución (Issue creation and solution):** Escribirás un prompt que pida al agente realizar cambios en el código (ej. corrección de errores o nuevas funciones), verificarás que al menos un modelo falle al resolverlo y luego escribirás tu propia solución al prompt.
3.  **Pruebas (Testing):** Crearás pruebas unitarias para verificar si una solución dada añade toda la funcionalidad solicitada sin romper ninguna funcionalidad existente.
4.  **Docker y scripts:** Prepararás los Dockerfiles y scripts para asegurar que tu trabajo sea reproducible.
5.  **Script de validación (Validation script):** Ejecutarás un script para verificar que tu solución pase todas las pruebas unitarias.
6.  **Etiquetas (Tags):** Añadirás etiquetas relevantes a tu tarea para categorizarla.
7-8. **Creación de rúbrica y parser (Rubric creation & parser):** Escribirás una rúbrica que consiste en una serie de criterios para calificar qué tan buena o mala es la respuesta a tu prompt, luego usarás un parser para generar el archivo .json.
9.  **Evaluar tu tarea (Evaluate your task):** Ejecutarás un script para verificar la calidad y alineación de los componentes de tu tarea.
---

## TITULO Pagina 3
### Imagen 1
**Paso 1: Configuración y análisis (1/2) - Estructura de Directorios**
Es obligatorio usar esta estructura para organizar el proyecto:

*   **App/**: El repositorio clonado desde GitHub.
*   **dockerfiles/**: Contiene `base.Dockerfile` e `instance.Dockerfile`. Se usan para configurar el entorno creando `/app`, clonando el repo e instalando dependencias.
*   **scripts/**: Contiene `run_script.sh` y `parse_results.sh`. Aplican parches, ejecutan pruebas y parsean resultados.
*   **patches/**: Contiene `gold_patch.patch`, `test_patch.patch` y `basetoinstance.patch`. Son los cambios realizados al repositorio en `/app`.
*   **test_results.json**: El archivo JSON de salida con los resultados de las pruebas.

### Imagen 2
**Paso 1: Configuración y análisis (2/2) - Tipos de problemas (Issue Types)**
Al explorar el código, debes pensar qué tipo de problema escribirás:

*   **Solicitud de nueva función (New feature request):** Añadir funcionalidad que no existe actualmente.
*   **Inyección y resolución de errores (Bug injection & resolution):** Introducir un cambio que rompa el código y pedir al modelo que lo arregle.
*   **Migración (Migration):** Adaptar parte o todo el código a una nueva librería o patrón sin perder la funcionalidad original.
*   **Optimización de rendimiento (Performance Optimization):** Mejorar velocidad o eficiencia sin cambiar la funcionalidad original.
*   **Mantenimiento / Mejora de pruebas (Maintenance / testing enhancement):** Actualizar dependencias, pruebas o herramientas.

### Imagen 3
**Paso 2: Creación del problema y solución (1/4) - Calidad del Prompt**
Principios para prompts de alta calidad:

*   **Específico:** Define el problema claramente y sin ambigüedades. El modelo debe poder tener éxito, pero no le des la solución en el prompt.
*   **Realista:** Escribe el prompt como si fuera un "issue" real de GitHub, con lenguaje conciso.
*   **Objetivo:** Cada requisito debe ser comprobable mediante una prueba unitaria. Debes visualizar cómo escribirías la solución y los tests antes de enviarlo al modelo.
*   **NOTA:** La rúbrica y el prompt deben estar alineados en especificidad. Menciona explícitamente nombres de archivos, funciones o módulos.

### Imagen 4
**Paso 2: Creación del problema y solución (2/4) - Dificultad del Prompt**
Evalúas la dificultad contando cuántas de estas señales aplican:

*   **Propagación (Spread):** La solución cambia 3 o más archivos.
*   **Interacción entre módulos:** El arreglo afecta a más de una parte del proyecto.
*   **Conocimiento arquitectónico:** Para arreglarlo, necesitas entender cómo está organizado el proyecto.
*   **Lógica no trivial:** El arreglo requiere toma de decisiones, no solo renombrar o mover archivos.
*   **Casos de borde implícitos:** La solución debe manejar casos especiales o errores posibles.
*   **Riesgo de regresión:** Un mal arreglo podría romper accidentalmente otra cosa.

**Escala:** Fácil (1-2 señales), Medio (3-4), Difícil (5+).

### Imagen 5
**Paso 2: Creación del problema y solución (3/4) - Probar que el modelo falle**
Debes asegurar que al menos un modelo falle:

1.  Abre la carpeta `app/` en Cursor. Cierra otras carpetas para que la IA no vea los parches de solución.
2.  Pega el mensaje del issue en cada modelo (ej. Claude, GPT) y ejecútalos.
3.  Si ambos modelos dan una solución válida: **Reescribe / ajusta el prompt** para aumentar la complejidad.
4.  Si al menos uno falla: Extrae el rastro (trace) del fallo del modelo.
### Imagen 6
**Paso 2: Creación del problema y solución (4/4) - Solución Maestra (Golden Solution)**
Una vez que el modelo falla, crearás tu propia **Solución Maestra** que represente una solución completa e impecable al problema planteado.

*   **Ubicación:** `patches/gold_patch.patch`.
*   **Implementación:** Realiza la solución en la rama del issue y luego crea el parche.

### Imagen 7
**Paso 3: Pruebas (1/2) - Pruebas Unitarias**
Debes escribir pruebas para validar si CUALQUIER solución resuelve tu enunciado. Escribirás pruebas de comportamiento (behavioral), no de estructura.

*   **F2P (Fail-to-Pass):** Falla antes del arreglo, Pasa después. Propósito: Verificar el nuevo comportamiento o la corrección del bug.
*   **P2P (Pass-to-Pass):** Pasa antes y después del arreglo. Propósito: Confirmar que las funciones existentes siguen funcionando (evitar regresiones).

**Ejemplos por tipo de problema:**
*   **Bug Injection:** Verificar que el error se corrigió (ej. el estado se actualiza correctamente).
*   **New Feature:** Verificar que la función existe y funciona (ej. un botón genera un CSV válido).
*   **Migration:** Verificar que la nueva librería/patrón funciona correctamente.
*   **Performance:** Benchmarks que muestran mejora o cumplen estándares (ej. renderizado en <100ms).

### Imagen 8
**Paso 3: Pruebas (2/2) - Requisitos de los Tests**
*   **Nombres de archivos:** Usa `**/*.f2p.test.{ext}` para F2P y `**/*.p2p.test.{ext}` para P2P. Esto permite que el parser los detecte.
*   **Parche limpio:** Asegúrate de que el parche se aplique limpiamente usando `git apply --ignore-whitespace`.
*   **Solo archivos de prueba:** El `test_patch.patch` NO debe contener cambios al código de la aplicación, pruebas existentes, dependencias o archivos de configuración.

### Imagen 9
**Paso 4: Docker y Scripts - Componentes Requeridos**
*   **Run Script (`run_script.sh`):** Aplica el parche de prueba, ejecuta tests, aplica el parche de solución y vuelve a ejecutar los tests.
*   **Parse Script (`parse_results.sh`):** Parsea la salida del Run Script y genera un archivo JSON.
*   **Base Dockerfile:** Configura el entorno original y clona el repo en `/app`. NO copies scripts, parches ni tests dentro del Dockerfile.
*   **Instance Dockerfile:** Extiende la imagen base para crear el estado del problema (en tareas de Inyección de Bugs).

### Imagen 10
**Paso 5: Script de Validación**
Descarga `validation_script.zip` y ejecútalo para verificar automáticamente:
*   Estructura del proyecto (directorios y archivos requeridos).
*   Construcción de imágenes Docker (Base e Instance).
*   Ejecución del contenedor de instancia (ejecutando `run_script.sh` y `parse_results.sh`).
*   Validación de resultados para estados pre-parche y post-parche.

### Imagen 11
**Paso 6: Añadir etiquetas (Tags)**
Para ayudar a categorizar la tarea, añadirás etiquetas relevantes a tu problema. Si no encuentras una etiqueta específica, puedes seleccionar "Other" (Otro) para añadirla manualmente.

### Imagen 12
**Paso 7: Creación de Rúbrica**
Una rúbrica es un conjunto de criterios usados para calificar de manera objetiva y granular qué tan buena es la respuesta a un prompt.

**Pautas básicas para la rúbrica:**
*   Puedes escribir tantos criterios como sean necesarios.
*   **Cada criterio debe coincidir con una o más partes del prompt.** Si no tiene contraparte en el prompt, es probable que sea demasiado específico o ambiguo.
*   Puede haber cero, uno o múltiples criterios por dimensión de calidad.
*   Asignarás pesos a cada criterio basándote en su importancia para el problema.
*   La dimensión de **"Correctness" (Corrección)** debe tener al menos un criterio y representar al menos el **10%** del peso total.
*   No seas tan restrictivo que excluyas otras soluciones posibles que también sean buenas.

### Imagen 13
**Paso 8: Parser de Rúbricas**
Usa la herramienta web `https://v0-stargazer.vercel.app/`:
1.  Copia tus rúbricas de la taxonomía y pégalas en el área de texto.
2.  Haz clic en **Parse Rubric** y corrige cualquier campo faltante resaltado en rojo.
3.  Cambia a **Raw JSON** y verifica que la salida se vea correcta.
4.  Haz clic en **Download rubric.json**.

### Imagen 14
**Paso 9: Evaluar tu tarea**
Descarga `Stargazer_Eval.zip` y sigue estos pasos:
1.  Descomprímelo en el directorio raíz de tu tarea y sigue `HOW_TO_RUN_EVAL.md`.
2.  Revisa el reporte consolidado: muestra un veredicto de **PASS/FAIL** para cada componente (Prompt, Tests, Rúbrica, Alineación, Granularidad, Dockerfile y Parche Maestro).
3.  Corrige cualquier componente en **FAIL** usando la tabla "How to Fix" (Cómo arreglar) del reporte.
4.  Vuelve a ejecutar la evaluación hasta que todos los componentes muestren **PASS**.
5.  Si modificaste algún archivo, vuelve a ejecutar el Script de Validación antes de volver a subirlo.
6.  **¡Envía tu tarea!**

---

## TITULO Pagina 4
### Imagen 1
**Principios Básicos de los Criterios de la Rúbrica**
Mantén estos seis principios en mente para asegurar que tus rúbricas sean robustas:

*   **Autocontenido (Self-containment):** Debe ser posible decir si la respuesta pasa un criterio solo mirando la respuesta y el criterio, sin necesidad del prompt o información externa.
*   **Sin Ambigüedad (No Ambiguity):** Vincula los criterios a factores medibles o descripciones inequívocas. Evita lenguaje como "secciones importantes", "renderizado apropiadamente" o "debería verse bien".
*   **Relevancia (Relevance):** Cada criterio debe rastrearse hasta un requisito explícito en el prompt o mejorar claramente la respuesta.
*   **Atomicidad (Atomicity):** Cada criterio debe probar uno y solo un aspecto distinto de la respuesta.
*   **Especificidad (Specificity):** Haz referencia a fragmentos de código específicos, elementos de la interfaz, valores de datos o rutas de archivos.
*   **Granularidad Consistente:** El nivel de detalle debe ser el mismo en todos los criterios. Si unos referencian rutas o APIs específicas, todos deberían hacerlo.

### Imagen 2
**Dimensiones de Calidad de la Rúbrica**
Tus criterios cubrirán las siguientes dimensiones. Todas son opcionales **excepto Corrección (Correctness)**:

*   **Corrección (Correctness) [OBLIGATORIO]:** ¿El código generado entrega el requisito funcional completo? Incluye corrección sintáctica y lógica. Debe tener al menos un criterio y el 10% del peso total, **más** un 20% adicional para los tests F2P y P2P.
*   **Independencia (Independence):** ¿El código generado está libre de componentes o dependencias innecesarias?
*   **Legibilidad/Extensibilidad (Readability/Extensibility):** ¿El código está bien presentado y documentado?
*   **Eficiencia de Ejecución (Execution Efficiency):** ¿El código está libre de ineficiencias significativas en memoria y latencia?
*   **Estética Visual (Visual Aesthetics):** ¿Los elementos visuales son atractivos según los estándares de diseño populares?

### Imagen 3
**Formato de Criterios y Ejemplo**
Requisitos clave para los criterios:

*   Cada criterio debe tener un texto de ID (título), texto de requisito (descripción), peso (weight) y dimensión.
*   El **texto de ID (título)** debe seguir el formato `"rubric_criteria"`; por ejemplo: `"composer_setup"`.
*   La **suma de todos los pesos debe ser 100**.
*   Debes añadir criterios de pruebas unitarias (F2P y P2P) bajo la dimensión de Corrección:
    *   Los IDs deben ser exactamente `f2p_success` y `p2p_success`, respectivamente.
    *   No deben referenciar módulos o casos de prueba específicos.
    *   Deben representar al menos el **20% del peso total**, además del 10% asignado a otros criterios en la dimensión de Corrección.

---

## TITULO Pagina 5
### Pregunta 1
**Original:** What is the primary purpose of the Stargazer Axiom project?
**Traducción:** ¿Cuál es el propósito principal del proyecto Stargazer Axiom?
**Respuesta:** **B) To create a database of challenging issue requests to benchmark coding agents** (Crear una base de datos de solicitudes de problemas desafiantes para evaluar agentes de programación).

### Pregunta 2 (Multiselección)
**Original:** Which of the following are required components of a task? (Select all that apply)
**Traducción:** ¿Cuáles de los siguientes son componentes requeridos de una tarea? (Selecciona todos los que apliquen)
**Respuesta:** **A, B, D, E**.
*   **A) Writing a challenging prompt** (Escribir un prompt desafiante).
*   **B) Ensuring at least one model fails** (Asegurar que al menos un modelo falle).
*   **D) Creating unit tests** (Crear pruebas unitarias).
*   **E) Writing a rubric** (Escribir una rúbrica).

### Pregunta 3
**Original:** In the workflow, what is the purpose of Step 3: Testing?
**Traducción:** En el flujo de trabajo, ¿cuál es el propósito del Paso 3: Pruebas (Testing)?
**Respuesta:** **B) To verify that solutions (including your own Golden Solution) add requested functionality without breaking existing features** (Verificar que las soluciones añadan la funcionalidad solicitada sin romper las características existentes).

### Pregunta 4
**Original:** Which directory contains the changes made to the repository?
**Traducción:** ¿Qué directorio contiene los cambios realizados al repositorio?
**Respuesta:** **C) patches/** (El directorio que contiene los archivos de parche como `gold_patch.patch`).

### Pregunta 5 (Multiselección)
**Original:** Which of the following are characteristics of a high-quality prompt? (Select all that apply)
**Traducción:** ¿Cuáles de las siguientes son características de un prompt de alta calidad? (Selecciona todas las que apliquen)
**Respuesta:** **A, C, D**.
*   **A) Specific and unambiguous** (Específico y sin ambigüedades).
*   **C) Realistic and written like a GitHub issue** (Realista y escrito como un "issue" de GitHub).
*   **D) Fully testable via unit tests** (Totalmente comprobable mediante pruebas unitarias).

### Pregunta 6
**Original:** What must you do if both models successfully solve your prompt?
**Traducción:** ¿Qué debes hacer si ambos modelos resuelven con éxito tu prompt?
**Respuesta:** **D) Increase complexity or add constraints and retry** (Aumentar la complejidad o añadir restricciones y volver a intentarlo. El objetivo es que al menos un modelo falle).

### Pregunta 7
**Original:** Where should the Golden Solution patch be located?
**Traducción:** ¿Dónde debe estar ubicado el parche de la Solución Maestra (Golden Solution)?
**Respuesta:** **C) patches/gold_patch.patch** (Todos los parches de solución deben ir en la carpeta `patches/`).

### Pregunta 8
**Original:** What is the difference between F2P and P2P tests?
**Traducción:** ¿Cuál es la diferencia entre las pruebas F2P y P2P?
**Respuesta:** **B) F2P tests fail before and pass after; P2P tests pass before and after** (Las pruebas F2P fallan antes del arreglo y pasan después; las pruebas P2P pasan tanto antes como después del arreglo).

### Pregunta 9 (Multiselección)
**Original:** Which of the following statements about rubric requirements are TRUE? (Select all that apply)
**Traducción:** ¿Cuáles de las siguientes afirmaciones sobre los requisitos de la rúbrica son VERDADERAS? (Selecciona todas las que apliquen)
**Respuesta:** **A, B, D, E**.
*   **A) The total weight must equal 100** (El peso total debe ser igual a 100).
*   **B) Correctness must have at least one criterion and >=10% weight** (La dimensión de Corrección debe tener al menos un criterio y un peso mayor o igual al 10%).
*   **D) F2P and P2P criteria must be included under Correctness** (Los criterios F2P y P2P deben incluirse bajo la dimensión de Corrección).
*   **E) Criteria should map to the prompt** (Los criterios deben mapearse o corresponder a los requisitos del prompt).
    *(La C es falsa porque los criterios NUNCA deben ser vagos).*




