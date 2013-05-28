class RenameArgsToArg < ActiveRecord::Migration
  def change
    rename_column :rules, :args, :arg
  end
end
