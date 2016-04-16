`import Ember from 'ember'`
`import config from './config/environment'`
`import {DSL} from 'autox/utils/router-dsl'`
Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  {namespace, model,  collection, form, view, child, children} = DSL.import @
  model "appointment", ->
    children "import-batches", as: "batch", -> form "new"
    children "export-batches", as: "batch"
  collection "appointments"
  model "batch"
  
  namespace "alpha", ->
    collection "docks", ->
      form "new"
      model "dock", ->
        collection "trucks", ->
          form "new"

    collection "trucks", ->
      form "new"
      model "truck"

  namespace "omega", ->
    collection "docks", ->
      form "new"
      model "dock", ->
        collection "trucks", ->
          form "new"

    collection "trucks", ->
      form "new"
      model "truck"

  model "user"
  collection "owners"
  collection "chairs", ->
    form "new"
  model "chair", ->
    form "edit"
  collection "shops", ->
    form "new"
    model "shop", ->
      form "edit"
      collection "histories"

  collection "salsas", ->
    form "new"
    model "salsa", ->
      form "edit"
      collection "histories"

  @route "finite-state-machine"
  @route "autox-show-for"

  namespace "setup", ->
    @route "requirements"
    @route "install"
  namespace "server", ->
    @route "router"
    @route "models"
    @route "plugs"
    @route "scaffold"
  namespace "client", ->
    @route "router"
    @route "models"
    @route "mixins"
  namespace "release", ->
    @route "backend"
    @route "web"
    @route "mobile"
    @route "desktop"

`export default Router`
