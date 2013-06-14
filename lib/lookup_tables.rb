SETTER_PLACEHOLDERS = { 
  set_activity: "{ activity: 'Biking' }",
  add_friend: "{ name: 'Lance Armstrong', fb_id: 'lancearmstrong' }",
  add_duration: "{ num: '54', unit: 'min' }",
  set_distance: "{ num: '17.4', 'unit: 'mi' }",
  set_reps: "{ reps: '12' }",
  set_note: "{ note: 'Felt engaged' }",
  nil => "string, hash, or leave blank for regex match data",
}.with_indifferent_access

SETTER_ICONS = {
  set_activity: 'flag',
  add_friend: 'user',
  add_duration: 'time',
  set_distance: 'road',
  set_reps: 'repeat',
  set_note: 'comment',
}.with_indifferent_access