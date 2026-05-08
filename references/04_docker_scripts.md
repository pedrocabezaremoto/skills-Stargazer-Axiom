# Paso 4: Docker y Scripts

## Principio General

Los Dockerfiles y scripts garantizan la **reproducibilidad** del trabajo. Hay una separación estricta de responsabilidades:

| Componente | Responsabilidad |
|------------|-----------------|
| `base.Dockerfile` | Configurar entorno: clonar repo, instalar dependencias |
| `instance.Dockerfile` | Extender base, aplicar `basetoinstance.patch` |
| `run_script.sh` | Aplicar parches y ejecutar pruebas (SOLO eso) |
| `parse_results.sh` | Parsear salida y generar `test_results.json` |

---

## 4.1 Script de Ejecución — `run_script.sh`

**Ubicación:** `scripts/run_script.sh`

### El script DEBE hacer (en este orden):

1. **Aplicar el parche de prueba** antes de ejecutar cualquier prueba
2. **Ejecutar pruebas en estado defectuoso (Fase 1)** — mostrar resultado completo
3. **Aplicar el parche dorado** después de la Fase 1
4. **Ejecutar pruebas en estado fijo (Fase 2)** — mostrar resultado completo
5. **Completarse limpiamente** sin errores de script ni problemas de aplicación de parches

### El script NO DEBE:
- Instalar dependencias (`npm install`, `pip install`, etc.)
- Hacer nada fuera de aplicar parches y correr pruebas

### Plantilla base

```bash
#!/bin/bash
set -e

WORKDIR="/app"
SCRIPTS_DIR="/app/scripts"
PATCHES_DIR="/app/patches"

cd "$WORKDIR"

echo "=== APLICANDO TEST PATCH ==="
git apply --ignore-whitespace "$PATCHES_DIR/test_patch.patch"

echo ""
echo "=== FASE 1: ESTADO DEFECTUOSO ==="
# Ejecuta tus pruebas aquí — ejemplo para Jest:
npx jest --testPathPattern="(f2p|p2p)\.test\." --no-coverage 2>&1 || true

echo ""
echo "=== APLICANDO GOLD PATCH ==="
git apply --ignore-whitespace "$PATCHES_DIR/gold_patch.patch"

echo ""
echo "=== FASE 2: ESTADO CORREGIDO ==="
# Ejecuta tus pruebas aquí nuevamente:
npx jest --testPathPattern="(f2p|p2p)\.test\." --no-coverage 2>&1 || true

echo ""
echo "=== SCRIPT COMPLETADO ==="
```

> ⚠️ IMPORTANTE: Todas las dependencias (incluyendo dependencias solo para pruebas como Playwright, Vitest, etc.) deben instalarse en `base.Dockerfile`, NO en el script.

---

## 4.2 Script de Análisis — `parse_results.sh`

**Ubicación:** `scripts/parse_results.sh`

### El script DEBE:

1. Parsear la salida de `run_script.sh`
2. Identificar resultados de Fase 1 (estado defectuoso)
3. Identificar resultados de Fase 2 (estado fijo)
4. Determinar el resultado general:
   - **ÉXITO**: Todos los F2P fallan en Fase 1 + todos los P2P pasan en Fase 1 + todo pasa en Fase 2
5. Generar `test_results.json` con el formato requerido

### Formato de salida JSON requerido

```json
{
  "fase_1": [
    {
      "nombre": "ruta/al/archivo/prueba.f2p.test.js | título de la prueba 1",
      "estado": "FALLIDO"
    },
    {
      "nombre": "ruta/al/archivo/prueba.p2p.test.js | título de la prueba 2",
      "estado": "APROBADO"
    }
  ],
  "fase_2": [
    {
      "nombre": "ruta/al/archivo/prueba.f2p.test.js | título de la prueba 1",
      "estado": "APROBADO"
    },
    {
      "nombre": "ruta/al/archivo/prueba.p2p.test.js | título de la prueba 2",
      "estado": "APROBADO"
    }
  ],
  "resultado_general": "ÉXITO"
}
```

---

## 4.3 Dockerfile Base — `base.Dockerfile`

**Ubicación:** `dockerfiles/base.Dockerfile`

### Responsabilidades
- Configurar el entorno original "tal como está"
- Clonar el repositorio en `/app`
- Instalar dependencias del sistema y del proyecto
- Instalar dependencias adicionales para pruebas (Playwright, etc.)

### Lo que PUEDES modificar
- La línea `FROM <imagen-base>:<etiqueta>`
- La `<repo_url>` en el comando `git clone`
- La sección de dependencias del sistema
- La sección de dependencias del proyecto/pruebas

### Lo que NO DEBES modificar
- La sección de configuración de la aplicación
- La línea `ENTRYPOINT`

### Plantilla

```dockerfile
FROM node:20-slim

# Dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clonar repositorio
WORKDIR /
RUN git clone <repo_url> /app

WORKDIR /app

# Dependencias del proyecto
RUN npm ci

# Dependencias adicionales solo para pruebas (si aplica)
# RUN npx playwright install --with-deps

ENTRYPOINT ["/bin/bash"]
```

### Reglas críticas
- El repo siempre se clona en `/app`
- NO copiar scripts ni parches en la imagen
- NO ejecutar pruebas dentro del Dockerfile

---

## 4.4 Dockerfile de Instancia — `instance.Dockerfile`

**Ubicación:** `dockerfiles/instance.Dockerfile`

### Responsabilidades
- Extender la imagen base
- Aplicar `basetoinstance.patch` al repositorio en `/app`
- Manejar tanto parches llenos (bug injection) como vacíos (otras tareas)

### Plantilla

```dockerfile
FROM <base_image_name>

WORKDIR /app

# Restablecer al último commit
RUN git reset --hard HEAD

# Aplicar basetoinstance.patch (maneja archivo vacío o con contenido)
COPY patches/basetoinstance.patch /tmp/basetoinstance.patch
RUN if [ -s /tmp/basetoinstance.patch ]; then \
      git apply --ignore-whitespace /tmp/basetoinstance.patch; \
    fi

ENTRYPOINT ["/bin/bash"]
```

### Reglas críticas
- Reemplaza `<base_image_name>` con el nombre real de tu imagen base
- El directorio de trabajo debe seguir siendo `/app`
- NO copiar scripts ni parches permanentes en la imagen (se montarán en tiempo de ejecución)
- NO ejecutar pruebas dentro del Dockerfile

---

## Checklist del Paso 4

- [ ] `run_script.sh` — aplica test_patch → Fase 1 → aplica gold_patch → Fase 2
- [ ] `run_script.sh` — NO instala dependencias
- [ ] `parse_results.sh` — genera `test_results.json` con formato correcto
- [ ] `base.Dockerfile` — clona repo, instala TODO lo necesario (incluyendo deps de pruebas)
- [ ] `instance.Dockerfile` — extiende base, aplica `basetoinstance.patch` correctamente
- [ ] Ningún Dockerfile ejecuta pruebas
- [ ] Ningún Dockerfile copia scripts/patches (se montan en runtime)

---

→ Continúa con `references/05_to_08_remaining_steps.md`
