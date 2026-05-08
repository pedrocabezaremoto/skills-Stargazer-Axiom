# Guía de Plantillas Dockerfile — Stargazer Axiom

## Tabla de Contenido
- [Base.dockerfile](#basedockerfile)
- [Instance.dockerfile](#instancedockerfile)
- [Reglas Generales](#reglas-generales)

---

## Base.dockerfile

### Propósito
Construye la imagen base del proyecto: clona el repositorio, instala dependencias del sistema y del proyecto, y deja el entorno listo para ser extendido por el Instance.dockerfile.

### Estructura por Secciones

```dockerfile
###############################################
# IMAGEN BASE
###############################################
# TODO: Elegir la imagen base adecuada
# FROM <imagen-base>:<etiqueta>

###############################################
# DIRECTORIO DE TRABAJO
###############################################
# NO MODIFICAR ESTAS SECCIONES
RUN mkdir /app
WORKDIR /app

###############################################
# DEPENDENCIAS DEL SISTEMA
###############################################
# TODO: Instalar las dependencias del sistema necesarias
# RUN apt-get update && apt-get install -y git <otros-paquetes-necesarios>

###############################################
# CONFIGURACIÓN DEL REPOSITORIO
###############################################
# TODO: SOLO MODIFICAR LA PARTE REPO_URL.
# (Excepción: Se pueden agregar comandos adicionales de
# configuración de Git o de estructura del repositorio si es necesario)
RUN git clone <url_del_repositorio> .
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git reset --hard $LATEST_COMMIT

###############################################
# DEPENDENCIAS Y CONFIGURACIÓN DEL PROYECTO
###############################################
# Instalar aquí las dependencias del proyecto.

###############################################
# PUNTO DE ENTRADA / CMD
###############################################
```

### Reglas de la Plantilla

| Sección | ¿Modificable? | Notas |
|---|---|---|
| IMAGEN BASE | ✅ Sí | Elegir imagen según el stack del proyecto |
| DIRECTORIO DE TRABAJO | ❌ No | Siempre `/app` |
| DEPENDENCIAS DEL SISTEMA | ✅ Sí | Agregar paquetes según sea necesario |
| CONFIGURACIÓN DEL REPOSITORIO | ⚠️ Solo REPO_URL | No cambiar la lógica de git reset |
| DEPENDENCIAS DEL PROYECTO | ✅ Sí | npm install, pip install, etc. |
| PUNTO DE ENTRADA / CMD | ✅ Sí | Ver regla de ENTRYPOINT en Instance |

### Ejemplo Completo (Node.js)

```dockerfile
FROM node:20-slim

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/org/mi-proyecto.git .
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git reset --hard $LATEST_COMMIT

RUN npm install
```

---

## Instance.dockerfile

### Propósito
Extiende la imagen base aplicando un patch diferencial (`basetoinstance.patch`) que representa el estado "roto" del código que se va a testear. Siempre debe terminar con `ENTRYPOINT ["/bin/bash"]`.

### Estructura por Secciones

```dockerfile
FROM <imagen-base>

###############################################
# CONFIGURACIÓN DEL REPOSITORIO
###############################################
# NO MODIFICAR ESTA SECCIÓN
# (Excepción: comandos adicionales de Git si es necesario)
WORKDIR /app
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git checkout $LATEST_COMMIT

RUN \
  --mount=type=bind,source=patches/basetoinstance.patch,target=/tmp/basetoinstance.patch \
  if grep -q '^diff' /tmp/basetoinstance.patch 2>/dev/null; then \
    git apply --whitespace=fix /tmp/basetoinstance.patch; \
  else \
    echo "basetoinstance.patch está vacío o no tiene diferencias, omitiendo..."; \
  fi

###############################################
# DEPENDENCIAS Y CONFIGURACIÓN DEL PROYECTO
###############################################
# Normalmente se deja vacío.
# En casos excepcionales, instalar las mismas dependencias que en Base.dockerfile.

###############################################
# PUNTO DE ENTRADA
###############################################
ENTRYPOINT ["/bin/bash"]
```

### Reglas Críticas

> ⚠️ **ENTRYPOINT siempre debe ser `/bin/bash`.**
> Si los comandos de compilación y prueba están configurados como `CMD` o `ENTRYPOINT`, conviértelos a comandos `RUN` y muévelos a las secciones anteriores.

| Sección | ¿Modificable? | Notas |
|---|---|---|
| FROM | ✅ Sí | Debe apuntar a la imagen base construida |
| CONFIGURACIÓN DEL REPOSITORIO | ❌ No | Lógica de patch no se modifica |
| DEPENDENCIAS DEL PROYECTO | ⚠️ Rara vez | Solo si hay deps exclusivas de la instancia |
| ENTRYPOINT | ❌ No | Siempre `/bin/bash` |

### Cómo funciona el patch

El archivo `basetoinstance.patch` contiene el diff que transforma el código de su estado "limpio" al estado "roto" que se va a testear. Si el archivo está vacío o no contiene diffs, el script lo omite sin error.

---

## Reglas Generales

1. **El repositorio siempre se clona en `/app`** — no cambiar este path.
2. **`git reset --hard` en Base** garantiza el estado más reciente del HEAD.
3. **`git checkout` en Instance** garantiza consistencia con el commit base antes de aplicar el patch.
4. **No poner lógica de tests en los Dockerfiles** — eso va en los scripts `.sh`.
5. **Las dependencias del sistema van en Base** — Instance las hereda automáticamente.
