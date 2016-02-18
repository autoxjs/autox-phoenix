`import Ember from 'ember'`
`import action from '../utils/action'`
`import {_computed} from '../utils/xdash'`
{apply} = _computed
ActionMulticastMixin = Ember.Mixin.create
  selectedForAction: action "click",
    label: "Select for Current Action"
    description: "Indictate to the system you want this object in your current action"
    priority: 0
    display: ["show"]
    useHack: "just-fucking-do-it-i-dont-care"
    when: apply "actionState", "model", (state, model) -> state?.stillNeeds?model
    (actionState) -> actionState.fulfillNextNeed(@)

`export default ActionMulticastMixin`
