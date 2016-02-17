`import Ember from 'ember'`
`import FieldCore from '../mixins/field-core'`
`import FieldSelect from '../mixins/field-select'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`
`import {RouteData} from 'autox/utils/router-dsl'`
{identity} = _
{computed: {apply}} = _x
{RSVP, Object, computed: {oneWay, alias}} = Ember

RelationField = Object.extend FieldCore, FieldSelect,
  proxyKey: apply "meta.options.proxyKey", (key) -> key ? "id"

`export default RelationField`
