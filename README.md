# 🦉 Golden Owl DevOps Internship - Technical Test Solution

Welcome to my solution for the Golden Owl DevOps Internship technical test. This repository demonstrates a modern, secure, and automated Infrastructure as Code (IaC) approach combined with a robust CI/CD pipeline.

---

## 🚀 Live Deployment

**Deployment Link (ALB):** `http://goldenowl-devops-cluster-alb-1516692012.ap-southeast-1.elb.amazonaws.com`

> **Note:** Please test the endpoint using `curl` or a web browser to see the JSON response.

---

## 📐 Architecture & Visual Flow Diagram

To meet and exceed the "Nice to have" requirements, I have designed a highly secure, production-ready AWS architecture.

### Key Architectural Decisions

- **Security by Design (Private Subnets):** The ECS Fargate tasks are entirely isolated in Private Subnets. They are not directly exposed to the internet.

- **Application Load Balancer (ALB):** Placed in the Public Subnets, the ALB serves as the single point of entry, routing internet HTTP traffic securely to the ECS tasks.

- **Optimized Networking (VPC Endpoints & NAT Gateway):**
  - **VPC Endpoints (PrivateLink):** Used for ECR (API & DKR), S3, and CloudWatch Logs. This allows the private containers to pull images and push logs internally within the AWS network, maximizing security and minimizing data transfer costs.
  - **NAT Gateway:** Maintained in the routing table for any external outbound internet requests that the application might need.

- **Keyless Authentication (OIDC):** The CI/CD pipeline authenticates with AWS via OpenID Connect (OIDC). No long-lived AWS Access Keys are stored in GitHub Secrets, preventing potential credential leaks.

---

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| Application | Node.js |
| Containerization | Docker |
| Infrastructure as Code | Terraform |
| Cloud Provider | Amazon Web Services (AWS) |
| Compute | ECS (Fargate Serverless) |
| Network | VPC, ALB, Security Groups, VPC Endpoints, NAT Gateway |
| Storage & Registry | ECR |
| IAM | OIDC Provider, Roles, Policies |
| CI/CD | GitHub Actions |

---

## 📂 Repository Structure

The repository separates the application source code from the infrastructure code for better maintainability.

```
.
├── .github/workflows/    # CI/CD Pipeline configuration
├── src/                  # Node.js Application source code
├── terraform/            # Infrastructure as Code (IaC)
│   ├── modules/          # Modularized Terraform configurations
│   │   ├── ecr/
│   │   ├── ecs/
│   │   ├── github-oidc-role/
│   │   ├── vpc/
│   │   └── vpc-endpoints/
│   ├── main.tf           # Terraform entry point
│   ├── providers.tf      # AWS Provider configuration
│   └── variables.tf      # Terraform variables
├── Dockerfile            # Container definition
├── GoldenOwl.drawio.png  # Architecture Diagram
└── README.md
```

---

## 🔄 CI/CD Pipeline Workflow

The GitHub Actions pipeline (`.github/workflows/deploy.yml`) is triggered automatically on a push to the `master` branch **only when changes occur in `src/` or `Dockerfile`**, saving unnecessary build minutes.

### Pipeline Stages

**Continuous Integration (CI):**
1. Checks out the code.
2. Sets up the Node.js 20 environment.
3. Installs dependencies, runs Format Checks, Linter (ESLint), and Unit Tests.

**Continuous Deployment (CD):**
1. Assumes the AWS IAM Role via GitHub OIDC.
2. Authenticates with Amazon ECR.
3. Builds, tags, and pushes the new Docker image to ECR.
4. Downloads the active ECS Task Definition from AWS.
5. Renders the new image URI into the Task Definition.
6. Deploys the updated Task Definition to the ECS Service and waits for container stability.

---

## 🏃‍♂️ Running the Node.js Application Locally

This is a Node.js application, and running it locally is straightforward:

1. Navigate to the `src` directory:
   ```bash
   cd src
   ```

2. Install the project's dependencies:
   ```bash
   npm i
   ```

3. Execute tests:
   ```bash
   npm test
   ```

4. Start the HTTP server:
   ```bash
   npm start
   ```

Test it using the following command:

```bash
curl localhost:3000
```

Expected response:

```json
{"message":"Welcome warriors to Golden Owl!"}
```

---

## 💻 How to Provision the Infrastructure

If you wish to replicate this AWS environment:

**Prerequisites:** AWS CLI configured, Terraform installed.

1. Navigate to Terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize and Apply:
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

3. **Update GitHub Actions:**
   After applying, copy the generated IAM OIDC Role ARN and update the `role-to-assume` field in `.github/workflows/deploy.yml`.

4. **Clean Up (Important):**
   To avoid unexpected AWS charges, destroy the infrastructure when done:
   ```bash
   terraform destroy -auto-approve
   ```

---

Thank you for reviewing my submission! I am excited about the opportunity to bring my passion for DevOps, automation, and secure architecture to Golden Owl.