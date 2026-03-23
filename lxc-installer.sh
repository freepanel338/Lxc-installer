#!/usr/bin/env bash
set -euo pipefail

# PrimeNexus Ultra Installer Core

RESET="\e[0m"
BOLD="\e[1m"
C1="\e[38;5;51m"
C2="\e[38;5;45m"
C3="\e[38;5;39m"
SUCCESS="\e[32m"
ERROR="\e[31m"

LOG_FILE="/tmp/primenexus.log"

init_log() {
 echo "PrimeNexus Log" > $LOG_FILE
 echo "Start: $(date)" >> $LOG_FILE
}header() {
clear
cat << "EOF"
██████╗ ██████╗ ██╗███╗   ███╗███████╗███╗   ██╗
██╔══██╗██╔══██╗██║████╗ ████║██╔════╝████╗  ██║
██████╔╝██████╔╝██║██╔████╔██║█████╗  ██╔██╗ ██║
██╔═══╝ ██╔══██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║
██║     ██║  ██║██║██║ ╚═╝ ██║███████╗██║ ╚████║
╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝
EOF

echo -e "\n${C1}${BOLD}PrimeNexus Installer${RESET}"
}progress() {
 local total=30
 printf "["
 for ((i=0;i<total;i++)); do
  printf "#"
  sleep 0.03
 done
 printf "] Done\n"
}spinner() {
 local pid=$1
 local spin='-\|/'
 while kill -0 $pid 2>/dev/null; do
  for i in $(seq 0 3); do
   printf "\r${spin:$i:1}"
   sleep 0.1
  done
 done
 printf "\rDone\n"
}run() {
 local msg="$1"
 shift

 echo -e "${C2}→ $msg${RESET}"
 "$@" >> $LOG_FILE 2>&1 &
 spinner $!
 wait $!

 echo -e "${SUCCESS}✔ Done${RESET}"
}check_root() {
 if [ "$EUID" -ne 0 ]; then
  echo -e "${ERROR}Run as root${RESET}"
  exit 1
 fi
}detect_os() {
 . /etc/os-release
 echo "OS: $PRETTY_NAME"
}check_resources() {
 RAM=$(free -m | awk '/Mem:/ {print $2}')
 CPU=$(nproc)

 echo "RAM: $RAM MB"
 echo "CPU: $CPU cores"
}update_system() {
 run "Updating system" apt update -y
 run "Upgrading system" apt upgrade -y
}install_core() {
 run "Installing packages" apt install -y lxc lxd curl wget
}# ================================
# PrimeNexus Advanced Engine Core
# ================================

# ---------- Extended Colors ----------
C_BLUE="\e[38;5;33m"
C_GREEN="\e[38;5;46m"
C_YELLOW="\e[38;5;226m"
C_RED="\e[38;5;196m"
C_WHITE="\e[97m"
C_GRAY="\e[90m"

# ---------- Enhanced Logging ----------
log_info() {
 echo -e "[$(date '+%H:%M:%S')] [INFO] $1" >> $LOG_FILE
}

log_error() {
 echo -e "[$(date '+%H:%M:%S')] [ERROR] $1" >> $LOG_FILE
}

log_success() {
 echo -e "[$(date '+%H:%M:%S')] [SUCCESS] $1" >> $LOG_FILE
}

# ---------- Fancy Divider ----------
divider() {
 printf "${C_GRAY}---------------------------------------------${RESET}\n"
}

