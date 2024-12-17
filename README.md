# HAProxy e Keepalived com Docker Compose

Este repositório fornece uma configuração prática de HAProxy e Keepalived utilizando Docker Compose. Essa configuração é ideal para criar um ambiente de alta disponibilidade (HA) para aplicações web e balanceamento de carga.

---

## 🔧 **Requisitos**
- Docker (20.x ou superior)
- Docker Compose (v2.0 ou superior)
- Permissões de root ou um usuário com acesso ao Docker

---

## 🌐 **Estrutura do Projeto**

```
├── Haproxy-1
|   └── haproxy.cfg 
├── Haproxy-2
|   └── haproxy.cfg
├── nginx-1
|   └── index.html
├── nginx-2
|   └── index.html
├── nginx-3
|   └── index.html
├── compose.yml
├── Dockerfile
```

**Explicação:**
- **compose.yml**: Arquivo de orquestração dos containers HAProxy e Keepalived.
- **Haproxy-1[2]/haproxy.cfg**: Arquivo de configuração do HAProxy.
- **keepalived/keepalived.conf**: Arquivo de configuração do Keepalived.

---

## 📌 **Configuração dos Arquivos**

### **compose.yml**
```yaml
networks:
  haproxy1:
    driver: bridge
  haproxy2:
    driver: bridge

services:
  haproxy1:
    image: haproxy
    ports:
      - 80:80
    volumes:
      - ./haproxy-1/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg
    networks:
      - haproxy1
      - haproxy2
    depends_on:
      - nginx1
      - nginx2
      - nginx3

  nginx1:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./nginx-1/index.html:/usr/share/nginx/html/index.html
    networks:
      - haproxy1
      - haproxy2

  nginx2:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./nginx-2/index.html:/usr/share/nginx/html/index.html
    networks:
      - haproxy1
      - haproxy2

  nginx3:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - ./nginx-3/index.html:/usr/share/nginx/html/index.html
    networks:
      - haproxy1
      - haproxy2      
```

---

### **haproxy/haproxy.cfg**
```haproxy
global
        log stdout format raw local0
        daemon
        maxconn 256
defaults 
        log global
        option httplog
        option dontlognull
        timeout queue       1m
        timeout connect     10s
        timeout client      1m
        timeout server      1m
        timeout check       10s
        maxconn             3000
        mode http

frontend front-nginxes
        bind *:80
        option forwardfor
        mode http
        default_backend back-nginxes

backend back-nginxes
        server s1 nginx1:80
        server s2 nginx2:80
        server s3 nginx3:80

listen listen-nginxes
        bind *:81
        server s1 localhost:80


```

**Explicação:**
- O HAProxy está configurado para escutar na porta 80 e distribuir o tráfego entre os servidores backend configurados.

---

### **keepalived/keepalived.conf**
```conf
! Configuração do Keepalived
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1

    authentication {
        auth_type PASS
        auth_pass 12345678
    }

    virtual_ipaddress {
        192.168.0.100/24
    }
}
```

**Explicação:**
- O Keepalived cria um IP virtual (VIP) **192.168.0.100** que será utilizado como IP flutuante entre os nós.
- A prioridade define qual instância será o master. Para um slave, mude o valor de `priority` para um menor (ex: 90).

---

## 🔄 **Comandos para Iniciar o Ambiente**

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git
   cd seu-repositorio
   ```

2. Inicie os containers:
   ```bash
   docker-compose up -d
   ```

3. Verifique se os containers estão em execução:
   ```bash
   docker ps
   ```

---

## 📊 **Comandos úteis**

- **Parar os containers:**
  ```bash
  docker-compose down
  ```

- **Reiniciar os containers:**
  ```bash
  docker-compose restart
  ```

- **Ver logs do HAProxy:**
  ```bash
  docker logs haproxy
  ```

- **Ver logs do Keepalived:**
  ```bash
  docker logs keepalived
  ```

---

## 🛠️ **Possíveis Problemas**

### **Keepalived não está subindo como MASTER**
- Verifique se o arquivo **keepalived.conf** está correto.
- Certifique-se de que o container **keepalived** tem as permissões adequadas e está rodando com `privileged: true`.

### **HAProxy não está balanceando corretamente**
- Certifique-se de que as IPs dos servidores no **haproxy.cfg** estão acessíveis.
- Veja os logs do HAProxy para entender o problema:
  ```bash
  docker logs haproxy
  ```

---

## 🌎 **Recursos Adicionais**
- [Documentação Oficial do HAProxy](https://www.haproxy.org/)
- [Documentação Oficial do Keepalived](https://www.keepalived.org/)

---

## 🌐 **Contribuições**
Contribuições são bem-vindas! Se quiser melhorar esta configuração ou adicionar algo, fique à vontade para abrir um Pull Request.

---

## ✅ **Licença**
Este repositório está licenciado sob a licença MIT. Consulte o arquivo LICENSE para mais informações.

---

Se precisar de ajuda ou tiver dúvidas, fique à vontade para abrir uma issue. 🛠️

