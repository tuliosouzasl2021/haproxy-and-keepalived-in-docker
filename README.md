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
├── docker-compose.yml
├── haproxy
│   └── haproxy.cfg
└── keepalived
    └── keepalived.conf
```

**Explicação:**
- **docker-compose.yml**: Arquivo de orquestração dos containers HAProxy e Keepalived.
- **haproxy/haproxy.cfg**: Arquivo de configuração do HAProxy.
- **keepalived/keepalived.conf**: Arquivo de configuração do Keepalived.

---

## 📌 **Configuração dos Arquivos**

### **docker-compose.yml**
```yaml
docker-compose.yml
version: '3'
services:
  haproxy:
    image: haproxy:latest
    container_name: haproxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro
    networks:
      - ha-network

  keepalived:
    image: osixia/keepalived:latest
    container_name: keepalived
    restart: always
    privileged: true
    network_mode: "host"
    volumes:
      - ./keepalived/keepalived.conf:/container/service/keepalived/assets/keepalived.conf:ro

networks:
  ha-network:
    driver: bridge
```

---

### **haproxy/haproxy.cfg**
```haproxy
# Configuração básica do HAProxy
frontend http-in
    bind *:80
    default_backend servers

backend servers
    balance roundrobin
    server server1 192.168.0.101:80 check
    server server2 192.168.0.102:80 check
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

