# MyVPS

A personal project to automate my VPS setup with Docker, Traefik, and other configurations.

## 🚀 Features

- Automatic system update and git installation
- Automatic Docker and Docker Compose installation
- Traefik configuration as reverse proxy
- Automatic SSL configuration with Let's Encrypt
- Basic firewall setup (UFW)
- Modular and reusable scripts

## 📋 Prerequisites

- Operating System: Debian/Ubuntu
- Root or sudo access
- Internet connection

## 🛠️ Installation

Run the following command to install automatically:

```bash
curl -s https://raw.githubusercontent.com/alancriaxyz/myvps/main/boot.sh | sudo bash
```

After installation, reboot your system:
```bash
sudo reboot
```

## 🔒 Security

- Firewall configured to allow only essential ports
- Automatic SSL with Let's Encrypt
- Docker security settings
- Automatic HTTP to HTTPS redirection

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- Alan Alves - [GitHub](https://github.com/alancriaxyz)

## 🙏 Acknowledgments

- [Docker](https://www.docker.com/)
- [Traefik](https://traefik.io/)
- [Let's Encrypt](https://letsencrypt.org/) 