# ---------- Advanced Spinner ----------
spinner_advanced() {
 local pid=$1
 local delay=0.08
 local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
 while ps -p $pid > /dev/null 2>&1; do
  for ((i=0; i<${#spinstr}; i++)); do
   printf "\r${C_BLUE}${spinstr:$i:1}${RESET} Processing..."
   sleep $delay
  done
 done
 printf "\r${C_GREEN}✔ Completed${RESET}       \n"
}

# ---------- Gradient Progress ----------
progress_ultra() {
 local width=50
 printf "\n${C_BLUE}["
 for ((i=0;i<width;i++)); do
  printf "${C_GREEN}█${RESET}"
  sleep 0.02
 done
 printf "${C_BLUE}]${RESET} Done\n"
}

# ---------- Retry System ----------
retry_command() {
 local cmd="$1"
 local attempts=0
 local max=5

 until [ $attempts -ge $max ]; do
  eval "$cmd" && break
  attempts=$((attempts+1))
  echo -e "${C_YELLOW}Retry $attempts/$max...${RESET}"
  sleep 2
 done

 if [ $attempts -eq $max ]; then
  echo -e "${C_RED}Command Failed: $cmd${RESET}"
  exit 1
 fi
}

# ---------- Smart Runner ----------
run_pro() {
 local msg="$1"
 shift

 divider
 echo -e "${C_BLUE}${BOLD}➜ $msg${RESET}"
 log_info "$msg"

 ("$@" >> $LOG_FILE 2>&1) &
 spinner_advanced $!
 wait $! || {
  log_error "$msg failed"
  echo -e "${C_RED}✖ Failed${RESET}"
  exit 1
 }

 log_success "$msg done"
}

# ---------- System Banner ----------
system_banner() {
 divider
 echo -e "${C_WHITE}${BOLD}SYSTEM ANALYSIS${RESET}"

 OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
 CPU=$(nproc)
 RAM=$(free -h | awk '/Mem:/ {print $2}')
 KERNEL=$(uname -r)

 echo -e "${C_GREEN}OS:${RESET} $OS"
 echo -e "${C_GREEN}CPU:${RESET} $CPU cores"
 echo -e "${C_GREEN}RAM:${RESET} $RAM"
 echo -e "${C_GREEN}Kernel:${RESET} $KERNEL"

 divider
}

# ---------- Network Check ----------
check_network() {
 divider
 echo -e "${C_BLUE}Checking network connectivity...${RESET}"

 if ping -c 1 google.com >/dev/null 2>&1; then
  echo -e "${C_GREEN}Network OK${RESET}"
 else
  echo -e "${C_RED}No Internet${RESET}"
  exit 1
 fi
}

# ---------- Disk Check ----------
check_disk() {
 DISK=$(df / | awk 'NR==2 {print $4}')
 if [ "$DISK" -lt 1000000 ]; then
  echo -e "${C_YELLOW}Low Disk Space${RESET}"
 fi
}

# ---------- Memory Optimization ----------
optimize_memory() {
 echo -e "${C_BLUE}Optimizing memory...${RESET}"
 sync; echo 3 > /proc/sys/vm/drop_caches || true
}

# ---------- Cleanup ----------
cleanup_system() {
 echo -e "${C_BLUE}Cleaning system...${RESET}"
 apt autoremove -y >> $LOG_FILE 2>&1
 apt clean >> $LOG_FILE 2>&1
}

# ---------- Welcome Box ----------
welcome_box() {
 divider
 echo -e "${C_BLUE}${BOLD}PrimeNexus Installer Engine Activated${RESET}"
 echo -e "${C_GRAY}Initializing advanced modules...${RESET}"
 divider
}# ==========================================
# PrimeNexus LXC/LXD Advanced Install Engine
# ==========================================

install_dependencies_advanced() {
 divider
 echo -e "${C_BLUE}${BOLD}Installing Core Dependencies${RESET}"

 run_pro "Updating package index" apt update -y
 run_pro "Upgrading system packages" apt upgrade -y

 run_pro "Installing base tools" apt install -y \
  curl wget git unzip software-properties-common \
  apt-transport-https ca-certificates gnupg lsb-release

 run_pro "Installing container packages" apt install -y \
  lxc lxc-utils uidmap bridge-utils dnsmasq-base \
  squashfs-tools

 echo -e "${C_GREEN}Dependencies installed successfully${RESET}"
}

# ---------- Snap Setup ----------
setup_snap_system() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring Snap System${RESET}"

 if ! command -v snap >/dev/null 2>&1; then
  run_pro "Installing snapd" apt install -y snapd
 else
  echo -e "${C_GREEN}snapd already installed${RESET}"
 fi

 run_pro "Enabling snapd service" systemctl enable --now snapd.socket

 # Fix for older systems
 if [ ! -L /snap ]; then
  ln -s /var/lib/snapd/snap /snap || true
 fi

 # Wait for snap ready
 echo -e "${C_BLUE}Waiting for snap to initialize...${RESET}"
 sleep 5
}

# ---------- LXD Install ----------
install_lxd_engine() {
 divider
 echo -e "${C_BLUE}${BOLD}Installing LXD Engine${RESET}"

 if snap list lxd >/dev/null 2>&1; then
  echo -e "${C_GREEN}LXD already installed${RESET}"
 else
  run_pro "Installing LXD via snap" snap install lxd --channel=latest/stable
 fi

 # Ensure service running
 run_pro "Starting LXD service" systemctl restart snap.lxd.daemon || true

 echo -e "${C_GREEN}LXD installation complete${RESET}"
}

# ---------- User Configuration ----------
configure_user_access() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring User Access${RESET}"

 TARGET_USER=${SUDO_USER:-$(whoami)}

 echo -e "${C_GREEN}Target User:${RESET} $TARGET_USER"

 if ! groups "$TARGET_USER" | grep -q lxd; then
  run_pro "Adding user to lxd group" usermod -aG lxd "$TARGET_USER"
 else
  echo -e "${C_GREEN}User already in lxd group${RESET}"
 fi

 echo -e "${C_YELLOW}User must re-login to apply changes${RESET}"
}

# ---------- LXD Initialization ----------
initialize_lxd_system() {
 divider
 echo -e "${C_BLUE}${BOLD}Initializing LXD Configuration${RESET}"

 echo -e "${C_GRAY}Auto configuration will be applied${RESET}"

 run_pro "Running LXD auto init" lxd init --auto

 echo -e "${C_GREEN}LXD initialized successfully${RESET}"
}

# ---------- Storage Setup ----------
setup_storage_pool() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring Storage Pool${RESET}"

 if lxc storage list | grep -q default; then
  echo -e "${C_GREEN}Storage pool already exists${RESET}"
 else
  run_pro "Creating storage pool" lxc storage create default dir
 fi
}

