require 'goodeggs-spec-helpers/node_helper'
wd = require 'wd'
asPromised = require 'chai-as-promised'

asPromised.transferPromiseness = wd.transferPromiseness

global.expect = chai
  .use asPromised
  .expect

before ->
  @browser = wd.promiseChainRemote()

before ->
  @timeout 20000
  selenium = require 'selenium-standalone'
  tcpPort = require 'tcp-port-used'
  server = selenium()

  ((done) ->
    tcpPort.waitUntilUsed(4444, 500, 20000).then -> done()
  ).sync()

  @browser
    .init
      browserName: 'chrome'
    .configureHttp
      baseUrl: 'https://www.huevosbuenos.com'
    .sync.nodeify()

after ->
  @browser.sync.quit()
