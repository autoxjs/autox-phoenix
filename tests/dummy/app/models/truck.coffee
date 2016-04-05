`import Ember from 'ember'`
`import DS from 'ember-data'`
`import {Mixins, action, computed, _x} from 'autox'`
{tapLog} = _x
{isBlank, isPresent, RSVP} = Ember
{computedTask} = computed
{Relateable, Timestamps, Multiaction} = Mixins
Model = DS.Model.extend Relateable, Timestamps, Multiaction,
  name: DS.attr "string",
    label: "Truck Name"
    description: "Name of the truck"
    display: ["show", "index"]
    modify: ["new", "edit"]
  status: DS.attr "string",
    label: "Truck Status"
    description: "Status of the truck"
    display: ["show", "index"]
    modify: ["new", "edit"]  

  dock: DS.belongsTo "dock",
    label: "Loading Dock"
    description: "The loading dock where this truck is currently parked"
    display: ["show"]
    async: true

  arriveAtDock: action "click",
    label: "Arrive at Dock"
    description: "Mark that this truck has arrived at a dock"
    display: ["show"]
    priority: 0
    when: computedTask "model.dock", ->
      RSVP.resolve(@get "model.dock")
      .then (dock) -> isBlank dock
    ->
      {dock} = yield from action.need "dock"
      @set "dock", dock
      @save()

  weirdDockTruck: action "click",
    label: "Weird Dock Truck"
    description: "Test if action needs can properly redirect the user to weird places"
    display: ["show"]
    priority: 1
    ->
      {dock} = yield from action.need "dock:1:alpha.trucks"
      @
  arriveAtAlphaDock: action "click",
    label: "Alpha Dock Arrival"
    description: "Mark this truck arrived via the alpha docks"
    display: ["show"]
    priority: 0
    when: computedTask "model.dock", ->
      RSVP.resolve(@get "model.dock")
      .then (dock) -> isBlank dock
    ->
      {dock} = yield from action.need "dock:1:alpha.docks"
      @set "dock", dock
      @save()

  departFromDock: action "click",
    label: "Depart from Dock"
    description: "Send this truck away from this dock"
    display: ["show"]
    priority: 0
    when: computedTask "model.dock", ->
      RSVP.resolve(@get "model.dock")
      .then (dock) -> isPresent dock
    ->
      @set "dock", null
      yield return @save()

`export default Model`