# ---------- Network Setup ----------
setup_network_bridge() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring Network Bridge${RESET}"

 if lxc network list | grep -q lxdbr0; then
  echo -e "${C_GREEN}Network bridge exists${RESET}"
 else
  run_pro "Creating network bridge" lxc network create lxdbr0
 fi
}

# ---------- Service Health Check ----------
check_lxd_health() {
 divider
 echo -e "${C_BLUE}${BOLD}Checking LXD Health${RESET}"

 if lxc info >/dev/null 2>&1; then
  echo -e "${C_GREEN}LXD service running${RESET}"
 else
  echo -e "${C_RED}LXD service issue detected${RESET}"
 fi
}

# ---------- Post Install Cleanup ----------
post_install_cleanup() {
 divider
 echo -e "${C_BLUE}${BOLD}Final Cleanup${RESET}"

 cleanup_system
 optimize_memory

 echo -e "${C_GREEN}System optimized${RESET}"
}

# ---------- Full Install Pipeline ----------
run_full_install() {
 install_dependencies_advanced
 setup_snap_system
 install_lxd_engine
 configure_user_access
 initialize_lxd_system
 setup_storage_pool
 setup_network_bridge
 check_lxd_health
 post_install_cleanup
}# ==========================================
# PrimeNexus Smart Container Deployment Engine
# ==========================================

# ---------- Default Config ----------
DEFAULT_IMAGE="ubuntu:24.04"
CONTAINER_NAME="pnx-container"
NETWORK_NAME="lxdbr0"

# ---------- Image Pull System ----------
pull_container_image() {
 divider
 echo -e "${C_BLUE}${BOLD}Fetching Container Image${RESET}"

 if lxc image list images: | grep -q "ubuntu"; then
  echo -e "${C_GREEN}Image already available${RESET}"
 else
  run_pro "Pulling Ubuntu image" lxc image copy images:$DEFAULT_IMAGE local: --alias pn-ubuntu
 fi
}

# ---------- Container Launch ----------
launch_container() {
 divider
 echo -e "${C_BLUE}${BOLD}Launching Container${RESET}"

 if lxc list | grep -q "$CONTAINER_NAME"; then
  echo -e "${C_YELLOW}Container already exists${RESET}"
 else
  run_pro "Launching container" lxc launch images:$DEFAULT_IMAGE "$CONTAINER_NAME"
 fi
}

