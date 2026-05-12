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

# Customize these variables as needed
WORKING_DIR="/app"
TEST_PATCH="${TEST_PATCH:-/app/patches/test_patch.patch}"
GOLD_PATCH="${GOLD_PATCH:-/app/patches/gold_patch.patch}"
RAW_OUTPUT_FILE="${RAW_OUTPUT_FILE:-/app/test_output_raw.txt}"

# Utility function to apply patches
apply_patch() {
    local patch_file="$1"
    echo "=== Applying patch: $patch_file ==="
    git apply --ignore-whitespace "$patch_file"
    echo "Patch applied successfully"
}

echo "=========================================="
echo "Running Tests"
echo "=========================================="

cd "$WORKING_DIR"

# Reset raw output file
: > "$RAW_OUTPUT_FILE"

echo ""
echo "=== Adding Tests ==="
apply_patch "$TEST_PATCH"

echo ""
echo "=========================================="
echo "PHASE 1: Testing BROKEN State"
echo "=========================================="
echo ""

# Marker for parser
echo "=== PHASE 1 START ===" | tee -a "$RAW_OUTPUT_FILE"
echo "=== Running Tests on Broken State ==="
# Run your test commands here:
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true

echo ""
echo "=========================================="
echo "PHASE 2: Applying Fix and Re-testing on FIXED State"
echo "=========================================="
echo ""

echo "=== Applying Gold Patch ==="
apply_patch "$GOLD_PATCH"

echo ""
# Marker for parser
echo "=== PHASE 2 START ===" | tee -a "$RAW_OUTPUT_FILE"
echo "=== Running Tests on Fixed State ==="
# Run the test commands here (should pass now):
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true

echo ""
echo "=========================================="
echo "Test Execution Complete"
echo "=========================================="

exit 0
```

> ⚠️ CRÍTICO: Los markers `=== PHASE 1 START ===` y `=== PHASE 2 START ===` deben escribirse al `RAW_OUTPUT_FILE` con `tee -a`. `parse_results.sh` los usa para separar las fases.
> ⚠️ CRÍTICO: El output de los tests DEBE capturarse con `tee -a "$RAW_OUTPUT_FILE"` en ambas fases.

> ⚠️ IMPORTANTE: Todas las dependencias (incluyendo dependencias solo para pruebas como Playwright, Vitest, etc.) deben instalarse en `base.Dockerfile`, NO en el script.

---

## 4.2 Script de Análisis — `parse_results.sh`

**Ubicación:** `scripts/parse_results.sh`

### El script DEBE:

1. Parsear la salida de `run_script.sh` desde `/app/test_output_raw.txt`
2. Identificar resultados de Fase 1 usando el marker `=== PHASE 1 START ===`
3. Identificar resultados de Fase 2 usando el marker `=== PHASE 2 START ===`
4. Determinar el resultado general:
   - **SUCCESS**: Todos los F2P fallan en Fase 1 + todos los P2P pasan en Fase 1 + todo pasa en Fase 2
5. Generar `test_results.json` con el formato requerido

### Formato de línea esperado en el output de tests

```
<test_path> | <test_title> :: <PASSED/FAILED>
```

El parser busca líneas con `::` para extraer nombre y estado.

### Template completo

```bash
#!/bin/bash

# Expected input: a temporary raw log file created by run_script.sh
RAW_OUTPUT_FILE="/app/test_output_raw.txt"
JSON_OUTPUT_FILE="/app/test_results.json"

# Arrays to hold results
phase1_results=()
phase2_results=()

# Helper function to convert status to JSON entries
make_json_entry() {
    local name="$1"
    local status="$2"
    echo "{\"name\": \"${name}\", \"status\": \"${status}\"}"
}

# Parse the raw output
current_phase=""
while IFS= read -r line; do
    if [[ "$line" == "=== PHASE 1 START ===" ]]; then
        current_phase="1"
        continue
    fi
    if [[ "$line" == "=== PHASE 2 START ===" ]]; then
        current_phase="2"
        continue
    fi

    # Expected line format:
    # <test_path> | <test_title> :: <PASSED/FAILED>
    if [[ "$line" == *"::"* ]]; then
        test_name=$(echo "$line" | cut -d':' -f1 | xargs)
        test_status=$(echo "$line" | awk -F'::' '{print $2}' | xargs)
        json_entry=$(make_json_entry "$test_name" "$test_status")

        if [[ "$current_phase" == "1" ]]; then
            phase1_results+=("$json_entry")
        elif [[ "$current_phase" == "2" ]]; then
            phase2_results+=("$json_entry")
        fi
    fi
done < "$RAW_OUTPUT_FILE"

