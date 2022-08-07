class WeatherConditions {
  dynamic weatherImage = 'svgs/day.svg';

  dynamic getWeatherImage(int condition, int sunrise, int sunset) {
    var unixTimestamp = DateTime.now().millisecondsSinceEpoch/ 1000;
    if (condition < 300) {
      return 'svgs/thunder.svg';
    } else if (condition < 600) {
      return 'svgs/rainy.svg';
    } else if (condition < 700) {
      return 'svgs/snowy.svg';
    } else if (condition < 800) {
      return 'svgs/cloudy.svg';
    } else if (condition == 800) {
      if (sunrise < unixTimestamp && unixTimestamp < sunset) {
        return 'svgs/day.svg';
      } else {
        return 'svgs/night.svg';
      }
    } else {
      return 'svgs/cloudy.svg';
    }
  }
}
