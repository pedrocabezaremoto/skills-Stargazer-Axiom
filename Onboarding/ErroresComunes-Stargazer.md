# Stargazer Axiom - Errores Comunes (Onboarding)

Este documento contiene la traducción y el resumen detallado de los puntos clave del curso "Common Errors" de Stargazer Axiom.

---

## TITULO Pagina 1
### Imagen 1
**Stargazer Axiom - Common Errors (Errores Comunes)**
Slide de presentación del curso enfocado en qué evitar al crear y revisar tareas en Stargazer Axiom.

### Imagen 2
**¡Bienvenido!**
Agradecimiento por el trabajo en el proyecto. Se reitera que Stargazer Axiom evalúa cómo los agentes de IA manejan cambios de código reales.

**Puntos clave:**
*   **Workflow estricto:** Cada tarea debe seguir un flujo de trabajo reproducible, desde la creación del prompt hasta las pruebas y la validación.
*   **Causa de fallos:** La mayoría de las tareas no fallan por ser "demasiado complejas", sino por **errores pequeños y evitables** durante el proceso.
*   **Objetivo del curso:** Identificar estos errores comunes de forma temprana para corregirlos antes de enviarlos.

⚠️ **IMPORTANTE:** El éxito de una tarea depende de la adherencia total al flujo de trabajo reproducible. Un error pequeño en la configuración o validación invalidará todo el esfuerzo.

---

## TITULO Pagina 2
### Imagen 1
**Falso Fallo del Modelo (False Model Failure)**
Ocurre cuando se etiqueta un problema de conexión o de API como si fuera un fallo del modelo de IA.

*   **¿Qué sucede?:** El agente se detiene por causas externas (conexión o fallos de API).
*   **¿Por qué es un problema?:** No es un fallo real del modelo y conduce a una evaluación incorrecta.
*   **¿Cómo solucionarlo?:** Regenerar la conversación y confirmar que el fallo es causado por el modelo y no por el entorno.
*   **Ejemplo:** El rastro (trace) muestra `Error: connection failed`, pero el contribuidor lo etiqueta como "model produced an invalid answer" en lugar de regenerar.

⚠️ **IMPORTANTE:** Problemas de infraestructura NO son fallos del modelo. Debes regenerar hasta obtener una respuesta o un fallo lógico real.

### Imagen 2
**Desalineación del Tipo de Problema (Issue Type Misalignment)**
El mensaje del issue no coincide con el tipo de problema (Issue Type) asignado.

*   **¿Qué sucede?:** Se define un tipo de problema, pero el prompt describe una tarea de un tipo diferente.
*   **¿Por qué es un problema?:** El objetivo de la tarea se vuelve confuso e inconsistente. Los revisores no pueden evaluarla correctamente.
*   **¿Cómo solucionarlo?:** Antes de escribir el prompt, asegúrate de que el mensaje del issue se alinee directamente con el tipo de problema asignado.
*   **Ejemplo:** Tipo de issue: *Testing Enhancement* / Mensaje: "Fix export bug" (Esto es un desajuste entre mejora de tests y corrección de bugs).

### Imagen 3
**Dockerfile No Compilable (Non-Compilable Dockerfile)**
El Dockerfile falla al intentar construirse o ejecutarse.

*   **¿Qué sucede?:** El contenedor no puede ser construido o ejecutado con éxito.
*   **¿Por qué es un problema?:** La tarea no puede ser validada ni reproducida por los revisores.
*   **¿Cómo solucionarlo?:** Construye y ejecuta el Dockerfile localmente antes de enviarlo, y depura cualquier dependencia rota o comando inválido.
*   **Ejemplo:** Al ejecutar `docker build` o `docker run` con el `base.Dockerfile` o `instance.Dockerfile`, estos fallan con errores de compilación.

### Imagen 4
**Modificaciones Inválidas en el Dockerfile (Invalid Dockerfile Modifications)**
Se modifica el Dockerfile fuera del alcance permitido o de la plantilla obligatoria.

*   **¿Qué sucede?:** El Dockerfile no sigue la plantilla requerida.
*   **¿Por qué es un problema?:** El entorno se vuelve inconsistente y puede fallar al ejecutarse como se espera.
*   **¿Cómo solucionarlo?:** Usa la plantilla de Dockerfile proporcionada y solo modifica las secciones explícitamente permitidas.
*   **Ejemplo:** Subir un `base.Dockerfile` con un comando `CMD` al final en lugar de `ENTRYPOINT ["/bin/bash"]`.

