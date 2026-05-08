# Paso 1: Configuración y Análisis

## 1.1 Configuración del Entorno

Antes de revisar el código fuente asignado, asegúrate de que:
- Tu entorno esté configurado
- **Cursor** esté instalado y configurado con Sonnet 4.6 y Qwen 3.5 27b
- **Docker** esté en ejecución

### Crea las carpetas de trabajo

```bash
mkdir App dockerfiles scripts patches
```

Estructura inicial:
```
proyecto/
├── App/
├── dockerfiles/
├── scripts/
└── patches/
```

---

## 1.2 Clonar el Repositorio y Analizar el Código

```bash
# Clona el repositorio asignado
git clone <repo_url> App/

# Entra al repositorio
cd App/
```

### Qué explorar en el código fuente

Antes de crear cualquier issue, analiza:

1. **Estructura y arquitectura** — ¿Cómo están organizados los módulos?
2. **Tipo de problema asignado** — ¿Es nueva función, bug injection, migración, optimización o mantenimiento?
3. **Dependencias y proceso de compilación** — ¿Qué herramientas usa el proyecto? (npm, pip, cargo, etc.)
4. **Puntos de extensión** — ¿Dónde encajaría una nueva funcionalidad?
5. **Pruebas existentes** — ¿Qué framework de testing usa? ¿Cuál es la convención de nombres?

### Preguntas clave a responder antes de continuar

- ¿Cuál es el entry point del proyecto?
- ¿Dónde viven las pruebas actualmente?
- ¿Qué comandos ejecutan las pruebas? (`npm test`, `pytest`, `cargo test`, etc.)
- ¿Hay archivos de configuración relevantes? (`jest.config.js`, `pytest.ini`, etc.)

---

## Checklist del Paso 1

- [ ] Cursor configurado con ambos modelos (Sonnet 4.6 y Qwen 3.5 27b)
- [ ] Docker corriendo
- [ ] Repositorio clonado en `App/`
- [ ] Estructura del proyecto comprendida
- [ ] Framework de testing identificado
- [ ] Tipo de problema asignado claro

---

→ Continúa con `references/02_problem_creation.md`
