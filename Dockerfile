# Use official Ubuntu 20.04 as base
FROM ubuntu:20.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && \
    apt install -y sudo wget curl xvfb x11vnc xfce4 firefox dbus-x11 tigervnc-standalone-server tigervnc-viewer

# Create user and set password
RUN useradd -m user && \
    echo 'user:user' | chpasswd && \
    usermod -aG sudo user

# Switch to user
USER user
WORKDIR /home/user

# Download and extract noVNC
RUN cd /home/user && \
    wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip  -O novnc.zip && \
    unzip novnc.zip && \
    mv noVNC-master novnc

# Download websockify (to bridge WebSocket <-> VNC)
RUN cd /home/user && \
    wget https://github.com/novnc/websockify/archive/refs/heads/master.zip  -O websockify.zip && \
    unzip websockify.zip && \
    mv websockify-master novnc/utils/websockify

# Expose VNC and noVNC ports
EXPOSE 5901
EXPOSE 7860

# Copy start script
COPY start.sh /home/user/start.sh
RUN chmod +x /home/user/start.sh

# Start everything
CMD ["./start.sh"]
