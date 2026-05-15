# Issue Message 1 - PostHog Baseline

---

## 🇺🇸 ENGLISH (Para Cursor)

# PostHog Analytics Issue

## Problem

The analytics dashboard is showing incomplete data. Users report that visitor records from certain sources are being dropped during processing and never appear in the final report.

## Current Behavior

The `getVisitors` function in `src/server/api/routers/posthog.ts` processes visitor data but some records disappear silently without being counted.

## Expected Behavior

All visitor records should be included in the analytics, regardless of the data characteristics. The report should show complete metrics.

## Constraints

- Do NOT refactor the entire routing system
- Do NOT change the API response structure
- Minimize changes to the existing logic
- Keep variable names and structure unchanged

**Review the PostHog router and identify where records might be getting lost during processing. Propose a minimal fix.**

---

## 🇪🇸 REVISIÓN EN ESPAÑOL (Para Pedro)

# Problema: Analytics de PostHog

## El Problema

El dashboard de analytics está mostrando datos incompletos. Los usuarios reportan que ciertos registros de visitantes se pierden durante el procesamiento y nunca aparecen en el reporte final.

## Comportamiento Actual

La función `getVisitors` en `src/server/api/routers/posthog.ts` procesa datos de visitantes pero algunos registros desaparecen silenciosamente sin ser contados.

## Comportamiento Esperado

Todos los registros de visitantes deben incluirse en los analytics, sin importar las características de los datos. El reporte debe mostrar métricas completas.

## Restricciones

- No refactorices todo el sistema de routing
- No cambies la estructura de respuesta del API
- Minimiza los cambios a la lógica existente
- Mantén los nombres de variables y estructura sin cambios

**Revisa el router de PostHog e identifica dónde se pierden los registros durante el procesamiento. Propón un fix mínimo.**

---

**¿Está bien así? ¿Le cambio algo?**
