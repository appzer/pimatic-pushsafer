# #Pushsafer Plugin

# This is an plugin to send push notifications via pushsafer

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an environment object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  util = env.require 'util'
  M = env.matcher
  # Require the [pushsafer-notifications](https://github.com/appzer/nodeJS-pushsafer) library
  Pushsafer = require 'pushsafer-notifications'
  Promise.promisifyAll(Pushsafer.prototype)

  pushsaferService = null

  # ###Pushsafer class
  class PushsaferPlugin extends env.plugins.Plugin

    # ####init()
    init: (app, @framework, config) =>
      
      privatekey = config.privatekey
      env.logger.debug "pushsafer: privatekey = #{privatekey}"

      pushsaferService = new Pushsafer( {
        k: privatekey,
        onerror: (message) => env.logger.error("pushsafer error: #{message}")
      })
      
      @framework.ruleManager.addActionProvider(new PushsaferActionProvider @framework, config)
  
  # Create a instance of my plugin
  plugin = new PushsaferPlugin()

  class PushsaferActionProvider extends env.actions.ActionProvider
  
    constructor: (@framework, @config) ->
      return

    parseAction: (input, context) =>

      defaultTitle = @config.title
      defaultMessage = @config.message
      defaultSound = @config.sound
      defaultIcon = @config.icon
      defaultVibration = @config.vibration
      defaultURL = @config.url
      defaultURLTitle = @config.urltitle
      defaultTime2Live = @config.time2live
      defaultDevice = @config.device
      
      # Helper to convert 'some text' to [ '"some text"' ]
      strToTokens = (str) => ["\"#{str}\""]

      titleTokens = strToTokens defaultTitle
      messageTokens = strToTokens defaultMessage
      sound = defaultSound
      icon = defaultIcon
      vibration = defaultVibration
      url = defaultURL
      urltitle = defaultURLTitle
      time2live = defaultTime2Live
      device = defaultDevice

      setTitle = (m, tokens) => titleTokens = tokens
      setMessage = (m, tokens) => messageTokens = tokens
      setDevice = (m, d) => device = d
      setSound = (m, d) => sound = d
      setIcon = (m, d) => icon = d
      setVibration = (m, d) => vibration = d
      setURL = (m, d) => url = d
      setURLTitle = (m, d) => urltitle = d
      setTime2Live = (m, d) => time2live = d

      m = M(input, context)
        .match('send ', optional: yes)
        .match(['push','pushsafer','notification'])

      next = m.match(' title:').matchStringWithVars(setTitle)
      if next.hadMatch() then m = next

      next = m.match(' message:').matchStringWithVars(setMessage)
      if next.hadMatch() then m = next

      next = m.match(' device:').matchString(setDevice)
      if next.hadMatch() then m = next

      next = m.match(' sound:').matchString(setSound)
      if next.hadMatch() then m = next

      next = m.match(' icon:').matchString(setIcon)
      if next.hadMatch() then m = next

      next = m.match(' vibration:').matchString(setVibration)
      if next.hadMatch() then m = next

      next = m.match(' url:').matchString(setURL)
      if next.hadMatch() then m = next

      next = m.match(' urltitle:').matchString(setURLTitle)
      if next.hadMatch() then m = next

      next = m.match(' time2live:').matchString(setTime2Live)
      if next.hadMatch() then m = next	  

      if m.hadMatch()
        match = m.getFullMatch()

        assert Array.isArray(titleTokens)
        assert Array.isArray(messageTokens)

        return {
          privatekey: match
          nextInput: input.substring(match.length)
          actionHandler: new PushsaferActionHandler(
            @framework, titleTokens, messageTokens, sound, device, icon, vibration, url, urltitle, time2live
          )
        }
            

  class PushsaferActionHandler extends env.actions.ActionHandler 

    constructor: (@framework, @titleTokens, @messageTokens, @sound, @device, @icon, @vibration, @url, @urltitle, @time2live) ->

    executeAction: (simulate, context) ->
      Promise.all( [
        @framework.variableManager.evaluateStringExpression(@titleTokens)
        @framework.variableManager.evaluateStringExpression(@messageTokens)
      ]).then( ([title, message]) =>
        if simulate
          # just return a promise fulfilled with a description about what we would do.
          return __("would push message \"%s\" with title \"%s\"", message, title)
        else
          
            msg = {
                m: message
                t: title
                s: @sound
                v: @vibration
                i: @icon
                d: @device
                u: @url
                ut: @urltitle
                l: @time2live
            }

          msg.d = @d if @d? and @d.length > 0

          return pushsaferService.sendAsync(msg).then( => 
            __("pushsafer message sent successfully") 
          )
      )

  module.exports.PushsaferActionHandler = PushsaferActionHandler

  # and return it to the framework.
  return plugin   
