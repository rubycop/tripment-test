class CreateProcedures < ActiveRecord::Migration[6.0]
  def change
    create_table :procedures do |t|
      t.string :name, unique: true, null: false
      t.timestamps
    end
  end
end