# ---------- Container Network Setup ----------
configure_container_network() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring Container Network${RESET}"

 run_pro "Attaching network bridge" \
  lxc network attach "$NETWORK_NAME" "$CONTAINER_NAME" eth0 || true

 run_pro "Restarting container network" \
  lxc exec "$CONTAINER_NAME" -- systemctl restart networking || true
}

# ---------- Container Update ----------
update_container() {
 divider
 echo -e "${C_BLUE}${BOLD}Updating Container${RESET}"

 run_pro "Updating container packages" \
  lxc exec "$CONTAINER_NAME" -- apt update -y

 run_pro "Upgrading container packages" \
  lxc exec "$CONTAINER_NAME" -- apt upgrade -y
}

# ---------- Install Basic Tools ----------
install_container_tools() {
 divider
 echo -e "${C_BLUE}${BOLD}Installing Tools in Container${RESET}"

 run_pro "Installing curl, wget, nano" \
  lxc exec "$CONTAINER_NAME" -- apt install -y curl wget nano net-tools
}

# ---------- Set Hostname ----------
set_container_hostname() {
 divider
 echo -e "${C_BLUE}${BOLD}Setting Container Hostname${RESET}"

 run_pro "Applying hostname" \
  lxc exec "$CONTAINER_NAME" -- hostnamectl set-hostname primenexus-node
}

# ---------- Container Info ----------
show_container_info() {
 divider
 echo -e "${C_BLUE}${BOLD}Container Information${RESET}"

 lxc list
 lxc info "$CONTAINER_NAME"
}

# ---------- Auto Start ----------
enable_autostart() {
 divider
 echo -e "${C_BLUE}${BOLD}Enabling Auto Start${RESET}"

 run_pro "Setting auto start" \
  lxc config set "$CONTAINER_NAME" boot.autostart true
}

# ---------- Resource Limit Setup ----------
set_container_limits() {
 divider
 echo -e "${C_BLUE}${BOLD}Applying Resource Limits${RESET}"

 run_pro "Limiting CPU" \
  lxc config set "$CONTAINER_NAME" limits.cpu 2

 run_pro "Limiting Memory" \
  lxc config set "$CONTAINER_NAME" limits.memory 1024MB
}

# ---------- Snapshot System ----------
create_snapshot() {
 divider
 echo -e "${C_BLUE}${BOLD}Creating Snapshot${RESET}"

 SNAP_NAME="init-snapshot"

 if lxc info "$CONTAINER_NAME" | grep -q "$SNAP_NAME"; then
  echo -e "${C_YELLOW}Snapshot already exists${RESET}"
 else
  run_pro "Creating snapshot" \
   lxc snapshot "$CONTAINER_NAME" "$SNAP_NAME"
 fi
}

# ---------- Container Security ----------
apply_security_profile() {
 divider
 echo -e "${C_BLUE}${BOLD}Applying Security Profile${RESET}"

 run_pro "Setting security nesting" \
  lxc config set "$CONTAINER_NAME" security.nesting true

 run_pro "Disabling privileged mode" \
  lxc config set "$CONTAINER_NAME" security.privileged false
}

# ---------- Health Check ----------
container_health_check() {
 divider
 echo -e "${C_BLUE}${BOLD}Running Container Health Check${RESET}"

 if lxc exec "$CONTAINER_NAME" -- ping -c 1 google.com >/dev/null 2>&1; then
  echo -e "${C_GREEN}Internet inside container OK${RESET}"
 else
  echo -e "${C_RED}Network issue inside container${RESET}"
 fi
}

# ---------- Full Deployment Pipeline ----------
deploy_container_full() {
 pull_container_image
 launch_container
 configure_container_network
 update_container
 install_container_tools
 set_container_hostname
 enable_autostart
 set_container_limits
 create_snapshot
 apply_security_profile
 container_health_check
 show_container_info
}# ==========================================
# PrimeNexus Interactive Control Panel
# ==========================================

# ---------- Menu Colors ----------
MENU_TITLE="${C_PRIMARY}${BOLD}"
MENU_OPTION="${C_SECOND}"
MENU_INPUT="${C_ACCENT}"

# ---------- Clear Screen ----------
clear_screen() {
 clear
}

# ---------- Pause ----------
pause_screen() {
 echo -e "\n${C_GRAY}Press Enter to continue...${RESET}"
 read -r
}

