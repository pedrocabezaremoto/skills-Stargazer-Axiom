# Stargazer Axiom - Quality Assessment (Evaluación)

Este documento contiene el seguimiento de la evaluación de calidad para el rol de Attempter.

---

## TITULO Pagina 1
### Imagen 1 y 2
**Bienvenida al Assessment**
Esta fase evalúa si el attempter está listo para realizar tareas reales.

**Áreas evaluadas:**
*   Composición de prompts.
*   Escritura de pruebas unitarias (F2P y P2P).
*   Creación de rúbricas.

⚠️ **IMPORTANTE:** La plataforma prohíbe explícitamente el uso de editores externos o LLMs durante este assessment. Las respuestas deben ser naturales y seguir las guías del proyecto.

---

## TITULO Pagina 2 - Escritura de un Prompt
### Imagen 3 y 4
**Guía para escribir un buen Prompt:**
1.  **Seguir el tipo de issue:** Si es Bug Injection, el prompt debe tratar sobre un error.
2.  **Detalle suficiente:** El modelo debe tener contexto para trabajar, pero sin recibir la solución.
3.  **Desafiar al modelo:** No pongas tareas triviales; el problema debe requerir análisis lógico.
4.  **Lenguaje natural:** Escribe como si fueras un desarrollador reportando un issue real en GitHub.

### Imagen 5 - Tarea Práctica 1
**Escenario:** Frontend de e-commerce en JavaScript. El buscador acepta texto pero la lista de productos no cambia.
**Tipo de Issue:** Bug Injection.

**Borrador de Prompt:**
> Fix the bug in the product list where the search bar does not filter the results. Currently, typing in the search bar updates the input field but the displayed products remain the same. The solution should ensure the list filters dynamically and handles empty states correctly.

---

## TITULO Pagina 3 - Tests (F2P & P2P)
### Imagen 1 y 2
**Evaluación de Pruebas Unitarias**
Se evalúa la capacidad de escribir y distinguir entre tests que validan nuevos comportamientos y tests que previenen regresiones.

### Imagen 3, 4 y 5 - Ejercicio Shopping Cart
**Contexto:** Bug en `shoppingCart.js`. `addItem()` crea duplicados en lugar de incrementar la cantidad de un producto ya existente.

**Análisis de Tests Propuestos (F2P):**

*   **Test A:** ✅ **VÁLIDO.** Falla con el bug (length sería 2) y pasa tras el arreglo. Verifica tanto la consolidación como el incremento de cantidad.
*   **Test B:** ❌ **INVÁLIDO.** El total podría ser correcto (20) incluso con duplicados, por lo que pasaría antes de arreglar el bug.
*   **Test C:** ❌ **INVÁLIDO.** Las aserciones sobre el orden de los primeros elementos pasarían incluso con la entrada duplicada al final. No prueba el arreglo.
*   **Test D:** ✅ **VÁLIDO.** Busca duplicados por ID. Falla antes (encontraría 2) y pasa después.

**Justificación técnica:**
Un F2P debe ser sensible al bug. Los tests B y C son demasiado genéricos o prueban comportamientos que no se ven afectados por la duplicación, lo que los hace inútiles para validar esta corrección específica. Los tests A y D atacan directamente la estructura del array de ítems y la lógica de duplicidad.

**Technical Justification (English):**
A valid F2P test must be bug-sensitive, meaning it must fail while the bug is present. Tests B and C are too generic or validate behaviors that are unaffected by item duplication, rendering them ineffective for validating this specific fix. In contrast, Tests A and D directly target the internal structure of the items array and the logic of item duplication, ensuring the bug is correctly detected and resolved.

### Ejercicio 2: Selección de Tests P2P
**Contexto:** Mismo bug en `shoppingCart.js`. Se busca asegurar que otras funciones no se rompan tras el arreglo.

**Análisis de Tests Propuestos (P2P):**

