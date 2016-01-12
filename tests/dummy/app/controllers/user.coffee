`import Ember from 'ember'`

UserController = Ember.Controller.extend
  session: Ember.inject.service("session")

`export default UserController`