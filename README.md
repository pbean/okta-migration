# Okta Tenant Migration with Terraform

This project uses Terraform to migrate Okta resources from a preview tenant to a production tenant. It is designed to be modular, allowing you to select which resources you want to migrate.

The core goals of this project are to:
-   Automate the transfer of configurations between Okta tenants.
-   Avoid migrating default Okta-generated items.
-   Prevent overwriting existing configurations in the production tenant.
-   Provide clear identification for all migrated resources.

## Prerequisites

Before you begin, ensure you have the following:

-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed on your local machine.
-   API tokens for both your Okta preview and production tenants. You can create these in the Okta Admin Console under **Security > API > Tokens**.
-   The necessary permissions in both Okta tenants to read and write the resources you want to migrate.

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd okta-transfer
    ```

2.  **Initialize Terraform:**
    Open your terminal and run the following command to initialize Terraform. This will download the necessary provider plugins.
    ```bash
    terraform init
    ```

3.  **Configure Variables:**
    Open `variables.tf` and update the `default` values for your preview and production organization names and base URLs.

4.  **Set Your API Tokens:**
    For security, your Okta API tokens are read from environment variables. Run the following commands in your terminal, replacing the placeholder values with your actual API tokens:
    ```bash
    export TF_VAR_okta_api_token_preview="your_preview_api_token"
    export TF_VAR_okta_api_token_production="your_production_api_token"
    ```

## Project Structure

-   `main.tf`: The main entry point for the Terraform configuration. It defines the Okta providers and calls the modules to migrate resources.
-   `variables.tf`: Declares the variables used in the project, such as the Okta organization names and API tokens.
-   `.gitignore`: A list of files and directories that should not be committed to version control.
-   `modules/`: This directory contains the modules for migrating different types of Okta resources.
    -   `applications/`: Migrates applications.
    -   `policies/`: Migrates Sign-On, Password, and MFA policies.
    -   `user_schema/`: Migrates custom user schema properties.
    -   `workflows/`, `profile_sources/`, `configurations/`: Placeholders for migrating other resources.

## Modules Usage

This project uses a modular approach. To migrate a specific type of resource, uncomment the corresponding module block in the `main.tf` file.

### Applications

The `applications` module migrates applications. It is designed to skip applications that already exist in the production tenant (by checking the application label) and allows you to explicitly exclude certain applications.

**To use this module:**
1.  Uncomment the `module "applications"` block in `main.tf`.
2.  (Optional) To prevent certain applications from being migrated, add their labels to the `exclude_apps` list.

```terraform
# main.tf

module "applications" {
  source       = "./modules/applications"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
  exclude_apps = ["Okta Browser Plugin", "Okta Dashboard"]
}
```

### Policies

The `policies` module migrates multiple types of policies: **Sign-On**, **Password**, and **MFA**. To ensure migrated policies are easily identifiable and to prevent overwriting existing policies, the name of each migrated policy is automatically prefixed with `oktapreview-`.

**To use this module:**
1.  Uncomment the `module "policies"` block in `main.tf`.

```terraform
# main.tf

module "policies" {
  source = "./modules/policies"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
}
```

### User Schema

The `user_schema` module migrates custom user profile attributes. It automatically filters out default Okta attributes (like `firstName`, `lastName`, `email`, etc.) and will not overwrite any attributes that already exist in the production tenant.

**To use this module:**
1.  Uncomment the `module "user_schema"` block in `main.tf`.

```terraform
# main.tf

module "user_schema" {
  source = "./modules/user_schema"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
}
```

## Execution Workflow

Once you have enabled the modules for the resources you want to migrate, run the following commands:

1.  **`terraform plan`**: This command creates an execution plan and shows you what changes Terraform will make to your Okta tenants without actually applying them. This is a great way to verify the changes.
2.  **`terraform apply`**: This command applies the changes and migrates the resources. Terraform will ask for confirmation before proceeding.

## Important Notes & Limitations

-   **Profile Mappings:** The ability to migrate profile mappings was removed due to limitations in the Okta Terraform provider. The provider does not currently support a data source to list all profile mappings, which makes their automatic migration impossible.
-   **Placeholder Modules:** The `workflows`, `profile_sources`, and `configurations` modules are placeholders. The Okta Terraform provider may not have a simple way to list all of these resources, so custom logic may be required.
-   **Testing:** It is **highly recommended** to test this project in a non-production environment before using it to migrate your production Okta tenants.