`import DS from 'ember-data'`
`import {Core} from '../mixins/rich-model'`

initialize = ->
  DS.Model.reopenClass Core

RichModelInitializer =
  name: 'rich-model'
  initialize: initialize

`export {initialize}`
`export default RichModelInitializer`
