class Area
  attr_reader :id, :map_id

  def initialize(id, map_id, tiles_text)
    @id = id
    @map_id = map_id
    init_tails tiles_text.lines.map {|line|line.chomp}
    init_available_location
  end

  def random_available_location
    @available_locations[rand @available_locations.size]
  end

  private

  def init_tails(lines)
    @row_count = lines.size
    @col_count = lines[0].size
    @tiles = Array.new(@row_count) do |row|
      Array.new(@col_count) do |col|
        lines[row][col, 1]
      end
    end
    LogUtil.info "area row_count #{@row_count} col_count #{@col_count}"
  end

  def init_available_location
    # 记录所有有效位置
    @available_locations = []

    0.upto(@row_count-1) do |row|
      0.upto(@col_count-1) do |col|
        if @tiles[row][col] == ' ' || @tiles[row][col] == 'X'
          @available_locations << [row, col]
        end
      end
    end
  end
end