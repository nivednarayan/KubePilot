#!/bin/bash
set -e

echo "Destroying all AWS infrastructure..."
cd infra/terraform && terraform destroy -auto-approve

echo "Done. All resources destroyed."
