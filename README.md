# 🤖 Stack de IAs — Técnico Informático

Stack completo de herramientas de IA locales y gratuitas para estudio y trabajo en soporte técnico informático. Diseñado para funcionar en hardware modesto sin GPU dedicada.

> Instalado y probado en Kali Linux Rolling · Intel i3-4130 · 12 GB RAM · Sin GPU CUDA

## 📋 Componentes

| Componente | Versión | Función | Puerto/Acceso |
|---|---|---|---|
| **Ollama** | 0.21.0 | Servidor local de LLMs | `0.0.0.0:11434` |
| **Open WebUI** | latest | Interfaz de chat tipo ChatGPT | `localhost:8080` |
| **VSCode** | 1.116.0 | Editor de código | Aplicación |
| **Continue.dev** | 1.2.22 | Copiloto IA en VSCode | Extensión VSCode |
| **Git** | 2.53.0 | Control de versiones | CLI |
| **GitHub CLI** | 2.90.0 | Gestión de repos desde terminal | CLI |
| **Claude Code** | 2.1.116 | Agente de código con IA (Anthropic) | CLI |
| **n8n** | 2.17.3 | Automatización visual de workflows | `localhost:5678` |
| **Engram** | 1.12.0 | Memoria persistente para agentes IA | MCP (SQLite) |

## 🏗️ Arquitectura
## ⚡ Instalación rápida

```bash
## ⚡ Instalación rápida

```bash
git clone https://github.com/Pedro6065/stack-ia.git
cd stack-ia
chmod +x scripts/install.sh
./scripts/install.sh
```

## 📦 Requisitos mínimos

- **SO:** Kali Linux / Ubuntu 20.04+ / Debian 10+
- **CPU:** Cualquier x86_64 con 2+ cores
- **RAM:** 8 GB mínimo (12 GB recomendado)
- **Disco:** 20 GB libres
- **GPU:** No necesaria (todo funciona por CPU)

## 🧠 Modelos recomendados por hardware

| Hardware | Modelo | RAM usada | Velocidad |
|---|---|---|---|
| 8 GB RAM, sin GPU | llama3.2:3b | ~2 GB | Fluido |
| 8 GB RAM, sin GPU | qwen2.5-coder:1.5b | ~1 GB | Muy rápido |
| 16 GB RAM, sin GPU | mistral:7b | ~4.5 GB | Aceptable |
| 16+ GB RAM, con GPU | deepseek-r1:7b | ~4.5 GB | Rápido |

## 🤖 Agentes definidos

### Para estudio (IFCT0210)

| Agente | Función |
|---|---|
| /investigador | Busca y sintetiza información del temario |
| /redactor | Crea apuntes y resúmenes |
| /evaluador | Genera tests y corrige ejercicios |
| /coder | Ayuda con scripts y automatización |

### Para trabajo IT profesional

| Agente | Función |
|---|---|
| /it-diagnostics | Analiza síntomas y propone diagnóstico |
| /it-scripter | Genera scripts bash/PowerShell |
| /it-docs | Documenta incidencias y tickets |
| /it-security | Revisiones de seguridad y CVEs |

## 🛠️ Comandos de gestión diaria

```bash
# Ver estado
systemctl status ollama
docker ps

# Arrancar/parar
docker start open-webui n8n
docker stop open-webui n8n

# Modelos
ollama list

# Claude Code
cd ~/stack-ia && claude

# Logs
docker logs open-webui --tail 50
docker logs n8n --tail 50
```

## 📝 Post-instalación (pasos manuales)

1. Cerrar sesión del sistema y volver a entrar (grupo Docker)
2. `gh auth login` — autenticarse en GitHub
3. `claude` — autenticarse en Claude Code (requiere cuenta Pro)
4. Abrir localhost:8080 — crear cuenta admin en Open WebUI
5. Abrir localhost:5678 — crear cuenta admin en n8n
6. En n8n: conectar Ollama con URL http://172.17.0.1:11434

## ⚠️ Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| ollama pull falla con error SSL | Proxy intercepta Cloudflare R2 | Descargar modelos en otra red |
| Continue.dev lento, CPU al 100% | Modelos 3B en CPU sin GPU | Desactivar autocomplete |
| Docker permission denied | Grupo no aplicado | Cerrar sesión completa |
| n8n fetch failed con Ollama | localhost apunta al contenedor | Usar http://172.17.0.1:11434 |

## 📁 Estructura del repositorio
## 📄 Licencia

MIT — Úsalo, modifícalo, compártelo libremente.

## 👤 Autor

**Pedro** — [@Pedro6065](https://github.com/Pedro6065)
Estudiante de IFCT0210 (Auxiliar Técnico Informático)

---
*Generado con ayuda de Claude (Anthropic) · Abril 2026*
