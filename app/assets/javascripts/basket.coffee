class Basket
  constructor: ->
    @items = []
    @distinctCount = 0
    @totalCount = 0
    @discount = 0

  add: (item, quantity) ->
    if @itemExistsInBasket(item.id)
      currentItemLocation = @getItemLocation item.id
      @items[currentItemLocation].quantity += quantity
    else
      @items.push
        "item_id" : item.id,
        "quantity" : quantity,
        "item" : item

      @distinctCount++

    @totalCount += quantity

  getQuantity: (item_id) ->
    for i in @items
      return i.quantity if i.item_id is item_id
    false

  itemExistsInBasket: (item_id) ->
    for i in @items
      return true if i.item_id is item_id
    false

  getItemLocation: (item_id) ->
    count = 0
    for i in @items
      return count if i.item_id is item_id
      ++count
    false

  calculateTotal: () ->
    total = 0
    for i in @items
      total += i.item.cost * i.quantity
    (total - ((@discount/100)) * total)

  updateItems: ->
    newArr = []
    for i in @items
      unless i is null
        newArr.push i
    @items = newArr

  remove: (item_id, quantity="all") ->
    return false if not @itemExistsInBasket item_id

    removeAll = (item_id) =>
      i = @getItemLocation item_id
      @items.splice(i, i+1)

    removeQuantity = (quantity, item_loc) =>
      @items[item_loc].quantity -= quantity
    
    unless quantity is "all"
      loc = @getItemLocation item_id
      item = @items[loc]

      if item.quantity <= quantity
        removeAll item_id
      else
        removeQuantity quantity, loc
    else
      removeAll item_id

  applyDiscount: (amount) ->
    amount = Math.abs(amount)
    if amount > 100 then amount = 100
    @discount = amount
    @calculateTotal()

window.Basket = Basket