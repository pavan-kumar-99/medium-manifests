#! /bin/bash
Green='\033[0;32m'
namespaces=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}'  | tr ' ' '\n' | grep -v kube-system)
for namespace in $namespaces; 
do 
deploys=$(kubectl get deploy -n $namespace -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n')
for deploy in $deploys; 
do
echo -ne $Green '#####                     (33%)\r'
cat << EOF | kubectl apply -f - 
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: $deploy
  namespace: $namespace
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       $deploy
  updatePolicy:
    updateMode: "Auto"
EOF
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
done
done
