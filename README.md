# Autox

JS dependencies

*Optional:
ember-data-filter
liquid-fire
ember-cli-sass
ember-cli-font-awesome

*Required
torii
ember-bootstrap
ember-simple-auth
ember-cpm
ember-cli-coffeescript
ember-moment
ember-lodash
ember-truth-helpers
ember-notify
ember-concurrency
ember-cli-page-object
ember-power-select
ember-bootstrap-datetimepicker
ember-cli-format-number
ember-form-tool
ember-phoenix-chan
ember-modal-dialog
ember-timezone-input

Phoenix Ember addon for rapidly building jsonapi backends

>Note: This is super alpha software! Use at your own peril

## TODO: Implement Action Symmetry aka multi-action
There is a natural symmetry in a lot of actions between models

For example, a truck can dock at a dock, but a dock can also be docked at by a truck.

The dock action takes 2 parameters (dock and truck), so it seems possible to automatically
implement how such "symmetric" action situations are handled using the FSM

## TODO: linkable attributes
allow all attributes to take a link decorator

## TODO: Smarter Routes
Allow routes to automatically detected if we're in a namespace, model, collection, or page and have better default choices for model

## Howto: Test
The server-side tests live in the sample app named `dummy`
test by doing:

```shell
cd dummy
mix test
```

In order to test the js end of autox, you'll need to run the server dummy:

```shell
cd dummy
iex -S mix phoenix.server
```
Then, open up another terminal tab and run:
```shell
ember s
```
Then, open up your browser and navigate to localhost:4200/tests

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
5. If your app needs session authentication, you're naming the models "Session", and "User" (this decision is *not* negotiable, go use another library if you don't like it)
6. There is no zeroth level route; i.e., everything lives in a scope block

## Dependencies
The ember side has a large number of dependencies; they are as listed:
```sh
ember install ember-bootstrap-datetimepicker
ember install ember-cli-format-number
ember install ember-cpm
ember install foxnewsnetwork/ember-form-tool
ember install ember-lodash
ember install ember-moment
ember install ember-notify
ember install ember-phoenix-chan
ember install ember-power-select
ember install ember-truth-helpers
```
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
