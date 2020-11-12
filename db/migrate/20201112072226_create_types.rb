class CreateTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :types do |t|
      t.string :title
      t.string :color

      t.timestamps
    end
  end
end