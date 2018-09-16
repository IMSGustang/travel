module ApplicationHelper
  require 'chunky_png'
  require 'barby'
  require 'barby/barcode/code_39'
  require 'barby/outputter/png_outputter'


  def active_class(main_path)
    active = current_page?(main_path) ? "active" : ""
  end

  def active_class_sub(main_path, link_path)
    active = current_page?(main_path) || current_page?(link_path) ? "active" : ""
  end

  def active_class_three_sub(main_path, first_path, last_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) ? "active" : ""
  end

  def active_class_four_sub(main_path, first_path, last_path, end_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) || current_page?(end_path) ? "active" : ""
  end

  def active_class_five_sub(main_path, first_path, last_path, long_path, end_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) || current_page?(long_path) || current_page?(end_path) ? "active" : ""
  end

  def active_class_six_sub(main_path, first_path, last_path, middle_path, long_path, end_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) || current_page?(middle_path) || current_page?(long_path) || current_page?(end_path) ? "active" : ""
  end

  def active_class_sev_sub(main_path, first_path, last_path, middle_path, sev_path, long_path, end_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) || current_page?(middle_path) || current_page?(sev_path) || current_page?(long_path) || current_page?(end_path) ? "active" : ""
  end

  def active_class_eig_sub(main_path, first_path, last_path, middle_path, five_path, eig_path, long_path, end_path)
    active = current_page?(main_path) || current_page?(first_path) || current_page?(last_path) || current_page?(middle_path) || current_page?(five_path) || current_page?(eig_path) || current_page?(long_path) || current_page?(end_path) ? "active" : ""
  end

  def active_current(path, condition)
    path.each_with_index do |row|
      return current_page?(row) ? "active" : condition
    end
  end

  def barcode_output( barcode_string, tinggi, margin )
    barcode = Barby::Code39.new(barcode_string)
    barcode.to_image(height: tinggi, margin: margin) .to_data_url
  end

  def wicked_pdf_image_tag_for_public(img, options={})
    if img[0] == "/"
      new_image = img.slice(1..-1)
      image_tag "file://#{Rails.root.join('public', new_image)}", options
    else
      image_tag img, options
    end
  end

end