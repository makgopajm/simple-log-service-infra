
/** 

    Managing variables effectively is one of the most important aspects of a fantastic IaC project. It makes it easy to customize deployments without modifying the core configuration files.
    Using a tfvars file helps keep your configurations reusable and avoids hardcoding values.   

**/


# Define input variables.

product-name = "log-service"
env = "stg"
region = "us-east-1"