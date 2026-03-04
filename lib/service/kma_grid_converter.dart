import 'dart:math';

/// 기상청(KMA) 단기예보/초단기 관측 API 격자 변환(DFS) 유틸.
///
/// 참고 파라미터(기상청 DFS 좌표계):
/// - 위경도(WGS84) -> 격자(nx, ny)
class KmaGridConverter {
  static const double _re = 6371.00877; // Earth radius (km)
  static const double _grid = 5.0; // Grid spacing (km)
  static const double _slat1 = 30.0; // Projection latitude 1 (degree)
  static const double _slat2 = 60.0; // Projection latitude 2 (degree)
  static const double _olon = 126.0; // Reference longitude (degree)
  static const double _olat = 38.0; // Reference latitude (degree)
  static const double _xo = 43.0; // Reference x coordinate (GRID)
  static const double _yo = 136.0; // Reference y coordinate (GRID)

  static const double _deg2rad = pi / 180.0;

  static ({int nx, int ny}) toGrid({required double lat, required double lon}) {
    final re = _re / _grid;
    final slat1 = _slat1 * _deg2rad;
    final slat2 = _slat2 * _deg2rad;
    final olon = _olon * _deg2rad;
    final olat = _olat * _deg2rad;

    final sn = log(cos(slat1) / cos(slat2)) /
        log(tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5));
    final sf = pow(tan(pi * 0.25 + slat1 * 0.5), sn) * cos(slat1) / sn;
    final ro = re * sf / pow(tan(pi * 0.25 + olat * 0.5), sn);

    final ra =
        re * sf / pow(tan(pi * 0.25 + (lat * _deg2rad) * 0.5), sn);
    var theta = lon * _deg2rad - olon;
    if (theta > pi) theta -= 2.0 * pi;
    if (theta < -pi) theta += 2.0 * pi;
    theta *= sn;

    final x = ra * sin(theta) + _xo;
    final y = ro - ra * cos(theta) + _yo;

    // 기상청 예제 구현과 동일하게 "반올림 + 1.5 보정"을 적용
    final nx = (x + 1.5).floor();
    final ny = (y + 1.5).floor();

    return (nx: nx, ny: ny);
  }
}

