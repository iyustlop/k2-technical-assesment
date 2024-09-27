function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: "https://reqres.in/api"
  }
  if (env == 'dev') {

  } else if (env == 'e2e') {

  }
  return config;
}