FROM nginx
WORKDIR /etc/nginx
RUN apt-get update -y
RUN apt-get update -y
RUN apt-get install ssh -y
RUN echo 'root:root' | chpasswd
RUN sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
CMD service ssh start && nginx -g 'daemon off;'
EXPOSE 443
EXPOSE 80
EXPOSE 22