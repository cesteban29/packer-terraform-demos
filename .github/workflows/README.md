# Github Actions Workflows

## Credentials Needed

**Put them in the repo's Github Actions Secrets**

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- HCP_CLIENT_ID
- HCP_CLIENT_SECRET
---

## Workflow Explained:
The GitHub Actions workflows in this repository automate the process of building and registering Packer images with HCP Packer. Here's how they work:

1. **Trigger**: 
   - Workflows are triggered on pushes to the main branch
   - Changes to specific paths (e.g., hashicat or terramino directories) trigger their respective workflows

2. **Authentication**:
   - Uses stored GitHub secrets to authenticate with AWS and HCP
   - AWS credentials for building EC2 instances
   - HCP credentials for registering images in HCP Packer Registry

3. **Build Process**:
   - Initializes Packer with required plugins
   - Validates Packer configuration files
   - Builds images for both development and production environments
   - Example images:
     - dev-hashicat
     - prod-hashicat
     - dev-terramino
     - prod-terramino

4. **Registration**:
   - Successfully built images are automatically registered in HCP Packer Registry
   - Images are organized in buckets by application (hashicat-demo, terramino-demo)
   - Includes metadata like build time, OS, and application information

5. **Integration**:
   - Built images become available for use in HCP Terraform workspaces
   - Enables automated deployment of the latest application versions

---

## Different Workflows:

- `dev-hashicat`: Builds the Dev version of the HashiCat application
- `prod-hashicat`: Builds the Prod version of the HashiCat application
- `dev-terramino`: Builds the Dev version of the Terramino application
- `prod-terramino`: Builds the Prod version of the Terramino application
