# HTTP Application
k create deploy web-svc --image=nginx -- /bin/sh -c "while true; do curl db-svc; sleep 5; done"
k expose deploy web-svc --port=80
k create deploy db-svc --image=nginx
k expose deploy db-svc --port=80

k delete deploy web-svc db-svc 
k delete svc web-svc db-svc 

# Mysql

https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/

kubectl run mysql-client --image=mysql:5.6 --restart=Never -- /bin/sh -c "sleep 100000"

kubectl run mysql-client --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword


# Istio 
istioctl install --set values.global.proxy.privileged=true

kubectl label namespace app istio-injection=enabled --overwrite

apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: app
spec:
  mtls:
    mode: STRICT

kubectl exec -n app mysql-68579b78bb-czf5s -c istio-proxy -- sudo tcpdump -vv dst port 3306 -A

kubectl exec -n app "$(kubectl get pod -n app -lapp=httpbin -ojsonpath={.items..metadata.name})" -c istio-proxy -- sudo tcpdump dst port 15090 -A

# Web Istio 

kubectl exec -n app web-svc-6d9c555df8-z5fzh -c istio-proxy -- sudo tcpdump -s 65535 -vv dst port 80 -A 

# Wireshark
https://githubmemory.com/repo/eldadru/ksniff/issues/63

tcp.port == 80 && ip.dst == 172.18.34.174 ( Web-svc )
