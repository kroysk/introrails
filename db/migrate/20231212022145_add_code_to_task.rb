class AddCodeToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :code, :string
  end
end
