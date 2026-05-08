# Criterios de Evaluación para Revisores — Referencia Completa

Este archivo contiene las tablas detalladas de criterios de evaluación organizadas por dimensión.
Consulta esta referencia durante el Paso 9 (Revisar Rúbrica) y para calificar los criterios de la tarea.

---

## Tabla de Criterios — Dimensión: Inmediato (Prompt)

### Claridad Inmediata / Especificidad / Único / Verdad sobre el Terreno

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | No está claro qué se pregunta; la indicación es extremadamente difícil de seguir o demasiado vaga; la intención del usuario no puede comprenderse razonablemente |
| **1–2 (Fallo)** | Faltan detalles importantes necesarios para responder que no pueden asumirse razonablemente |
| **3–4** | En general está claro lo que se pregunta; puede haber diferentes interpretaciones razonables, pero todas darán el mismo resultado |
| **5 (Perfecto)** | La consigna es clara, específica y carece de ambigüedad |

### Dominio / Pertinencia

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Error - Tipo de problema incorrecto]` La solicitud no cumple con el tipo de problema |
| **3–4** | `[Sin fallo - Indicación de relevancia del dominio]` La consigna está vagamente conectada, o puede interpretarse como relacionada |
| **5 (Perfecto)** | La consigna se ajusta claramente al tipo de problema |

### Modelo Válido / Falla

| Nota | Descripción |
|------|-------------|
| *Nota para auditores* | Si la consigna se modifica para coincidir con la especificidad de la rúbrica, no es necesario actualizar el registro; puede contener versión anterior de la consigna |
| **1–2 (Fallo)** | `[Fallo - No hay fallo del modelo/Falta de traza]` La solicitud no provoca que al menos un modelo falle en ningún criterio (implícito/explícito). No se proporcionó ningún fallo de seguimiento del modelo |
| **1–2 (Fallo)** | El fallo en la respuesta del modelo se basa en una interpretación ambigua (la solicitud puede interpretarse de varias maneras y el modelo eligió una interpretación válida) |
| **N/A** | — |
| **5 (Perfecto)** | El fallo del modelo es evidente y se basa en una solicitud clara en el mensaje |

---

## Tabla de Criterios — Dimensión: Alineación Consigna → Rúbrica

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Alineación de la rúbrica de la solicitud]` Referencias a archivos, funciones, clases o API específicas en la rúbrica que no se mencionan en el enunciado |
| **1–2 (Fallo)** | Discrepancia en granularidad: La rúbrica es significativamente más específica que la consigna |
| **3–4** | `[Sin fallo - Desalineación menor]` La rúbrica y la consigna están mayormente alineadas con pequeñas discrepancias; algunos criterios requieren inferencia razonable |
| **3–4** | Se mencionan los elementos clave, pero los requisitos de especificidad podrían ser más claros |
| **5 (Perfecto)** | La consigna y la rúbrica están completamente alineadas en especificidad y granularidad |

### Ejemplos Prácticos de Alineación

**Ejemplo de desalineación (FALLO):**
- Mensaje: *"Agrega un interruptor de modo oscuro a la aplicación"*
- Rúbrica: `{ "id": "El componente Theme Toggle existe", "requirement": "El archivo src/components/ThemeToggle/ThemeToggle.tsx existe y exporta el componente ThemeToggle", "weight": 10 }`
- Solución incorrecta: hacer indicaciones demasiado específicas para que coincidan con requisitos cuantitativos de la rúbrica

**Referencias de archivos — Casos (NO FALLO):**
- Mensaje: *"Modificar AuthenticationService"* → Rúbrica: *"src/services/auth/AuthenticationService.ts se modifica"* ✅
- Mensaje: *"Modificar src/services/auth/AuthenticationService.ts"* → Rúbrica: *"El servicio de autenticación se ha modificado"* ✅
- Mensaje: *"Actualice el servicio de autenticación"* (no específico) → Rúbrica: *"AuthenticationService es actualizado"* ✅

> **Nota**: Los nombres de archivo en rúbrica no necesitan ser idénticos a los de la consigna, siempre que se refieran claramente al mismo elemento.

---

## Tabla de Criterios — Dimensión: Rúbrica / Criterios

### Objetividad / Especificidad

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Al menos un criterio correspondiente a un requisito explícito es subjetivo, demasiado vago, demasiado amplio o imposible de medir (ej: *"la respuesta debe tener un buen formato"* o *"el código debe ser óptimo"*) |
| **N/A** | — |
| **5 (Perfecto)** | Todos los criterios son objetivos y directamente vinculados a factores cuantificables o cualitativos que pueden describirse de manera libre de ambigüedades |

