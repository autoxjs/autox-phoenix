`import DS from 'ember-data'`
`import {Mixins, action} from 'autox'`
{needs} = action
{Relateable, Timestamps, Historical} = Mixins
Model = DS.Model.extend Relateable, Timestamps, Historical,
  name: DS.attr "string"
  price: DS.attr "number"
  secretSauce: DS.attr "string"
  shops: DS.hasMany "shop", async: true
  
  mateWithShop: action "click",
    label: "Couple With Shop"
    description: "Couples this salsa to a shop"
    setup: (state) -> state.get("shop")
    needs "shop", (shop) -> @relate("shops").associate(shop).save()

`export default Model`