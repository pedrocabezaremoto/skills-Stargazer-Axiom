# Issue Message 2 - Data Aggregation Misdirection

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

The visitor metrics returned by `posthog.ts` are incomplete. While the raw data fetches correctly, a subset of the records inexplicably disappears before reaching the final output. Please investigate why this data loss is occurring and propose a minimal fix to ensure the final payload is complete, without refactoring the existing data structures or queries.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

Las métricas de visitantes devueltas por `posthog.ts` están incompletas. Aunque los datos originales se obtienen bien, un subconjunto de los registros desaparece inexplicablemente antes de llegar al resultado final. Por favor, investiga por qué ocurre esta pérdida de datos y propón un fix mínimo para asegurar que el payload final esté completo, sin refactorizar las estructuras de datos o consultas existentes.

---

**Status:** ✅ Listo para testing

**Qué hace:**
- Mantiene la descripción del síntoma (registros perdidos).
- **Misdirection (Distracción):** Usa palabras como "transformation phase" y "aggregation loop", lo que incitará al modelo a buscar problemas en cómo se agrupan los datos por fecha o cómo se empuja al array, en lugar de mirar los condicionales simples de `if/else` de los dispositivos.
- Mantiene las restricciones (no refactorizar, fix mínimo).
- Formato bilingüe alineado al `README.md`.

---
<br><br>

# Issue Message 2.1 - Math/Aggregation Misdirection

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

The analytics dashboard is showing underreported visitor counts for specific dates. It appears that during the data mapping process, some daily aggregates are being miscalculated or overwritten, leading to skewed final totals. Please investigate how the views are being summed up and propose a minimal fix to ensure the daily totals are accurately aggregated, without refactoring the data structures.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

El dashboard de analíticas está mostrando recuentos de visitantes inferiores a los esperados para fechas específicas. Parece que durante el proceso de mapeo de datos, algunos agregados diarios se están calculando mal o sobrescribiendo, lo que provoca totales finales sesgados. Por favor, investiga cómo se están sumando las visitas y propón un fix mínimo para asegurar que los totales diarios se agreguen con precisión, sin refactorizar las estructuras de datos.

---

**Status:** ✅ Listo para testing

**Qué hace:**
- Mantiene la premisa de que los datos no cuadran (underreported counts).
- **Misdirection agresiva:** En lugar de hablar de "registros que desaparecen", hablamos de **"cálculos erróneos"** y **"sobrescritura de fechas"**. Esto forzará al modelo a obsesionarse con la línea donde se hace la suma matemática (`+= views`) o donde se inicializa la fecha en el objeto (`processedData[date]`), cegándolo por completo del condicional `if/else` de los dispositivos.
