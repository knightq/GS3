module StatisticheHelper
  def trend_img_for(value = 0)
    image_tag(value < 0 ? 'trend-down.png' : 'trend-up.png')
  end
end
