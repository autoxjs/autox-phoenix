`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

### Additional Features
Now, you can annotate display, modify, and defaultValue
on all DS attr; they are used in automatic generation of forms and data

If you provide values, I assume you don't want that field displayed

Dumb shit like putting modify: ["show"] is ignored
###

Model = DS.Model.extend RelateableMixin,
  name: DS.attr "string",
    display: ["show", "index"]
    modify: ["new", "edit"]
    description: "Some chairs have specific names"

  reference: DS.attr "string",
    display: ["new", "edit"]
    description: "Some reference field that isn't by the user"

  cost: DS.attr "number",
    display: ["show"]
    modify: ["new", "edit"]
    description: "The purchase price in cents of this chair"
    label: "Purchase Cost (cents)"

  insertedAt: DS.attr "moment",
    display: ["show", "index"]
    description: "The time when this model was created"
    label: "time of creation"

  size: DS.attr "string",
    display: ["show"]
    modify: ["new", "edit"]
    description: "The ANSI standard for dimensions"
    among: ["small", "medium", "large"]

  updatedAt: DS.attr "moment"
  
  shop: DS.belongsTo "shop",
    display: ["show"]
    description: "The shop which owns this chair"
    defaultValue: (_, store) -> store.findRecord "shop", 1
    async: true

# Self is a meta field that describes how   
Model.aboutMe =
  label: "chair id"
  description: "chairs are objects that belong in shops for people to sit on"
  display: ["show", "index"]

`export default Model`