class MagicSquare
  # Implement a method that takes a 2D array,
  # checks if it's a magic square and returns either true or false depending on the result.
  # sequence (https://en.wikipedia.org/wiki/Magic_square)
  def self.validate(square)
    # 1. Check if the 2d array is a square
    # Return false if the array is not 2d
    return false unless square.is_a?(Array) && square.all? { |row| row.is_a?(Array) }

    # Check if the row and column counts are equal
    row_count = square.size
    return false unless square.all? { |row| row.size == row_count }

    # 2. Check if all elements are distinct
    flat = square.flatten
    return false unless flat.uniq.size == flat.size

    # 3. Calculate sum of first row
    magic_sum = square[0].sum

    # 4. Check sum of all rows
    return false unless square.all? { |row| row.sum == magic_sum }

    # 5. Check sum of all columns
    (0...row_count).each do |col|
      col_sum = (0...row_count).sum { |row| square[row][col] }
      return false if col_sum != magic_sum
    end

    # 6. Check sum of main diagonal
    return false if (0...row_count).sum { |row| square[row][row] } != magic_sum

    # 7. Check sum of second diagonal
    return false if (0...row_count).sum { |row| square[row][row_count - 1 - row] } != magic_sum

    true
  end
end
