#!/bin/bash

# Verificar que se proporcionaron los argumentos
if [ "$#" -ne 2 ]; then
  echo "Uso: $0 <usuario> <contraseña>"
  exit 1
fi

USUARIO=$1
CONTRASENA=$2

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo pacman -Syu --noconfirm

# Instalar paquetes desde repositorios oficiales
echo "Instalando paquetes desde los repositorios oficiales..."
PACKAGES=(
  "yay"          # Instalador de paquetes AUR
  "fish"         # Shell
  "starship"     # Prompt
  "make"         # Herramienta de construcción
  "unzip"        # Herramienta de descompresión
  "fakeroot"     # Herramienta de emulación de root
  "curl"         # Herramienta de transferencia de datos
  "mariadb"      # Base de datos
)

for PACKAGE in "${PACKAGES[@]}"; do
  sudo pacman -S --noconfirm "$PACKAGE"
done

# Instalar paquetes desde AUR
echo "Instalando paquetes desde AUR..."
AUR_PACKAGES=(
  "visual-studio-code-bin"  # Editor de código
  "discord"                  # Aplicación de comunicación
  "google-chrome"            # Navegador web
  "postman-bin"              # Herramienta de pruebas de API
  "dbeaver-ce-bin"           # Herramienta de administración de bases de datos
)

for AUR_PACKAGE in "${AUR_PACKAGES[@]}"; do
  yay -S --noconfirm "$AUR_PACKAGE"
done

# Instalar y configurar fnm
echo "Instalando fnm..."
curl -fsSL https://fnm.vercel.app/install | bash

# Asegúrate de que fnm esté disponible en la sesión actual
export PATH="$HOME/.fnm:$PATH"

# Reemplazar el archivo config.fish
echo "Reemplazando el archivo config.fish..."
if [ -f "./config.fish" ]; then
  cp ./config.fish ~/.config/fish/config.fish
  echo "Archivo config.fish reemplazado."
else
  echo "El archivo config.fish no se encuentra en el directorio del script."
fi

# Instalar y configurar MariaDB
echo "Instalando MariaDB..."
sudo pacman -S --noconfirm mariadb

# Iniciar y habilitar MariaDB
echo "Iniciando y habilitando el servicio de MariaDB..."
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Configurar MariaDB
echo "Configurando MariaDB..."
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Ejecutar script de seguridad inicial de MariaDB
echo "Ejecutando script de seguridad inicial..."
sudo mysql_secure_installation <<EOF

y
n
y
y
y
y
EOF

# Crear usuario y otorgar permisos
echo "Creando usuario y otorgando permisos..."
sudo mysql -e "CREATE USER '$USUARIO'@'localhost' IDENTIFIED BY '$CONTRASENA';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$USUARIO'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Instalación y configuración completadas."
