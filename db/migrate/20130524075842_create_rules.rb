class CreateRules < ActiveRecord::Migration
  def change
    # when parsing, start with top of decision tree, i.e. rule without rule_id
    # then trickle down decision tree depth-first
    # TODO: rules downloadable as seed file, included in rspec
    # http://stackoverflow.com/questions/8386604/auto-load-the-seed-data-from-db-seeds-rb-with-rake
    create_table :rules do |t|
      t.timestamps
      t.integer :parent_id # link to parent rule, think decision tree
      t.string :command # . means subject is message, # means activity
      t.string :args # serialized json
      # Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Engaged.
      # Biked Butterlap in 1 hr 30 min. Engaged.
      # Biked Butterlap. Engaged.
      # ex.
      # command: ".split", { by: "." } return array of trimmed segments
      #   GROUP: name, category, accomplishment
      #   command: ".=~", { pattern: "^Biked" } return [n..-1]
      #     command: "#name=", { name: "Biking" } store string
      #     command: "#category=", { category: "Workout" } store string
      #     command: ".match", { pattern: '^[\w\s]+' } return match
      #       command: ".=~", { pattern: " (with|in) ", backspace: true } return [0...n]
      #         command: "#accomplishment", { accomplishment: "Butterlap" } store match
      #   GROUP: company
      #   command: ".=~", { pattern: "with" } return [n..-1]
      #     command: ".=~", { pattern: "Scott" } return [n..-1]
      #       command: "#company+=", { name: "Scott Levy", fb_id: "###" } find or create friend and company, then store company_id
      #   GROUP: duration
      #   command: ".match", { pattern: "(\d+) ?(day|days)" } return match
      #     command: "#duration+=", { duration: "1 day" } parse and add as seconds
      #   GROUP: duration
      #   command: ".match", { pattern: "(\d+) ?(hr|hrs|hour|hours)" } return match
      #     command: "#duration+=", { duration: "1 hr" } parse and add as seconds
      #   GROUP: duration
      #   command: ".match", { pattern: "(\d+) ?(min|mins|minute|minutes)" } return match
      #     command: "#duration+=", { duration: "1 min" } parse and add as seconds
      #   GROUP: mood
      #   command: ".match", { pattern: "(^|\. ?)[a-z]+\." } return match
      #     command: "#mood=", { mood: ". Engaged." } strip and store match
    end
  end
end
