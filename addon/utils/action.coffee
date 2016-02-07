`import Ember from 'ember'`

action = (type, options={}, f) ->
  Ember
  .computed -> f
  .meta({type, options, isAction: true})
  .readOnly()

`export default action`
