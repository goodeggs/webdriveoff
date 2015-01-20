require './spec_helper'

class BasketPage

  constructor: (@browser) ->

  load: fibrous ->
    @browser.get '/basket'

  isSplit: fibrous ->
    @browser
      .elementsByCss('.fulfillments .shopping-day')
      .sync.nodeify().length > 1


class ProductsPage

  constructor: (@browser) ->

  load: fibrous ->
    @browser.get '/sfbay/produce'

  root: ->
    @browser.elementByCss '.products-page'

  filterByDay: fibrous (day) ->
    @browser
      .elementByLinkText(day).click()
      .sync.nodeify()

  clearFilters: fibrous ->
    @browser
      .elementByCss('.filter .remove').click()
      .sync.nodeify()

  productTile: ->
    new ProductTile(@browser)

  basket: ->
    @browser.elementByCss('.basket-button')

class ProductTile

  constructor: (@browser) ->

  quickAdd: fibrous ->
    @browser
      .elementByCss('.js-product-tile__quick-add').click()
      .sync.nodeify()

describe 'a desktop shopper', ->

  before ->
    @productsPage = new ProductsPage(@browser)
    @basketPage = new BasketPage(@browser)

  it 'loads the produce section', ->
    @productsPage.sync.load()
    expect(@productsPage.root().isDisplayed())
      .to.eventually.be.ok
      .sync.nodeify()

  it 'filters by Thu 22nd', ->
    @productsPage.sync.filterByDay 'Thu 1/22'

  it 'quick adds product', ->
    @productsPage.productTile().sync.quickAdd()

  it 'filters by Fri', ->
    @productsPage.sync.clearFilters()
    @productsPage.sync.filterByDay 'Fri 1/23'

  it 'quick adds another product', ->
    @productsPage.productTile().sync.quickAdd()

  it 'looks at basket', ->
    @productsPage
      .basket().click()
      .sync.nodeify()

  it 'sees a split basket', ->
    expect(@basketPage.sync.isSplit()).to.be.ok
