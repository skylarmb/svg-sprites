module SvgHelper
  def svg_icon(id)
    haml_tag :svg, class: 'icon' do
      haml_tag :use, 'xlink:href' => "##{id}"
    end
  end
end
