defmodule Aoc.BMP do
  def file_header(offset \\ 26) do
    file_type = "BM"
    file_size = <<0::little-size(32)>>
    reserved = <<0::little-size(32)>>
    bitmap_offset = <<offset::little-size(32)>>
    file_type <> file_size <> reserved <> bitmap_offset
  end

  def win2x_header(width \\ 96, height \\ 96, bits_per_pixel \\ 24) do
    size = <<12::little-size(32)>>
    w = <<width::little-size(16)>>
    h = <<height::little-size(16)>>
    planes = <<1::little-size(16)>>
    bpp = <<bits_per_pixel::little-size(16)>>
    size <> w <> h <> planes <> bpp
  end

  def example_data(width, height) do
    for row <- 1..height, into: <<>> do
      for item <- 1..width, into: <<>> do
        <<100 + item::little-size(8), 2 * row::little-size(8), 2 * item + row::little-size(8)>>
      end
    end
  end

  def example_file(width, height, name \\ "hello.bmp") do
    save(name, win2x_header(width, height), example_data(width, height))
  end

  def save(filename, header, pixels) do
    File.write!(filename, file_header() <> header <> pixels)
  end

  def to_b64(pixels) do
    data = file_header() <> win2x_header() <> pixels
    Base.encode64(data)
  end
end
