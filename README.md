
# Okta Tenant Migration with Terraform

This project uses Terraform to migrate Okta resources from a preview tenant to a production tenant.

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed on your local machine.
- API tokens for both your Okta preview and production tenants. You can create these in the Okta Admin Console under **Security > API > Tokens**.
- The necessary permissions in both Okta tenants to read and write the resources you want to migrate.

## Getting Started

1.  **Initialize Terraform:**

    Open your terminal, navigate to the project directory, and run the following command to initialize Terraform. This will download the necessary provider plugins.

    ```bash
    terraform init
    ```

2.  **Set Your API Tokens:**

    For security, your Okta API tokens are not stored in the configuration files. Instead, they are read from environment variables. Run the following commands in your terminal, replacing the placeholder values with your actual API tokens:

    ```bash
    export TF_VAR_okta_api_token_preview="your_preview_api_token"
    export TF_VAR_okta_api_token_production="your_production_api_token"
    ```

## Project Structure

The project is organized into the following files and directories:

-   `main.tf`: The main entry point for the Terraform configuration. It defines the Okta providers and calls the modules to migrate resources.
-   `variables.tf`: Declares the variables used in the project, such as the Okta organization names and API tokens.
-   `.gitignore`: A list of files and directories that should not be committed to version control, such as Terraform state files and local variables.
-   `modules/`: This directory contains the modules for migrating different types of Okta resources.
    -   `applications/`: Migrates applications.
    -   `policies/`: Migrates policies.
    -   `workflows/`: A placeholder for migrating workflows.
    -   `profile_sources/`: Migrates user profile mapping sources.
    -   `user_schema/`: Migrates custom user schema properties.
    -   `configurations/`: A placeholder for migrating configurations.

## Usage

This project uses a modular approach to migrate Okta resources. Each resource type has its own module. To use a module, you must uncomment it in the `main.tf` file.

### Applications

The `applications` module migrates applications from the preview tenant to the production tenant.

To prevent the migration of default applications (e.g., "Okta Browser Plugin", "Okta Dashboard") or other applications that already exist in your production tenant, you can specify a list of application labels to exclude.

**To use this module:**

1.  Uncomment the `module "applications"` block in `main.tf`.
2.  (Optional) Add the `exclude_apps` variable with a list of application labels to exclude.

```terraform
# main.tf

module "applications" {
  source       = "./modules/applications"
  exclude_apps = ["Okta Browser Plugin", "Okta Dashboard"]
}
```

### Policies

The `policies` module migrates Okta Sign-On policies. To ensure migrated policies are easily identifiable and to prevent overwriting existing policies in your production tenant, the name of each migrated policy is automatically prefixed with `oktapreview-`.

**To use this module:**

1.  Uncomment the `module "policies"` block in `main.tf`.

```terraform
# main.tf

module "policies" {
  source = "./modules/policies"
}
```

### Profile Mappings

The `profile_mappings` module has been removed due to limitations in the Okta Terraform provider. The provider does not currently support a data source to list all profile mappings, which makes automatic migration of them impossible.

### Plan and Apply

Once you have enabled the modules for the resources you want to migrate, run the following commands:

-   `terraform plan`: This command shows you what changes Terraform will make to your Okta tenants.
-   `terraform apply`: This command applies the changes and migrates the resources.

## Customization

-   **Modifying Modules:** You can customize the behavior of each module by editing the `main.tf` file within the module's directory. For example, you can change the attributes of the resources being created or add new resources.
-   **Adding New Modules:** To migrate a new type of resource, create a new directory in the `modules/` directory and add the necessary Terraform configuration files.

## Important Notes

-   **Workflows, Profile Sources, and Configurations:** The modules for these resources are placeholders because the Okta Terraform provider does not currently have a simple way to list all of them. You will need to implement the logic to read these resources from your preview tenant. The placeholder files contain commented-out examples to guide you.
-   **Performance:** The `profile_sources` module iterates through all of your users to find their profile mapping sources. If you have a large number of users, this could be slow and result in many API calls to Okta.
-   **Testing:** It is highly recommended to test this project in a non-production environment before using it to migrate your production Okta tenants.
