`import Ember from 'ember'`
`import {_computed} from './xdash'`
`import {Macros} from 'ember-cpm'`

{Object, computed, isPresent, A, inject} = Ember
{match, apply, access} = _computed
{alias, empty, or: ifAny} = computed
{conditional} = Macros

numberType = /(number|money)/
directType = /(password|email)/

Field = Object.extend
  lookup: inject.service("lookup")
  contDisplay: apply "meta.options.display", "action", (xs, x) -> xs?.contains x
  canDisplay: ifAny "canModify", "contDisplay"
  canModify: apply "meta.options.modify", "action", (xs, x) -> xs?.contains x
  isBasic: empty "choices"
  type: alias "meta.type"
  choices: access "ctx.choices", "name"
  label: alias "meta.options.label"
  prefix: match "type",
    ["string", -> "fa-pencil"],
    ["money", -> "fa-money"],
    ["email", -> "fa-at"],
    ["text", -> "fa-comment-o"],
    ["password", -> "fa-lock"],
    ["moment", -> "fa-calendar"],
    ["phone", -> "fa-mobile-phone"]
  componentName: match "type",
    [numberType, -> "em-number-field"],
    [directType, ([x]) -> "em-#{x}-field"],
    ["string", -> "em-text-field"],
    ["text", -> "em-textarea-field"]
  selectChoice: conditional "userChose", "userSelectChoice", "autoxSelectChoice"
  userChose: apply "lookup", "userSelectChoice", (lookup, name) -> isPresent lookup.component(name)
  autoxSelectChoice: "autox-select-choice"
  userSelectChoice: apply "type", (type) -> "#{type}-select-choice"
  description: alias "meta.options.description"

class SchemaUtils
  @getFields = ({factory, ctx, action}) ->
    fields = A []
    factory.eachAttribute (name, meta) ->
      fields.pushObject Field.create {name, meta, ctx, action}
    factory.eachRelationship (name, meta) ->
      fields.pushObject Field.create {name, meta, ctx, action}
    fields
`export default SchemaUtils`