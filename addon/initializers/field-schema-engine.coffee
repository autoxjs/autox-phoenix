`import Ember from 'ember'`
`import {getFieldCollection} from 'autox/utils/field-schema-engine'`
`import {RouteData} from 'autox/utils/router-dsl'`
`import _ from 'lodash/lodash'`
`import getOwner from 'ember-getowner-polyfill'`
{partial, partialRight, chain} = _
{get, String, assert, isPresent, isArray} = Ember
registerField = (application, modelSpace, fieldClass) ->
  assert "needs modelSpace", isPresent(modelSpace)
  assert "needs fieldClass fieldName", isPresent(fieldClass?.fieldName)
  name = "field:#{modelSpace}/#{String.dasherize fieldClass.fieldName}"
  application.register name, fieldClass
  application.__container__.lookup name

registerCollection = (application, modelSpace, fieldCollection) ->
  assert "needs modelSpace", isPresent(modelSpace)
  application.register "field:#{modelSpace}", fieldCollection
  application.__container__.lookup "field:#{modelSpace}"

initialize = (application) ->
  container = application.__container__
  container
  .lookup "router:main"
  .one "willTransition", ->
    store = container.lookup("service:store")
    for modelName, _unused of RouteData.instance().models
      chain store.modelFor(modelName)
      .thru getFieldCollection
      .thru partial(registerCollection, application, modelName)
      .get "constructor.fieldClasses"
      .tap (classes) -> assert "should be array of fields", isArray(classes)
      .value()
      .map partial(registerField, application, modelName)
      .map (field) -> assert "fields should be properly registered", isPresent field

FieldSchemaEngineInitializer =
  name: 'field-schema-engine'
  initialize: initialize

`export {initialize}`
`export default FieldSchemaEngineInitializer`