### Cobertura

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Cobertura faltante]` La rúbrica carece de al menos un criterio que verifique un requisito explícito o una expectativa implícita crítica de la consigna |
| **3–4** | `[No falla - Cobertura faltante]` La rúbrica carece de criterios que verifiquen la expectativa implícita NO crítica de la consigna. Al menos una dimensión debería haberse cubierto pero no lo fue |
| **5 (Perfecto)** | La rúbrica es exhaustiva y verifica colectivamente todos los requisitos explícitos y expectativas implícitas de la consigna |

### Exactitud / Precisión

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Al menos un criterio verifica algo que contradice lo que se requiere explícitamente en la consigna |
| **1–2 (Fallo)** | Al menos uno de los criterios contiene un error de hecho o un punto engañoso |
| **1–2 (Fallo)** | Al menos uno de los criterios no es un requisito explícito en la consigna y su implementación no mejora la respuesta |
| **3–4** | `[Sin fallos - Precisión de la categoría]` Al menos uno de los criterios tiene la categoría incorrecta. Nota: No marcar si la categoría seleccionada aplica, pero otra se ajusta mejor |
| **5 (Perfecto)** | Todos los criterios de la rúbrica representan con precisión los requisitos explícitos e implícitos de la consigna |

### Atomicidad

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Atomicidad de criterios]` Al menos un criterio agrupa dos o más restricciones no relacionadas — elemento sin enfoque claro |
| **1–2 (Fallo)** | Al menos 1 criterio incluye múltiples restricciones solo parcialmente relacionadas |
| **3–4** | `[No fallar - Atomicidad de los criterios]` Como máximo 3 criterios incluyen múltiples restricciones parcialmente relacionadas, pero todas pueden interpretarse como parte de una instrucción coherente |
| **5 (Perfecto)** | Todos los criterios son razonablemente atómicos |

> **Importante**: Los criterios f2p y p2p deben estar contenidos dentro de `f2p_success` y `p2p_success` respectivamente.

---

## Tabla de Criterios — Dimensión: Rúbrica / Pesos

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Los pesos de la rúbrica no suman 100 |
| **1–2 (Fallo)** | La combinación de F2P + P2P es < 20% |
| **3–4** | `[No fallar - Ponderaciones]` La combinación de F2P + P2P representa al menos el 20%, pero menos del 30% para componentes no visuales o con mucha lógica |
| **5 (Perfecto)** | Todos los pesos de los criterios reflejan con precisión su impacto y suman 100. Cada dimensión de calidad presente tiene al menos 10 puntos. Las pruebas unitarias representan al menos el 20% del peso (o 30% si son no visuales/lógica compleja) |

### Umbrales mínimos F2P + P2P:
- **Componentes visuales**: `f2p_success + p2p_success >= 20%`
- **Componentes no visuales o con mucha lógica**: `f2p_success + p2p_success >= 30%`

---

## Tabla de Criterios — Dimensión: Rúbrica / Formato

**Formato adecuado de un criterio:**
```
id: Título del criterio (lo que se ve en vista colapsada)
Peso: número entero positivo
Requisito: lo que realmente debe hacer la respuesta para cumplir el criterio
Categoría: dimensión seleccionada de las 5 disponibles
```

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Al menos 1 criterio no sigue el formato correcto |
| **1–2 (Fallo)** | Dos criterios comparten un identificador (título) idéntico |
| **N/A** | — |
| **5 (Perfecto)** | Todos los criterios siguen el formato adecuado |

---

