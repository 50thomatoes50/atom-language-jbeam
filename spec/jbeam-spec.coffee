describe "JBEAM grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('atom-language-jbeam')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.jbeam')

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.jbeam'

  it "tokenizes arrays", ->
    baseScopes = ['source.jbeam', 'meta.structure.array.jbeam']
    numericScopes = [baseScopes..., 'constant.numeric.jbeam']
    separatorScopes = [baseScopes..., 'punctuation.separator.array.jbeam']

    {tokens} = grammar.tokenizeLine('[1, 2, 3]')
    expect(tokens[0]).toEqual value: '[', scopes: [baseScopes..., 'punctuation.definition.array.begin.jbeam']
    expect(tokens[1]).toEqual value: '1', scopes: numericScopes
    expect(tokens[2]).toEqual value: ',', scopes: separatorScopes
    expect(tokens[3]).toEqual value: ' ', scopes: [baseScopes...]
    expect(tokens[4]).toEqual value: '2', scopes: numericScopes
    expect(tokens[5]).toEqual value: ',', scopes: separatorScopes
    expect(tokens[6]).toEqual value: ' ', scopes: [baseScopes...]
    expect(tokens[7]).toEqual value: '3', scopes: numericScopes
    expect(tokens[8]).toEqual value: ']', scopes: [baseScopes..., 'punctuation.definition.array.end.jbeam']

  it "tokenizes objects", ->
    baseScopes = ['source.jbeam', 'meta.structure.dictionary.jbeam']
    keyScopes = [baseScopes..., 'string.quoted.double.jbeam']
    keyBeginScopes = [keyScopes..., 'punctuation.definition.string.begin.jbeam']
    keyEndScopes = [keyScopes..., 'punctuation.definition.string.end.jbeam']
    valueScopes = [baseScopes..., 'meta.structure.dictionary.value.jbeam']
    keyValueSeparatorScopes = [valueScopes..., 'punctuation.separator.dictionary.key-value.jbeam']
    pairSeparatorScopes = [valueScopes..., 'punctuation.separator.dictionary.pair.jbeam']
    stringValueScopes = [valueScopes..., 'string.quoted.double.jbeam']

    {tokens} = grammar.tokenizeLine('{"a": 1, "b": true, "foo": "bar"}')
    expect(tokens[0]).toEqual value: '{', scopes: [baseScopes..., 'punctuation.definition.dictionary.begin.jbeam']
    expect(tokens[1]).toEqual value: '"', scopes: keyBeginScopes
    expect(tokens[2]).toEqual value: 'a', scopes: keyScopes
    expect(tokens[3]).toEqual value: '"', scopes: keyEndScopes
    expect(tokens[4]).toEqual value: ':', scopes: keyValueSeparatorScopes
    expect(tokens[5]).toEqual value: ' ', scopes: valueScopes
    expect(tokens[6]).toEqual value: '1', scopes: [valueScopes..., 'constant.numeric.jbeam']
    expect(tokens[7]).toEqual value: ',', scopes: pairSeparatorScopes
    expect(tokens[8]).toEqual value: ' ', scopes: baseScopes
    expect(tokens[9]).toEqual value: '"', scopes: keyBeginScopes
    expect(tokens[10]).toEqual value: 'b', scopes: keyScopes
    expect(tokens[11]).toEqual value: '"', scopes: keyEndScopes
    expect(tokens[12]).toEqual value: ':', scopes: keyValueSeparatorScopes
    expect(tokens[13]).toEqual value: ' ', scopes: valueScopes
    expect(tokens[14]).toEqual value: 'true', scopes: [valueScopes..., 'constant.language.jbeam']
    expect(tokens[15]).toEqual value: ',', scopes: pairSeparatorScopes
    expect(tokens[16]).toEqual value: ' ', scopes: baseScopes
    expect(tokens[17]).toEqual value: '"', scopes: keyBeginScopes
    expect(tokens[18]).toEqual value: 'foo', scopes: keyScopes
    expect(tokens[19]).toEqual value: '"', scopes: keyEndScopes
    expect(tokens[20]).toEqual value: ':', scopes: keyValueSeparatorScopes
    expect(tokens[21]).toEqual value: ' ', scopes: valueScopes
    expect(tokens[22]).toEqual value: '"', scopes: [stringValueScopes..., 'punctuation.definition.string.begin.jbeam']
    expect(tokens[23]).toEqual value: 'bar', scopes: stringValueScopes
    expect(tokens[24]).toEqual value: '"', scopes: [stringValueScopes..., 'punctuation.definition.string.end.jbeam']
    expect(tokens[25]).toEqual value: '}', scopes: [baseScopes..., 'punctuation.definition.dictionary.end.jbeam']
