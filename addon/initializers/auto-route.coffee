`import Ember from 'ember'`
`import {Core} from '../mixins/auto-route'`

initialize = ->
  Ember.Route.reopen Core

AutoRouteInitializer =
  name: 'auto-route'
  initialize: initialize

`export {initialize}`
`export default AutoRouteInitializer`
