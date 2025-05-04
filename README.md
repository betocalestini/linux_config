# 🐧 Script de Instalação e Configuração para Arch Based Linux

## 📋 Descrição

Este projeto fornece um script automatizado para instalação e configuração de um ambiente de desenvolvimento completo no Manjaro Linux. Ele inclui a instalação de aplicativos essenciais, configuração do Zsh com Oh My Zsh e Powerlevel10k, além da instalação de fontes recomendadas.

## 🚀 Funcionalidades

* Instalação de aplicativos via `pacman`, `yay` e `flatpak`.
* Configuração do Zsh como shell padrão com Oh My Zsh e tema Powerlevel10k.
* Instalação de plugins úteis: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf` e `k`.
* Instalação das fontes MesloLGS NF (Regular, Bold, Italic, Bold Italic).
* Configuração do terminal integrado do VSCode para utilizar Zsh e fontes apropriadas.

## 🛠️ Requisitos

* Sistema operacional: Manjaro Linux.
* Acesso sudo para instalação de pacotes e configurações do sistema.

## 📦 Aplicativos Instalados

### Via `pacman`:

* docker
* docker-compose
* flatpak
* base-devel
* git
* zsh
* curl
* wget
* unzip
* variety

### Via `yay`:

* visual-studio-code-bin
* cryptomator
* anydesk-bin

### Via `flatpak`:

* com.spotify.Client
* md.obsidian.Obsidian
* com.google.Chrome
* org.onlyoffice.desktopeditors
* com.getpostman.Postman
* com.bitwarden.desktop
* us.zoom.Zoom
* com.brave.Browser
* org.libreoffice.LibreOffice
* com.discordapp.Discord
* org.telegram.desktop
* com.valvesoftware.Steam
* net.davidotek.pupgui2

## 📄 Instruções de Uso

1. Clone este repositório:

   ```bash
   git clone https://github.com/betocalestini/linux_config.git
   cd linux_config
   ```

2. Torne o script executável:

   ```bash
   chmod +x config.sh
   ```

3. Execute o script:

   ```bash
   ./config.sh
   ```

4. Após a conclusão, reinicie o sistema para aplicar todas as alterações.

## 📝 Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE[https://mit-license.org/] para obter mais informações.


---

**Autor:** Roberto Calestini

---

