# Stack de IAs — Pedro

## Memoria
Tienes acceso a Engram (memoria persistente) via MCP.
- Guarda proactivamente después de trabajo significativo (mem_save).
- Después de cualquier reset de contexto, llama a mem_context para recuperar estado.
- Usa mem_search para buscar decisiones y lecciones anteriores.

## Perfil
- Usuario: Pedro (pedro@Pedro, Kali Linux Rolling)
- Curso: IFCT0210 — Auxiliar Técnico Informático
- Hardware: i3-4130, 12GB RAM, sin GPU CUDA
- GitHub: Pedro6065

## Stack instalado
- Ollama 0.21.0 (0.0.0.0:11434) con llama3.2:3b
- Open WebUI (Docker, localhost:8080)
- VSCode + Continue.dev (chat, sin autocomplete)
- Git 2.53.0 + GitHub CLI (Pedro6065)
- Claude Code 2.1.116
- n8n (Docker, localhost:5678)
- Engram 1.12.0 (memoria persistente SQLite)

## Agentes de estudio (IFCT0210)

### /investigador
Busca y sintetiza información del temario del curso.
Modelo preferido: llama3.2:3b via Ollama.

### /redactor
Crea apuntes, resúmenes y documentación clara.
Formato: markdown. Tono: directo y conciso.

### /evaluador
Genera tests tipo examen, corrige ejercicios y da feedback.
Formato: preguntas con respuestas al final.

### /coder
Ayuda con scripts bash, PowerShell y automatización.
Prioriza scripts simples y bien comentados.

## Agentes IT profesionales

### /it-diagnostics
Analiza síntomas técnicos y propone diagnóstico y solución.
Sigue el flujo: síntoma → causa probable → verificación → solución.

### /it-scripter
Genera scripts de mantenimiento, monitorización y automatización.
Lenguajes: bash, PowerShell. Siempre con manejo de errores.

### /it-docs
Documenta incidencias, tickets y resoluciones.
Formato: fecha, descripción, pasos, resolución, prevención.

### /it-security
Revisa configuraciones de seguridad, busca CVEs relevantes.
Herramientas: nmap, OpenVAS, análisis de logs.

## Convenciones
- Idioma: español
- Scripts: siempre con comentarios explicativos
- Commits: en español, formato "tipo: descripción" (feat:, fix:, docs:)
- Rama principal: main
