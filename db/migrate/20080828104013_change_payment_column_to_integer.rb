class ChangePaymentColumnToInteger < ActiveRecord::Migration
  def change
    change_column :favors, :payment, 'integer USING CAST(payment AS integer)'
  end
end
