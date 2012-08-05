describe 'Item', ->
  test = {}
  beforeEach ->
    test.item = new Item 1, 'Magic', 'Super', 50

  describe 'updating an item', ->
    it 'updates only the properties passed to it', ->
      test.item.update
        'title': 'The Magic Mouse'
        'cost': 49.50
      expect(test.item.title).toEqual 'The Magic Mouse'
      expect(test.item.cost).toEqual 49.50
      expect(test.item.desc).toEqual 'Super'

    it 'updates ID property', ->
      test.item.update
        'title': 'The Magic Mouse'
        'id': 49
      expect(test.item.title).toEqual 'The Magic Mouse'
      expect(test.item.id).toEqual 1

  describe 'protected fields', ->
    it 'adds a new protected field to the array', ->
      priorCount = test.item.protectedFields.length
      test.item.addProtected 'desc'
      expect(test.item.protectedFields.length).toEqual priorCount + 1

    it 'protects teh ID field by default', ->
      expect(test.item.protectedFields).toContain('id')

    it 'stops the update method if the field is protected', ->
      test.item.addProtected 'desc'
      test.item.update
        'desc': 'new description'
      expect(test.item.desc).toEqual 'Super'

  describe 'isProtected()', ->
    it 'returns true if field is protected', ->
      expect(test.item.isProtected('id')).toBeTruthy()

    it 'returns false if field is not protected or does not exist', ->
      expect(test.item.isProtected('desc')).toBeFalsy()
      expect(test.item.isProtected('foo')).toBeFalsy()
