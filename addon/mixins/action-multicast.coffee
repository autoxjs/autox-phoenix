`import Ember from 'ember'`
`import action from '../utils/action'`
ActionMulticastMixin = Ember.Mixin.create
  selectedForAction: action "click",
    label: "Select for Current Action"
    description: "Indictate to the system you want this object in your current action"
    when: ({fsm}) -> fsm.get("currentAction")?.stillNeeds @
    (actionState) -> actionState.fulfillNextNeed(@)

`export default ActionMulticastMixin`
