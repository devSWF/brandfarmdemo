// combine separate export files
// import export files
const sendToField = require("./send-to-field.js");
const sendToFarm = require("./send-to-farm.js");

exports.sendToField = sendToField.pushNotification;
exports.sendToFarm = sendToFarm.pushNotification;