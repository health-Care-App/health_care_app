//api url
const prodApiUrl = "https://go-server-852613489557.us-central1.run.app";
const devApiUrl = "http://localhost:8080";
const healthPath = "/health";
const sleepTimePath = "/sleepTime";
const messagePath = "/message";

//ws url
const wsPath = "ws://localhost:8080/ws";

//exception message
const healthScaleException = "health must be between 1 and 10";
const sleepTimeScaleEsception = "sleepTime must be between 1 and 10";
const idTokenException = "failed to get idToken";
const getHealthException = "failed to call health get api";
const postHealthException = "failed to call health post api";
const getMessageException = "failed to call message get api";
const getSleepTimeException = "failed to call sleepTime get api";
const postSleepTimeException = "failed to call sleepTime post api";

//api common headers
Map<String, String> headers = {'Content-Type': 'application/json'};

//datetime
const dateTimePattern = "yyyy-MM-ddTHH:mm:ss";
const defaultDayTerm = 7;
