`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-field'`
`import UserCustomize from '../mixins/user-customize'`

AutoxShowFieldComponent = Ember.Component.extend UserCustomize,
  customPrefix: "show-for-field"
  layout: layout
  classNames: ["autox-show-field"]
  classNameBindings: ["userHasDefinedComponent::list-group-item"]

`export default AutoxShowFieldComponent`
