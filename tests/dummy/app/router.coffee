`import Ember from 'ember'`
`import config from './config/environment'`
`import DSL from 'ember-polymorphica/utils/dsl'`
`import Standardx from 'ember-autox-support/utils/standardx'`
Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  {namespace, model, collection, form, view, child, children} = DSL.import(@).with Standardx
  @route "login"

  namespace "dashboard", ->
    collection "appointments", ->
      form "new"
      model "appointment", ->
        form "edit"
        children "import-batches", as: "batch", -> form "new"
        children "export-batches", as: "batch"

    collection "trucks", ->
      form "new"
      model "truck"

    model "batch", ->
      form "edit"

  namespace "admin", ->
    collection "users", ->
      form "new"
      model "user", ->
        form "edit"

`export default Router`
