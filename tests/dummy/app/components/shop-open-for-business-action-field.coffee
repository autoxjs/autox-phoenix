`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import ActionComponent from 'autox/components/autox-show-action-field'`
{computed: {computedPromise}} = _x
Component = ActionComponent.extend
  isPermissible: computedPromise "model.histories.lastObject", ->
    @get("model")?.latestHistoryHas("name", "approve-inspection")

`export default Component`