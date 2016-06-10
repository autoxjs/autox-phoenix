import Ember from 'ember';
import ApplicationRoute from 'ember-simple-auth/mixins/application-route-mixin';
import DummyAppRoute from '../mixins/dummy-app-route';

export default Ember.Route.extend(ApplicationRoute, DummyAppRoute, {});
