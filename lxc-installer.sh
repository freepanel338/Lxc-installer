#!/usr/bin/env bash

# ==========================================
# 🚀 RyomenNodes LXC Installer
# made by PrimeNexus
# Credit: FreePanel338
# ==========================================

# ===== COLORS =====
RED="\e[38;5;196m"
GREEN="\e[38;5;46m"
YELLOW="\e[38;5;226m"
BLUE="\e[38;5;33m"
CYAN="\e[38;5;51m"
MAGENTA="\e[38;5;201m"
WHITE="\e[97m"
GRAY="\e[38;5;240m"
RESET="\e[0m"

# ===== HEADER =====
header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           RyomenNodes LXC Installer          ║"
    echo "║            made by PrimeNexus 🔥             ║"
    echo "║          Credit: FreePanel338               ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# ===== PAUSE =====
pause() {
    echo ""
    read -p "Press Enter to continue..."
}

# ===== LOADING =====
loading() {
    echo -e "${MAGENTA}⏳ Processing...${RESET}"
    sleep 1
}

# ===== SAFE RUN =====
run_cmd() {
    bash -c "$1" || echo -e "${RED}⚠ Error but continuing...${RESET}"
}

# ===== INSTALL FUNCTIONS =====

install_lxc_script() {
    header
    loading
    echo -e "${CYAN}Installing LXC Panel Script...${RESET}"
    bash <(curl -s https://raw.githubusercontent.com/freepanel338/Lxc-installer/main/lxc-installer.sh)
    pause
}

install_docker() {
    header
    loading
    echo -e "${CYAN}Installing Docker...${RESET}"
    curl -fsSL https://get.docker.com | bash
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✔ Docker Installed${RESET}"
    pause
}

install_portainer() {
    header
    loading
    echo -e "${CYAN}Installing Portainer...${RESET}"
    docker volume create portainer_data
    docker run -d -p 9000:9000 --name=portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data portainer/portainer-ce
    echo -e "${GREEN}✔ Portainer Installed (Port 9000)${RESET}"
    pause
}

install_tailscale() {
    header
    loading
    echo -e "${CYAN}Installing Tailscale...${RESET}"
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    echo -e "${GREEN}✔ Tailscale Ready${RESET}"
    pause
}

system_update() {
    header
    loading
    echo -e "${CYAN}Updating System...${RESET}"
    apt update -y && apt upgrade -y
    echo -e "${GREEN}✔ System Updated${RESET}"
    pause
}

remove_all() {
    header
    echo -e "${RED}Removing all installed tools...${RESET}"
    docker rm -f portainer 2>/dev/null
    docker volume rm portainer_data 2>/dev/null
    apt remove docker docker.io -y
    apt remove tailscale -y
    echo -e "${GREEN}✔ Cleaned Successfully${RESET}"
    pause
}

# ===== MENU =====
main_menu() {
    while true; do
        header

        echo -e "${CYAN}1) ${WHITE}Install LXC Panel Script${RESET}"
        echo -e "${CYAN}2) ${WHITE}Install Docker${RESET}"
        echo -e "${CYAN}3) ${WHITE}Install Portainer${RESET}"
        echo -e "${CYAN}4) ${WHITE}Install Tailscale${RESET}"
        echo -e "${CYAN}5) ${WHITE}System Update${RESET}"
        echo -e "${CYAN}6) ${WHITE}Remove All Tools${RESET}"
        echo -e "${RED}7) Exit${RESET}"

        echo -e "${GRAY}────────────────────────────────────────────${RESET}"
        read -p "Select option: " choice

        case $choice in
            1) install_lxc_script ;;
            2) install_docker ;;
            3) install_portainer ;;
            4) install_tailscale ;;
            5) system_update ;;
            6) remove_all ;;
            7) exit 0 ;;
            *) echo -e "${RED}Invalid option!${RESET}"; sleep 1 ;;
        esac
    done
}

# ===== START =====
main_menu
