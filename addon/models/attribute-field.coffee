`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import {Macros} from 'ember-cpm'`
`import _ from 'lodash/lodash'`
`import FieldCore from '../mixins/field-core'`
`import FieldSelect from '../mixins/field-select'`
{computed: {match, apply, access}} = _x
{Object, computed: {alias, or: ifAny}} = Ember
{join} = Macros
{noop} = _

TextType = /^string&(comment|note|body|description)/
DateType = /(date|moment|datetime)/
AttributeField = Object.extend FieldCore, FieldSelect,
  canDisplay: ifAny "canModify", "canOnlyDisplay"
  typeName: join "type", "name", "&"
  prefix: match "typeName",
    ["string&email", -> "fa-at"],
    [TextType, -> "fa-comment-o"],
    [/^string&password/, -> "fa-lock"],
    [/^string/, -> "fa-pencil"],
    [/(price|cost|money)$/, -> "fa-money"],
    [DateType, -> "fa-calendar"],
    [/phone$/, -> "fa-mobile-phone"]
    [_, noop]
  componentName: match "typeName",
    [/^number/, -> "em-number-field"],
    ["string&email", -> "em-email-field"],
    [/^string&password/, -> "em-password-field"],
    [/^string&timezone/, -> "em-timezone-field"],
    [TextType, -> "em-textarea-field"],
    [DateType, -> "em-datetime-field"],
    [/^string/, -> "em-text-field"],
    [_, noop]
  presenter: alias "meta.options.presenter"

`export default AttributeField`