# ---------- Header Banner ----------
menu_header() {
 clear_screen
 echo -e "${MENU_TITLE}"
 echo "======================================="
 echo "        PrimeNexus Control Panel       "
 echo "======================================="
 echo -e "${RESET}"
}

# ---------- Menu Options ----------
show_main_menu() {
 menu_header

 echo -e "${MENU_OPTION}1) Full Install (LXC + LXD + Container)${RESET}"
 echo -e "${MENU_OPTION}2) Install Only LXC/LXD${RESET}"
 echo -e "${MENU_OPTION}3) Deploy Container Only${RESET}"
 echo -e "${MENU_OPTION}4) System Information${RESET}"
 echo -e "${MENU_OPTION}5) Network Test${RESET}"
 echo -e "${MENU_OPTION}6) Cleanup System${RESET}"
 echo -e "${MENU_OPTION}7) Exit${RESET}"

 echo -e "\n${MENU_INPUT}Select Option:${RESET} "
}

# ---------- Handle Input ----------
handle_menu_choice() {
 read -r choice

 case $choice in
 1)
  echo -e "${C_GREEN}Running Full Install...${RESET}"
  run_full_install
  deploy_container_full
  pause_screen
  ;;
 2)
  echo -e "${C_GREEN}Installing LXC/LXD...${RESET}"
  run_full_install
  pause_screen
  ;;
 3)
  echo -e "${C_GREEN}Deploying Container...${RESET}"
  deploy_container_full
  pause_screen
  ;;
 4)
  system_banner
  pause_screen
  ;;
 5)
  check_network
  pause_screen
  ;;
 6)
  cleanup_system
  pause_screen
  ;;
 7)
  echo -e "${C_RED}Exiting...${RESET}"
  exit 0
  ;;
 *)
  echo -e "${C_RED}Invalid Option${RESET}"
  sleep 1
  ;;
 esac
}

# ---------- Loop ----------
menu_loop() {
 while true; do
  show_main_menu
  handle_menu_choice
 done
}

# ---------- Advanced Mode ----------
advanced_menu() {
 clear_screen

 echo -e "${MENU_TITLE}Advanced Options${RESET}"
 echo "---------------------------------------"

 echo -e "${MENU_OPTION}1) Reinitialize LXD${RESET}"
 echo -e "${MENU_OPTION}2) Reset Network Bridge${RESET}"
 echo -e "${MENU_OPTION}3) Remove Container${RESET}"
 echo -e "${MENU_OPTION}4) Back${RESET}"

 echo -e "\n${MENU_INPUT}Select:${RESET}"
 read -r adv

 case $adv in
 1)
  run_pro "Reinitializing LXD" lxd init --auto
  ;;
 2)
  run_pro "Resetting network" lxc network delete lxdbr0 || true
  run_pro "Recreating network" lxc network create lxdbr0
  ;;
 3)
  run_pro "Deleting container" lxc delete -f "$CONTAINER_NAME" || true
  ;;
 4)
  return
  ;;
 *)
  echo "Invalid"
  ;;
 esac

 pause_screen
}

# ---------- Startup Mode ----------
startup_menu() {
 clear_screen

 echo -e "${C_BLUE}${BOLD}Select Mode:${RESET}"
 echo -e "${MENU_OPTION}1) Interactive Mode${RESET}"
 echo -e "${MENU_OPTION}2) Auto Install Mode${RESET}"
 echo -e "${MENU_OPTION}3) Exit${RESET}"

 read -r mode

 case $mode in
 1)
  menu_loop
  ;;
 2)
  echo -e "${C_GREEN}Running Auto Install...${RESET}"
  run_full_install
  deploy_container_full
  ;;
 3)
  exit 0
  ;;
 *)
  echo -e "${C_RED}Invalid choice${RESET}"
  ;;
 esac
}# ==========================================
# PrimeNexus Security & Performance Engine
# ==========================================

# ---------- Firewall Setup ----------
setup_firewall() {
 divider
 echo -e "${C_BLUE}${BOLD}Configuring Firewall${RESET}"

 if ! command -v ufw >/dev/null 2>&1; then
  run_pro "Installing UFW firewall" apt install -y ufw
 fi

 run_pro "Resetting firewall rules" ufw --force reset
 run_pro "Setting default policies" ufw default deny incoming
 run_pro "Allowing outgoing traffic" ufw default allow outgoing

 run_pro "Allowing SSH" ufw allow 22/tcp
 run_pro "Allowing LXD bridge traffic" ufw allow in on lxdbr0

 run_pro "Enabling firewall" ufw --force enable

 echo -e "${C_GREEN}Firewall configured${RESET}"
}

