# PSONO Secret Whisperer Action

This GitHub Action fetches secrets from a PSONO server using psonoci and makes them available as outputs for your GitHub workflow.

## Usage

```yaml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - name: Fetch secrets from PSONO
        id: psono-secrets
        uses: jfheinric-eu/psono-secret-whisperer@v1
        with:
            ci_api_key_id: ${{ secrets.CI_API_KEY_ID }}
            ci_api_key_secret_hex: ${{ secrets.CI_API_KEY_SECRET_HEX }}
            ci_server_url: 'https://your-psono-server.com'
            secret_id: ${{ secrets.SECRET_ID }}
            secret_fields: 'API_KEY,DATABASE_URL,OTHER_SECRET'
            mask_secrets: 'API_KEY'

      # Access secrets
      - name: Use secrets
        run: |
          echo "API Key: ${{ steps.psono-secrets.outputs.API_KEY }}"
          echo "Database URL: ${{ steps.psono-secrets.outputs.DATABASE_URL }}"
```

## Inputs

| Input                   | Description                                           | Required | Default           |
|-------------------------|-------------------------------------------------------|----------|-------------------|
| `ci_api_key_id`         | PSONO API key                                         | Yes      | -                 |
| `ci_api_key_secret_hex` | PSONO API key                                         | Yes      | -                 |
| `ci_server_url`         | URL of your PSONO server                              | Yes      | -                 |
| `secret_id`             | secret id to fetch                                    | Yes      | -                 |
| `secret_fields`         | Comma-separated list of secret keys to retrieve       | No       | username,password |
| `mask_secrets`          | Comma-separated list of secret keys to masked         | No       | -                 |

## Outputs

The action provides following outputs:

1. Individual outputs for each secret key, accessible via the key name

## Security Recommendations

- Always use GitHub secrets to store your PSONO credentials
- Limit the secret keys you retrieve to only what you need
- Consider using GitHub's OIDC support for even more secure authentication

## Requirements

The action requires:
- A PSONO server that's accessible from GitHub Actions
- Valid PSONO credentials with access to the requested secrets

## License

This GitHub Action is released under the [MIT License](LICENSE).
