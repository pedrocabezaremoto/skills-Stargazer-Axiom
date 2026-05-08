# Guía de Plantillas de Scripts — Stargazer Axiom

## Tabla de Contenido
- [run_script.sh](#run_scriptsh)
- [parse_results.sh](#parse_resultssh)
- [Flujo completo](#flujo-completo)
- [Formato de salida esperado](#formato-de-salida-esperado)

---

## run_script.sh

### Propósito
Orquesta la ejecución de pruebas en **dos fases**: primero con el código roto (Fase 1), luego con el código corregido tras aplicar el gold patch (Fase 2). Escribe toda la salida en un archivo raw para que `parse_results.sh` lo procese.

### Plantilla Completa

```bash
#!/bin/bash
set -e

# Personaliza estas variables según sea necesario
WORKING_DIR="/app"
TEST_PATCH="${TEST_PATCH:-/app/patches/test_patch.patch}"
GOLD_PATCH="${GOLD_PATCH:-/app/patches/gold_patch.patch}"
RAW_OUTPUT_FILE="${RAW_OUTPUT_FILE:-/app/test_output_raw.txt}"

# Función de utilidad para aplicar parches
apply_patch() {
  local patch_file="$1"
  echo "=== Aplicando parche: $patch_file ==="
  git apply --ignore-whitespace "$patch_file"
  echo "Parche aplicado correctamente"
}

#=======================================================================
# EJECUCIÓN DE LA PRUEBA PRINCIPAL
#=======================================================================

echo "=========================================="
echo "Ejecutando pruebas"
echo "=========================================="

cd "$WORKING_DIR"

# Restablecer archivo de salida sin procesar
: > "$RAW_OUTPUT_FILE"

#=======================================================================
# CONFIGURACIÓN: Aplicar parche de prueba
#=======================================================================
echo ""
echo "=== Añadiendo pruebas ==="
apply_patch "$TEST_PATCH"

#=======================================================================
# FASE 1: Probar el código defectuoso (antes de la corrección)
#=======================================================================
echo ""
echo "=========================================="
echo "FASE 1: Probando el estado ROTO"
echo "=========================================="
echo ""

# Marcador para el analizador
echo "=== INICIO DE LA FASE 1 ===" | tee -a "$RAW_OUTPUT_FILE"

echo "=== Ejecutando pruebas en estado roto ==="
# Ejecuta tus comandos de prueba aquí:
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true
echo ""

#=======================================================================
# FASE 2: Aplicar la corrección y volver a probar
#=======================================================================
echo ""
echo "=========================================="
echo "FASE 2: Aplicación de la corrección y nueva prueba en el estado CORREGIDO"
echo "=========================================="
echo ""

echo "=== Aplicando parche dorado ==="
apply_patch "$GOLD_PATCH"

#=======================================================================
# FASE 2: Prueba del estado FIJO
#=======================================================================
echo ""
# Marcador para el analizador
echo "=== INICIO DE LA FASE 2 ===" | tee -a "$RAW_OUTPUT_FILE"

echo "=== Ejecutando pruebas en estado fijo ==="
# Ejecuta los comandos de prueba aquí (debería pasar ahora):
npm test 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true

#=======================================================================
# FINALIZACIÓN
#=======================================================================
echo ""
echo "=========================================="
echo "Ejecución de prueba completada"
echo "=========================================="

exit 0
```

### Variables de Entorno

| Variable | Default | Descripción |
|---|---|---|
| `WORKING_DIR` | `/app` | Directorio raíz del proyecto |
| `TEST_PATCH` | `/app/patches/test_patch.patch` | Patch con los tests a agregar |
| `GOLD_PATCH` | `/app/patches/gold_patch.patch` | Patch con la corrección de código |
| `RAW_OUTPUT_FILE` | `/app/test_output_raw.txt` | Archivo de salida sin procesar |

### Marcadores Críticos para el Parser

El script debe emitir exactamente estos marcadores para que `parse_results.sh` funcione correctamente:

```
=== INICIO DE LA FASE 1 ===
=== INICIO DE LA FASE 2 ===
```

> ⚠️ **No modificar el texto de estos marcadores.** El parser los busca literalmente.

### Adaptación por Stack

Reemplaza el comando `npm test` por el equivalente del stack:

| Stack | Comando |
|---|---|
| Node.js / npm | `npm test 2>&1 \| tee -a "$RAW_OUTPUT_FILE" \|\| true` |
| Python / pytest | `pytest 2>&1 \| tee -a "$RAW_OUTPUT_FILE" \|\| true` |
| Java / Maven | `mvn test 2>&1 \| tee -a "$RAW_OUTPUT_FILE" \|\| true` |
| Go | `go test ./... 2>&1 \| tee -a "$RAW_OUTPUT_FILE" \|\| true` |
| Rust | `cargo test 2>&1 \| tee -a "$RAW_OUTPUT_FILE" \|\| true` |

---

## parse_results.sh

### Propósito
Lee el archivo raw generado por `run_script.sh`, separa los resultados por fase, clasifica los tests como `f2p` (fail-to-pass) o `p2p` (pass-to-pass), determina el resultado general y genera un archivo `test_results.json`.

### Plantilla Completa

```bash
#!/bin/bash

# Entrada esperada: archivo de log sin procesar creado por run_script.sh
RAW_OUTPUT_FILE="/app/test_output_raw.txt"
JSON_OUTPUT_FILE="/app/test_results.json"

# Matrices para almacenar resultados
phase1_results=()
phase2_results=()

# Función auxiliar para convertir el estado en entradas JSON
make_json_entry() {
  local name="$1"
  local status="$2"
  echo "{\"name\": \"${name}\", \"status\": \"${status}\"}"
}

# Analizar la salida sin procesar
current_phase=""

while IFS= read -r line; do
  if [[ "$line" == "=== INICIO DE LA FASE 1 ===" ]]; then
    current_phase="1"
    continue
  fi

  if [[ "$line" == "=== INICIO DE LA FASE 2 ===" ]]; then
    current_phase="2"
    continue
  fi

  # Formato de línea esperado:
  # <ruta_de_prueba> | <título_de_prueba> :: <PASSED/FAILED>
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

# Determinar el resultado general
# ÉXITO si: Fase 1 F2P todos fallan Y P2P todos aprueban, Fase 2 todos aprueban
overall="FAILURE"

# Pruebas F2P y P2P separadas para la fase 1
phase1_f2p=()
phase1_p2p=()

for entry in "${phase1_results[@]}"; do
  if [[ "$entry" == *".f2p.test.js"* ]] || [[ "$entry" == *".f2p.test.ts"* ]]; then
    phase1_f2p+=("$entry")
  elif [[ "$entry" == *".p2p.test.js"* ]] || [[ "$entry" == *".p2p.test.ts"* ]]; then
    phase1_p2p+=("$entry")
  fi
done

# Fase de comprobación 1: Todos los F2P deben FALLAR, todos los P2P deben PASAR
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

# Fase de verificación 2: Todas las pruebas deben PASAR
phase2_all_passed=true

for entry in "${phase2_results[@]}"; do
  if [[ "$entry" != *"PASSED"* ]]; then
    phase2_all_passed=false
    break
  fi
done

# ÉXITO general si se cumplen todas las condiciones
if [ ${#phase1_f2p[@]} -gt 0 ] && [ ${#phase1_p2p[@]} -gt 0 ] && [ ${#phase2_results[@]} -gt 0 ]; then
  if $phase1_f2p_all_failed && $phase1_p2p_all_passed && $phase2_all_passed; then
    overall="SUCCESS"
  fi
fi

# Generar el JSON final
{
  echo "{"
  echo "  \"phase_1\": ["
  printf "    %s\n" "$(IFS=$',\n'; echo "${phase1_results[*]}")"
  echo "  ],"
  echo "  \"phase_2\": ["
  printf "    %s\n" "$(IFS=$',\n'; echo "${phase2_results[*]}")"
  echo "  ],"
  echo "  \"overall_result\": \"${overall}\""
  echo "}"
} > "$JSON_OUTPUT_FILE"

# También imprimirlo en la salida estándar para herramientas externas
cat "$JSON_OUTPUT_FILE"
```

### Lógica de Clasificación de Tests

```
phase1_results
├── *.f2p.test.js / *.f2p.test.ts → phase1_f2p[]  (deben FALLAR en Fase 1)
└── *.p2p.test.js / *.p2p.test.ts → phase1_p2p[]  (deben PASAR en Fase 1)

phase2_results → todos deben PASAR
```

### Condición de ÉXITO Global

```
overall = SUCCESS si:
  1. phase1_f2p[] no está vacío Y todos sus tests son FAILED
  2. phase1_p2p[] no está vacío Y todos sus tests son PASSED
  3. phase2_results[] no está vacío Y todos sus tests son PASSED
```

### Formato del JSON de Salida

```json
{
  "phase_1": [
    {"name": "tests/feature.f2p.test.js", "status": "FAILED"},
    {"name": "tests/stable.p2p.test.js",  "status": "PASSED"}
  ],
  "phase_2": [
    {"name": "tests/feature.f2p.test.js", "status": "PASSED"},
    {"name": "tests/stable.p2p.test.js",  "status": "PASSED"}
  ],
  "overall_result": "SUCCESS"
}
```

---

## Flujo Completo

```
Instance.dockerfile
       ↓
  [código roto en /app]
       ↓
  run_script.sh
  ├── apply test_patch.patch   → agrega archivos de test
  ├── FASE 1: ejecuta tests    → código roto → f2p FAIL, p2p PASS
  ├── apply gold_patch.patch   → aplica la corrección
  └── FASE 2: ejecuta tests    → código corregido → todos PASS
       ↓
  test_output_raw.txt
       ↓
  parse_results.sh
       ↓
  test_results.json
  └── overall_result: SUCCESS / FAILURE
```

---

## Formato de Salida Esperado

El runner de tests **debe** emitir cada resultado en este formato exacto para que el parser funcione:

```
<ruta_de_prueba> | <título_de_prueba> :: PASSED
<ruta_de_prueba> | <título_de_prueba> :: FAILED
```

**Ejemplo:**
```
tests/auth.f2p.test.js | should reject invalid token :: FAILED
tests/health.p2p.test.js | should return 200 OK :: PASSED
```