# ---------- Kernel Optimization ----------
optimize_kernel() {
 divider
 echo -e "${C_BLUE}${BOLD}Optimizing Kernel Parameters${RESET}"

 cat <<EOF >> /etc/sysctl.conf

# PrimeNexus Optimizations
net.core.netdev_max_backlog=5000
net.core.somaxconn=1024
net.ipv4.tcp_max_syn_backlog=2048
net.ipv4.ip_forward=1
vm.swappiness=10
EOF

 run_pro "Applying sysctl settings" sysctl -p

 echo -e "${C_GREEN}Kernel optimized${RESET}"
}

# ---------- Security Limits ----------
set_security_limits() {
 divider
 echo -e "${C_BLUE}${BOLD}Applying Security Limits${RESET}"

 cat <<EOF >> /etc/security/limits.conf

# PrimeNexus Limits
* soft nofile 65535
* hard nofile 65535
EOF

 echo -e "${C_GREEN}Limits applied${RESET}"
}

# ---------- Disable Unused Services ----------
disable_unused_services() {
 divider
 echo -e "${C_BLUE}${BOLD}Disabling Unused Services${RESET}"

 SERVICES=("bluetooth" "cups" "avahi-daemon")

 for svc in "${SERVICES[@]}"; do
  if systemctl list-unit-files | grep -q "$svc"; then
   run_pro "Disabling $svc" systemctl disable --now "$svc" || true
  fi
 done

 echo -e "${C_GREEN}Unused services disabled${RESET}"
}

# ---------- CPU Optimization ----------
optimize_cpu() {
 divider
 echo -e "${C_BLUE}${BOLD}Optimizing CPU Settings${RESET}"

 if command -v cpufreq-set >/dev/null 2>&1; then
  run_pro "Setting CPU governor performance" cpufreq-set -r -g performance || true
 fi

 echo -e "${C_GREEN}CPU optimized${RESET}"
}

# ---------- Disk Optimization ----------
optimize_disk() {
 divider
 echo -e "${C_BLUE}${BOLD}Optimizing Disk IO${RESET}"

 echo deadline > /sys/block/sda/queue/scheduler 2>/dev/null || true

 echo -e "${C_GREEN}Disk optimized${RESET}"
}

# ---------- Fail2Ban Setup ----------
install_fail2ban() {
 divider
 echo -e "${C_BLUE}${BOLD}Installing Fail2Ban${RESET}"

 run_pro "Installing fail2ban" apt install -y fail2ban

 run_pro "Enabling fail2ban" systemctl enable --now fail2ban

 echo -e "${C_GREEN}Fail2Ban active${RESET}"
}

# ---------- SSH Hardening ----------
secure_ssh() {
 divider
 echo -e "${C_BLUE}${BOLD}Hardening SSH${RESET}"

 sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config || true
 sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config || true

 run_pro "Restarting SSH" systemctl restart ssh

 echo -e "${C_GREEN}SSH secured${RESET}"
}

# ---------- Auto Updates ----------
enable_auto_updates() {
 divider
 echo -e "${C_BLUE}${BOLD}Enabling Auto Updates${RESET}"

 run_pro "Installing unattended-upgrades" apt install -y unattended-upgrades

 dpkg-reconfigure -f noninteractive unattended-upgrades

 echo -e "${C_GREEN}Auto updates enabled${RESET}"
}

# ---------- System Monitor ----------
install_monitor_tools() {
 divider
 echo -e "${C_BLUE}${BOLD}Installing Monitoring Tools${RESET}"

 run_pro "Installing htop, iotop, net-tools" apt install -y htop iotop net-tools

 echo -e "${C_GREEN}Monitoring tools installed${RESET}"
}

# ---------- Full Security Pipeline ----------
run_security_suite() {
 setup_firewall
 optimize_kernel
 set_security_limits
 disable_unused_services
 optimize_cpu
 optimize_disk
 install_fail2ban
 secure_ssh
 enable_auto_updates
 install_monitor_tools
}# ==========================================
# PrimeNexus Final Validation & Completion
# ==========================================

