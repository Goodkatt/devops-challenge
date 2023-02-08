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

![svc](https://user-images.githubusercontent.com/20110284/217599994-331d3144-ac03-4611-aa50-4206d3e56dff.png)
![cluster](https://user-images.githubusercontent.com/20110284/217600059-2c4c013d-a1ae-4bd8-8c19-c1ff0869d2fe.png)
![vm](https://user-images.githubusercontent.com/20110284/217600072-cdea248c-0822-4d25-95a3-4862e8c2cbf1.png)
![app](https://user-images.githubusercontent.com/20110284/217600080-9f638339-461a-4b13-87c3-bf87bd97495e.png)
