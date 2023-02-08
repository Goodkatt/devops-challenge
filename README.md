# Devops Challenge
# http://35.187.171.49:8080

### All infrastructure is created with Terraform, components are as follows

#### - VPC
#### - Private and Public subnets
#### - Firewall rules
#### - Secondary IP ranges for Kubernetes in Private Subnet
#### - Cloud Nat Gw and Cloud Router
#### - GKE Cluster and Node Pool(Private nodes and Public master node)
#### - Can access gcr.io
#### - Application is exposed through port 8080 via LoadBalancer
#### - Deployment.yaml file(Includes Deployment and Service)

<br/><br/>
### Connected to master plane through my terminal by using the Google CLI command, created and exposed the service by applying the deployment.yml file

#### - gcloud container clusters get-credentials primary --zone europe-west1-b --project devops-377015
#### - kubectl apply -f deployment.yaml
<br/><br/>

