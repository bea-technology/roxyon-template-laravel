# Roxyon template: Laravel

The Laravel 13 skeleton, ready for Roxyon. Roxyon runs `composer install --no-dev`, then `start.sh`, which migrates, caches the config and serves the app behind HTTPS. `storage/` (app key, SQLite database, sessions, uploads) is kept across deploys via `.rxshared`.

## Deploy to Roxyon in 3 steps

**From the terminal**

1. Install the CLI and sign in:
   `npm i -g @roxyon/cli && roxyon login`
2. Set `host` in `roxyon.json` to a host on your Roxyon account: one of your domains, a subdomain of
   one, or a free `<name>.roxyon.com` (add it in the [console](https://console.roxyon.com) first, or
   ask your AI agent to add it).
3. Deploy:
   `roxyon deploy`

**With your AI agent**

1. Open this folder in an agent that supports MCP (Claude Code, Cursor, VS Code, ...). `.mcp.json`
   connects it to the Roxyon MCP server at `https://mcp.roxyon.com/mcp`; sign in with your Roxyon
   account when it asks.
2. Say: **"Deploy this to Roxyon at <name>.roxyon.com"**.
3. The agent adds the host if needed, deploys, and gives you the URL. Static files go up through the
   Roxyon MCP server; a server app is deployed with `roxyon deploy` (the CLI above) or the
   `roxyon_deploy` tool of the local MCP server (`npx -y @roxyon/mcp`), since both read this
   folder from your machine.

## Run it locally

```bash
composer install
cp .env.example .env && php artisan key:generate
php artisan migrate
php artisan serve   # http://127.0.0.1:8000
```

**Settings on Roxyon:** `roxyon env set KEY=value` after the first deploy (for example `APP_URL`, or `DB_CONNECTION=mysql`
with `DB_HOST`/`DB_DATABASE`/`DB_USERNAME`/`DB_PASSWORD` of a Roxyon database). Without `APP_KEY`, `start.sh` creates one
on the first start and keeps it in `storage/`. PHP 8.3 or newer is required; Roxyon uses 8.4.

## Files

- `roxyon.json`: how Roxyon builds and serves this project (`host`, `runtime`, `kind`, ...).
  `application` is added on the first deploy of a server app; commit it so later deploys update the
  same app.
- `.mcp.json`: the Roxyon MCP server for AI agents.

Docs for AI assistants: https://roxyon.com/llms.txt · Status: https://roxyon.com/status

## License

MIT
