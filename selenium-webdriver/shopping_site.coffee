WebChauffeur = require 'web-chauffeur'
Q = require 'q'
chai = require 'chai'
chaiWebdriver = require 'chai-webdriver'

module.exports = class ShoppingSite
  constructor: ->
    @chauffeur = new WebChauffeur()

  start: ->
    Q.ninvoke(@chauffeur, 'start')
    .then =>
      @driver = @chauffeur.webdriver()
      chai.use chaiWebdriver @driver
      @driver.getWindowHandle()

  stop: ->
    @driver.quit()
    .then => Q.ninvoke(@chauffeur, 'stop')

  expect: (css) ->
    chai.expect(css).dom

  loadMarket: ->
    @driver.get 'http://www.goodeggs.dev:3000/sfbay/produce'
    @closeModal()

  closeModal: ->
    waitFn = =>
      # close modal, if open
      @driver.findElements(class: '.modal-background')
      .then (elements) ->
        if elements.length
          elements[0].click()
          return true

    onSuccess = -> # no-op, just move on
    onFailure = -> # no-op, we don't care if the modal's not there

    @driver.wait(waitFn, 2000, 'no modal found')
      .then onSuccess, onFailure

  filterByDeliveryDay: (day) ->
    @driver.findElement(linkText: day).click()
    @closeModal()

  quickAddProduct: (productName) ->
    @driver.findElement(js: "return $('a:contains(\"#{productName}\")').closest('.product-tile').find('.product-tile__quick-add-plus').get(0)").click()

  openBasket: ->
    @driver.executeScript('window.scrollTo(0,0)')
    @driver.findElement(partialLinkText: 'Basket').click()
