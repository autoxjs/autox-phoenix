`import DS from 'ember-data'`
`import {virtual, action, about, RelateableMixin, HistoricalMixin} from 'autox'`
`import {Macros} from 'ember-cpm'`
`import moment from 'moment'`
`import {persistHistory} from 'autox/utils/create-history'`

{join} = Macros

Histories =
  deny:
    name: "deny-inspection"
    message: "deny message"
  approve:
    name: "approve-inspection"
    message: "inspection message"
  open:
    name: "Open-Business"
    message: "open business message"
Model = DS.Model.extend RelateableMixin, HistoricalMixin,
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
    defaultValue: "Los Angeles, CA"
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

  approveInspection: action "click",
    label: "Approve Shop"
    description: "Give this shop the seal of approval"
    display: ["show"]
    priority: 0
    -> persistHistory(Histories.approve, {shop: @}).then => @get("histories").reload()

  denyInspection: action "click",
    label: "Deny Shop"
    description: "Deny approval to this shop"
    display: ["show"]
    priority: 0
    -> persistHistory(Histories.deny, {shop: @}).then => @get("histories").reload()

  openForBusiness: action "click",
    label: "Open For Business"
    description: "Open shop for business"
    display: ["show"]
    priority: 0
    presenter: "shop-open-for-business-action-field"
    -> persistHistory(Histories.open, {shop: @}).then => @get("histories").reload()

  chairs: DS.hasMany "chair", async: true
  salsas: DS.hasMany "salsa", async: true
  tacos: DS.hasMany "taco", async: true
    
about Model,
  label: "Shop Name"
  description: "Shops are stores and resturaunts in and around the United States"

`export default Model`