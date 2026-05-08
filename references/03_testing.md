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

---

→ Continúa con `references/04_docker_scripts.md`
