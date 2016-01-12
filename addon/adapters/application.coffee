`import DS from 'ember-data'`

ApplicationAdapter = DS.JSONAPIAdapter.extend
  ajaxOptions: ->
    hash = @_super arguments...
    hash.xhrFields = 
      withCredentials: true
    hash

`export default ApplicationAdapter`
