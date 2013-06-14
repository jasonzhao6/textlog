SETTER_PLACEHOLDERS = { 
  set_activity: '{ activity: <activity> }',
  add_friend: '{ name: <name>, fb_id: <fb_id> }',
  add_duration: '{ duration: <duration>, unit: <unit> }',
  set_distance: '{ distance: <distance>, unit: <unit> }',
  set_reps: '{ reps: <reps> }',
  set_note: '{ note: <note> }',
  nil => 'string, hash, or leave blank for regex match data',
}.with_indifferent_access

SETTER_ICONS = {
  set_activity: 'flag',
  add_friend: 'user',
  add_duration: 'time',
  set_distance: 'road',
  set_reps: 'repeat',
  set_note: 'comment',
}.with_indifferent_access