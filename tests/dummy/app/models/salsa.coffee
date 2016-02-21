`import DS from 'ember-data'`
`import {Mixins, action, about} from 'autox'`
{needs} = action
{Relateable, Timestamps, Historical, Multiaction} = Mixins
Model = DS.Model.extend Relateable, Timestamps, Historical, Multiaction,
  name: DS.attr "string",
    label: "Salsa Name"
    description: "The vanity name of this salsa"
    display: ["show", "index"]
    modify: ["new", "edit"]
  price: DS.attr "number",
    label: "R&D Cost"
    description: "The amount money it took to develop this salsa"
    display: ["show"]
    modify: ["new", "edit"]
  secretSauce: DS.attr "string",
    label: "Secret Sauce"
    description: "Magical ingredients this salsa may have"
    display: ["show"]
    modify: ["new", "edit"]
  shops: DS.hasMany "shop", async: true
  
  mateWithShop: action "click",
    display: ["show"]
    label: "Couple With Shop"
    description: "Couples this salsa to a shop"
    (actionState) ->
      shop = yield needs "shop"
      relation = @relate("shops").associate(shop)
      relation.set "authorizationKey", "xxx"
      relation.save()
      

about Model,
  label: "Salsa Identification"
  description: "Salsas are dressings put on top of tacos to enhance the flavor"
  aliasKey: "name"
  display: ["show", "index"]

`export default Model`