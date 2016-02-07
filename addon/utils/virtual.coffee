`import Ember from 'ember'`

virtual = (type, options={}, cp) ->
  cp.meta({type, options, isVirtual: true})

`export default virtual`
