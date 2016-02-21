`import Ember from 'ember'`
`import FieldFoundation from '../mixins/field-foundation'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`
`import {RouteData} from 'autox/utils/router-dsl'`
{identity} = _
{computed: {apply}} = _x
{RSVP, Object, computed: {oneWay, alias}} = Ember

RelationField = Object.extend FieldFoundation,
  proxyKey: apply "meta.options.proxyKey", (key) -> key ? "id"

`export default RelationField`
