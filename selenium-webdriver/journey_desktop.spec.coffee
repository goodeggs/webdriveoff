require './setup'

scenario 'shopping for multiple days', ->
  @timeout 30000

  given 'the shopping site on a large screen', ->
    before ->
      @site = new (require './shopping_site')
      @site.start()

    after ->
      @site.stop()

    it 'allows a user to add veggies to their basket for separate days', ->
      @site.loadMarket()

      # add product on 1/22
      @site.filterByDeliveryDay 'Thu 1/22'
      @site.quickAddProduct 'Organic Cocktail Grapefruit'
      @site.filterByDeliveryDay 'Thu 1/22' # un-click the filter

      # add product on 1/23
      @site.filterByDeliveryDay 'Fri 1/23'
      @site.quickAddProduct 'Organic Brussels Sprouts'

    it 'displays two separate fulfillments on the basket page', ->
      @site.openBasket()
      @site.expect('.fulfillments .fulfillment').to.have.count 2
