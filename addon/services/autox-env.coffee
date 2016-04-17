`import Ember from 'ember'`
{computed: {alias}, inject: {service}} = Ember

AutoxEnvService = Ember.Service.extend
  config: service "config"
  newComp: alias "config.AutoX.Components.newForm"
  editComp: alias "config.AutoX.Components.editForm"
  modelComp: alias "config.AutoX.Components.showModel"
  collectionComp: alias "config.AutoX.Components.indexCollection"
  summarizeComp: alias "config.AutoX.Components.indexSummarizeModel"
  linkComp: alias "config.AutoX.Components.showLinkField"
  fieldComp: alias "config.AutoX.Components.showAttrField"
  actionComp: alias "config.AutoX.Components.showActionField"
  choiceComp: alias "config.AutoX.Components.selectChoice"

`export default AutoxEnvService`
