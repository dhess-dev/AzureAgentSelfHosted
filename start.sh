#!/usr/bin/env bash
set -e

# Optional: Agent files persistent ablegen
mkdir -p /azp/agent
chown -R azdo:azdo /azp/agent

exec su - azdo -c '
  set -e
  cd /azp/agent

  if [ -z "$AZP_URL" ] || [ -z "$AZP_TOKEN" ] || [ -z "$AZP_POOL" ] || [ -z "$AZP_AGENT_NAME" ]; then
    echo "Missing AZP_* env vars"
    exit 1
  fi

  cleanup () {
    echo "Removing agent registration..."
    ./config.sh remove --unattended --auth pat --token "$AZP_TOKEN" || true
  }
  trap cleanup EXIT INT TERM

  if [ ! -f ./run.sh ]; then
    echo "Downloading agent..."
    curl -Ls https://download.agent.dev.azure.com/agent/4.266.2/vsts-agent-linux-x64-4.266.2.tar.gz | tar zx
  fi

  ./config.sh --unattended \
    --url "$AZP_URL" \
    --auth pat \
    --token "$AZP_TOKEN" \
    --pool "$AZP_POOL" \
    --agent "$AZP_AGENT_NAME" \
    --acceptTeeEula \
    --work /azp/_work \
    --replace

  ./run.sh
'
