
# MERN Stack - 3 Tier application


Welcome to the End-to-End DevSecOps Kubernetes Project guide! In this comprehensive project, we will walk through the process of setting up a robust Three-Tier architecture on AWS using Kubernetes, DevOps best practices, and security measures. This project aims to provide hands-on experience in deploying, securing, and monitoring a scalable application environment.

- High Level Overview of the project.
  
![image](https://github.com/user-attachments/assets/ab093310-7b81-4424-be5a-543fbe93c2ca)


MERN stands for:
  
1- Mongo DB (Database)
  
2- Express.js

3- React.js (frontent)

4- Node.js (backend)

## Table Of Contents

1. Introduction

2. Prerequisites

3. Project Overview

4. Infrastructure Provisioning

    4.1 Local Jenkins Server Setup

    4.2 Terraform Setup

    4.3 Ansible Configuration Management

5. Continuous Integration with AWS Jenkins Server

    5.1 AWS Jenkins Server Setup

    5.2 CI Pipelines Setup

    5.3 Security Scanning with Trivy & SonarQube

6. Continuous Deployment with ArgoCD

    6.1 ArgoCD Setup

7. Monitoring with Prometheus & Grafana

    7.1 Prometheus Installation

    7.2 Grafana Installation

    7.3 Configuring Grafana


8. Challenges & Troubleshooting

9. Conclusion

10. References

## 1. Introduction

This documentation outlines the steps taken to set up a complete DevSecOps pipeline utilizing AWS services, Jenkins for CI/CD, ArgoCD for GitOps, and Prometheus and Grafana for monitoring. The goal is to automate the infrastructure provisioning and application deployment process while maintaining high standards of security and observability.

## 2. Prerequisites

Before proceeding with the installation and setup, ensure the following tools and services are available:

AWS Account: An active AWS account with permissions to create resources like VPCs, EC2 instances, and EKS.
![image](https://github.com/user-attachments/assets/26649999-cac7-4352-bbda-7b7616ed025b)


Local Machine Setup:

Install Git: For version control.

Install Jenkins: Either locally or in an EC2 instance.

Install Terraform: For infrastructure provisioning.

Install Ansible: For configuration management.

AWS CLI: Installed and configured with the necessary IAM permissions.

Helm: For managing Kubernetes applications.


## 3. Project Overview

This project involves the following main components:

Infrastructure: Provisioning AWS resources such as VPC, EKS, EC2 instances, and security groups using Terraform.

CI/CD: Building and deploying applications using Jenkins for CI and ArgoCD for CD.

Monitoring: Utilizing Prometheus and Grafana for application and infrastructure monitoring.

Security: Integrating security scanning tools like Trivy and SonarQube to ensure the application's integrity.

## 4. Infrastructure Provisioning

   4.2 Terraform Setup

Install Terraform:

Download and install Terraform from the official Terraform website.
Terraform Configuration:

The Terraform scripts are located in the repository. The main components include:

VPC Configuration: Defines the VPC, subnets, route tables, and internet gateway.

EKS Cluster: Provisions the EKS cluster and the necessary IAM roles.

Run Terraform Commands:

Initialize Terraform:
    
    terraform init
    Apply the configuration:

    terraform apply -auto-approve

    4.1 Local Jenkins Server Setup

Install Jenkins on Your Local Machine:
![Screenshot from 2024-10-03 14-57-34](https://github.com/user-attachments/assets/f3ab5691-302a-4978-9048-951627d91d6a)


Follow the installation instructions for your operating system. Refer to the official Jenkins documentation.

Clone the Project Repository:

    git clone https://github.com/amrkedra/MERN-Full-project.git
    cd MERN-Full-project/CI-CD

Create a New Pipeline in Jenkins:

- Navigate to Jenkins Dashboard > New Item.
    Choose Pipeline and name it (e.g., Infra-Pipeline).
    In the pipeline configuration, select Pipeline script from SCM and choose Git.
    Provide the repository URL and select the Jenkinsfile-infra from your cloned   repository.
    Add Necessary Credentials to Jenkins:

- Navigate to Manage Jenkins > Manage Credentials.

    Add the required AWS credentials for Jenkins to access AWS resources. 

![Screenshot from 2024-10-12 12-51-05](https://github.com/user-attachments/assets/ba5c24aa-db7e-4968-8336-1c9c75f51a5f)
    Run the Pipeline:

- Execute the pipeline to provision the infrastructure.

  ![Screenshot from 2024-09-29 20-18-30](https://github.com/user-attachments/assets/fe5a1b9d-5eaf-44f2-96c5-66fc2eabd675)


- Monitor the console output for any errors or confirmation messages.

  ![Screenshot from 2024-09-29 15-43-06](https://github.com/user-attachments/assets/ae4ea8e3-d599-43dd-86ce-56b96d9574b4)


 


    4.3 Ansible Configuration Management

Install Ansible:

Follow the installation instructions on the Ansible website.
Ansible Playbooks:

The Ansible playbooks are located in the ansible directory within the cloned repository.

The playbooks are used to configure the Jenkins server and the Jump server.

Run Ansible Playbooks:

Execute the following command to set up Jenkins and other necessary configurations:

    
    ansible-playbook -i inventory ansible/setup-jenkins.yml

![Screenshot from 2024-10-13 14-24-37](https://github.com/user-attachments/assets/b735293b-714e-4718-8300-262e34f74a3f)



## 5. Continuous Integration

The jenkins server & Jump server have been provided already as part of the infrastructure provisioning step.



5.1 AWS Jenkins Server

Open your browser and navigate to:

![Screenshot from 2024-10-03 14-57-34](https://github.com/user-attachments/assets/45b57c99-6c59-4787-b2cc-2a955a66a479)


http://<AWS-Jenkins-EC2-Public-IP>:8080


    5.2 CI Pipelines Setup

Pipeline Stages

1. Cleaning Workspace

Purpose:

Ensures that the Jenkins workspace is clean before starting a new build. This 
prevents residual files from previous builds from affecting the current build process.

Implementation:


    stage('Cleaning Workspace') {
        steps {
            cleanWs()
        }
    }


2. Checkout from Git

Purpose:
Retrieves the latest code from the GitHub repository's main branch. This ensures that the CI pipeline works with the most recent code changes.

Implementation:


    stage('Checkout from Git') {
        steps {
            git branch: 'main', credentialsId: 'GIHUB-Creds', url: 'https://github.com/amrkedra/MERN-Full-project.git'
        }
    }

Details:

credentialsId: References stored Jenkins credentials (GIHUB-Creds) for authenticated access to the GitHub repository.

url: URL of the GitHub repository.

3. SonarQube Analysis

Purpose:
Performs static code analysis to assess code quality, detect bugs, vulnerabilities, and code smells. SonarQube provides a comprehensive report that helps maintain high code standards.

Implementation:


    stage('Sonarqube Analysis') {
        steps {
            dir('App-Code/frontend') {
                withSonarQubeEnv('sonar-server') { // Ensure 'sonar-server' matches your SonarQube server configuration
                    withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            # Running SonarQube Analysis...
                            echo "Running SonarQube Analysis..."
                            $SCANNER_HOME/bin/sonar-scanner -X \
                                -Dsonar.projectName=frontend \
                                -Dsonar.projectKey=frontend \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://15.185.210.43:9000 \
                                -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }
    }

Details:

withSonarQubeEnv: Configures the SonarQube environment based on Jenkins global settings.

sonar-scanner: Executes the SonarQube analysis with specified parameters.
Parameters:

sonar.projectName: Name of the SonarQube project.

sonar.projectKey: Unique identifier for the project in SonarQube.

sonar.sources: Directory containing the source code to analyze.

sonar.host.url: URL of the SonarQube server.

sonar.login: Authentication token for SonarQube.

4. Quality Check

Purpose:

Waits for the SonarQube Quality Gate result to determine if the code meets the defined quality standards. Depending on the result, the pipeline can proceed or halt.

Implementation:


    stage('Quality Check') {
        steps {
            script {
                try {
                    echo "Waiting for SonarQube Quality Gate..."
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                        echo "SonarQube quality gate status: ${qg.status}"
                        if (qg.status != 'OK') {
                            echo "Warning: SonarQube quality gate failed!"
                            // Optionally, mark build as unstable or failed
                            // currentBuild.result = 'UNSTABLE'
                        }
                    }
                } catch (err) {
                    echo "Error while waiting for quality gate: ${err}"
                    currentBuild.result = 'FAILURE'
                }
            }
        }
    }

Details:

waitForQualityGate: Jenkins waits for SonarQube to send the Quality Gate result.

timeout: Ensures that the pipeline does not wait indefinitely.

Handling Results:

If the Quality Gate status is not OK, a warning is logged, and the build can be marked as unstable or failed based on requirements.

5. OWASP Dependency-Check Scan

Purpose:
Performs a security scan to identify known vulnerabilities in project dependencies. Ensures that the project does not include dependencies with known security issues.

Implementation:


    stage('OWASP Dependency-Check Scan') {
        steps {
            dir('App-Code/frontend') {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'Dependency-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
    }

Details:

dependencyCheck: Executes the OWASP Dependency-Check tool with specified arguments.
--scan ./: Scans the current directory.

--disableYarnAudit & --disableNodeAudit: Disables specific audit features if not needed.

dependencyCheckPublisher: Publishes the generated report to Jenkins.

6. Trivy File Scan

Purpose:

Uses Trivy, a comprehensive security scanner, to scan the filesystem for vulnerabilities. This step ensures that the codebase and its dependencies are free from known security issues.

Implementation:


    stage('Trivy File Scan') {
        steps {
            dir('App-Code/frontend') {
                sh 'trivy fs . > trivyfs.txt'
            }
        }
    }
Details:

trivy fs .: Scans the current directory (.) for vulnerabilities.

Output: The results are redirected to trivyfs.txt for further analysis or reporting.

7. Docker Image Build

Purpose:

Builds the Docker image for the frontend application. This image will later be pushed to AWS Elastic Container Registry (ECR) for deployment.

Implementation:


    stage("Docker Image Build") {
        steps {
            script {
                dir('App-Code/frontend') {
                    sh 'docker system prune -f'
                    sh 'docker container prune -f'
                    sh 'docker build -t ${AWS_ECR_REPO_NAME} .'
                }
            }
        }
    }

Details:

docker system prune -f & docker container prune -f: Cleans up unused Docker data to ensure a clean build environment.

docker build -t ${AWS_ECR_REPO_NAME} .: Builds the Docker image and tags it with the ECR repository name.

8. ECR Image Pushing

Purpose:

Pushes the newly built Docker image to AWS ECR. This makes the image available for deployment in the Kubernetes cluster.

Implementation:


    stage("ECR Image Pushing") {
        steps {
            script {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS-Creds']]) {
                    sh '''
                        # Logging into AWS ECR
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
                        
                        # Tagging the Docker image
                        docker tag ${AWS_ECR_REPO_NAME} ${REPOSITORY_URI}${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                        
                        # Pushing the Docker image to ECR
                        docker push ${REPOSITORY_URI}${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                    '''
                }
            }
        }
    }

Details:

AWS Credentials: Utilizes Jenkins credentials (AWS-Creds) to authenticate with AWS.

aws ecr get-login-password: Retrieves the ECR login password.

Docker Tagging and Pushing:

Tags the image with the build number.

Pushes the tagged image to the specified ECR repository.

9. Trivy Image Scan

Purpose:

Scans the pushed Docker image in ECR for vulnerabilities using Trivy. Ensures that the Docker image is secure before deployment.

Implementation:


    stage("TRIVY Image Scan") {
        steps {
            sh 'trivy image ${REPOSITORY_URI}${AWS_ECR_REPO_NAME}:${BUILD_NUMBER} > trivyimage.txt' 
        }
    }

Details:

trivy image: Scans the specified Docker image for vulnerabilities.

Output: Results are saved to trivyimage.txt for review.

10. Update Deployment File

Purpose:

Updates the Kubernetes deployment YAML file with the new Docker image tag. Commits the updated file back to the GitHub repository to reflect the latest deployment version.

Implementation:


    stage('Update Deployment file') {
        environment {
            GIT_REPO_NAME = "MERN-Full-project"
            GIT_USER_NAME = "amrkedra"
        }
        steps {
            dir('K8S') {
                withCredentials([string(credentialsId: 'GitHub-Token', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        # Configure Git
                        git config user.email "${GIT_USER_EMAIL}"
                        git config user.name "${GIT_USER_NAME}"
                        
                        # Assign build number
                        BUILD_NUMBER=${BUILD_NUMBER}
                        echo "Build number: ${BUILD_NUMBER}"
                        
                        # Debug: Check contents of frontend-deployment.yaml before changes
                        echo "==== Contents of frontend-deployment.yaml BEFORE changes ===="
                        cat frontend-deployment.yaml
                        
                        # Extract current image tag
                        imageTag=$(grep -oP '(?<=image: )[^ ]+' frontend-deployment.yaml)
                        echo "Extracted image tag: $imageTag"
                        
                        # Echo variables
                        echo "AWS_ECR_REPO_NAME: ${AWS_ECR_REPO_NAME}"
                        echo "BUILD_NUMBER: ${BUILD_NUMBER}"
                        
                        # Check if imageTag is empty
                        if [ -z "$imageTag" ]; then
                            echo "Error: Image tag not found in frontend-deployment.yaml"
                            exit 1
                        fi
                        
                        # Print current image line
                        echo "Current image line before replacement:"
                        grep 'image:' frontend-deployment.yaml
                        
                        # Replace image tag from latest to build number
                        sed -i "s|${AWS_ECR_REPO_NAME}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/frontend:${imageTag}|${AWS_ECR_REPO_NAME}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/frontend:${BUILD_NUMBER}|g" frontend-deployment.yaml
                        
                        # Debug: Check contents of frontend-deployment.yaml after sed
                        echo "==== Contents of frontend-deployment.yaml AFTER changes ===="
                        cat frontend-deployment.yaml
                        
                        # Print updated image line
                        echo "Updated image line:"
                        grep 'image:' frontend-deployment.yaml
                        
                        # Add changes to git, commit, and push
                        git add frontend-deployment.yaml
                        git commit -m "Update deployment Image to version ${BUILD_NUMBER}" || echo "No changes to commit"
                        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                    '''
                }
            }
        }
    }


![Screenshot from 2024-10-08 23-30-53](https://github.com/user-attachments/assets/ead3d0bf-fecb-4071-bb41-e79735b94ed5)


![Screenshot from 2024-10-09 15-44-04](https://github.com/user-attachments/assets/3768a492-9c96-47aa-8065-33d93a3ff74b)





Details:

Git Configuration: Sets the Git user email and name using environment variables.

Image Tag Extraction: Extracts the current Docker image tag from frontend-deployment.yaml.

Updating the YAML File: Replaces the old image tag with the new build number using sed.

Git Operations: Commits and pushes the updated deployment file back to GitHub using the provided GitHub token.

Environment Variables and Credentials

Environment Variables

The pipeline utilizes several environment variables to manage configurations and credentials securely.

SCANNER_HOME: Path to the SonarQube Scanner installation.

AWS_ACCOUNT_ID: AWS account ID, retrieved securely via Jenkins credentials.

AWS_ECR_REPO_NAME: Name of the AWS ECR repository, retrieved securely via Jenkins credentials.

AWS_DEFAULT_REGION: AWS region (e.g., me-south-1).

REPOSITORY_URI: AWS ECR repository URI constructed using the account ID and region.

GIT_USER_EMAIL: Git user email for commit operations.

GIT_USER_NAME: Git username for commit operations.

GIT_REPO_NAME: Name of the GitHub repository.

Credentials

Sensitive information such as tokens and AWS credentials are managed using Jenkins' credentials store.

GIHUB-Creds: Credentials for accessing the GitHub repository.

sonarqube-token: Token for authenticating with SonarQube.

GitHub-Token: Token for authenticating Git operations.

AWS-Creds: AWS access key and secret key for interacting with AWS services.

Note: Ensure that these credentials are securely stored in Jenkins and have the necessary permissions for their respective operations.

Prerequisites
Before setting up and running the CI pipeline, ensure the following prerequisites are met:

Jenkins Server:

Installed and configured with necessary plugins:

Git Plugin

SonarQube Scanner Plugin

AWS CLI Plugin

Dependency-Check Plugin

Trivy Plugin (if available) or custom installation.

AWS Account:

Properly configured with permissions to create and manage ECR repositories.

AWS CLI installed on the Jenkins server.

SonarQube Server:

Accessible from the Jenkins server.

Properly configured projects with necessary Quality Gates.

GitHub Repository:

Accessible with the provided credentials.

Contains the Kubernetes deployment files.

Docker Installation:

Docker installed and running on the Jenkins server for building and pushing images.
Usage

Triggering the Pipeline:

The pipeline can be triggered manually from the Jenkins dashboard or automatically via GitHub webhooks on code commits.

Pipeline Execution Flow:

Cleaning Workspace: Prepares a clean environment.

Checkout from Git: Retrieves the latest code.

SonarQube Analysis: Analyzes code quality.

Quality Check: Validates against quality gates.

OWASP Dependency-Check Scan: Checks for vulnerable dependencies.

Trivy File Scan: Scans the filesystem for vulnerabilities.
Docker Image Build: Builds the Docker image.

ECR Image Pushing: Pushes the image to AWS ECR.

Trivy Image Scan: Scans the Docker image for vulnerabilities.

Update Deployment File: Updates Kubernetes deployment with the new image tag.

Viewing Reports:

SonarQube Reports: Accessible via the SonarQube dashboard.

Dependency-Check Reports: Published within Jenkins job artifacts.

Trivy Reports: Stored as text files (trivyfs.txt and trivyimage.txt) in the workspace.



Troubleshooting:


Common Issues and Resolutions


    SonarQube Quality Gate Stuck:

Cause: Webhook not properly configured or SonarQube unable to notify Jenkins.

Resolution:

Verify SonarQube webhook settings pointing to http://<JENKINS_URL>/sonarqube-webhook/.

Ensure network connectivity between SonarQube and Jenkins.

Check Jenkins logs for incoming webhook requests.



    ECR Repository Already Exists:

Cause: Manually created ECR repositories are not imported into Terraform state.

Resolution:

Import existing repositories using terraform import.

Ensure Terraform configuration matches existing resources.



    Docker Push Failures:

Cause: Incorrect AWS credentials or repository URI.

Resolution:

Verify AWS credentials stored in Jenkins.

Ensure the REPOSITORY_URI is correctly constructed.



    Git Commit and Push Failures:

Cause: Invalid GitHub token or repository permissions.

Resolution:

Ensure the GitHub token has push permissions.

Verify the GIT_USER_EMAIL and GIT_USER_NAME are correctly set.



    Trivy Scan Not Working:

Cause: Trivy not installed or misconfigured.

Resolution:

Ensure Trivy is installed on the Jenkins server.

Verify the scan commands and output paths.



## 6. Continuous Deployment with ArgoCD

6.1 ArgoCD Setup

Install ArgoCD on EKS:

Deploy ArgoCD in your EKS cluster using the following commands:

    
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Access ArgoCD UI:

Access ArgoCD by using aws load balancer service.

use this command to edit the argocd service and change it's type from CLusterIP to NodePort.

    
    kubectl edit service/argocd-server -n argocd

scroll till the type parameter anc change it from CLusterIP to NodePort.

then run the command:

    kubectl get svc -n argocd

you will notice that the external ip of the service became like this 

xxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxx.me-south-1.elb.amazonaws.com

this will be the address we will use to access argocd UI.

Login to ArgoCD:

![Screenshot from 2024-10-05 15-43-48](https://github.com/user-attachments/assets/5fe9f176-51e8-45e8-8a6b-67d63f76dbd1)


Default username: admin
Retrieve the password with:


    kubectl get pods -n argocd
    kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


Sync Applications:

Set up application sync with the Git repository containing Kubernetes manifests.
Monitor the deployment status through the ArgoCD dashboard.

![Screenshot from 2024-10-05 15-44-43](https://github.com/user-attachments/assets/382b0dc2-f7ee-4b14-a032-4e28a3a0a28e)

![Screenshot from 2024-10-05 15-50-37](https://github.com/user-attachments/assets/81831317-17fa-43f5-941d-cb3c0b1b5f25)

![Screenshot from 2024-10-11 21-27-55](https://github.com/user-attachments/assets/b4216c8c-5e2e-4166-bdca-64fa3ea341f0)


## 7. Monitoring with Prometheus & Grafana

7.1 Prometheus Installation

Create namespace called monitoring.

    kubectl create ns monitoring

7.2 Install Prometheus using Helm:

    helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring

7.3 Grafana Installation

Install Grafana using Helm:


    helm install grafana grafana/grafana -n monitoring

7.4 Configuring Grafana

Access Grafana:

we will use same method we used with argocd and change the service type for prometheus and grafana to LoadBalncer instead of ClusterIP

    kubectl edit service/grafana -n monitoring

you will notice that the external ip of the service became like this

xxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxx.me-south-1.elb.amazonaws.com

this will be the address we will use to access Grafana UI.

Log in with the default admin credentials.

    username: admin
    password: admin

![image](https://github.com/user-attachments/assets/e2986017-ad6f-4da7-a466-9beb68b6e589)


Add Prometheus as a Data Source:

Navigate to Configuration > Data Sources and add Prometheus.
Import Pre-Built Dashboards:

Import dashboards for monitoring Kubernetes cluster health and application metrics.

![Screenshot from 2024-10-11 22-08-07](https://github.com/user-attachments/assets/87330242-3f4d-42fc-823d-79368338ee8d)

## 8. Challenges & Troubleshooting

Issues Faced

    Load Balancer Configuration:

Encountered issues with multiple subnets in the same availability zone, resolved by specifying exact subnets in Ingress configuration.

    EC2 Metadata Access Issue:

Resolved AWS Load Balancer Controller failure to fetch VPC details by adding the necessary flags.



## 9. Conclusion

This documentation provides a comprehensive overview of the setup and implementation of a complete CI/CD pipeline using AWS EKS, Jenkins, ArgoCD, Prometheus, and Grafana. The project demonstrates automation and efficient management of applications with a focus on security and monitoring.


Contributing

Contributions to improve the CI pipeline are welcome! Please follow these guidelines:

Fork the Repository:
Create a personal fork of the project repository.

Create a Feature Branch:



    git checkout -b feature/your-feature-name
    Commit Your Changes:

    git commit -m "Description of your changes"

Push to Your Fork:


    git push origin feature/your-feature-name

Open a Pull Request:

Submit a pull request detailing your changes and the reasons behind them.

Review and Discuss:

Engage with project maintainers during the review process.

Additional Notes

Security Best Practices:

Always manage credentials securely using Jenkins' credentials store.

Regularly update dependencies and tools to patch known vulnerabilities.

Scalability:

The pipeline is designed to handle multiple ECR repositories dynamically, allowing scalability as the project grows.

Customization:

The pipeline can be customized to include additional stages such as automated deployments, rollback mechanisms, or integration with other tools.
