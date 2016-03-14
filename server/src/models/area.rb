class Area
  GRID_WIDTH = 10
  GRID_HEIGHT = 10

  attr_reader :id, :map_id, :area_type

  def initialize(id, map_id, tiles_text, area_type)
    @id = id
    @map_id = map_id
    @area_type = area_type
    init_tails tiles_text.lines.map {|line|line.chomp}
    init_available_location
    init_large_available_location
  end

  def random_available_location
    @available_locations[rand @available_locations.size]
  end

  def random_large_available_location
    @large_available_locations[rand @large_available_locations.size]
  end

  def random_large_available_position
    row, col = random_large_available_location
    Area.get_position row, col
  end

  def self.get_position(row, col)
    [GRID_WIDTH * col + GRID_WIDTH / 2,
     GRID_HEIGHT * row + GRID_HEIGHT / 2]
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

  def init_large_available_location
    edge_grid_count = 15
    @large_available_locations = []
    edge_grid_count.upto(@row_count-1-edge_grid_count) do |row|
      edge_grid_count.upto(@col_count-1-edge_grid_count) do |col|
        if @tiles[row][col] == ' ' || @tiles[row][col] == 'X'
          @large_available_locations << [row, col]
        end
      end
    end
  end
end