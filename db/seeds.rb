# Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.

Rule.delete_all

r0 = Rule.create(matcher_id: nil, command: 'match', arg: 'butterlap')
  r01 = Rule.create(matcher_id: r0.id, command: 'set_activity', arg: { activity: 'Error' })
  
r1 = Rule.create(matcher_id: nil, command: 'match', arg: 'butterlap')
  r11 = Rule.create(matcher_id: r1.id, command: 'set_activity', arg: { activity: 'Butterlap' })
  r12 = Rule.create(matcher_id: r1.id, command: 'set_distance', arg: { distance: '17.4', unit: 'mi' })
r2 = Rule.create(matcher_id: nil, command: 'match', arg: '(scott)[,\.]')
  r21 = Rule.create(matcher_id: r2.id, command: 'add_friend', arg: { name: 'Scott Levy', fb_id: 'ScottBLevy' })
r3 = Rule.create(matcher_id: nil, command: 'match', arg: '(alan)[,\.]')
  r31 = Rule.create(matcher_id: r3.id, command: 'add_friend', arg: { name: 'Alan Fineberg', fb_id: 'fineberg' })
r4 = Rule.create(matcher_id: nil, command: 'match', arg: '(mary ann)[,\.]')
  r41 = Rule.create(matcher_id: r4.id, command: 'add_friend', arg: { name: 'Mary Ann Jawili', fb_id: 'mjawili' })
r5 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<duration>\d+) ?(?<unit>hr)')
  r51 = Rule.create(matcher_id: r5.id, command: 'add_duration', arg: nil)
r6 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<duration>\d+) ?(?<unit>min)')
  r61 = Rule.create(matcher_id: r6.id, command: 'add_duration', arg: nil)
r7 = Rule.create(matcher_id: nil, command: 'match', arg: '(?<note>felt.*)\.')
  r71 = Rule.create(matcher_id: r7.id, command: 'set_note', arg: nil)
