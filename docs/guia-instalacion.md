# Guía de instalación paso a paso

Guía detallada del Stack de IAs en Kali Linux (también funciona en Ubuntu 20.04+).

## Hardware probado

| Componente | Especificación |
|---|---|
| CPU | Intel i3-4130 @ 3.40GHz (2 cores, 4 hilos) |
| RAM | 12 GB |
| GPU | GeForce 210 (no compatible con CUDA) |
| Disco | Kingston SA400S3 427 GB SSD |
| SO | Kali GNU/Linux Rolling (Kernel 6.19.11) |

## Paso 1 — Ollama + Open WebUI

### 1.1 Instalar Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama --version
```

### 1.2 Descargar modelo

```bash
ollama pull llama3.2:3b
ollama run llama3.2:3b "Hola, preséntate en una frase"
```

### 1.3 Configurar Ollama para todas las interfaces

```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d
echo '[Service]
Environment="OLLAMA_HOST=0.0.0.0"' | sudo tee /etc/systemd/system/ollama.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart ollama
curl http://172.17.0.1:11434
```

### 1.4 Instalar Docker

```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
sudo groupadd -f docker
sudo usermod -aG docker $USER
```

> Cerrar sesión completa y volver a entrar. Verificar con `groups`.

### 1.5 Instalar Open WebUI

```bash
docker run -d \
  --network=host \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

Acceder en localhost:8080 y crear cuenta admin.

## Paso 2 — VSCode

```bash
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code
code --install-extension Continue.continue
code --install-extension ms-azuretools.vscode-docker
```

## Paso 3 — Git + GitHub CLI

```bash
git config --global user.name "TU_USUARIO"
git config --global user.email "TU_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false
```

GitHub CLI (no está en repos de Kali):

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install -y gh
gh auth login
```

## Paso 4 — Continue.dev + Ollama

```bash
mkdir -p ~/.continue
cp configs/continue-config.yaml ~/.continue/config.yaml
```

> Autocompletado desactivado intencionalmente. En CPUs modestas consume 100% CPU constantemente.

## Paso 5 — Claude Code CLI

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude --version
claude
```

> Requiere cuenta Pro ($20/mes), Max, Team, Enterprise o Console.

## Paso 6 — n8n

```bash
docker pull docker.n8n.io/n8nio/n8n
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  --restart always \
  docker.n8n.io/n8nio/n8n
```

Conectar con Ollama en Settings > Chat > Ollama:
- Base URL: http://172.17.0.1:11434
- API Key: vacío

## Paso 7 — Engram

```bash
ENGRAM_URL=$(curl -s https://api.github.com/repos/Gentleman-Programming/engram/releases/latest | grep "browser_download_url.*linux.*amd64" | cut -d '"' -f 4)
cd /tmp && curl -LO "$ENGRAM_URL"
tar xzf engram_*.tar.gz
sudo mv engram /usr/local/bin/
engram --version
claude mcp add-json engram '{"command":"engram","args":["mcp"]}'
```

## Problemas conocidos

### Proxy intercepta Cloudflare R2

Síntoma: `tls: failed to verify certificate`

Causa: Proxy en la red reemplaza certificado SSL de r2.cloudflarestorage.com.

Diagnóstico:

```bash
curl -vI https://dd20bb891979d25aebc8bec07b2b3bbc.r2.cloudflarestorage.com 2>&1 | grep -E "issuer|subject"
```

Solución: Descargar modelos desde otra red sin proxy.

### Continue.dev lento

Solución: Desactivar autocomplete en config.yaml. Usar solo chat puntual.

### Docker permission denied

Solución: Cerrar sesión completa del sistema. Verificar con `groups`.

### n8n fetch failed con Ollama

Solución: Usar http://172.17.0.1:11434 en lugar de localhost.
