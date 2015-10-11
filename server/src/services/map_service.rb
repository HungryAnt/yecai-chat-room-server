class MapService
  def initialize
    @area_dict = {}
  end

  def add_area(area)
    @area_dict[area.id] = area
  end

  def get_area(id)
    @area_dict[id]
  end

  def get_all_areas
    @area_dict.values
  end

  def get_village_areas
    @area_dict.values.find_all {|area| area.area_type == :village}
  end

  def get_map_area_ids(map_id)
    area_ids = []
    get_all_areas.each do |area|
      if area.map_id == map_id
        area_ids << area.id
      end
    end
    area_ids
  end
end

lambda do
  @map_service = get_instance(MapService)

  def create_area(area_id, map_id, tiles_text, area_type=:default)
    @map_service.add_area Area.new(area_id, map_id, tiles_text, area_type)
  end

  search_pattern = File.join(File.dirname(__FILE__), 'area/*.rb')
  LogUtil.info search_pattern

  Dir.glob(search_pattern).each do |file|
    LogUtil.info file
    require file
  end

end.call