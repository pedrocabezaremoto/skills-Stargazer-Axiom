# Issue Message Testing - Haciendo Fallar al Modelo

## El Objetivo

Crear un **issue message** que confunda al modelo para que **NO arregle el bug**.

El bug: En `posthog.ts` (líneas 107-113), falta un `else` para manejar device types inesperados.

---

## El Flujo (actualizado 2026-05-15)

Cada issue_message tiene **sub-versiones** dentro del mismo archivo (1.0, 1.1, 1.2...):

- Si el modelo arregla el bug → pasamos al siguiente sub-prompt del mismo archivo
- Cuando un sub-prompt logra que el modelo falle → ese es el ganador
- Si todos los sub-prompts del archivo fallan → pasamos al siguiente archivo (issue_message_2.md)

### Historial de progreso

| Prompt | Modelo | Resultado |
|--------|--------|-----------|
| 1.0 (original) | QWEN 3.5 27B | ❌ Lo arregló — identificó if/else en líneas 107-113 directo |
| 1.1 | — | 🧪 Sin probar |
| 1.2 | — | 🧪 Sin probar |
| 1.3 | — | 🧪 Sin probar |

---

## Cómo Probar Cada Message

### Paso a Paso en Cursor

1. Abre el archivo `issue_message_N.md` en `/root/skills-Stargazer-Axiom/task02/prompts_modelos/`
2. **Copia TODO el contenido**
3. Abre Cursor chat (Ctrl+L)
4. **Selecciona el modelo** (abajo a la derecha ves el switch)
5. **Pega el issue message**
6. **Observa qué hace el modelo:**
   - ✅ **FALLA** (no lo arregla, propone fix incorrecto, se confunde) → **¡GANASTE! Documenta y termina**
   - ❌ **ARREGLA** (propone la solución correcta) → Sigue a `issue_message_N+1`

---

## Estrategias para Confundir

Cada nueva versión será **más vaga y menos explícita**:

- **Message 1:** Describe el problema de forma clara (baseline)
- **Message 2:** Menos específico, sin mencionar device types exactamente
- **Message 3:** Solo síntomas, sin detalles técnicos
- **Message 4+:** Misdirection total, confusión de contexto

---

## 🎯 El Nivel de Vaguedad Correcto

**⚠️ EJEMPLO (NO USAR ESTE PROMPT, SOLO REFERENCIA):**

```
El archivo app-routing.module.ts importa de forma inmediata CheckoutComponent 
y CourseDetailsComponent al principio del archivo, junto con más de 30 
pantallas adicionales. Convierta únicamente las rutas checkout/:id y 
course-details/:id para que utilicen loadComponent con importaciones dinámicas. 
Deje intactas todas las demás rutas y sus importaciones inmediatas.
```

**¿Por qué funciona este nivel?**
- ✅ Describe el SÍNTOMA (importaciones inmediatas)
- ✅ Pide una ACCIÓN (convertir a dinámicas)
- ✅ Tiene RESTRICCIONES (solo 2 rutas, dejar las demás)
- ✅ No revela la solución exacta
- ✅ Tono profesional pero conversacional

**Esto es lo que buscamos para issue_message_1, 2, 3, etc.**

---

## 📝 Formato de los Issue Messages

**Cada archivo `issue_message_N.md` tiene 2 secciones:**

### Sección 1: English (LO QUE USAMOS EN CURSOR)
```
# Issue: [Título en inglés]

## Problem Description
[Descripción del problema en inglés - esto se pega en Cursor]
...
```

### Sección 2: Traducción al Español (PARA REVISIÓN)
```
---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro)

**Título:** [Traducción]
**Descripción:** [Traducción del contenido]
...
```

**Por qué:** El modelo recibe el inglés (precisión testing), pero Pedro revisa el español para aprobar si está bien o si falta confusión.

---

## Cuando Funcione

Cuando encuentres **el message que rompe el modelo**:

1. Copia su contenido a `/root/skills-Stargazer-Axiom/task02/issue_message.txt`
2. Exporta el chat (Export Transcript en Cursor)
3. Guarda en `task02/model_trace_failure.md`
4. Marca Paso 2 como ✅ completado

---

**Estamos listos. Vamos a crear issue_message_1.md primero. ¿Listo?**
