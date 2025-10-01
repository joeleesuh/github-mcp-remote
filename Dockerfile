# --- build the GitHub MCP server (Go) ---
FROM golang:1.22 AS build
WORKDIR /src

# install git for cloning + certs for TLS
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# pull source and build
RUN git clone https://github.com/github/github-mcp-server . \
 && go build -o /out/github-mcp-server ./cmd/github-mcp-server

# --- minimal runtime with mcp-proxy exposing Streamable HTTP/SSE ---
FROM python:3.12-slim
WORKDIR /app

# proxy converts stdio <-> Streamable HTTP/SSE
RUN pip install --no-cache-dir mcp-proxy

# add server binary
COPY --from=build /out/github-mcp-server /usr/local/bin/github-mcp-server

# expose + simple healthcheck
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD python - <<'PY' || exit 1
import urllib.request; urllib.request.urlopen("http://127.0.0.1:8080").read()
PY

# run: proxy on :8080 wrapping the stdio server
ENTRYPOINT ["mcp-proxy","--host","0.0.0.0","--port","8080","--","/usr/local/bin/github-mcp-server","stdio"]
