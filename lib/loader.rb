response = Net::HTTP.get(URI('http://ddragon.leagueoflegends.com/cdn/12.22.1/data/en_US/champion.json'))
parsed = JSON.parse(response)
champion_names = parsed['data'].keys

champion_names.each do |name|
  response = Net::HTTP.get(URI("http://ddragon.leagueoflegends.com/cdn/12.22.1/data/en_US/champion/#{name}.json"))
  parsed = JSON.parse(response)
  real_name = parsed['data'][name]['name']
  spells = parsed['data'][name]['spells']

  spells.each.with_index do |spell, i|
    Spell.where(name: spell['name']).update(
      champion: real_name,
      name: spell['name'],
      cooldown: spell['cooldown'].join('/'),
      cost: spell['cost'].join('/'),
      key: ['Q', 'W', 'E', 'R'][i]
    )
  end
end
