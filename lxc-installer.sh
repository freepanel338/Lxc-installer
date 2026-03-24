#!/usr/bin/env bash

# ================================
#   🚀 RyomenNodes Installer
#   made by PrimeNexus
#   Credit: Sagar
# ================================

set -e

# ===== COLORS (MODERN) =====
C="\e[38;5;51m"
G="\e[38;5;46m"
R="\e[38;5;196m"
B="\e[38;5;33m"
Y="\e[38;5;226m"
M="\e[38;5;201m"
W="\e[97m"
GRAY="\e[38;5;240m"
N="\e[0m"

# ===== LOADING =====
loading() {
    echo -e "${M}⏳ Processing...${N}"
    sleep 1
}

# ===== HEADER =====
header() {
    clear
    echo -e "${B}"
    echo "╔════════════════════════════════════════════╗"
    echo "║            RyomenNodes Installer           ║"
    echo "║          made by PrimeNexus 🔥             ║"
    echo "║             Credit: Sagar                 ║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "${N}"
}

# ===== PAUSE =====
pause() {
    echo ""
    read -p "$(echo -e ${GRAY}Press\ Enter\ to\ continue...${N})"
}

# ===== MAIN LOOP =====
while true; do
    header

    echo -e "${C} 1) ${W}Dependency Installer ${G}(Node + Mineflayer)${N}"
    echo -e "${C} 2) ${W}Bot Maker ${G}(Create app.js)${N}"
    echo -e "${C} 3) ${W}Auto Restarter ${G}(Systemd Service)${N}"
    echo -e "${C} 4) ${W}Bot Remover${N}"
    echo -e "${C} 5) ${W}Discord Server${N}"
    echo -e "${C} 6) ${W}YouTube Channel${N}"
    echo -e "${C} 7) ${W}VM Installer ${G}(IDX VPS)${N}"
    echo -e "${C} 8) ${W}RDP Installer${N}"
    echo -e "${C} 9) ${W}Tailscale VPN${N}"
    echo -e "${R}10) Exit${N}"

    echo -e "${GRAY}────────────────────────────────────────────${N}"
    read -p "$(echo -e ${Y}👉\ Select\ option\ [1-10]:${N}) " choice

    case $choice in

        1)
            loading
            curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/dependency.sh | bash
            pause
            ;;

        2)
            loading
            curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/bot_maker.sh | bash
            pause
            ;;

        3)
            loading
            curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/autorestarter.sh | bash
            pause
            ;;

        4)
            loading
            curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/bot_remover.sh | bash
            pause
            ;;

        5)
            echo -e "\n${B}📢 Discord Server:${N}"
            echo -e "${G}https://discord.gg/ZAAyrb4J6s${N}"
            pause
            ;;

        6)
            echo -e "\n${R}📺 YouTube Channel:${N}"
            echo -e "${Y}https://www.youtube.com/@OfficialNotGamerPie${N}"
            pause
            ;;

        7)
            loading
            bash <(curl -fsSL https://raw.githubusercontent.com/NotGamerPiie/idx-vps/main/vps.sh)
            pause
            ;;

        8)
            loading
            curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/rdp_installer.sh | bash
            pause
            ;;

        9)
            loading
            curl -fsSL https://tailscale.com/install.sh | sh
            echo -e "${G}✔ Tailscale Installed!${N}"
            pause
            ;;

        10)
            echo -e "\n${G}👋 Exiting... Thanks for using RyomenNodes!${N}"
            exit 0
            ;;

        *)
            echo -e "\n${R}❌ Invalid option!${N}"
            sleep 1
            ;;
    esac
done
