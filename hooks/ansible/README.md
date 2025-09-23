Ansible playbook for HCP Terraform Operator pre-plan hook

This folder contains a minimal example Ansible playbook that the `pre-plan.sh` hook will run (if present) to create a notification for the current workspace.

Files
- `create_notification.yml` - example playbook that POSTs to an API to create a notification. Update the URL and payload to match your target API.

How it is used
- The `hooks/scripts/pre-plan.sh` script will look for this playbook and run it with `ansible-playbook`.
- The script passes `workspace_name` as an extra var. You still need to provide `hcp_token` and `hcp_api_url`.

Required variables
- `hcp_token` - API token with permission to create notifications. Provide as an environment variable or via `--extra-vars`.
- `hcp_api_url` - Base API URL (e.g. `https://app.terraform.io/api/v2`).
- `workspace_name` - passed automatically by the hook from environment or Terraform.
- `org_name` - optional, if your API path requires the organization.

Example invocation (the hook runs this automatically):

ansible-playbook create_notification.yml --extra-vars "hcp_token=$HCP_TOKEN hcp_api_url=https://app.terraform.io/api/v2 org_name=my-org workspace_name=my-ws"

Note
- This is an example and may need to be adapted to the actual HCP/TC API endpoints and payload formats you use.