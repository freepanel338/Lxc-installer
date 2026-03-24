#!/usr/bin/env bash

# ===== COLORS =====
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[97m"
RESET="\e[0m"

# ===== HEADER =====
header() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════╗"
    echo "║            RyomenNodes Installer           ║"
    echo "║          made by PrimeNexus 🔥             ║"
    echo "║             Credit: Sagar                 ║"
    echo "╚════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# ===== PAUSE =====
pause() {
    echo ""
    read -r -p "Press Enter to continue..." dummy
}

# ===== SAFE RUN =====
run_safe() {
    bash -c "$1" || echo -e "${RED}⚠ Command failed but script continues${RESET}"
}

# ===== MAIN LOOP =====
while true; do
    header

    echo -e "${CYAN} 1) ${WHITE}Dependency Installer${RESET}"
    echo -e "${CYAN} 2) ${WHITE}Bot Maker${RESET}"
    echo -e "${CYAN} 3) ${WHITE}Auto Restarter${RESET}"
    echo -e "${CYAN} 4) ${WHITE}Bot Remover${RESET}"
    echo -e "${CYAN} 5) ${WHITE}Discord Server${RESET}"
    echo -e "${CYAN} 6) ${WHITE}YouTube Channel${RESET}"
    echo -e "${CYAN} 7) ${WHITE}VM Installer${RESET}"
    echo -e "${CYAN} 8) ${WHITE}RDP Installer${RESET}"
    echo -e "${CYAN} 9) ${WHITE}Tailscale${RESET}"
    echo -e "${RED}10) Exit${RESET}"

    echo "────────────────────────────────────────────"

    read -r -p "Select option: " choice

    case $choice in
        1)
            run_safe "curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/dependency.sh | bash"
            pause
            ;;
        2)
            run_safe "curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/bot_maker.sh | bash"
            pause
            ;;
        3)
            run_safe "curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/autorestarter.sh | bash"
            pause
            ;;
        4)
            run_safe "curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/bot_remover.sh | bash"
            pause
            ;;
        5)
            echo "Discord: https://discord.gg/ZAAyrb4J6s"
            pause
            ;;
        6)
            echo "YouTube: https://www.youtube.com/@OfficialNotGamerPie"
            pause
            ;;
        7)
            run_safe "bash <(curl -fsSL https://raw.githubusercontent.com/NotGamerPiie/idx-vps/main/vps.sh)"
            pause
            ;;
        8)
            run_safe "curl -fsSL https://raw.githubusercontent.com/Sagargamin/INSTALLER-REPO/main/rdp_installer.sh | bash"
            pause
            ;;
        9)
            run_safe "curl -fsSL https://tailscale.com/install.sh | sh"
            pause
            ;;
        10)
            echo -e "${GREEN}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${RESET}"
            sleep 1
            ;;
    esac

done
