.PHONY : all install_kind_linux install_kind_mac create_kind_cluster

KIND_VERSION := $(shell kind --version 2>/dev/null)

install_kind_linux : 
ifdef KIND_VERSION
	@echo "Found version $(KIND_VERSION)"
else
	@curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
	@chmod +x ./kind
	@mv ./kind /bin/kind
endif

install_kind_mac : 
ifdef KIND_VERSION
	@echo "Found version $(KIND_VERSION)"
else
	@brew install kind
endif

create_kind_cluster :
	@kind create cluster --name crossplane-cluster 
	@kind get kubeconfig --name crossplane-cluster
	@kubectl config set-context crossplane-cluster 

install_crossplane : 
	@kubectl create namespace crossplane-system
	@helm repo add crossplane-stable https://charts.crossplane.io/stable
	@helm repo update
	@helm install crossplane --namespace crossplane-system crossplane-stable/crossplane

all : install_kind_linux create_kind_cluster install_crossplane
