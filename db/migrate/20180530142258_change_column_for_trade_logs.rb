class ChangeColumnForTradeLogs < ActiveRecord::Migration
  def change
    change_column :trade_logs, :tradeable_id, :string
  end
end
