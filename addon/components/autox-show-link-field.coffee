`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-field'`
`import UserCustomize from '../mixins/user-customize'`

AutoxShowLinkFieldComponent = Ember.LinkComponent.extend UserCustomize,
  customPrefix: "show-for-link-field"
  layout: layout
  classNames: ["autox-show-link-field"]
  classNameBindings: ["userHasDefinedComponent::list-group-item"]

AutoxShowLinkFieldComponent.reopenClass
  positionalParams: 'params'

`export default AutoxShowLinkFieldComponent`
