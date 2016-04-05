import Ember from 'ember';
import ApplicationAdapter from './adapters/application';
import RelationshipAdapter from './adapters/relationship';
import RelateableMixin from './mixins/relateable';
import HistoricalMixin from './mixins/historical';
import Paranoia from './mixins/paranoia';
import Timestamps from './mixins/timestamps';
import Realtime from './mixins/realtime';
import Multiaction from './mixins/action-multicast';
import RelationshipModel from './models/relationship';
import RelationshipSerializer from './serializers/relationship';
import Payload from './utils/payload';
import SessionStateMixin from './mixins/session-state';
import CookieCredentialsMixin from './mixins/cookie-credentials';
import QueryUtils from './utils/query';
import virtual from './utils/virtual';
import action from './utils/action';
import about from './utils/about';
import FSE from './utils/field-schema-engine';
import _x from './utils/xdash';
import {RouteData, DSL} from './utils/router-dsl';
import Importance from './utils/importance';
const Mixins = {
  Paranoia,
  Timestamps,
  Realtime,
  Multiaction,
  Relateable: RelateableMixin,
  Historical: HistoricalMixin
};
const VERSION = "0.2.1";
const computed = _x.computed;
if (Ember.libraries) {
  Ember.libraries.register("AutoX", VERSION);
}
export {
  VERSION,
  ApplicationAdapter,
  RelationshipAdapter,
  RouteData,
  DSL,
  Mixins,
  RelateableMixin,
  HistoricalMixin,
  RelationshipModel,
  RelationshipSerializer,
  Payload,
  Importance,
  SessionStateMixin,
  CookieCredentialsMixin,
  QueryUtils,
  FSE,
  about,
  action,
  virtual,
  _x,
  computed
};