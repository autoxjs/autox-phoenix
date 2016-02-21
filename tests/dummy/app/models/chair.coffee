`import Ember from 'ember'`
`import DS from 'ember-data'`
`import {RelateableMixin, virtual, action, about} from 'autox'`

### Additional Features
Now, you can annotate display, modify, and defaultValue
on all DS attr; they are used in automatic generation of forms and data

If you provide values, I assume you don't want that field displayed

Dumb shit like putting modify: ["show"] is ignored
###
{computed} = Ember
Model = DS.Model.extend RelateableMixin,
  name: DS.attr "string",
    display: ["show", "index"]
    modify: ["new", "edit"]
    description: "Some chairs have specific names"
    priority: 1

  reference: DS.attr "string",
    display: ["new", "edit"]
    description: "Some reference field that isn't by the user"
    priority: 2

  cost: DS.attr "number",
    display: ["show"]
    modify: ["new", "edit"]
    description: "The purchase price in cents of this chair"
    label: "Purchase Cost (cents)"
    priority: 3

  insertedAt: DS.attr "moment",
    display: ["show", "index"]
    description: "The time when this model was created"
    label: "time of creation"
    priority: 100

  updatedAt: DS.attr "moment",
    display: ["show"]
    description: "The time when this model was updated"
    label: "time of update"
    priority: 101

  size: DS.attr "string",
    display: ["show"]
    modify: ["new", "edit"]
    description: "The ANSI standard for dimensions"
    among: ["small", "medium", "large"]
    priority: 4

  
  shop: DS.belongsTo "shop",
    display: ["show"]
    modify: ["new"]
    description: "The shop which owns this chair"
    defaultValue: -> @store.findRecord "shop", 1
    among: -> @store.findAll "shop"
    async: true
    proxyKey: "name"
    priority: 5

  # status: virtual "number",
  #   display: ["new", "edit"]
  #   label: "Status Field"
  #   description: "Virtual fields act like regular computed fields, but are picked up by autox"
  #   computed "size", "cost", -> @get("size") + "-" + @get("cost")

  # doSomething: action "click",
  #   display: ["show"]
  #   label: "Perform some action"
  #   description: "Action descriptions may show up on mouse-over or in help-blocks"
  #   bubbles: false # if true, bubbles this action
  #   confirm: false # if set to true, generates a pop-up that requires user-confirmation
  #   when: computed -> true # can be a function, or a string
  #   ->

# Self is a meta field that describes how to render this thing
# Model.reopenClass
#   aboutMe:
#     label: "chair id"
#     description: "chairs are objects that belong in shops for people to sit on"
#     display: ["show", "index"]
#     routeName: "chair.index"
about Model,
  label: "chair id"
  description: "chairs are objects that belong in shops for people to sit on"
  display: ["show", "index"]
  routeName: "chair.index"
# You can provide either a string like "apiv2.chair.index"
# Or you may provide a function that will calculate the route from the router
# if the route does not exist, an error is thrown

`export default Model`