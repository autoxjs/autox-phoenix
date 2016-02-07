`import Ember from 'ember'`
`import _x from '../utils/xdash'`
{inject, isPresent} = Ember
{computed: {apply}} = _x
UserCustomizeMixin = Ember.Mixin.create
  lookup: inject.service "lookup"
  userHasDefinedComponent: apply "userDefinedComponent", "lookup", (c, lookup) ->
    c? and isPresent lookup.component c
  userDefinedComponent: apply "model.constructor.modelName", "customPrefix", (name, customPrefix) ->
    "#{customPrefix}-#{name}" if isPresent name

`export default UserCustomizeMixin`