⚠️ **IMPORTANTE:** El `ENTRYPOINT` debe ser siempre `["/bin/bash"]`. No uses `CMD`.

### Imagen 5
**Nombres de Archivos Incorrectos (Wrong File Names)**
Los archivos subidos no siguen las convenciones de nombres requeridas.

*   **¿Qué sucede?:** Los archivos se envían con nombres incorrectos o inconsistentes.
*   **¿Por qué es un problema?:** Los linters fallan y la tarea puede ser invalidada automáticamente.
*   **¿Cómo solucionarlo?:** Sigue exactamente la nomenclatura de archivos especificada en las guías.
*   **Ejemplo:** Subir `run_tests.sh` en lugar de `run_script.sh`.

### Imagen 6
**Falta de Cobertura en la Rúbrica (Missing Rubric Coverage)**
La rúbrica no incluye todos los requisitos explícitos mencionados en el prompt.

*   **¿Qué sucede?:** Algunos requisitos del prompt no están representados en la rúbrica.
*   **¿Por qué es un problema?:** La evaluación queda incompleta y no refleja la tarea completa.
*   **¿Cómo solucionarlo?:** Asegúrate de que **cada requisito explícito** tenga un criterio de rúbrica correspondiente.
*   **Ejemplo:** El prompt pide funciones para `hexToRgbA`, `colorLuminance`, `lighten` y `darken`, pero la rúbrica solo evalúa las dos primeras.

### Imagen 7
**Criterios Vagos o Subjetivos (Vague Or Subjective Criteria)**
Los criterios de la rúbrica son poco claros, subjetivos o no medibles.

*   **¿Qué sucede?:** Los criterios usan lenguaje vago o carecen de reglas de validación claras.
*   **¿Por qué es un problema?:** Diferentes revisores pueden interpretar y calificar de forma distinta.
*   **¿Cómo solucionarlo?:** Escribe criterios como verificaciones **específicas, observables y medibles** vinculadas a un solo requisito a la vez.
*   **Ejemplo:** Criterios como "La respuesta debe tener buen formato" o "El código debe ser óptimo" son inaceptables por ser subjetivos.

### Imagen 8
**Pesos de Criterios Incorrectos (Incorrect Criteria Weights)**
Los criterios de prueba (F2P/P2P) no alcanzan el umbral de peso mínimo requerido.

*   **¿Qué sucede?:** Se asigna muy poco peso a los criterios F2P y P2P.
*   **¿Por qué es un problema?:** Las pruebas quedan subrepresentadas en la evaluación.
*   **¿Cómo solucionarlo?:** Asegúrate de que la suma de **F2P + P2P sea al menos el 20%** del peso total antes de asignar pesos a otros criterios.
*   **Ejemplo:** En una rúbrica de 100 puntos, `f2p_success = 5` y `p2p_success = 5` suman solo 10%, lo cual está por debajo del **20% obligatorio** para criterios de tests.

⚠️ **IMPORTANTE:** La suma de los pesos de `f2p_success` y `p2p_success` debe ser >= 20.

### Imagen 9
**Parche de Solución Incorrecto (Incorrect Solution Patch)**
La solución no resuelve el problema planteado o introduce nuevos errores.

*   **¿Qué sucede?:** El parche no arregla el issue o rompe funcionalidades existentes.
*   **¿Por qué es un problema?:** La tarea se vuelve inválida y falla la validación técnica.
*   **¿Cómo solucionarlo?:** Verifica que el parche resuelva **completamente** el problema del prompt y preserve el comportamiento original (sin regresiones).
*   **Ejemplo:** El prompt pide arreglar un crash con entrada vacía, pero tras aplicar el parche, tanto los tests F2P como P2P fallan, mostrando que el problema persiste.

### Imagen 10
**Cobertura de Pruebas Incompleta (Incomplete Test Coverage)**
Las pruebas no cubren todos los requisitos explícitos del prompt.

*   **¿Qué sucede?:** Algunos comportamientos requeridos no tienen pruebas asociadas.
*   **¿Por qué es un problema?:** La solución no está validada por completo.
*   **¿Cómo solucionarlo?:** Añade al menos **un test F2P por cada requisito explícito**, y añade tests P2P para funciones relacionadas que puedan verse afectadas.
*   **Ejemplo:** El prompt pide cambios en los servicios de "Account" (Cuenta) y "Cart" (Carrito), pero los tests F2P solo comprueban los métodos de "Account".

