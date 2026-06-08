#!/usr/bin/env bash

# ==========================================
# 1. ALTERAR AS INFORMAÇÕES DO SISTEMA (ENTRANHAS)
# ==========================================
cat << 'EOF' > /etc/os-release
NAME="LumeOS"
VERSION="26 (Aurora)"
ID=lumeos
ID_LIKE="fedora"
VERSION_ID=26
PRETTY_NAME="LumeOS Aurora"
ANSI_COLOR="0;34"
HOME_URL="https://lumeos.org"
DOCUMENTATION_URL="https://lumeos.org"
SUPPORT_URL="https://lumeos.org"
BUG_REPORT_URL="https://lumeos.org"
DEFAULT_SUPPORT_URL="https://lumeos.org"
EOF

# ==========================================
# 2. CRIAR A ESTRUTURA DE PASTAS DO SISTEMA
# ==========================================
mkdir -p /usr/share/wallpapers/LumeOS_Galeria/contents/images/
mkdir -p /usr/share/plasma/look-and-feel/org.lumeos.aurora/contents/layouts/
mkdir -p /usr/share/pixmaps/lumeos-logos/
mkdir -p /usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/
mkdir -p /etc/skel/Desktop/

# ==========================================
# 3. DOWNLOADS DOS LOGOS E WALLPAPERS (CORRIGIDO PARA .PNG)
# ==========================================
BASE_URL="https://update.lumeos.com.br/images"

baixar_arquivo() {
    curl -fsSL "$1" -o "$2" || echo "Aviso: Nao foi possivel baixar $1"
}

# Buscando wpp03.png no servidor e salvando como o JPG padrao que o KDE espera
baixar_arquivo "${BASE_URL}/wpp03.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/1920x1080.jpg

# Baixando o resto da galeria (.png do servidor salvando como .png no sistema)
baixar_arquivo "${BASE_URL}/wpp01.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp01.png
baixar_arquivo "${BASE_URL}/wpp02.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp02.png
baixar_arquivo "${BASE_URL}/wpp04.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp04.png
baixar_arquivo "${BASE_URL}/wpp05.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp05.png
baixar_arquivo "${BASE_URL}/wpp06.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp06.png
baixar_arquivo "${BASE_URL}/wpp07.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp07.png
baixar_arquivo "${BASE_URL}/wpp08.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp08.png
baixar_arquivo "${BASE_URL}/wpp09.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp09.png
baixar_arquivo "${BASE_URL}/wpp10.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp10.png
baixar_arquivo "${BASE_URL}/wpp11.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp11.png
baixar_arquivo "${BASE_URL}/wpp12.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp12.png
baixar_arquivo "${BASE_URL}/wpp13.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp13.png
baixar_arquivo "${BASE_URL}/wpp14.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp14.png
baixar_arquivo "${BASE_URL}/wpp15.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp15.png
baixar_arquivo "${BASE_URL}/wpp17.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp17.png
baixar_arquivo "${BASE_URL}/wpp18.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp18.png
baixar_arquivo "${BASE_URL}/wpp19.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp19.png
baixar_arquivo "${BASE_URL}/wpp20.png" /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp20.png

# Logos (Garantindo que puxa com a caixa alta exata se houver)
baixar_arquivo "${BASE_URL}/Logo01.png" /usr/share/plasma/look-and-feel/org.lumeos.aurora/contents/preview.png
baixar_arquivo "${BASE_URL}/icn01.png" /usr/share/pixmaps/lumeos-logos/logo_menu.png
baixar_arquivo "${BASE_URL}/icn02.png" /usr/share/pixmaps/lumeos-logos/logo_boot.png
baixar_arquivo "${BASE_URL}/lg02.png"  /usr/share/pixmaps/lumeos-logos/logo_sistema.png

# ==========================================
# 4. INJETAR O LOGO DO LUMEOS NO MENU INICIAR
# ==========================================
cat << 'EOF' > /usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/lumeos_menu_icon.js
var desktops = desktops();
for (var i = 0; i < desktops.length; i++) {
    var panels = panels();
    for (var j = 0; j < panels.length; j++) {
        var widgets = panels[j].widgets();
        for (var k = 0; k < widgets.length; k++) {
            if (widgets[k].type === "org.kde.plasma.kickoff") {
                widgets[k].currentConfigGroup = ["General"];
                widgets[k].writeConfig("icon", "/usr/share/pixmaps/lumeos-logos/logo_menu.png");
            }
        }
    }
}
EOF

# ==========================================
# 5. CONFIGURAÇÃO DE AMBIENTE PADRÃO (TEMA ESCURO E WALLPAPER)
# ==========================================
cat << 'EOF' > /usr/share/plasma/look-and-feel/org.lumeos.aurora/contents/defaults
[kdeglobals][Icons]
Theme=Papirus-Dark

[Wallpaper]
Image=/usr/share/wallpapers/LumeOS_Galeria/contents/images/1920x1080.jpg
EOF

touch /usr/share/plasma/look-and-feel/org.lumeos.aurora/contents/layouts/main.xml

# ==========================================
# 6. SCRIPT DE AUTOMAÇÃO DE PRIMEIRO BOOT (FLATPAKS)
# ==========================================
mkdir -p /etc/profile.d/
cat << 'EOF' > /etc/profile.d/lumeos-firstboot.sh
#!/bin/bash
if [ ! -f ~/.config/lumeos-setup-done ]; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
    flatpak install -y flathub com.google.Chrome
    flatpak install -y flathub com.google.EarthPro
    flatpak install -y flathub com.spotify.Client
    flatpak install -y flathub org.onlyoffice.desktopeditors
    flatpak install -y flathub com.valvesoftware.Steam
    flatpak install -y flathub net.lutris.Lutris
    flatpak install -y flathub com.valvesoftware.Steam.Utility.mangoHUD
    
    mkdir -p ~/Desktop/
    cp /var/lib/flatpak/exports/share/applications/com.google.Chrome.desktop ~/Desktop/ 2>/dev/null || true
    cp /var/lib/flatpak/exports/share/applications/com.google.EarthPro.desktop ~/Desktop/ 2>/dev/null || true
    cp /var/lib/flatpak/exports/share/applications/com.spotify.Client.desktop ~/Desktop/ 2>/dev/null || true
    cp /var/lib/flatpak/exports/share/applications/org.onlyoffice.desktopeditors.desktop ~/Desktop/ 2>/dev/null || true
    cp /var/lib/flatpak/exports/share/applications/com.valvesoftware.Steam.desktop ~/Desktop/ 2>/dev/null || true
    cp /var/lib/flatpak/exports/share/applications/net.lutris.Lutris.desktop ~/Desktop/ 2>/dev/null || true
    
    chmod +x ~/Desktop/*.desktop 2>/dev/null || true
    touch ~/.config/lumeos-setup-done
fi
EOF
chmod +x /etc/profile.d/lumeos-firstboot.sh
