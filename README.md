## Prepare Host

## TODO:
- Create the documentation
- Configure Kustomization
- Configure secrets for PRE and PROD environments
- Create a crud for users

#### Create cluster

```shell
# Download microk8s
sudo snap install microk8s --classic

# Configure firewall
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

# Enable Addons
microk8s enable dns
microk8s enable dashboard

# Start cluster
microk8s start
```

#### Dashboard


```shell
# Create dashboard auth token
microk8s kubectl create token default

# Start dashboard
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```

#### Expondo Serviços
```
microk8s kubectl port-forward <pod_name> <local_port>:<pod_port> 
```

### Install API for development

```shell
# Prepare development environment
make install-dev

# Prepare env vars
mv template.env .env

# Start api for development
make start 

# Start worker for development
make worker
```

### Deploy API on microk8s

```
make deploy
```

- The API will be available on http://localhost/