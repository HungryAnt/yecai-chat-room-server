class ShitMineDao < DaoBase
  def decrease_shit_mine(user_id)
    execute do |conn|
      sql = 'UPDATE v1_shit_mines SET mine_count = mine_count - 1 WHERE user_id = ? AND mine_count > 0'
      stmt = conn.prepare sql
      stmt.execute user_id
    end
  end
end