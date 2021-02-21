I should have taken better notes!

For fly...

* I didn't see any good way to stand up multiple fly instances outside of just having separate files, so there's `fly.toml` for the elixir app and `flies/postgres/fly.toml` for the postgres server
* Have to set private_network = true in both fly.toml files
* Fly is IPV6 interally, so I had to set inet6 on every sort of connection
* I don't have docker installed locally and just hardcoded everything in the dockerfile. yolo.

Locally..

```
mix deps.get
npm install --prefix assets
mix ecto.setup
mix phx.server
```