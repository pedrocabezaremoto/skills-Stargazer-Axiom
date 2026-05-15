# Issue Message 1 - PostHog Baseline

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

The `posthog.ts` file processes visitor data but some records are not being counted in the final report. Users report that certain visitors never show up on the dashboard chart. Review the code and propose a minimal fix so all records are included without refactoring the data system.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

El archivo posthog.ts en src/server/api/routers/ procesa datos de visitantes pero algunos registros desaparecen sin ser contados en el reporte final. Los usuarios reportan que ciertos visitantes nunca aparecen en el dashboard. Revisa el código y propón un fix mínimo para que todos los registros se incluyan sin refactorizar el sistema de datos.

---

**Status:** ❌ FALLÓ — modelo lo arregló directo (identificó el if/else en líneas 107-113)

---

---

# Prompt 1.1 — Sin nombre de archivo

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

Some visitor records are not being counted in the final analytics report. Users have noticed that certain sessions never appear on the dashboard chart. Review the data processing logic and propose a minimal fix to ensure all records are included, without refactoring the existing data structures.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

Algunos registros de visitantes no se están contabilizando en el reporte final de analytics. Los usuarios notaron que ciertas sesiones nunca aparecen en el gráfico del dashboard. Revisa la lógica de procesamiento de datos y propón un fix mínimo para que todos los registros se incluyan, sin refactorizar las estructuras de datos existentes.

---

**Status:** 🧪 Sin probar

**Qué cambia vs 1.0:**
- Sin mencionar `posthog.ts` — el modelo tiene que encontrar el archivo solo
- "sessions" en vez de "records" — más vago, puede ir al auth o al tracking frontend
- Mismo síntoma, misma restricción

---

---

# Prompt 1.2 — Solo síntoma frontend

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

The visitor chart on the admin dashboard is showing lower numbers than expected. Some users are reporting that their sessions are not reflected in the analytics view. Please look into why some entries might be getting dropped and propose a minimal fix, without refactoring the data layer.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

El gráfico de visitantes en el dashboard admin muestra números más bajos de lo esperado. Algunos usuarios reportan que sus sesiones no se reflejan en la vista de analytics. Por favor investiga por qué algunos registros podrían estar siendo descartados y propón un fix mínimo, sin refactorizar la capa de datos.

---

**Status:** 🧪 Sin probar

**Qué cambia vs 1.1:**
- Apunta al gráfico frontend ("visitor chart on the admin dashboard") — misdirection hacia `chart-area-interactive.tsx`
- No menciona ningún archivo de backend
- "dropped" es vago — puede ir a filtros, fechas, rendering

---

---

# Prompt 1.3 — Misdirection total (fecha/sorting)

---

## 🇺🇸 ENGLISH (Para Cursor - COPY THIS ONLY)

The analytics dashboard occasionally shows gaps or missing data points for certain date ranges. The issue seems related to how daily totals are being calculated and sorted before rendering. Review the aggregation and sorting logic and propose a minimal fix to ensure all data points appear correctly in the final output, without refactoring the existing system.

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro - SOLO REFERENCIA)

El dashboard de analytics ocasionalmente muestra huecos o puntos de datos faltantes para ciertos rangos de fechas. El problema parece estar relacionado con cómo se calculan y ordenan los totales diarios antes del renderizado. Por favor revisa la lógica de agregación y ordenamiento y propón un fix mínimo para que todos los puntos de datos aparezcan correctamente en el output final, sin refactorizar el sistema existente.

---

**Status:** 🧪 Sin probar

**Qué cambia vs 1.2:**
- Apunta explícitamente al sorting y aggregation por fecha — misdirection hacia líneas 117-119 (`Object.values().sort()`)
- "gaps or missing data points for certain date ranges" — suena a bug de fechas, no de device types
- El modelo probablemente va al `.sort()` o al `processedData[date]` antes que al if/else
