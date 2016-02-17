`import Ember from 'ember'`
`import config from './config/environment'`
`import {DSL} from 'autox/utils/router-dsl'`
Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  {namespace, model,  collection, form, view} = DSL.import @

  model "user"
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

`export default Router`
