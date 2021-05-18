// combine separate export files
// import export files
const sendToField = require("./send-to-field");
const sendToFarm = require("./send-to-farm");

exports.sendToField = sendToField.pushNotification;
exports.sendToFarm = sendToFarm.pushNotification;