 # Create Trafeik cluster
 sudo k3d cluster create dev -p "8081:80@loadbalancer" --k3s-arg --disable=traefik@server:0 --k3s-arg --disable=metrics-server@server:0
 #Install traefik with Prometheus monitoring
 sudo helm repo add traefik https://helm.traefik.io/traefik
 sudo helm repo add traefik https://helm.traefik.io/traefik
 sudo helm repo update
 sudo helm install traefik traefik/traefik -n kube-system -f ./traefik-values.yaml
 sudo kubectl apply -f traefik-dashboard-service.yaml
 sudo kubectl apply -f traefik-metrics-service.yaml -n kube-system
 
 #Check traefik
 sudo kubectl port-forward service/traefik-dashboard 9000:9000 -n kube-system
 sudo kubectl port-forward service/traefik-metrics 9100:9100 -n kube-system

 # Install Prometheus
 helm install prometheus-stack prometheus-community/kube-prometheus-stack
 sudo helm install prometheus-stack prometheus-community/kube-prometheus-stack
 sudo kubectl apply -f traefik-service-monitor.yaml
 sudo kubectl port-forward service/prometheus-stack-kube-prom-prometheus 9090:9090

 # Check Grafana
 sudo kubectl port-forward service/prometheus-stack-grafana 8080:80

