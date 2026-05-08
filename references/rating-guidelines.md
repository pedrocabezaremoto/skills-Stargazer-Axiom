# Directrices de Calificación — Escala 1 al 5

Referencia para el **Paso 9** del flujo de revisión Stargazer Axiom.
Usa esta guía para asignar la calificación final a la tarea del participante.

---

## Escala de Calificación

### ⚫ 1 — Inaceptable

**Descripción:** La tarea no muestra signos de esfuerzo y debe rehacerse por completo.

**Cuándo usar:**
- La tarea es claramente **spam**
- Hay indicios evidentes de uso de **LLM** para generar la tarea completa
- La tarea requiere **muy poco esfuerzo** (entrega mínima sin trabajo real)

---

### 🔴 2 — Problemas Principales

**Descripción:** La tarea muestra algunos indicios de esfuerzo, pero debe rehacerse en gran parte.

**Cuándo usar:**
- La tarea demuestra un esfuerzo de buena fe, pero fundamentalmente no cumple con las pautas
- La consigna es confusa o demasiado simple
- La parte destacada (parche/solución) tiene un defecto importante
- La rúbrica necesita ser reescrita completamente

**Ejemplos de situaciones:**
- El mensaje del problema debe reescribirse completamente
- Los Dockerfiles no se compilan en absoluto
- El gold_patch no resuelve el problema
- Las pruebas F2P pasan en Fase 1 (cuando deberían fallar)

---

### 🟡 3 — Algunos Problemas

**Descripción:** La tarea presentaba problemas moderados que debían corregirse, pero en general era válida.

**Cuándo usar:**
- La tarea cumplió con los requisitos básicos del proyecto
- Necesitó ediciones moderadas para alcanzar la calidad requerida:
  - Pequeñas modificaciones en la consigna
  - Correcciones menores en el parche
  - Una reescritura moderada de la rúbrica
  - Otros ajustes de nivel medio

**Señales de un 3:**
- El mensaje del problema es mayormente válido pero necesita ajustes de claridad
- Los parches funcionan pero tienen pequeños problemas de contenido
- La rúbrica cubre los requisitos pero algunos criterios son vagos

---

### 🟢 4 — Problemas Menores

**Descripción:** La tarea presentaba pocos problemas y solo requería pequeñas modificaciones para quedar perfecta.

**Cuándo usar:**
- Solo se necesitaron algunas pequeñas modificaciones para que la tarea quedara perfecta:
  - Corregir algunos errores tipográficos
  - Reescribir un par de criterios de la rúbrica
  - Otros pequeños errores puntuales

**Señales de un 4:**
- La consigna es clara pero tiene una ambigüedad menor
- Los parches están bien pero tienen una advertencia corregible
- La rúbrica es sólida pero le falta especificidad en un criterio

---

### ✅ 5 — Perfecto

**Descripción:** La tarea siguió todas las directrices y no requirió modificaciones.

**Cuándo usar:**
- Absolutamente ninguna modificación fue necesaria
- Todos los componentes cumplen completamente con los estándares del proyecto
- La consigna, parches, pruebas, scripts y rúbrica son impecables

---

## Notas para Auditores — Criterios de Evaluación de Revisores

La siguiente tabla describe cómo los auditores evaluarán el trabajo del **revisor** (no del participante):

| Dimensión | Sub-Dimensión | Score 1–2 (Fallo) | Score 3–4 | Score 5 (Perfecto) |
|-----------|--------------|-------------------|-----------|-------------------|
| **Inmediato** | Claridad inmediata / Especificidad / Único / Verdad sobre el terreno | No está claro qué se pregunta; la indicación es extremadamente difícil de seguir o demasiado vaga; faltan detalles importantes | En general está claro lo que se pregunta; puede haber interpretaciones razonables, pero todas darán el mismo resultado | La consigna es clara, específica y carece de ambigüedad |
| **Inmediato** | Dominio / Pertinencia | `[Error - Tipo de problema incorrecto]` La solicitud no cumple con el tipo de problema | `[Sin fallo - Indicación de relevancia del dominio]` La consigna está vagamente conectada o puede interpretarse como relacionada | La consigna se ajusta claramente al tipo de problema |
| **Inmediato** | Modelo válido / Falla | `[Fallo - No hay fallo del modelo/Falta de traza]` La solicitud no provoca que al menos un modelo falle; no se proporcionó ningún fallo. El fallo se basa en interpretación ambigua | N/A | El fallo del modelo es evidente y se basa en una solicitud clara en el mensaje |

---

## Guía de Feedback para el Participante

Al redactar el feedback, asegúrate de que sea:

### ✏️ Específico
Menciona las partes exactas de la tarea donde realizaste cambios o encontraste problemas.

❌ **Mal:** *"La rúbrica tiene problemas"*
✅ **Bien:** *"El criterio 'Corrección de datos' (peso: 15) es demasiado vago. Reescríbelo especificando exactamente qué función/archivo debe modificarse y cuál es el comportamiento esperado."*

### 🎯 Conciso
Mantén tus comentarios organizados y enfocados. Usa listas o secciones cuando hay múltiples puntos.

### ⚡ Accionable
Explica exactamente cómo el colaborador puede solucionar los problemas en sus futuras tareas.

❌ **Mal:** *"El Dockerfile no funciona bien"*
✅ **Bien:** *"El base.Dockerfile está instalando `libpq-dev` en el script de inicio en lugar de en la sección de dependencias del sistema. Mueve la instalación a la sección designada en la plantilla para que el entorno sea reproducible."*

### 💪 Alentador
Sé respetuoso y menciona tanto las fortalezas como las debilidades.

**Estructura recomendada del feedback:**
```
✅ Fortalezas:
- [Aspecto que funcionó bien]
- [Otro aspecto positivo]

🔧 Áreas de mejora:
- [Problema específico + cómo solucionarlo]
- [Otro problema + solución accionable]

📝 Nota general:
[Comentario motivador sobre la dirección del trabajo]
```
