module.exports = {
  title: "Pushsafer.com config options"
  type: "object"
  required: ["privatekey"]
  properties: 
    privatekey:
      description: "Pushsafer private key"
      type: "string"
      default: ""
      required: yes
    title: #might be overwritten by predicate
      description: "Title for the notification"
      type: "string"
      default: ""
    message: #might be overwritten by predicate
      description: "Message for the notification"
      type: "string"
      default: ""
    sound: #might be overwritten by predicate
      description: "Sound for the notification, see https://www.pushsafer.com/en/pushapi"
      type: "string"
      default: "0"
    icon: #might be overwritten by predicate
      description: "Icon for the notification, see https://www.pushsafer.com/en/pushapi"
      type: "string"
      default: "1"
    iconcolor: #might be overwritten by predicate
      description: "Icon Color, leave empty as default or a Hexadecimal Colorcode, Example: #FF0000"
      type: "string"
      default: ""  
    vibration: #might be overwritten by predicate
      description: "Vibration for the notification, see https://www.pushsafer.com/en/pushapi"
      type: "string"
      default: ""
    url: #might be overwritten by predicate
      description: "An URL or URL Scheme see https://www.pushsafer.com/en/url_schemes"
      type: "string"
      default: ""
    urltitle: #might be overwritten by predicate
      description: "The URLs title"
      type: "string"
      default: ""
    time2live: #might be overwritten by predicate
      description: "Integer number 0-43200: Time in minutes, after which message automatically gets purged."
      type: "string"
      default: ""
    priority: #might be overwritten by predicate
        description: "Integer number -2, -1, 0, 1, 2"
        type: "string"
        default: ""  
    retry: #might be overwritten by predicate
        description: "Integer number 60-10800: Time in seconds, after the message is resend."
        type: "string"
        default: ""  
    expire: #might be overwritten by predicate
        description: "Integer number 60-10800: Time in seconds, after retry is canceling."
        type: "string"
        default: ""  
    confirm: #might be overwritten by predicate
        description: "Integer number 10-10800: Time in seconds, after the message is resend until it is confirmed."
        type: "string"
        default: ""  
    answer: #might be overwritten by predicate
        description: "Integer number 1 = answer is possible or 0 = answer is not possible."
        type: "string"
        default: ""
    answeroptions: #might be overwritten by predicate
        description: "specify predefined answer options divided by a pipe character, e.g. Yes|No|Maybe"
        type: "string"
        default: ""
    answerforce: #might be overwritten by predicate
        description: "Integer number 1 = forca answer or 0 = do not force answer."
        type: "string"
        default: ""
    device: #might be overwritten by predicate
      description: "device or device group id to send the notification to"
      type: "string"
      default: ""
}
