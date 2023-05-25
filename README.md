# Infrastructure as Code

All the terraform files for Breaking Bad graduation job.

To use this code change the following:

in terraform.tfvars:
    - set your GCP project id

In vpc.tf:
    - Download a json-key from your GCP account, add it to your repo and specify the file in "credentials" in the vpc-tf file.

In Github:
    - You need to add a GCP-KEY secret. This secret is the same as you downloaded and added to your repo. Remember to not to check it in to your github repo. It should not be public.

The files set up and configure network settings and GKE cluster settings in Google Cloud. It also deploys and configure a ArgoCD.

    To set up Argo run the pipeline, remember to set your Github secrets and GCP project ID accordingly.
    When the pipeline is done check that the pods is running. Go to Kubernetes Egninge ==> Services and Ingress. You should see the services here.
    It is now time to set connect to gcloud in your local CLI. 
    - sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
    - gke-gcloud-auth-plugin --version 
    - export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    - source ~/.bashrc
    - gcloud components update
    - gcloud container clusters get-credentials CLUSTER_NAME
    - gcloud init
    - gcloud auth login (Choose the email connected to your GCP project)
    - gcloud config set project <your project ID>

    Now you should be able to to run kubectl commando:
    - kubectl get pod -n argocd
    - kubectl get ns
    
    Go back to GCP now and click on the argocd-server endpoint address with port 80.
    username is admin to get the password run:
    - kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.  password}" | base64 -d; echo
    - echo <password value from above script> | base64 --decode
    Once Argo is up there is a set of configuration to do, start with click on:
    - New app
        - Add project name
        - Set project to default
        - Sync policy to Automatic
        - Source repository where the k8s manifest is or docker image
        - path can be set to where the files to the service is if root = ./
        - Destination repo = https://kubernetes.default.svc
        - Namespace = the namespace of the application
        - Create
    Now it should start sync and if the application is in a k8s manifest it should also be automatically deployed to GKE.
