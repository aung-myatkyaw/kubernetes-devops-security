# kubernetes-devops-security

# Forked Project with AWS Server Setup

This repository is a fork of an existing project from kodekloud course, DevSecOps, enhanced with AWS server setup, an updated numeric application API using Spring Boot 3.1, and updated Jenkins pipeline scripts for the latest Jenkins versions and tools, including Kubernetes version 1.30.

## Changes Made

- **AWS Server Setup**:
  - Added setup instructions and configuration files for deploying the application on AWS infrastructure.
  - Includes scripts and templates for provisioning AWS resources using AWS services like EC2, Cloudwatch, and Cloudflare.

- **Updated Numeric Application API**:
  - Upgraded the existing numeric application API to utilize Spring Boot 3.1.
  - Includes updated dependencies, configurations, and enhancements for improved performance and compatibility.

- **Jenkins Pipeline Updates**:
  - Revised Jenkins pipeline scripts to align with the latest Jenkins versions.
  - Updated plugin dependencies and integrated new features offered by Jenkins updates.
  
- **Kubernetes Version Update**:
  - Updated Kubernetes configurations to support the latest Kubernetes version 1.30.
  - Adjusted deployment scripts and Kubernetes manifest files for compatibility with the updated Kubernetes features.

## Contributing

Contributions to this project are welcome! If you encounter issues or have suggestions for improvements, please submit a pull request or open an issue in the repository.

## Acknowledgements

We would like to acknowledge the original creators of the forked project and thank them for providing a foundation for this enhanced version.

## NodeJS Microservice - ARM64 Docker Image -
`docker run -p 8787:5000 yinko2/node-service:v1`

`curl localhost:8787/plusone/99`
 
## NodeJS Microservice - Kubernetes Deployment -
`kubectl create deploy node-app --image yinko2/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`