# ---------- LXD Validation ----------
validate_lxd() {
 divider
 echo -e "${C_BLUE}${BOLD}Validating LXD Installation${RESET}"

 if command -v lxc >/dev/null 2>&1; then
  echo -e "${C_GREEN}LXC command available${RESET}"
 else
  echo -e "${C_RED}LXC not installed${RESET}"
 fi

 if lxc info >/dev/null 2>&1; then
  echo -e "${C_GREEN}LXD service running${RESET}"
 else
  echo -e "${C_RED}LXD service issue${RESET}"
 fi
}

# ---------- Container Validation ----------
validate_container() {
 divider
 echo -e "${C_BLUE}${BOLD}Validating Container${RESET}"

 if lxc list | grep -q "$CONTAINER_NAME"; then
  echo -e "${C_GREEN}Container exists${RESET}"
 else
  echo -e "${C_RED}Container not found${RESET}"
 fi
}

# ---------- Network Validation ----------
validate_network() {
 divider
 echo -e "${C_BLUE}${BOLD}Checking Network${RESET}"

 if ping -c 1 google.com >/dev/null 2>&1; then
  echo -e "${C_GREEN}Internet working${RESET}"
 else
  echo -e "${C_RED}Network issue detected${RESET}"
 fi
}

# ---------- System Report ----------
generate_report() {
 divider
 echo -e "${C_BLUE}${BOLD}Generating System Report${RESET}"

 OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
 CPU=$(nproc)
 RAM=$(free -h | awk '/Mem:/ {print $2}')
 DISK=$(df -h / | awk 'NR==2 {print $4}')

 echo -e "${C_GREEN}OS:${RESET} $OS"
 echo -e "${C_GREEN}CPU:${RESET} $CPU cores"
 echo -e "${C_GREEN}RAM:${RESET} $RAM"
 echo -e "${C_GREEN}Disk Free:${RESET} $DISK"
}

# ---------- Save Report ----------
save_report() {
 REPORT_FILE="/tmp/primenexus_report.txt"

 echo "PrimeNexus Installation Report" > $REPORT_FILE
 echo "Date: $(date)" >> $REPORT_FILE
 echo "System: $(uname -a)" >> $REPORT_FILE

 echo -e "${C_GREEN}Report saved at:${RESET} $REPORT_FILE"
}

# ---------- Success Banner ----------
final_banner() {
 clear
cat << "EOF"
██████╗ ██████╗ ██╗███╗   ███╗███████╗███╗   ██╗███████╗██╗  ██╗
██╔══██╗██╔══██╗██║████╗ ████║██╔════╝████╗  ██║██╔════╝╚██╗██╔╝
██████╔╝██████╔╝██║██╔████╔██║█████╗  ██╔██╗ ██║█████╗   ╚███╔╝ 
██╔═══╝ ██╔══██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║██╔══╝   ██╔██╗ 
██║     ██║  ██║██║██║ ╚═╝ ██║███████╗██║ ╚████║███████╗██╔╝ ██╗
╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
EOF

 echo -e "\n${C_GREEN}${BOLD}INSTALLATION COMPLETED SUCCESSFULLY${RESET}"
 echo -e "${C_SECOND}PrimeNexus Engine Ready${RESET}\n"
}

# ---------- Quick Commands ----------
show_quick_commands() {
 echo -e "${C_BLUE}${BOLD}Quick Commands:${RESET}"

 echo "lxc list"
 echo "lxc launch ubuntu:24.04 test-container"
 echo "lxc exec test-container bash"
}

# ---------- Final Execution ----------
finalize_installation() {
 validate_lxd
 validate_container
 validate_network
 generate_report
 save_report
}

# ---------- Main Controller ----------
main_controller() {
 init_log
 header
 check_root
 detect_os

 system_banner
 check_network

 # INSTALL CORE
 run_full_install

 # DEPLOY CONTAINER
 deploy_container_full

 # SECURITY
 run_security_suite

 # FINAL VALIDATION
 finalize_installation

 # SHOW SUCCESS
 final_banner
 show_quick_commands

 # START MENU
 startup_menu
}

# ---------- START ----------u
cat << "EOF"
main_controller
