`import Ember from 'ember'`
{computed: {alias}} = Ember
SummarizeForShopComponent = Ember.Component.extend
  tagName: ""
  fields: alias "meta.fields"
  modelPath: alias "meta.modelPath"

`export default SummarizeForShopComponent`