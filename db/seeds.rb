# TODO when there are conflicting rules, eg 'scott' use to match Person A, but now there is a new Person B, show both matches ordered by recentness.
# Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.

Rule.delete_all
r1 = Rule.create(matcher_id: nil, command: 'match', arg: 'biked (?<objective>[\w\s]+?)(with|in|\.)')
  r11 = Rule.create(matcher_id: r1.id, command: 'set_name', arg: 'Biking')
  r12 = Rule.create(matcher_id: r1.id, command: 'set_category', arg: 'Fitness')
  r13 = Rule.create(matcher_id: r1.id, command: 'set_objective', arg: nil)
r2 = Rule.create(matcher_id: nil, command: 'match', arg: '(scott)[,\.]')
  r21 = Rule.create(matcher_id: r2.id, command: 'add_friend', arg: { name: 'Scott Levy', fb_id: 'ScottBLevy' })
r3 = Rule.create(matcher_id: nil, command: 'match', arg: '(alan)[,\.]')
  r31 = Rule.create(matcher_id: r3.id, command: 'add_friend', arg: { name: 'Alan Fineberg', fb_id: 'fineberg' })
r4 = Rule.create(matcher_id: nil, command: 'match', arg: '(mary ann)[,\.]')
  r41 = Rule.create(matcher_id: r4.id, command: 'add_friend', arg: { name: 'Mary Ann Jawili', fb_id: 'mjawili' })
r5 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<num>\d+) ?(?<unit>hr)')
  r51 = Rule.create(matcher_id: r5.id, command: 'add_time', arg: nil)
r6 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<num>\d+) ?(?<unit>min)')
  r61 = Rule.create(matcher_id: r6.id, command: 'add_time', arg: nil)
r7 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<experience>felt [\w\s]+)\.')
  r71 = Rule.create(matcher_id: r7.id, command: 'set_experience', arg: nil)
r_ = Rule.create(matcher_id: nil, command: 'match', arg: '_')
