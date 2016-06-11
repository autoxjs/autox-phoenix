`import DS from 'ember-data'`
`import {Mixins, action} from 'autox-phoenix'`
{Relateable, Timestamps, Multiaction} = Mixins
Model = DS.Model.extend Relateable, Timestamps, Multiaction,
  name: DS.attr "string",
    label: "Dock Name"
    description: "Name of the dock"
    display: ["show", "index"]
    modify: ["new", "edit"]
  status: DS.attr "string",
    label: "Dock Status"
    description: "Status of the dock"
    display: ["show", "index"]
    modify: ["new", "edit"]
  trucks: DS.hasMany "truck",
    async: true

  chocolateSprinklesDance: action "click",
    label: "Dance to Chocolate Sprinkles"
    description: "Tell the workers here to perform a dance with chocolate sprinkles in the air"
    display: ["show"]
    ->
      @set "status", "chocolate"
      yield return @save()

  bananaCreamDance: action "click",
    label: "Dance to Banana Cream"
    description: "Tell the workers here to perform a dance to banana cream pie"
    display: ["show"]
    ->
      @set "status", "banana"
      yield return @save()

`export default Model`