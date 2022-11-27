response = Net::HTTP.get(URI('http://ddragon.leagueoflegends.com/cdn/12.22.1/data/en_US/champion.json'))
parsed = JSON.parse(response)
champion_names = parsed['data'].keys

champion_names.each do |name|
  response = Net::HTTP.get(URI("http://ddragon.leagueoflegends.com/cdn/12.22.1/data/en_US/champion/#{name}.json"))
  parsed = JSON.parse(response)
  spells = parsed['data'][name]['spells']

  spells.each.with_index do |spell, i|
    Spell.create(
      champion: name,
      name: spell['name'],
      cooldown: spell['cooldown'],
      cost: spell['cost'],
      key: ['Q', 'W', 'E', 'R'][i]
    )
  end
end
