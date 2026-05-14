# Guía de Configuración del Entorno — Stargazer Axiom

## Prerequisitos

Antes de iniciar cualquier tarea en Stargazer, **Cursor** y **Docker** deben estar correctamente configurados.

---

## Configuración de Cursor

### Instalación
- **Descargar versión 2.6 específicamente** — otras versiones no funcionan con los modelos de Outlier
- Si ya tienes Cursor instalado, desinstala e instala la 2.6
- Acepta la invitación al **Cursor Team Plan** — contactar QMs en el War Room de Zoom si no tienes acceso

### Configuración de modelos
1. Abre **Cursor Settings → Models**
2. **Desactiva** todos los modelos existentes
3. Añade únicamente estos dos modelos (guía oficial 2026-05-08):
   - `claude-qwen3-5-27b-scale`
   - `claude-4.6-sonnet-scale`

> **CAMBIO:** Los modelos anteriores `gpt-oss-120b-bedrock` y `qwen3-235b-a22b-instruct-2507-scale` eran de guías previas. La guía oficial actualizada (2026-05-08) usa los modelos arriba.

### Configuración de API Key
1. Accede al **Key Manager**: `https://cursor-intelligence-service.outlier.ai/key-manager`
2. Haz clic en **"View API Key"**
3. En Cursor Settings → **Habilita OpenAI API Key**
4. Pega tu API key
5. Sobrescribe la **Base URL** con: `https://cursor-intelligence-api.outlier.ai/api/v1`
6. Haz clic en **"Verify"**
7. Prueba los modelos en Cursor para confirmar que funcionan

---

## Configuración de Docker

### Instalación
- Asegúrate de tener Docker instalado y actualizado
- Si no lo tienes, sigue la guía oficial de instalación de Outlier

### Configuración de recursos
- Asigna suficiente **RAM y espacio en disco** para que los contenedores se ejecuten sin problemas
- Como regla general: mínimo 8 GB RAM disponibles para Docker

### Mantenimiento
- Limpia regularmente imágenes y contenedores no utilizados para liberar espacio:

```bash
# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes no utilizadas
docker image prune

# Limpieza completa (contenedores, imágenes, redes, volúmenes sin usar)
docker system prune
```

---

## Extracción del Rastro del Modelo (Model Trace)

La transcripción del agente es un archivo `.md` con el historial completo de la conversación en Cursor.
**Es obligatorio subirla a la tarea.**

### Pasos para exportar
1. Ve al panel de **Chat** en Cursor
2. Haz clic en el ícono de **tres puntos** (`...`) en la esquina superior derecha
3. Selecciona **"Export Transcript"**
4. Se generará automáticamente un archivo `.md` con el contenido del chat
5. Sube ese archivo a la tarea en la plataforma Stargazer

### Problemas comunes al exportar
| Problema | Solución |
|----------|----------|
| La opción no aparece | Asegúrate de estar en el panel correcto (Agents Window, no chat normal) |
| El archivo está vacío | Verifica que la conversación haya tenido respuestas del agente |
| Error al subir | El archivo debe estar en formato `.md`, no renombrar a otro formato |

---

## Estructura de carpetas esperada en la tarea

```
/App/                          → Código base (commit "base")
/dockerfiles/
    base.Dockerfile
    instance.Dockerfile
/scripts/
    run_script.sh              → Debe ser ejecutable (chmod +x)
    parse_results.sh           → Debe ser ejecutable (chmod +x)
/patches/
    gold_patch.patch
    test_patch.patch
    basetoinstance.patch
test_results.json
```

---

## Verificación del entorno antes de iniciar

```bash
# Verificar Docker está corriendo
docker info

# Verificar que los Dockerfiles compilan
docker build -f dockerfiles/base.Dockerfile -t test-base .
docker build -f dockerfiles/instance.Dockerfile -t test-instance .

# Verificar que la instancia ejecuta correctamente
docker run test-instance
```

Si `docker build` falla con errores de paquetes dañados o comandos incorrectos, **depura antes de subir la tarea**.