*   **Test A (`removeItem`):** ✅ **VÁLIDO.** Prueba una funcionalidad distinta que no depende del bug de duplicados. Pasa antes y después.
*   **Test B (`total`):** ✅ **VÁLIDO.** Aunque usa un caso que dispara el bug, el resultado matemático del total es consistente tanto con duplicados como con cantidades incrementadas. Pasa siempre.
*   **Test C (`clearCart`):** ✅ **VÁLIDO.** Funcionalidad de limpieza base. Pasa siempre.
*   **Test D (`getItem`):** ✅ **VÁLIDO.** Funcionalidad de búsqueda base. Pasa siempre.

**Respuesta para el Assessment:**
*   **Selección:** A, B, C, D.
*   **Explicación:** N/A (Todos son válidos).
**Tipo de Issue:** Bug Injection (Corrección de un error introducido).

**Borrador Propuesto para el Prompt:**

> **Título:** Fix: Search bar input does not filter the product list
>
> **Descripción:**
> There is a critical issue in our e-commerce frontend where the search functionality has stopped working. While the search bar correctly accepts and displays user input, the product list below remains unchanged regardless of what is typed.
>
> Please investigate the product list component to find why the filtering logic is not being triggered or why the UI isn't updating with the filtered results. You must ensure that the list filters dynamically in real-time. Also, verify that clearing the search input correctly restores the full product list and that the 'no results' state is handled gracefully.

---

## TITULO Pagina 4 - Rúbricas (Rubrics)
### Imagen 1 y 2
**Evaluación de Rúbricas**
Se evalúa la capacidad de crear criterios de calificación objetivos, atómicos y alineados con el prompt.

### Imagen 3 y 4 - Ejercicio React Router
**Prompt:** Migrar React Router v5 -> v6 (rutas, history, links).

**Análisis de Criterios:**
*   **Válidos:** A (`f2p_success`), B (`p2p_success`), D (`link_migration`).
*   **Inválidos por ser compuestos:** C (rutas + history), I (history + links).
*   **Inválidos por fuera de alcance:** E (replace option), F (NavLink), G (errorElement).
*   **Inválidos por subjetividad:** H (best practices), J (adequate coverage).

**Selección:** A, B, D.

### Imagen 5 - Ejercicio Cart Component
**Prompt:** Arreglar bug en `total()`, `update()` y `remove()`.

**Análisis de Criterios:**
*   **Válidos:** A (`f2p_success`), B (`p2p_success`), C (`total()`), E (`remove()`).
*   **Inválidos por ser compuestos:** D (`update()` + `remove()`).
*   **Inválidos por fuera de alcance:** F (rounding), G (index special case), H (toFixed).

### Imagen 6, 7 y 8 - Ejercicio Dark Mode
**Prompt:** Añadir toggle, cambio de UI y persistencia en `localStorage`.

**Análisis de Criterios:**
*   **Válidos:** `persistence`, `toggle_renders`, `theme_switch`.
*   **Inválidos por ser compuestos:** `toggle_and_persistence`.
*   **Inválidos por fuera de alcance:** `animation_transition` (no se pidió animación).
*   **Inválidos por subjetividad:** `toggle_implementation` ("proper", "best practices").

**Respuesta Assessment:**
*   **Selección:** `persistence`, `toggle_renders`, `theme_switch`.
*   **Explicación:** `toggle_and_persistence` is compound. `animation_transition` is out of scope. `toggle_implementation` is subjective.

---

## CONCLUSIÓN DEL CURSO
Hemos completado la documentación técnica del **Stargazer Axiom - Quality Assessment**.
1.  **Bug Injection:** Aprendimos a redactar prompts específicos que indiquen el error sin dar la solución.
2.  **Validación de Tests:** Identificamos tests F2P (que fallan con el bug) y P2P (regresión).
3.  **Rúbricas:** Aplicamos las reglas de atomicidad, objetividad y alcance para crear criterios de evaluación robustos.

¡Onboarding completado con éxito! 🔧🚀
