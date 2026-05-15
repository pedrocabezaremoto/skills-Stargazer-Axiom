# Paso 3: Pruebas — F2P y P2P

## Principio Fundamental

Las pruebas validan si **CUALQUIER solución** resuelve el problema — no solo la tuya. El objetivo es verificar **comportamientos**, no implementaciones específicas.

> Las pruebas deben ser **autónomas**: no pueden depender de otros elementos externos para funcionar.

---

## Comportamiento Esperado de las Pruebas

| Tipo | Antes del gold patch | Después del gold patch | Objetivo |
|------|---------------------|------------------------|---------|
| **F2P** (Fail-to-Pass) | ❌ FALLO | ✅ APROBADO | Verifica el nuevo comportamiento |
| **P2P** (Pass-to-Pass) | ✅ APROBADO | ✅ APROBADO | Confirma que la funcionalidad existente no se rompió |

---

## 3.1 Pruebas F2P (Fail-to-Pass)

### Qué probar
- Los **cambios y funcionalidades específicos** añadidos por la solución
- Cada requisito explícito del prompt

### Nomenclatura obligatoria
```
**/*.f2p.test.js
**/*.f2p.test.ts
**/*.f2p.test.php
# etc. — el parser depende de estos sufijos exactos
```

### Ejemplos por tipo de problema

| Tipo | Qué prueba la F2P |
|------|-------------------|
| **Nueva función** | Que la nueva función existe y funciona (ej: botón de exportación genera CSV válido) |
| **Inyección de errores** | Que el error se haya corregido (ej: el cambio de estado se actualiza correctamente) |
| **Migración** | Que la nueva librería/patrón existe y se usa correctamente |
| **Rendimiento** | Benchmarks que muestran mejoras o confirman que el código cumple el estándar (ej: renderizado < 100ms) |
| **Mantenimiento** | Que las nuevas herramientas funcionan o confirman cualquier actualización |
| **Mejora de pruebas** | Que los archivos de prueba existen con estructura correcta y convenciones de nomenclatura |

---

## 3.2 Pruebas P2P (Pass-to-Pass)

### Qué probar
- **Funcionalidad relacionada** con los cambios (no la funcionalidad remota)
- Ausencia de regresiones o efectos secundarios

### Nomenclatura obligatoria
```
**/*.p2p.test.js
**/*.p2p.test.ts
**/*.p2p.test.php
# etc.
```

### Para mejora de pruebas (caso especial)
Las P2P deben validar que la **infraestructura de pruebas** no sufrió regresión:
- Configuración del framework de pruebas
- Utilidades de testing
- Pipeline CI/CD

> ⚠️ No prueban la funcionalidad de la aplicación, sino la infraestructura de testing.

---

## 3.3 Generar el Parche de Prueba

**Ubicación:** `patches/test_patch.patch`

```bash
# 1. Crea los archivos de prueba (F2P y P2P)
# Escribe tus tests en App/ con las convenciones de nomenclatura correctas...

# 2. Genera el parche desde el directorio de trabajo
git -C App diff > patches/test_patch.patch
```

### Reglas del test_patch.patch

✅ **DEBE contener:**
- Solo archivos de prueba nuevos (F2P y P2P)
- Opcionalmente: `npm install` si la tarea requiere modificar `package.json`

❌ **NO DEBE contener:**
- Cambios en código de la aplicación
- Pruebas existentes modificadas
- Archivos de dependencias: `package.json`, `package-lock.json`
- Archivos de configuración
- Archivos fuente fuera del directorio de pruebas

---

## 3.4 Manejo de Dependencias en test_patch (Migrations)

**⚠️ IMPORTANTE SOLO PARA TAREAS DE MIGRACIÓN**

### El Problema

Las tareas de migración (ej: Enzyme → React Testing Library) requieren nuevas dependencias npm. El gold patch agrega la dependencia a `package.json`, pero tras `git apply` la dependencia **nunca se instala** — solo queda declarada.

Sin instalación, Phase 2 falla con:
```
Cannot find module '@testing-library/react'
```

**Restricción crítica:** `run_script.sh` **NO DEBE instalar dependencias**. Su única responsabilidad es aplicar patches y correr tests.

### La Solución: beforeAll + execSync

Inyectar un bloque `beforeAll` directamente en los archivos de test que ejecute `npm install` mediante `child_process`. Esto activa la instalación desde dentro del test runner.

### Flujo de Ejecución

| Fase | Acción |
|------|--------|
| **Phase 1 (Roto)** | `beforeAll` se ejecuta. No hay nuevas deps en `package.json` aún. Tests F2P fallan (esperado). Tests P2P pasan. |
| **Aplicar gold_patch** | Agrega dependencia a `devDependencies` |
| **Phase 2 (Corregido)** | `beforeAll` se ejecuta de nuevo. `npm install` detecta nueva dep e instala. Todos los tests pasan. |

### Implementación Paso a Paso

#### Paso 1 — Agregar beforeAll a test_patch.patch

En los archivos `.f2p.test.js` (o `.ts`), incluir al inicio:

