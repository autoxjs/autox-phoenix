`import Ember from 'ember'`
`import DS from 'ember-data'`
`import moment from 'moment'`
`import {_computed} from 'ember-autox-core/utils/xdash'`
`import Importance from 'ember-annotative-models/utils/importance'`

{apply} = _computed
RealtimeMixin = Ember.Mixin.create
  goliveAt: DS.attr "moment",
    priority: Importance.CantStand
    label: "Time of Live Arrival"
    description: "The UTC date time when this object is scheduled to go live on-site"
    display: ["show", "index"]
    modify: ["edit", "new"]
    defaultValue: -> moment()
  unliveAt: DS.attr "moment",
    priority: Importance.CantStand
    label: "Time of Completion"
    description: "The UTC date time when this object completes its live onsite work"
    display: ["show"]
    modify: ["edit"]

  isOnsiteLive: apply "goliveAt", "unliveAt", (start, finish) ->
    start < moment() < (finish ? moment().add(2, "hours"))

`export default RealtimeMixin`
