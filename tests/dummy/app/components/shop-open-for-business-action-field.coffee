`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import ActionComponent from 'autox/components/autox-show-action-field'`
{computed: {computedTask}} = _x
Component = ActionComponent.extend
  isPermissible: computedTask "model.histories.firstObject", ->
    @get("model")?.latestHistoryHas("name", "approve-inspection")

`export default Component`