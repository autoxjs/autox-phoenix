`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-link-field'`
`import _x from '../utils/xdash'`
{computed: {apply}} = _x
{computed: {alias}} = Ember
AutoxShowLinkFieldComponent = Ember.Component.extend
  tagName: ""
  layout: layout
  linkClass: "list-group-item autox-show-link-field"
  slug: alias "field.linkSlug"

  linkModel: apply "slug.type", "field.name", "model", (type, name, model) ->
    switch type
      when "belongsToChild", "hasManyChildren" then model
      when "belongsTo" then model.get("#{name}.id")
  hasLinkModel: apply "slug.type", (type) -> type in ["hasManyChildren", "belongsToChild", "belongsTo"]

`export default AutoxShowLinkFieldComponent`
