#!/bin/bash
# ============================================
# Stack de IAs — Pedro
# Instalación completa en Kali Linux / Ubuntu
# github.com/Pedro6065/stack-ia · Abril 2026
# ============================================

set -e

GREEN='\033[0;32m'
AMBER='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }
print_ok()   { echo -e "${GREEN}✅ $1${NC}"; }
print_warn() { echo -e "${AMBER}⚠️  $1${NC}"; }

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     Stack de IAs — Instalación           ║"
echo "╚══════════════════════════════════════════╝"
echo ""

print_step "PASO 1/8: Ollama"
if command -v ollama &> /dev/null; then
    print_ok "Ollama ya instalado: $(ollama --version)"
else
    curl -fsSL https://ollama.com/install.sh | sh
    print_ok "Ollama instalado"
fi
sudo mkdir -p /etc/systemd/system/ollama.service.d
echo '[Service]
Environment="OLLAMA_HOST=0.0.0.0"' | sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null
sudo systemctl daemon-reload
sudo systemctl restart ollama
sleep 3
print_ok "Ollama configurado en 0.0.0.0:11434"
if ollama list 2>/dev/null | grep -q "llama3.2:3b"; then
    print_ok "Modelo llama3.2:3b ya descargado"
else
    echo "Descargando llama3.2:3b (~2 GB)..."
    ollama pull llama3.2:3b
    print_ok "Modelo llama3.2:3b descargado"
fi

print_step "PASO 2/8: Docker"
if command -v docker &> /dev/null; then
    print_ok "Docker ya instalado: $(docker --version)"
else
    sudo apt update
    sudo apt install -y docker.io docker-compose
    sudo systemctl enable --now docker
    print_ok "Docker instalado"
fi
sudo groupadd -f docker
if groups | grep -q docker; then
    print_ok "Usuario ya en grupo docker"
else
    sudo usermod -aG docker $USER
    print_warn "Usuario añadido al grupo docker — REQUIERE cerrar sesión"
fi

print_step "PASO 3/8: Open WebUI"
if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q open-webui; then
    print_ok "Open WebUI ya existe"
    docker start open-webui 2>/dev/null || true
else
    sudo docker run -d \
        --network=host \
        -v open-webui:/app/backend/data \
        -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
        --name open-webui \
        --restart always \
        ghcr.io/open-webui/open-webui:main
    print_ok "Open WebUI instalado en localhost:8080"
fi

print_step "PASO 4/8: VSCode + Extensiones"
if command -v code &> /dev/null; then
    print_ok "VSCode ya instalado: $(code --version | head -1)"
else
    sudo apt install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f /tmp/packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
    print_ok "VSCode instalado"
fi
code --install-extension Continue.continue 2>/dev/null || true
code --install-extension ms-azuretools.vscode-docker 2>/dev/null || true
print_ok "Extensiones instaladas"

print_step "PASO 5/8: Git + GitHub CLI"
if command -v git &> /dev/null; then
    print_ok "Git ya instalado: $(git --version)"
else
    sudo apt install -y git
fi
if [ -z "$(git config --global user.name)" ]; then
    read -p "Tu nombre de usuario de GitHub: " git_user
    read -p "Tu email de GitHub: " git_email
    git config --global user.name "$git_user"
    git config --global user.email "$git_email"
fi
git config --global init.defaultBranch main
git config --global pull.rebase false
print_ok "Git configurado: $(git config --global user.name)"
if command -v gh &> /dev/null; then
    print_ok "GitHub CLI ya instalado: $(gh --version | head -1)"
else
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
    print_ok "GitHub CLI instalado"
fi

print_step "PASO 6/8: Claude Code CLI"
if command -v claude &> /dev/null; then
    print_ok "Claude Code ya instalado: $(claude --version 2>/dev/null || echo 'instalado')"
else
    curl -fsSL https://claude.ai/install.sh | bash
    print_ok "Claude Code instalado"
fi

print_step "PASO 7/8: n8n"
if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "^n8n$"; then
    print_ok "n8n ya existe"
    docker start n8n 2>/dev/null || true
else
    sudo docker pull docker.n8n.io/n8nio/n8n
    sudo docker run -d \
        --name n8n \
        -p 5678:5678 \
        -v n8n_data:/home/node/.n8n \
        --restart always \
        docker.n8n.io/n8nio/n8n
    print_ok "n8n instalado en localhost:5678"
fi

print_step "PASO 8/8: Engram"
if command -v engram &> /dev/null; then
    print_ok "Engram ya instalado: $(engram --version 2>/dev/null || echo 'instalado')"
else
    ENGRAM_URL=$(curl -s https://api.github.com/repos/Gentleman-Programming/engram/releases/latest | grep "browser_download_url.*linux.*amd64" | cut -d '"' -f 4)
    if [ -n "$ENGRAM_URL" ]; then
        curl -LO "$ENGRAM_URL" -o /tmp/engram.tar.gz
        cd /tmp && tar xzf engram_*.tar.gz
        sudo mv /tmp/engram /usr/local/bin/
        print_ok "Engram instalado"
    else
        print_warn "No se pudo descargar Engram. Instálalo manualmente."
    fi
fi
if command -v claude &> /dev/null && command -v engram &> /dev/null; then
    claude mcp add-json engram '{"command":"engram","args":["mcp"]}' 2>/dev/null || true
    print_ok "Engram conectado a Claude Code"
fi

# Continue.dev config
mkdir -p ~/.continue
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/../configs/continue-config.yaml" ]; then
    cp "$SCRIPT_DIR/../configs/continue-config.yaml" ~/.continue/config.yaml
else
    cat > ~/.continue/config.yaml << 'EOF'
name: Stack local
version: 1.0.0
schema: v1
models:
  - name: Llama 3.2 3B
    provider: ollama
    model: llama3.2:3b
    apiBase: http://localhost:11434
    roles:
      - chat
      - edit
      - apply
context:
  - provider: code
  - provider: docs
  - provider: diff
  - provider: terminal
  - provider: problems
  - provider: folder
  - provider: codebase
EOF
fi
print_ok "Continue.dev configurado"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     ✅ INSTALACIÓN COMPLETADA            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Servicios:"
echo "  Ollama       → localhost:11434"
echo "  Open WebUI   → localhost:8080"
echo "  n8n          → localhost:5678"
echo ""
echo -e "${AMBER}PASOS MANUALES PENDIENTES:${NC}"
echo "  1. Cerrar sesión y volver a entrar (grupo docker)"
echo "  2. gh auth login"
echo "  3. claude (autenticarse — requiere cuenta Pro)"
echo "  4. Crear cuenta admin en Open WebUI (localhost:8080)"
echo "  5. Crear cuenta admin en n8n (localhost:5678)"
echo "  6. En n8n: conectar Ollama → http://172.17.0.1:11434"
echo ""
