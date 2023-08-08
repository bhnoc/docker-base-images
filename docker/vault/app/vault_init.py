import hvac
import yaml

# Load the configuration from YAML file
with open('/opt/env/live/app/vault_config.yaml', 'r') as config_file:
    config = yaml.safe_load(config_file)

# Extract Vault server URL and unseal keys from the configuration
vault_url = config['vault_url']
unseal_keys = config['unseal_keys']
root_token = config['root_token']

# Connect to the Vault server
client = hvac.Client(url=vault_url, token=root_token)

print(client.sys.is_initialized())

# Initialize the Vault server AKA build keys
# This part is not tested yest.
if not client.sys.is_initialized():
    result = client.initialize()
    root_token = result['root_token']
    unseal_keys = result['keys']
    print(f"Vault initialized. Root token: {root_token}")
    config = {
    'vault_url': 'http://127.0.0.1:8200',
    'root_token': root_token,
    'unseal_keys': unseal_keys
    }   

    with open('/opt/env/live/app/vault_config.yaml', 'w') as config_file:
        yaml.safe_dump(config, config_file)

    print("Vault initialized and configuration saved to 'vault_config.yaml'.")

print(client.sys.is_sealed())

# Load the configuration from YAML file
with open('/opt/env/live/app/vault_config.yaml', 'r') as config_file:
    config = yaml.safe_load(config_file)

# Unseal the Vault server (if necessary)
if client.sys.is_sealed():
    for key in unseal_keys:
        client.sys.submit_unseal_key(key)



# Enable AppRole authentication
try:

    client.sys.enable_auth_method('approle')
except Exception as e:
    print(f"An error occurred: {e}")

# Create an AppRole role
role_name = 'my-approle'
role_options = {
    'policies': 'default',  # Replace 'default' with your desired policies
    'bound_cidr_list': '0.0.0.0/0',  # Replace with your desired CIDR list
    'token_ttl': '1h',  # Replace with your desired token TTL
    'token_max_ttl': '24h'  # Replace with your desired maximum token TTL
}
client.write('auth/approle/role/{0}'.format(role_name), **role_options)

# Retrieve the Role ID and Secret ID for the AppRole
role_id = client.read('auth/approle/role/{0}/role-id'.format(role_name))['data']['role_id']
secret_id = client.write('auth/approle/role/{0}/secret-id'.format(role_name))['data']['secret_id']
print(role_id)
print(secret_id)
'''
print("AppRole authentication enabled in Vault.")
print("Role ID: {0}".format(role_id))
print("Secret ID: {0}".format(secret_id))

# Define the policy name and file path for policy rules
policy_name = 'my-policy'
policy_rules_file = 'policy_rules.hcl'

# Read the policy rules from the file
with open(policy_rules_file, 'r') as policy_file:
    policy_rules = policy_file.read()

# Write the policy to Vault
client.sys.create_or_update_policy(name=policy_name, policy=policy_rules)

print(f"Policy '{policy_name}' created successfully from '{policy_rules_file}'.")
'''