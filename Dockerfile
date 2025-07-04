# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install basic dependencies
RUN apt-get update && apt-get install -y \
    bash \
    wget \
    expect \
    python3-psutil \
    xbase-clients \
    xvfb \
    nautilus \
    nano \
    xscreensaver \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a user 'user' with password 'preetygoodpassword:)'
RUN useradd -m user && \
    usermod -aG sudo user && \
    echo 'user:preetygoodpassword:)' | chpasswd

# Install Ubuntu desktop environment (takes 5-10 minutes)
RUN apt-get update && apt-get install -y ubuntu-desktop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -y --fix-broken && \
    rm google-chrome-stable_current_amd64.deb

# Install Chrome Remote Desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb && \
    dpkg -i chrome-remote-desktop_current_amd64.deb || apt-get install -y --fix-broken && \
    rm chrome-remote-desktop_current_amd64.deb

# Install Visual Studio Code
RUN wget https://az764295.vo.msecnd.net/stable/7f6ab5485bbc008386c4386d08766667e155244e/code_1.60.2-1632313585_amd64.deb && \
    dpkg -i code_1.60.2-1632313585_amd64.deb || apt-get install -y --fix-broken && \
    rm code_1.60.2-1632313585_amd64.deb

# Download hehe.sh script
RUN wget https://raw.githubusercontent.com/Mrbokri/ubuntu-hehe/main/hehe.sh && \
    chmod +x hehe.sh

# Create setup script for Chrome Remote Desktop
RUN echo '#!/usr/bin/expect' > /setup.sh && \
    echo 'spawn /opt/google/chrome-remote-desktop/chrome-remote-desktop --setup' >> /setup.sh && \
    echo 'expect "Enter a PIN of at least six digits: "' >> /setup.sh && \
    echo 'send "123456\r"' >> /setup.sh && \
    echo 'expect "Enter the same PIN again: "' >> /setup.sh && \
    echo 'send "123456\r"' >> /setup.sh && \
    echo 'expect eof' >> /setup.sh && \
    chmod +x /setup.sh

# Expose port 7860 for remote desktop access
EXPOSE 7860

# Set environment for display
ENV DISPLAY=:0

# Start Xvfb and Chrome Remote Desktop
CMD ["/bin/bash", "-c", "Xvfb :0 -screen 0 1920x1080x24 & /setup.sh && /opt/google/chrome-remote-desktop/chrome-remote-desktop --start && /hehe.sh"]
