// combine separate export files
// import export files
const sendToField = require("./send-to-field.js");
const sendToFarm = require("./send-to-farm.js");
const sendToOffice = require("./send-to-office.js");

exports.sendToField = sendToField.pushNotification;
exports.sendToFarm = sendToFarm.pushNotification;
exports.sendToOffice = sendToOffice.pushNotification;