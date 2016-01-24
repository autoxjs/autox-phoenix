`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

### Additional Features
Now, you can annotate display, modify, and defaultValue
on all DS attr; they are used in automatic generation of forms and data

If you provide values, I assume you don't want that field displayed

Dumb shit like putting modify: ["show"] is ignored
###

Model = DS.Model.extend RelateableMixin,
  
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
    defaultValue: (ctx) -> ctx.fetch("shop")
    async: true
  

`export default Model`