### Imagen 11
**Pruebas Irrelevantes (Irrelevant Tests)**
Las pruebas no coinciden con el issue o el área de código modificada.

*   **¿Qué sucede?:** Las pruebas validan partes del código base que no tienen relación con el problema planteado.
*   **¿Por qué es un problema?:** La evaluación se vuelve engañosa e ineficaz.
*   **¿Cómo solucionarlo?:** Asegúrate de que los tests F2P sean relevantes para el problema explícito y que los P2P cubran el área o módulo relacionado correcto.
*   **Ejemplo:** El prompt pide un cambio de color en la barra de navegación (navbar). Los tests F2P se enfocan en los botones de la barra, mientras que los P2P se enfocan en los servicios del Carrito (Cart services).

### Imagen 12
**Pruebas Inválidas (Invalid Tests)**
Las pruebas validan la implementación (estructura) en lugar del comportamiento.

*   **¿Qué sucede?:** Las pruebas verifican contenido estático o la presencia de un archivo en lugar del comportamiento real.
*   **¿Por qué es un problema?:** No demuestran que la solución realmente funcione.
*   **¿Cómo solucionarlo?:** Escribe **pruebas de comportamiento** (behavioral tests) que ejecuten la funcionalidad y validen el resultado esperado.
*   **Ejemplo:** El prompt pide una nueva función de suma que sume dos números y muestre el resultado, pero el test F2P solo usa `grep` para verificar que la función existe.

### Imagen 13
**Archivo de Salida Faltante (Missing Output File)**
El script de parseo (`parse_results.sh`) no genera el archivo de salida JSON requerido.

*   **¿Qué sucede?:** Los resultados se imprimen en la consola (`stdout`) pero no se guardan en el archivo JSON obligatorio.
*   **¿Por qué es un problema?:** El sistema no puede capturar ni validar los resultados de las pruebas adecuadamente.
*   **¿Cómo solucionarlo?:** Asegúrate de que el script escriba la salida tanto en `stdout` como en **/app/test_results.json** (se recomienda usar el comando `tee`).
*   **Ejemplo:** `parse_results.sh` imprime un resumen JSON en la terminal, pero nunca escribe el archivo `/app/test_results.json`.

⚠️ **IMPORTANTE:** El archivo `/app/test_results.json` es la única fuente de verdad para el sistema de calificación. Debe ser generado físicamente.

### Imagen 14
**Artefactos de Parche Desactualizados (Outdated Patch Artifacts)**
Los parches incluyen rutas de archivos o estructuras de directorios desactualizadas.

*   **¿Qué sucede?:** Referencias a directorios como `/base` o `/instance` permanecen dentro del archivo de parche.
*   **¿Por qué es un problema?:** El parche no coincide con la estructura de proyecto actual (basada en `/app`).
*   **¿Cómo solucionarlo?:** Regenerar el parche usando la estructura de directorio `/app` actualizada y elimina cualquier prefijo desactualizado.
*   **Ejemplo:** El parche intenta modificar un archivo bajo `base/Front End/components/Button.js` incluso cuando la estructura actualizada coloca el archivo directamente bajo `Front End/components/Button.js`.

---

## TITULO Pagina 3
### Imagen 1
**Verificación Final (Final Check)**
En Stargazer Axiom, las tareas se evalúan como flujos de trabajo completos, no como partes individuales. Incluso pequeñas inconsistencias entre el prompt, la solución, los tests o el entorno pueden invalidar toda la entrega.

**Lista de revisión (Review end-to-end):**
1.  **Definición de la Tarea:** El tipo de problema, la descripción y el prompt están alineados y tienen un alcance claro.
2.  **Calidad de la Solución:** El parche resuelve completamente el problema sin romper la funcionalidad existente.
3.  **Pruebas y Validación:** Todos los requisitos explícitos están cubiertos y los tests validan el comportamiento (no la implementación).
4.  **Cobertura de la Rúbrica:** Cada requisito está representado con criterios claros y medibles.
5.  **Configuración del Entorno:** Los Dockerfiles se construyen correctamente y el flujo de trabajo se ejecuta sin errores.
6.  **Salidas y Archivos:** Los archivos requeridos están presentes, correctamente nombrados y guardados en las ubicaciones esperadas.

⚠️ **IMPORTANTE:** Una revisión rápida y estructurada asegura que tu tarea sea consistente, reproducible y esté lista para la evaluación. **No envíes nada sin pasar por este checklist.**
