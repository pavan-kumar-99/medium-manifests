import requests
import logging
import os

# Configure logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def delete_deploy_keys(repo_name, owner, token):
    # Get all deploy keys for the repository
    deploy_keys_url = f'https://api.github.com/repos/{owner}/{repo_name}/keys'
    response = requests.get(deploy_keys_url, headers={'Authorization': f'Bearer {token}'})

    if response.status_code == 200:
        deploy_keys = response.json()
        for key in deploy_keys:
            key_id = key['id']
            # Attempt to delete each deploy key
            delete_key_url = f'https://api.github.com/repos/{owner}/{repo_name}/keys/{key_id}'
            delete_response = requests.delete(delete_key_url, headers={'Authorization': f'Bearer {token}'})
            if delete_response.status_code == 204:
                logger.info(f"Deploy key {key_id} deleted successfully.")
            else:
                logger.error(f"Failed to delete deploy key {key_id}. Status code: {delete_response.status_code}, Response: {delete_response.text}")
    else:
        logger.error(f"Failed to retrieve deploy keys for repository {repo_name}. Status code: {response.status_code}, Response: {response.text}")

def get_all_repositories(username, token):
    repositories_url = f'https://api.github.com/users/{username}/repos'
    response = requests.get(repositories_url, headers={'Authorization': f'Bearer {token}'})

    if response.status_code == 200:
        repositories = response.json()
        for repo in repositories:
            repo_name = repo['name']
            owner = repo['owner']['login']
            delete_deploy_keys(repo_name, owner, token)
    else:
        logger.error(f"Failed to retrieve repositories for user {username}. Status code: {response.status_code}, Response: {response.text}")

def main():
    username = 'pavan-kumar-99'
    token = os.getenv('GITHUB_TOKEN')

    get_all_repositories(username, token)

if __name__ == '__main__':
    main()
