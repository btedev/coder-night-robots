class Destroyer
  # Adds a laser in a given position to a bitmap
  def add_laser(bitmap, position)
    bitmap | (2 ** position)
  end

  # Is a laser in a given position in a bitmap?
  def has_laser?(bitmap, position)
    bitmap & (2 ** position) != 0
  end
end

