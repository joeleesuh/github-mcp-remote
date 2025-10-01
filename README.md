# GitHub MCP Server on Smithery (Public by default)

This repo containerizes [github-mcp-server](https://github.com/github/github-mcp-server)
and exposes it via [mcp-proxy](https://pypi.org/project/mcp-proxy/) as a remote
**Streamable HTTP/SSE** MCP server (port 8080).

## Modes
- **Public (default):** No token needed. Works on public data only, with GitHub's unauthenticated rate limits (~60 req/hr).
- **Authenticated (optional):** Add `GITHUB_PERSONAL_ACCESS_TOKEN` in Smithery to raise limits and access private data.

## Optional environment variables
- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `GITHUB_READ_ONLY=1`
- `GITHUB_TOOLSETS="repos,issues,pull_requests,actions,code_security"`
- `GITHUB_DYNAMIC_TOOLSETS=1`
- `GITHUB_HOST="https://<your-ghes>"`

## Deploy
1) Connect this repo in Smithery → Publish → Deploy from GitHub.
2) (Optional) Add env vars in the Smithery project.
3) Deploy; you’ll get a hosted URL like `https://smithery.run/<you>/github-mcp-remote/`.

## Use in an MCP client (example: VS Code)
```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://smithery.run/<you>/github-mcp-remote/"
    }
  }
}
