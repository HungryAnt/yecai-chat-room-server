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
    @locations_cache = {}
  end

  def random_available_location
    @available_locations[rand @available_locations.size]
  end

  def random_large_available_location
    @large_available_locations[rand @large_available_locations.size]
  end

  # 以origin为原点，取地周边一定范围内随机的一个可移动方格位置
  def random_large_available_location_with_origin(origin_row, origin_col)
    key = "#{origin_row}_#{origin_col}"
    blank_locations = @locations_cache[key]
    if blank_locations.nil?
      min_col = [origin_col - 50, 0].max
      max_col = [origin_col + 50, @col_count - 1].min
      min_row = [origin_row - 30, 0].max
      max_row = [origin_row + 30, @row_count - 1].min

      blank_locations = []
      min_col.upto(max_col) do |col|
        min_row.upto(max_row) do |row|
          if is_blank_tile?(row, col)
            blank_locations << [row, col]
          end
        end
      end
      @locations_cache[key] = blank_locations
    end

    blank_locations[rand blank_locations.size]
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
        if is_blank_tile? row, col
          @large_available_locations << [row, col]
        end
      end
    end
  end

  def is_blank_tile?(row, col)
    @tiles[row][col] == ' ' || @tiles[row][col] == 'X'
  end
end