# Determine overall result
# SUCCESS if: Phase 1 F2P all fail AND P2P all pass, Phase 2 all pass
overall="FAILURE"

# Separate F2P and P2P tests for phase 1
phase1_f2p=()
phase1_p2p=()
for entry in "${phase1_results[@]}"; do
    if [[ "$entry" == *".f2p.test.js"* ]] || [[ "$entry" == *".f2p.test.ts"* ]]; then
        phase1_f2p+=("$entry")
    elif [[ "$entry" == *".p2p.test.js"* ]] || [[ "$entry" == *".p2p.test.ts"* ]]; then
        phase1_p2p+=("$entry")
    fi
done

# Check Phase 1: F2P should all FAIL, P2P should all PASS
phase1_f2p_all_failed=true
phase1_p2p_all_passed=true

for entry in "${phase1_f2p[@]}"; do
    if [[ "$entry" != *"FAILED"* ]]; then
        phase1_f2p_all_failed=false
        break
    fi
done

for entry in "${phase1_p2p[@]}"; do
    if [[ "$entry" != *"PASSED"* ]]; then
        phase1_p2p_all_passed=false
        break
    fi
done

# Check Phase 2: All tests should PASS
phase2_all_passed=true
for entry in "${phase2_results[@]}"; do
    if [[ "$entry" != *"PASSED"* ]]; then
        phase2_all_passed=false
        break
    fi
done

# Overall SUCCESS if all conditions met
if [ ${#phase1_f2p[@]} -gt 0 ] && [ ${#phase1_p2p[@]} -gt 0 ] && [ ${#phase2_results[@]} -gt 0 ]; then
    if $phase1_f2p_all_failed && $phase1_p2p_all_passed && $phase2_all_passed; then
        overall="SUCCESS"
    fi
fi

# Produce the final JSON
{
    echo "{"
    echo "  \"phase_1\": ["
    printf "    %s\n" "$(IFS=$',\n    '; echo "${phase1_results[*]}")"
    echo "  ],"
    echo "  \"phase_2\": ["
    printf "    %s\n" "$(IFS=$',\n    '; echo "${phase2_results[*]}")"
    echo "  ],"
    echo "  \"overall_result\": \"${overall}\""
    echo "}"
} > "$JSON_OUTPUT_FILE"

# Also print it to stdout for external tools
cat "$JSON_OUTPUT_FILE"
```

### Formato de salida JSON requerido

```json
{
  "phase_1": [
    {
      "name": "path/to/test/file.f2p.test.js | test title 1",
      "status": "FAILED"
    },
    {
      "name": "path/to/test/file.p2p.test.js | test title 2",
      "status": "PASSED"
    }
  ],
  "phase_2": [
    {
      "name": "path/to/test/file.f2p.test.js | test title 1",
      "status": "PASSED"
    },
    {
      "name": "path/to/test/file.p2p.test.js | test title 2",
      "status": "PASSED"
    }
  ],
  "overall_result": "SUCCESS"
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
# TODO: Choose appropriate base image
# FROM <base-image>:<tag>

# Set working directory — the repo should always be cloned into /app
# DO NOT MODIFY THIS SECTION
RUN mkdir /app
WORKDIR /app

# TODO: Install required system dependencies
# RUN apt-get update && apt-get install -y git <other-required-packages>

# TODO: ONLY MODIFY THE REPO_URL PART.
RUN git clone <repo_url> .
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git reset --hard $LATEST_COMMIT

# Install any project dependencies here.

# ENTRYPOINT should always be /bin/bash
# If build/test commands are set as CMD or ENTRYPOINT, convert them to RUN commands
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
FROM <base-image>

# DO NOT MODIFY THIS SECTION
WORKDIR /app
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git checkout $LATEST_COMMIT
RUN \
  --mount=type=bind,source=patches/basetoinstance.patch,target=/tmp/basetoinstance.patch \
    if grep -q '^diff' /tmp/basetoinstance.patch 2>/dev/null; then \
        git apply --whitespace=fix /tmp/basetoinstance.patch; \
    else \
        echo "basetoinstance.patch is empty or has no diffs, skipping..."; \
    fi

# Install any project dependencies here.
# Normally this is fine to leave empty, but in rare cases,
# you may have to install the same dependencies as in the base dockerfile

ENTRYPOINT ["/bin/bash"]
```

> ⚠️ CRÍTICO: Usar `--mount=type=bind` (NO `COPY`) para el patch.
> ⚠️ CRÍTICO: Usar `grep -q '^diff'` para verificar si el patch tiene contenido (NO `-s`).
> ⚠️ CRÍTICO: Usar `--whitespace=fix` (NO `--ignore-whitespace`) en instance.dockerfile.

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
