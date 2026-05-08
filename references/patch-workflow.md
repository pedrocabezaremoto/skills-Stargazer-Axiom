# Guía de Flujo de Trabajo con Parches — Stargazer Axiom

## Generación de archivos .patch

### Paso 1 — Preparar la base del repositorio

```bash
# Coloca los archivos del repositorio en la carpeta App/
# Elimina el directorio .git si existe
rm -rf .git

# Inicializa un nuevo repositorio
git init

# Crea el commit base
git add .
git commit -m "base"
```

### Paso 2 — Aplicar cambios y generar el parche

Después de realizar todas las modificaciones:

```bash
# Agrega los archivos modificados al área de staging
git add .

# Genera el archivo .patch
git diff --cached --binary > <NOMBRE_ARCHIVO>.patch
```

### Paso 3 — Verificar la validez del parche

```bash
# Restaurar al commit base
git reset --hard HEAD

# Verificar que el parche se aplica correctamente
git apply --check <NOMBRE_ARCHIVO>.patch
```

Si no hay errores, el parche está listo para la tarea.

---

## Verificación de encoding en Cursor

**⚠️ Crítico:** el parche debe tener codificación **UTF-8** y saltos de línea **LF** (no CRLF).

### Cómo verificar en Cursor
1. Abre el archivo `.patch` en Cursor
2. Revisa la **esquina inferior derecha** del editor
3. Debe mostrar: `UTF-8` y `LF`

### Si muestra CRLF → convertir a LF
1. Haz clic en `CRLF` en la barra inferior
2. Aparecerá un menú desplegable en la parte superior
3. Selecciona **"LF"**

### Si muestra UTF-16 → convertir a UTF-8
1. Haz clic en la codificación mostrada (ej: `UTF-16 LE`)
2. Selecciona **"Save with Encoding"**
3. Selecciona **"UTF-8"**

---

## Roles de cada archivo de parche

| Archivo | Función |
|---------|---------|
| `test_patch.patch` | Agrega archivos de prueba e inyecta lógica `beforeAll` para instalación |
| `gold_patch.patch` | Reescribe archivos de prueba con la nueva biblioteca; agrega dependencia a `devDependencies` |
| `basetoinstance.patch` | Transforma la base al estado de instancia (con el bug inyectado) |
| `run_script.sh` | Aplica parches y ejecuta `CI=true npm test -- --verbose`. Sin lógica de dependencias |
| `parse_results.sh` | Genera resumen JSON de resultados; debe escribir a `/app/test_results.json` |

---

## Instalación de dependencias en test_patch {#dependencias}

### El problema

Las tareas de **migración** requieren nuevas bibliotecas (ej: reemplazar Enzyme por React Testing Library).
El `gold_patch` agrega la dependencia a `package.json`, pero `run_script.sh` no puede instalarla.

Sin instalación, las pruebas de Fase 2 fallarán con:
```
Cannot find module '@testing-library/react'
```

### La solución

Insertar un bloque `beforeAll` en `test_patch.patch` que ejecute `npm install` automáticamente.

### Cómo funciona el flujo completo

1. **Se aplica `test_patch`** → agrega archivos de prueba con hook `beforeAll` que ejecuta `npm install --legacy-peer-deps`
2. **Fase 1 (estado roto)** → `beforeAll` se ejecuta pero no hay nuevas dependencias aún → pruebas F2P fallan (esperado), P2P pasan
3. **Se aplica `gold_patch`** → reescribe pruebas + agrega nueva dependencia a `package.json`
4. **Fase 2 (estado arreglado)** → `beforeAll` detecta la nueva dependencia → la instala → todas las pruebas pasan

### Paso 1 — Añadir bloque beforeAll a test_patch.patch

```diff
diff --git a/tests/example.test.js b/tests/example.test.js
new file mode 100644
--- /dev/null
+++ b/tests/example.test.js
@@ -0,0 +1,15 @@
+'use strict';
+
+const { execSync } = require('child_process');
+const path = require('path');
+const APP_ROOT = path.resolve(__dirname, '..');
+
+beforeAll(() => {
+  execSync('npm install --legacy-peer-deps', { cwd: APP_ROOT, stdio: 'pipe' });
+}, 120000);
+
+describe('Migration test', () => {
+  // ... lógica de prueba
+});
```

**⚠️ Importante:** el timeout debe ser `120000` ms para permitir que npm instale completamente.

### Paso 2 — Añadir fragmento de dependencia a gold_patch.patch

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

### Paso 3 — Asegurar que run_script.sh use npm test

```bash
# ✅ Correcto
CI=true npm test -- --verbose

# ❌ Incorrecto
npx jest --verbose
```

---

## Lista de verificación para parches con dependencias

- [ ] `test_patch.patch` incluye bloque `beforeAll` con `execSync` y timeout de 120000ms
- [ ] `gold_patch.patch` incluye fragmento `devDependencies` apuntando a `package.json`
- [ ] Ambos parches tienen conteos de líneas `@@` correctos y al menos 3 líneas de contexto
- [ ] Los parches se aplican en secuencia: `git apply test_patch.patch && git apply gold_patch.patch`
- [ ] `run_script.sh` usa `npm test` (no `npx <runner>` directamente)
- [ ] Usa `--legacy-peer-deps` si el proyecto tiene dependencias antiguas

---

## Errores comunes en parches

| Error | Causa | Solución |
|-------|-------|----------|
| Parche corrupto en línea N | Faltan líneas de contexto finales | Añadir líneas de contexto después de la última línea `+/-` |
| Fase 2 falla: módulo no encontrado | `gold_patch` no agrega la dependencia a `package.json` | Añadir fragmento `devDependencies` al `gold_patch` |
| El parche no se aplica después del otro | Los números de línea se desplazaron | Usar suficientes líneas de contexto para que `git apply` haga coincidencia aproximada |
| Timeout de prueba | npm install tarda más del timeout por defecto | Aumentar timeout de `beforeAll` a 120000ms |
| Errores de ruta | `APP_ROOT` calculado incorrectamente | Usar `path.resolve(__dirname, '..')` para apuntar a `package.json` |
| Parche con prefijos obsoletos | El parche contiene `/base` o `/instance` | El directorio de trabajo unificado es `/app`; regenerar el parche |

---

## Validación local con el script de Stargazer

```bash
./validation_script.sh --local path/to/task --task-id my-task --verbose
```

**Salida esperada:**
```
• Fase 1 (rota):    F2P 0/1 pase  P2P 1/1 pase
• Fase 2 (arreglada): F2P 1/1 pase  P2P 1/1 pase
```
