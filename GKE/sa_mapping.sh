#!/bin/bash  


#Reference: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity

#Step1: Create a GCP Service account with the required name.

#Step2: Attach the required roles to the Service account by using the below command. Here I am attaching the role storage.admin to the Member service account.

gcloud projects add-iam-policy-binding analog-ace-322402 \
    --member "serviceAccount:storage-admin@analog-ace-322402.iam.gserviceaccount.com" \
    --role "roles/storage.admin"

#Step3: Once you have attached the required roles to the service Account, you will now also have to add the namespace and the name of K8s Service Account that wants to use the IAM role via workload Identity

gcloud iam service-accounts add-iam-policy-binding \
        --role roles/iam.workloadIdentityUser \
        --member "serviceAccount:analog-ace-322402.svc.id.goog[default/prom-thaons-kube-prometheu-prometheus]" \
        storage-admin@analog-ace-322402.iam.gserviceaccount.com

gcloud iam service-accounts add-iam-policy-binding \
        --role roles/iam.workloadIdentityUser \
        --member "serviceAccount:analog-ace-322402.svc.id.goog[default/thanos-compactor]" \
        storage-admin@analog-ace-322402.iam.gserviceaccount.com

gcloud iam service-accounts add-iam-policy-binding \
        --role roles/iam.workloadIdentityUser \
        --member "serviceAccount:analog-ace-322402.svc.id.goog[default/thanos-storegateway]" \
        storage-admin@analog-ace-322402.iam.gserviceaccount.com

gcloud iam service-accounts add-iam-policy-binding \
        --role roles/iam.workloadIdentityUser \
        --member "serviceAccount:analog-ace-322402.svc.id.goog[default/thanos-bucketweb]" \
        storage-admin@analog-ace-322402.iam.gserviceaccount.com
