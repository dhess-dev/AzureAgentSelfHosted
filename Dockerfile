FROM mcr.microsoft.com/dotnet/sdk:10.0

RUN apt-get update && apt-get install -y \
  curl tar git libicu-dev docker.io \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m azdo

WORKDIR /azp
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