## Tabla de Criterios — Dimensión: Rúbrica / Autónomo

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Criterios autónomos]` Al menos un criterio no puede evaluarse contra la respuesta modelo sin acceso a la consigna, texto de referencia y/o hechos externos. Es decir, hace referencia al contexto (ej: "el problema", "el error") sin reformular completamente |
| **3–4** | `[Criterios autocontenidos que no implican fallos]` Al menos un criterio de la rúbrica no puede evaluarse sin acceso al contenido de otros criterios de la rúbrica. Nota: Si otros criterios proporcionan suficiente contexto, usar categoría NO SUSPENSO |
| **5 (Perfecto)** | Ninguno de los criterios requiere consultar la pregunta original o recursos externos para evaluar respuestas |

**Ejemplo correcto (autónomo):**
> *"La respuesta identifica al primer presidente de los Estados Unidos como George Washington"*

**Ejemplo incorrecto (no autónomo):**
> *"La respuesta aborda el error cuando el contexto completo existe en otra parte de la rúbrica"*

---

## Tabla de Criterios — Dimensión: Solución/Gold Patch / Exactitud

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Solución incorrecta]` La solución no resuelve el problema descrito en la instrucción |
| **1–2 (Fallo)** | La solución introduce nuevos errores o rompe la funcionalidad existente |
| **1–2 (Fallo)** | La solución es incompleta o aborda solo una parte de los requisitos |
| **3–4** | `[Sin fallos - Problemas menores de corrección]` La solución aborda el problema principal/requisitos, pero tiene pequeñas deficiencias o casos no resueltos |
| **3–4** | La solución funciona correctamente, pero la implementación tiene áreas que podrían ser más robustas |
| **3–4** | Se han cumplido todos los requisitos principales, pero con problemas menores |
| **5 (Perfecto)** | Todos los requisitos se abordaron correctamente sin introducir nuevos errores |

---

## Tabla de Criterios — Dimensión: Pruebas

### Prueba F2P — Cobertura

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Pruebas F2P faltantes/irrelevantes]` Las pruebas F2P no cubren los requisitos explícitos de la solicitud, o hay grandes lagunas en la cobertura |
| **3–4** | `[Prueba sin fallo - Prueba redundante/irrelevante]` Las pruebas son redundantes pero la funcionalidad requerida está cubierta. Algunas pruebas cubren comportamiento no explícito en la solicitud pero relevante para el problema o cubre un requisito implícito |
| **5 (Perfecto)** | Las pruebas F2P son relevantes para el problema y cubren TODOS los requisitos de la solicitud sin ser redundantes |

> Para tareas de mejora/mantenimiento de pruebas: las pruebas F2P deben verificar que los archivos de prueba existan con la estructura correcta, convenciones de nomenclatura y ejecutabilidad básica.

### Prueba F2P — Comportamiento (Aprobado/Reprobado)

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Al menos una prueba F2P **APROBADA** en la Fase 1 (debería fallar antes de la corrección) |
| **1–2 (Fallo)** | Al menos una prueba F2P **FALLADA** en la Fase 2 (debería aprobar después de la corrección) |
| **N/A** | — |
| **5 (Perfecto)** | Las pruebas F2P FALLAN en la Fase 1 y PASAN en la Fase 2 |

### Prueba P2P — Cobertura

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Pruebas P2P faltantes/irrelevantes]` 3 o más pruebas P2P son irrelevantes para el área modificada. No hay cobertura de regresión para la funcionalidad relacionada |
| **3–4** | `[Sin fallos - Pruebas simples/Prueba irrelevante]` Las pruebas son sencillas pero siguen siendo relevantes para el área modificada. Como máximo dos pruebas son irrelevantes para el área cambiada |
| **5 (Perfecto)** | Las pruebas P2P cubren adecuadamente la funcionalidad existente en torno al cambio, proporcionan buena detección de regresiones y son relevantes y significativas |

> Para tareas de mejora/mantenimiento de pruebas: las pruebas P2P deben validar que la infraestructura de pruebas no haya sufrido una regresión (configuración del framework, utilidades de prueba, CI/CD), no la funcionalidad de la aplicación que se está probando.

### Prueba P2P — Comportamiento

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | `[Fallo - Fallo en las pruebas P2P]` Al menos una prueba P2P falla en cualquiera de las fases |
| **N/A** | — |
| **5 (Perfecto)** | Las pruebas P2P se superan en la Fase 1 (antes de la corrección) y en la Fase 2 |

### Independencia de las Pruebas

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | Las pruebas F2P hacen referencia a las pruebas P2P o dependen de ellas (o viceversa) |
| **1–2 (Fallo)** | Los conjuntos de pruebas no son autónomos y no pueden ejecutarse ni superarse por sí solos sin depender de estados externos, sistemas externos, funciones o variables |
| **N/A** | — |
| **5 (Perfecto)** | Los conjuntos de pruebas F2P y P2P son completamente independientes. Cada conjunto es autónomo y ejecutable de forma independiente. No hay referencias cruzadas entre trayectorias de prueba |

---

