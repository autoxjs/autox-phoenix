`import Ember from 'ember'`
`import action from '../utils/action'`
`import {_computed} from '../utils/xdash'`
`import Importance from 'autox/utils/importance'`
{apply} = _computed
ActionMulticastMixin = Ember.Mixin.create
  selectedForAction: action "click",
    label: "Select for Current Action"
    description: "Indictate to the system you want this object in your current action"
    priority: Importance.VeryImportant
    display: ["show"]
    useCurrent: true
    when: apply "fsm.currentAction", "model", (currentAction, model) -> currentAction?.stillNeeds?(model)
    -> yield return @
      

`export default ActionMulticastMixin`
