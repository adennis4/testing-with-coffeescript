describe 'Basket', ->
  test = {}
  beforeEach ->
    test.basket = new Basket()
    test.item = new Item 1, 'Macbook Air', 'Newer', 799
    test.item2 = new Item 2, 'Magic Trackpad', 'Better', 50
    test.basket.add test.item2, 1

  describe 'adding items', ->      
    it 'adds a new item to basket', ->
      priorCountVal = test.basket.distinctCount
      test.basket.add(test.item, 1)
      expect(test.basket.distinctCount).toEqual priorCountVal + 1

    it 'updates quantity when adding an item already in the basket', ->
      test.basket.add(test.item, 1)
      priorCountVal = test.basket.getQuantity(1)
      test.basket.add(test.item, 1)
      expect(test.basket.getQuantity(1)).toEqual priorCountVal + 1

    it 'updates total count by 1 when adding a brand new item', ->
      priorCountVal = test.basket.totalCount
      test.basket.add(test.item, 1)
      expect(test.basket.totalCount).toEqual priorCountVal + 1

    it 'increases total count by 1 when adding to existing item', ->
      test.basket.add(test.item, 1)
      priorCountVal = test.basket.totalCount
      test.basket.add(test.item, 1)
      expect(test.basket.totalCount).toEqual priorCountVal + 1

    it 'updates distinctCount when adding brand new item', ->
      priorCountVal = test.basket.distinctCount
      test.basket.add(test.item, 1)
      expect(test.basket.distinctCount).toEqual priorCountVal + 1

    it 'does not update distinctCount when adding to an existing item', ->
      test.basket.add(test.item, 1)
      priorCountVal = test.basket.distinctCount
      test.basket.add(test.item, 2)
      expect(test.basket.distinctCount).toEqual priorCountVal


  describe 'helper functions in the Basket class', ->
    describe 'getQuantity', ->
      it 'should return false if passed an id that is not an array', ->
        expect(test.basket.getQuantity(12345)).toBeFalsy()

      it 'returns false if passed an invalid argument', ->
        expect(test.basket.getQuantity("hello")).toBeFalsy()

      it 'returns the quantity if given a valid id', ->
        expect(test.basket.getQuantity(2)).toEqual 1

    describe 'itemExistsinBasket', ->
      it 'returns false if item id does not exist', ->
        expect(test.basket.itemExistsInBasket(2343)).toBeFalsy()

      it 'returns true if item id does exist', ->
        expect(test.basket.itemExistsInBasket(2)).toBeTruthy()

      it 'returns false if given an invalid argument', ->
        expect(test.basket.itemExistsInBasket("hello")).toBeFalsy()

    describe 'getItemLocation', ->
      it 'returns the location of item with a valid id', ->
        expect(test.basket.getItemLocation(2)).toEqual 0

      it 'returns false if given an invalid input', ->
        expect(test.basket.getItemLocation("hello")).toBeFalsy()

    describe 'calculating total cost', ->
      it 'calculates cost for a single item in the basket', ->
        expect(test.basket.calculateTotal()).toEqual 50

      it 'calculates cost for 1 item with multiple quantities', ->
        test.basket.add(test.item2, 3)
        expect(test.basket.calculateTotal()).toEqual 200

      it 'calculates cost for multiple items with many quantities', ->
        test.basket.add(test.item2, 3)
        test.basket.add(test.item, 4)
        expect(test.basket.calculateTotal()).toEqual 3396

    describe 'removing items', ->
      it 'should return false if item does not exist to remove', ->
        expect(test.basket.remove(39)).toBeFalsy()

      it 'removes a specific quantity with a second parameter', ->
        test.basket.add(test.item, 5)
        prevCountVal = test.basket.getQuantity(1)
        test.basket.remove(1, 1)
        expect(test.basket.getQuantity(1)).toEqual 4

      it 'removes all items if not given a 2nd parameter', ->
        test.basket.add(test.item, 5)
        test.basket.remove(1)
        expect(test.basket.getQuantity(1)).toBeFalsy()

    describe 'discounting the basket', ->
      beforeEach ->
        @addMatchers
          toBeDiscounted: (orig, discount) ->
            actual = @actual
            @message = -> "Expected #{actual} to be #{discount}% of #{orig}"
            actual is (orig * (1-(discount/100)))

      it 'applies discounts', ->
        expect(test.basket.applyDiscount(10)).toEqual 45
        expect(test.basket.applyDiscount(50)).toEqual 25

      it 'will not apply discount larger than 100%', ->
        expect(test.basket.applyDiscount(120)).toEqual 0

      it 'treats negative numbers as positive', ->
        expect(test.basket.applyDiscount(-20)).toEqual 40

      it 'has a persistent discount', ->
        expect(test.basket.applyDiscount(10)).toBeDiscounted(50, 10)
        expect(test.basket.calculateTotal()).toEqual 45

  describe 'getting ratings from websites', ->
    it 'returns three latest ratings', ->
      expect(test.item.getRatings().ratings.length).toEqual 3

    it 'parses an individual ratings score', _.
      expect(test.item.getRatings().ratings[0].rating).toEqual 4




