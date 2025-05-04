#!/bin/bash

set -e

# Função para verificar e instalar pacotes via pacman
install_pacman_pkg() {
    for pkg in "$@"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            echo "✅ Pacman: $pkg já está instalado."
        else
            echo "📦 Instalando $pkg via pacman..."
            sudo pacman -S --noconfirm "$pkg"
        fi
    done
}

# Função para verificar e instalar pacotes via yay
install_yay_pkg() {
    for pkg in "$@"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            echo "✅ Yay: $pkg já está instalado."
        else
            echo "📦 Instalando $pkg via yay..."
            yay -S --noconfirm "$pkg"
        fi
    done
}

# Função para verificar e instalar aplicativos via Flatpak
install_flatpak_app() {
    for app in "$@"; do
        if flatpak info "$app" &>/dev/null; then
            echo "✅ Flatpak: $app já está instalado."
        else
            echo "📦 Instalando $app via Flatpak..."
            flatpak install -y flathub "$app"
        fi
    done
}

echo "🔄 Atualizando o sistema..."
sudo pacman -Syu --noconfirm

echo "📦 Instalando pacotes essenciais via pacman..."
install_pacman_pkg docker docker-compose flatpak base-devel git zsh curl wget unzip

echo "🔧 Habilitando e iniciando o serviço do Docker..."
sudo systemctl enable --now docker

echo "👤 Adicionando o usuário atual ao grupo docker..."
sudo usermod -aG docker "$USER"

# Verificar se o yay está instalado
if ! command -v yay &>/dev/null; then
    echo "🛠️ Instalando o yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "✅ Yay já está instalado."
fi

echo "🌐 Adicionando o repositório Flathub..."
if ! flatpak remote-list | grep -q flathub; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "✅ Repositório Flathub já está adicionado."
fi

echo "🎵 Instalando aplicativos via Flatpak..."
install_flatpak_app \
    com.spotify.Client \
    md.obsidian.Obsidian \
    com.google.Chrome \
    org.onlyoffice.desktopeditors \
    com.getpostman.Postman \
    com.bitwarden.desktop \
    us.zoom.Zoom \
    com.brave.Browser \
    org.libreoffice.LibreOffice \
    com.valvesoftware.Steam \
    net.davidotek.pupgui2 \
    org.telegram.desktop \
    com.discordapp.Discord

echo "💻 Instalando aplicativos via yay (AUR)..."
install_yay_pkg visual-studio-code-bin cryptomator anydesk-bin

echo "🧩 Instalando Variety via pacman..."
install_pacman_pkg variety

echo "🐚 Instalando e configurando Zsh com Oh My Zsh e Powerlevel10k..."

# Instalar Zsh se ainda não estiver instalado
install_pacman_pkg zsh

# Definir Zsh como shell padrão
chsh -s /usr/bin/zsh

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✅ Oh My Zsh já está instalado."
fi

# Instalar Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Instalando o tema Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
    echo "✅ Tema Powerlevel10k já está instalado."
fi

# Instalar plugins zsh-autosuggestions e zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "🔌 Instalando o plugin zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
    echo "✅ Plugin zsh-autosuggestions já está instalado."
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "🔌 Instalando o plugin zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
    echo "✅ Plugin zsh-syntax-highlighting já está instalado."
fi

# Instalar o plugin fzf
if [ ! -d "$HOME/.fzf" ]; then
    echo "🔍 Instalando o plugin fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "✅ Plugin fzf já está instalado."
fi

# Instalar o plugin k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/k" ]; then
    echo "📁 Instalando o plugin k..."
    git clone https://github.com/supercrabtree/k \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/k"
else
    echo "✅ Plugin k já está instalado."
fi

# Baixar e instalar as fontes MesloLGS NF
echo "🔤 Instalando fontes MesloLGS NF..."
install_pacman_pkg ttf-meslo-nerd



# Atualizar o cache de fontes
echo "🔄 Atualizando o cache de fontes..."
fc-cache -fv

cd ~

# Configurar o tema e plugins no .zshrc
echo "📝 Configurando o .zshrc..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf k)/' ~/.zshrc

# Adicionar alias para o VSCode instalado via Flatpak
echo "alias code='/usr/bin/code'" >> ~/.zshrc

# Configurar o terminal integrado do VSCode
echo "🛠️ Configurando o terminal integrado do VSCode..."
mkdir -p ~/.config/Code/User
cat <<EOL > ~/.config/Code/User/settings.json
{
    "terminal.integrated.profiles.linux": {
        "zsh-linux": {
            "path": "/usr/bin/flatpak-spawn",
            "args": ["--host", "--env=TERM=xterm-256color", "zsh"],
            "overrideName": true
        }
    },
    "terminal.integrated.defaultProfile.linux": "zsh-linux",
    "terminal.integrated.cwd": ".",
    "terminal.integrated.fontFamily": "MesloLGS NF",
    "thunder-client.saveToWorkspace": true,
    "terminal.integrated.enableMultiLinePasteWarning": "auto"
}
EOL

source ~/.zshrc

echo "✅ Instalação e configuração concluídas com sucesso!"
echo "🔁 Por favor, reinicie o sistema ou faça logout/login para aplicar todas as alterações."