```javascript
'use strict';

const { execSync } = require('child_process');
const path = require('path');
const APP_ROOT = path.resolve(__dirname, '..');

beforeAll(() => {
  execSync('npm install --legacy-peer-deps', { 
    cwd: APP_ROOT, 
    stdio: 'pipe' 
  });
}, 120000);  // 120 segundos de timeout (MÍNIMO para npm install)

describe('Migration Test', () => {
  // ... lógica de tests
});
```

**Notas importantes:**
- El timeout **mínimo es 120000ms** — npm install puede tardar
- Usar `stdio: 'pipe'` para evitar output innecesario
- `APP_ROOT` debe apuntar a `/app` (donde vive `package.json`)

#### Paso 2 — Agregar dependencia al gold_patch.patch

El gold patch debe incluir un hunk en `package.json`:

```diff
diff --git a/package.json b/package.json
--- a/package.json
+++ b/package.json
@@ -18,6 +18,7 @@
   "devDependencies": {
+    "@testing-library/react": "^12.1.5",
     "enzyme": "^3.3.0",
     "enzyme-adapter-react-16": "^1.1.1"
   }
```

#### Paso 3 — run_script.sh SIN npm install

Asegurarse de que `run_script.sh` **NO** ejecute npm install. Debe ser:

```bash
# ✅ CORRECTO
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true

# ❌ INCORRECTO
npm install --legacy-peer-deps
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true
```

### Checklist de Autoría

Antes de hacer submit, confirmar:

- [ ] `test_patch.patch` incluye bloque `beforeAll` con `execSync` 
- [ ] Timeout en `beforeAll` es **mínimo 120000ms**
- [ ] `gold_patch.patch` incluye hunk de `devDependencies` con la nueva librería
- [ ] Ambos patches tienen 3+ líneas de contexto antes/después de cada hunk
- [ ] Ambos patches se aplican sin conflictos: `git apply test_patch.patch && git apply gold_patch.patch`
- [ ] `run_script.sh` **NO** ejecuta `npm install`
- [ ] `run_script.sh` **SÍ** usa `npm test` (que gatilla el hook `beforeAll`)

### Errores Comunes

| Problema | Causa | Solución |
|----------|-------|----------|
| Phase 2 falla: `Cannot find module` | gold_patch no agrega dependencia a `package.json` | Verificar que `devDependencies` está en gold_patch |
| Timeout en Phase 1 | npm install tarda más que el timeout | Aumentar timeout a 180000ms |
| `APP_ROOT` es incorrecto | Path mal calculado | Usar `path.resolve(__dirname, '..')` — debe apuntar a `/app` |
| Patch corrupto en linesN | Faltan líneas de contexto | Agregar 3+ líneas de contexto antes/después |
| Parser no detecta cambios | Test runner no gatilla `beforeAll` | Confirmar que el test framework usa Jest/Vitest |

### Validación Final

Ejecutar localmente:

```bash
# Phase 1 con solo test_patch
git apply test_patch.patch
npm test  # beforeAll instala, pero package.json no tiene nueva dep → nada cambia
# Esperado: F2P fallan, P2P pasan

# Aplicar gold_patch
git apply gold_patch.patch
npm test  # beforeAll instala nuevamente, detecta nueva dep e instala
# Esperado: TODO pasa
```

**Output esperado del validador:**
```
✓ Phase 1 (broken): F2P 0/1 pass   P2P 1/1 pass
✓ Phase 2 (fixed):  F2P 1/1 pass   P2P 1/1 pass
```

### Cuándo usar esta técnica

✅ **Usar beforeAll si:**
- El issue type es "Migration"
- El gold_patch agrega entradas a `dependencies` o `devDependencies`
- La nueva librería no existe en `App/node_modules` hasta `npm install`

❌ **NO usar beforeAll si:**
- La dependencia ya existe en `package.json` (solo hay que actualizar versión)
- La tarea NO es migración (es bug, feature, etc.)
- `run_script.sh` ejecuta `npm install` explícitamente (entonces beforeAll es redundante)

---

## Verificación Final

```bash
# Verifica que el parche aplica limpiamente
git -C App apply --ignore-whitespace patches/test_patch.patch

# Comprueba el comportamiento esperado:
# 1. Con solo test_patch aplicado → F2P deben FALLAR, P2P deben PASAR
# 2. Con test_patch + gold_patch → TODO debe PASAR
```

---

## Checklist del Paso 3

- [ ] Pruebas F2P escritas con sufijo `*.f2p.test.*`
- [ ] Pruebas P2P escritas con sufijo `*.p2p.test.*`
- [ ] Pruebas son autónomas (sin dependencias externas)
- [ ] `test_patch.patch` generado
- [ ] Verificado: F2P fallan en estado problemático
- [ ] Verificado: P2P pasan en estado problemático
- [ ] Verificado: Todo pasa después de aplicar gold_patch
- [ ] El parche NO contiene archivos de aplicación ni configuración
- [ ] **[Si es migración]** Bloque `beforeAll` incluido en test_patch
- [ ] **[Si es migración]** Dependencia agregada a `devDependencies` en gold_patch

---

→ Continúa con `references/04_docker_scripts.md`
