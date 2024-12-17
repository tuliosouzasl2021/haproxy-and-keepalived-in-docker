FROM nginx
WORKDIR /etc/nginx
RUN apt-get update -y
RUN apt-get update -y
RUN apt-get install ssh -y
EXPOSE 443
EXPOSE 80