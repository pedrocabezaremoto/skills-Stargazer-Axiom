# Paso 2: Creación y Solución del Problema

## 2.1 Redactar la Declaración del Problema

El prompt es la **base de la tarea**. Su calidad determina la calidad de cada componente que se construye sobre él.

### Tipos de Problemas

| Tipo | Descripción |
|------|-------------|
| **Nueva función** | Agregar funcionalidad que actualmente no existe en el código |
| **Inyección y resolución de errores** | Introducir un cambio incompatible con versiones anteriores en código que funciona |
| **Migración** | Adaptar todo o parte del código existente a un nuevo sistema, librería o patrón |
| **Optimización del rendimiento** | Mejorar velocidad, eficiencia o uso de recursos sin cambiar funcionalidad |
| **Mantenimiento o mejora de pruebas** | Actualizar dependencias, pruebas o herramientas |

---

### Principios para un Buen Prompt

1. **Escríbelo como un issue real de GitHub** — Un problema, una solicitud. Si escribes "y también", detente y divide.
2. **Sé claro y conciso** — La dificultad viene del realismo, no de la ambigüedad artificial.
3. **Elimina ambigüedades** — Dos desarrolladores competentes deben interpretar lo mismo.
4. **Usa requisitos explícitos** — Cada requisito debe poder verificarse con una prueba.
5. **Piensa con anticipación** — Antes de escribir, planifica cómo serán la solución dorada y las pruebas.
6. **Menciona rutas/funciones si la rúbrica las referencia** — La consigna y la rúbrica deben tener el mismo nivel de especificidad.

---

## 2.2 Calificar la Dificultad del Problema

Cuenta cuántas de estas **señales de complejidad** aplican:

| # | Señal | Descripción |
|---|-------|-------------|
| 1 | **Propagación** | La corrección modifica 3 o más archivos |
| 2 | **Interacción entre módulos** | La solución afecta más de una parte del proyecto |
| 3 | **Conocimiento arquitectónico** | Necesitas entender cómo está organizado el proyecto para resolverlo |
| 4 | **Lógica no trivial** | Requiere toma de decisiones en el código, no solo renombrar o mover cosas |
| 5 | **Casos límite implícitos** | La solución también debe manejar casos especiales o posibles errores |
| 6 | **Riesgo de regresión** | Una mala solución podría accidentalmente dañar otra cosa |

### Tabla de Dificultad

| Dificultad | Señales que aplican |
|------------|---------------------|
| Fácil | 1 – 2 |
| Medio | 3 – 4 |
| Difícil | 5+ |

---

## 2.3 Crear la Incidencia

**Ubicación:** `App/`

### Para todos los tipos EXCEPTO inyección de errores:
Los archivos dentro de `App/` deben permanecer **idénticos al repositorio original**.

### Para inyección de errores:
Introduce el bug directamente en `App/` para que esta versión represente el **estado de instancia defectuoso**.

### 2.3.1 Generar el parche basetoinstance

**Si es inyección de errores:**
```bash
# Desde la raíz del proyecto (fuera de App/)
# Después de introducir el bug en App/:
git -C App diff > patches/basetoinstance.patch
```

**Si NO es inyección de errores:**
```bash
# Sube un archivo vacío
touch patches/basetoinstance.patch
```

---

## 2.4 Probar el Mensaje de Error

**IMPORTANTE:** El prompt debe ser lo suficientemente complejo para que **al menos un modelo falle**.

### Procedimiento

1. Abre **únicamente** la carpeta `App/` en Cursor (nueva ventana, sin acceso a patches)
2. Pega el prompt y selecciona **Sonnet 4.6**
3. Comprueba si logra crear una solución válida
4. Repite el mismo procedimiento con **Qwen 3.5 27b**

### Criterios de Decisión

| Resultado | Acción |
|-----------|--------|
| Ambos modelos resuelven correctamente | Reescribe o ajusta el prompt para aumentar complejidad |
| Al menos uno falla | Selecciona "Sí" y continúa con la tarea |

Cuando al menos uno falle, **extrae el log de errores del modelo desde Cursor** como documentación.

> ⚠️ IMPORTANTE: Solo abre `App/` en Cursor — los modelos NO deben tener acceso a los patches.

---

## 2.5 Generar la Solución y el Parche Dorado

**Ubicación:** `patches/gold_patch.patch`

Una vez que al menos un modelo falle, escribe tu propia **Solución Dorada** (completa e impecable).

```bash
# 1. Implementa la solución en App/
# Edita los archivos necesarios...

# 2. Crea el parche
# Opción A — Archivos específicos:
git -C App diff archivo1 archivo2 > patches/gold_patch.patch

# Opción B — Todos los cambios:
git -C App diff > patches/gold_patch.patch

# 3. Deshaz los cambios para mantener App/ en estado problemático
git -C App checkout -- .
```

> ✅ Verifica que el parche aplica correctamente:
> ```bash
> git -C App apply --ignore-whitespace patches/gold_patch.patch
> ```

---

## Checklist del Paso 2

- [ ] Tipo de problema identificado y prompt redactado
- [ ] Prompt probado con Sonnet 4.6 — al menos uno falla
- [ ] Prompt probado con Qwen 3.5 27b — confirmado fallo
- [ ] Log de errores extraído de Cursor
- [ ] `basetoinstance.patch` generado (vacío si no es bug injection)
- [ ] `gold_patch.patch` generado y verificado con `git apply --ignore-whitespace`
- [ ] `App/` restaurado al estado original/defectuoso

---

→ Continúa con `references/03_testing.md`
