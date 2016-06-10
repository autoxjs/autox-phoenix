`import Ember from 'ember'`
`import ChanCore from 'autox-phoenix/mixins/chan-core'`
{Service, Evented} = Ember

ChannelService = Service.extend Evented, ChanCore, {}

`export default ChannelService`
