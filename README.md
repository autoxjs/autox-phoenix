# Autox

Phoenix Ember addon for rapidly building jsonapi backends

>Note: This is super alpha software! Use at your own peril

## Assumptions

In order to ultra rapidly scaffold out the backend, I make the following
assumptions about your back-end. If *any* of them are not true for you,
I highly recommend against using this library as it may cause irreparable damage
to your app.

1. You don't have any user data in your db and therefore can drop and re-create it on a whim
2. You won't ever care to "optimize" at the application level
3. You *will* use ember-data and phoenix
4. In your routers, you namespace like this:
```elixir
scope "apiv1", Apiv1 do
  ...
end
```
Instead of like this:
```elixir
scope "api/v1", Apiv1 do
  ...
end
```
Yeah, don't nest shit unnecessarily

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
