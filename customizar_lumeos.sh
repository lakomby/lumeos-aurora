#!/usr/bin/env bash
set -e

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
# 3. DOWNLOADS DOS LOGOS E WALLPAPERS DO SEU SERVIDOR
# ==========================================
BASE_URL="https://update.lumeos.com.br/images"

curl -fsSL "${BASE_URL}/wpp03.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/1920x1080.jpg
curl -fsSL "${BASE_URL}/wpp01.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp01.jpg
curl -fsSL "${BASE_URL}/wpp02.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp02.jpg
curl -fsSL "${BASE_URL}/wpp04.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp04.jpg
curl -fsSL "${BASE_URL}/wpp05.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp05.jpg
curl -fsSL "${BASE_URL}/wpp06.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp06.jpg
curl -fsSL "${BASE_URL}/wpp07.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp07.jpg
curl -fsSL "${BASE_URL}/wpp08.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp08.jpg
curl -fsSL "${BASE_URL}/wpp09.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp09.jpg
curl -fsSL "${BASE_URL}/wpp10.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp10.jpg
curl -fsSL "${BASE_URL}/wpp11.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp11.jpg
curl -fsSL "${BASE_URL}/wpp12.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp12.jpg
curl -fsSL "${BASE_URL}/wpp13.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp13.jpg
curl -fsSL "${BASE_URL}/wpp14.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp14.jpg
curl -fsSL "${BASE_URL}/wpp15.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp15.jpg
curl -fsSL "${BASE_URL}/wpp17.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp17.jpg
curl -fsSL "${BASE_URL}/wpp18.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp18.jpg
curl -fsSL "${BASE_URL}/wpp19.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp19.jpg
curl -fsSL "${BASE_URL}/wpp20.jpg" -o /usr/share/wallpapers/LumeOS_Galeria/contents/images/wpp20.jpg

curl -fsSL "${BASE_URL}/Logo01.png" -o /usr/share/plasma/look-and-feel/org.lumeos.aurora/contents/preview.png
curl -fsSL "${BASE_URL}/icn01.png" -o /usr/share/pixmaps/lumeos-logos/logo_menu.png
curl -fsSL "${BASE_URL}/icn02.png" -o /usr/share/pixmaps/lumeos-logos/logo_boot.png
curl -fsSL "${BASE_URL}/lg02.png"  -o /usr/share/pixmaps/lumeos-logos/logo_sistema.png

# ==========================================
# 4. INJETAR A ESTRELA DO LUMEOS NO MENU INICIAR
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
# 6. ENFIAR OS ATALHOS NA ÁREA DE TRABALHO DE FÁBRICA
# ==========================================
cp /var/lib/flatpak/exports/share/applications/com.google.Chrome.desktop /etc/skel/Desktop/ 2>/dev/null || true
cp /var/lib/flatpak/exports/share/applications/com.google.EarthPro.desktop /etc/skel/Desktop/ 2>/dev/null || true
cp /var/lib/flatpak/exports/share/applications/com.spotify.Client.desktop /etc/skel/Desktop/ 2>/dev/null || true
cp /var/lib/flatpak/exports/share/applications/org.onlyoffice.desktopeditors.desktop /etc/skel/Desktop/ 2>/dev/null || true

# ==========================================
# 7. SCRIPT DE AUTOMAÇÃO DE PRIMEIRO BOOT (FLATPAKS)
# ==========================================
mkdir -p /usr/etc/profile.d/
cat << 'EOF' > /usr/etc/profile.d/lumeos-firstboot.sh
#!/bin/bash
if [ ! -f ~/.config/lumeos-setup-done ]; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub com.google.Chrome
    flatpak install -y flathub com.google.EarthPro
    flatpak install -y flathub com.spotify.Client
    flatpak install -y flathub org.onlyoffice.desktopeditors
    touch ~/.config/lumeos-setup-done
fi
EOF
chmod +x /usr/etc/profile.d/lumeos-firstboot.sh
