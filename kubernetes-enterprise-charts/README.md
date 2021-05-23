# lamp-application-k8-s ( Used spinnaker to deploy the application )
This is a LAMP based application hosted on Kubernetes. The Docker files are used to build 2 images 
1- php-Docker file is used to build the frontend application with all the php files
2- mysql-dockerfile builds a mysql database from the dump 
And Once after the docker images are build Install the e-commerce-application application by using the command 
helm install my-ecommerce-application e-commerce-application ( Feel free to change the values.yaml file to your preference )
And once the entire application is installed, install the nginx-ingress-controller ( Feel free to change the ingress resource while application deployement )
Now access your application by going to http://<ingress_controller_svc_ip>
