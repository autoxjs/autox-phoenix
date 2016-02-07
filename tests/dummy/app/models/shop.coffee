`import DS from 'ember-data'`
`import {virtual, action, about, RelateableMixin} from 'autox'`
`import {Macros} from 'ember-cpm'`
`import moment from 'moment'`
{join} = Macros

Model = DS.Model.extend RelateableMixin,
  name: DS.attr "string",
    label: "Shop Name"
    description: "The official brand name of your shop"
    modify: ["new", "edit"]
    display: ["show", "index"]
    priority: 1
  
  location: DS.attr "string",
    label: "City of Location"
    description: "The city and state where your shop is physically located"
    modify: ["new", "edit"]
    display: ["show", "index"]
    among: ["Los Angeles, CA", "Las Vegas, NV", "New York, NY", "Chicago, IL", "Phoenix, AZ"]
    priority: 2
  
  theme: DS.attr "string",
    label: "Resturaunt Theme"
    description: "The general brand decor and persona of your shop in a few words (e.g. hot and trendy, old-fashioned, etc.)"
    modify: ["new", "edit"]
    display: ["show"]
    priority: 3

  insertedAt: DS.attr "moment",
    label: "Inserted At"
    description: "The time when this shop was first recorded into the database"
    display: ["show"]
    priority: 500
  updatedAt: DS.attr "moment",
    label: "Updated At"
    description: "The last time the entry for this shop in the database was modified"
    display: ["show"]
    priority: 500
  inspectedAt: DS.attr "moment",
    label: "Last Inspection Time"
    description: "The last time this shop was inspected by the inspector general and approved for continued business"
    display: ["show"]
    modify: ["edit"]
    defaultValue: -> moment()
    priority: 25
  
  kitchen: DS.belongsTo "kitchen",
    label: "Kitchen Id"
    description: "All shops have an unique kitchen ID as required by the health inspector general"
    display: ["show"]
    modify: ["edit"]
    among: (_, store) -> store.findAll "kitchen"
    priority: 50
    async: true
  
  owner: DS.belongsTo "owner", 
    label: "Owner Name"
    description: "The name of the owner of this shop"
    display: ["show"]
    modify: ["new", "edit"]
    among: (_, store) -> store.findAll "owner"
    proxyKey: "name"
    priority: 5
    async: true

  nickname: virtual "string",
    label: "Shop Nickname"
    description: "Every shop has a nickname which is a portmaneu of its name with its location"
    display: ["show"]
    priority: 5
    join "name", "location", "-"
  
  consoleLog: action "click",
    label: "Log to Console"
    description: "Tests the generic action process"
    display: ["show"]
    priority: 5
    (ctx) ->
      console.log @get "nickname"
      console.log ctx

  shopBubble: action "click",
    label: "Bubble the action up"
    description: "Tests proper bubbling"
    display: ["show"]
    bubbles: true
    priority: 5
    -> console.log "in the shop"

  chairs: DS.hasMany "chair", async: true
  salsas: DS.hasMany "salsa", async: true
  tacos: DS.hasMany "taco", async: true
    
about Model,
  label: "Shop Name"
  description: "Shops are stores and resturaunts in and around the United States"
  aliasKey: "nickname"

`export default Model`