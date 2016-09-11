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
    vibration: #might be overwritten by predicate
      description: "Vibration for the notification, see https://www.pushsafer.com/en/pushapi"
      type: "string"
      default: ""
    device: #might be overwritten by predicate
      description: "device or device group id to send the notification to"
      type: "string"
      default: ""
}