## Tabla de Criterios — Dimensión: Parche de Prueba / Calidad

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | El parche de prueba contiene archivos que no son de prueba (código de la aplicación, dependencias, archivos de configuración como package.json) |
| **1–2 (Fallo)** | El parche de prueba modifica las pruebas existentes dentro del código fuente |
| **1–2 (Fallo)** | El parche de prueba no se aplica al código de instancia |
| **N/A** | — |
| **5 (Perfecto)** | El parche de prueba contiene ÚNICAMENTE archivos de prueba. Es una diferencia de Git válida y se aplica correctamente |

---

## Tabla de Criterios — Dimensión: Parche de Oro / Calidad

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | El parche Gold contiene o modifica archivos de prueba (solo debe contener código de solución) |
| **1–2 (Fallo)** | El código del parche rompe el código existente después de aplicarlo |
| **1–2 (Fallo)** | El parche no se aplica al código de instancia |
| **N/A** | — |
| **5 (Perfecto)** | El parche contiene ÚNICAMENTE la solución (sin archivos de prueba). El nuevo código no rompe ninguna funcionalidad existente. El parche se aplica correctamente (advertencias son aceptables) |

---

## Tabla de Criterios — Dimensión: Docker y Scripts

### Base Dockerfile

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | El Dockerfile base no se compila debido a dependencias críticas faltantes o paquetes del sistema. El entorno/código base debe ser el mismo que el repositorio de GitHub |
| **1–2 (Fallo)** | No sigue la plantilla y/o modifica secciones prohibidas (comentadas como: NO MODIFICAR, SOLO MODIFICAR LA SECCIÓN X, etc.) |
| **N/A** | — |
| **5 (Perfecto)** | El Dockerfile base se compila correctamente sin errores. Todas las dependencias se instalan correctamente. Entorno correctamente configurado |

### Instance Dockerfile

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo)** | El Dockerfile de instancia no se compila debido a falta de dependencias críticas o paquetes del sistema |
| **1–2 (Fallo)** | No sigue la plantilla y/o modifica secciones prohibidas |
| **N/A** | — |
| **5 (Perfecto)** | El Dockerfile se compila correctamente sin errores y copia los archivos de instancia correctos. Los scripts tienen permisos de ejecución. El flujo de prueba completo se ejecuta automáticamente con un único contenedor Docker |

> El entorno de instancia será igual al entorno base para todos los tipos de incidencias, **excepto** inyección de errores.

### Basetoinstance Patch

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo - Parche no vacío)** | La tarea NO es inyección de errores y el archivo `basetoinstance.patch` no está vacío |
| **1–2 (Fallo - Parche vacío/irrelevante)** | La tarea ES inyección de errores y `basetoinstance.patch` está vacío o contiene código no relacionado con la inyección de errores |
| **N/A** | — |
| **5 (Perfecto - Inyección)** | La tarea es inyección de errores y `basetoinstance.patch` no está vacío y es totalmente relevante para la inyección de errores |
| **5 (Perfecto - No inyección)** | La tarea no es inyección de errores y `basetoinstance.patch` está vacío |

### Calidad del Script (run_script.sh + parse_results.sh)

**Orden correcto de run_script.sh:**
```
Fase 1 (estado defectuoso):
  → Aplicar test_patch → Ejecutar pruebas → F2P FALLAN, P2P PASAN

Fase 2 (estado corregido):
  → Aplicar gold_patch → Ejecutar pruebas → F2P PASAN, P2P PASAN
  → Ejecutar parse_results.sh
```

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo - Ejecutar script)** | Orden de aplicación de parches incorrecto. Uno o ambos parches no se aplican correctamente. El script finaliza con errores |
| **1–2 (Fallo - Script análisis)** | El script no analiza correctamente los resultados. El script finaliza con errores |
| **3–4 (Sin fallos)** | Contiene código que instala dependencias cuando el gold_patch no incluye ningún cambio en la lista de dependencias. Llama al script `parse_results.sh` dentro del script de ejecución |
| **5 (Perfecto)** | Los scripts se ejecutan correctamente y generan resultados legibles. `run_script.sh` aplica los parches en el orden correcto. `parse_results.sh` analiza correctamente los resultados |

---

## Tabla de Criterios — Dimensión: Archivos Subidos

| Puntuación | Descripción |
|------------|-------------|
| **1–2 (Fallo - Archivos faltantes)** | El participante no incluyó alguno de los archivos requeridos en la sección de carga: `base.Dockerfile`, `instance.Dockerfile`, `gold_patch.patch`, `test_patch.patch`, `basetoinstance.patch`, `run_script.sh`, `parse_results.sh`, `test_results.json` |
| **N/A** | — |
| **5 (Perfecto)** | Todos los archivos han sido subidos |
